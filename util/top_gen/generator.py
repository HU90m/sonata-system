# Copyright lowRISC contributors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
"""Top generation circuitry using a top configuration and templates."""

import subprocess
from pathlib import Path
from typing import Iterator, NamedTuple, TypeAlias

from pydantic import BaseModel
from pydantic.dataclasses import dataclass
from mako.template import Template

from .parser import (
    Block,
    BlockIoCombine,
    BlockIoType,
    Pin,
    TopConfig,
    BlockIoUid,
)


class BlockIoFlat(BaseModel, frozen=True):
    id: BlockIoUid

    default_value: int
    io_type: BlockIoType
    combine: BlockIoCombine | None = None

    @staticmethod
    def generate_name(block: BlockIoUid) -> str:
        suffix = f"_{block.io_index}" if block.io_index is not None else ""
        return f"{block.block}_{block.instance}_{block.io}{suffix}"

    @property
    def name(self) -> str:
        return self.generate_name(self.id)

    @property
    def is_inout(self) -> bool:
        return self.io_type == BlockIoType.INOUT

    @property
    def bit_index_str(self) -> str:
        return f"[{self.id.io_index}]" if self.id.io_index is not None else ""


def flatten_block_ios(blocks: list[Block]) -> Iterator[BlockIoFlat]:
    for block in blocks:
        for instance in range(block.instances):
            for io in block.ios:
                if io.length is None:
                    yield BlockIoFlat(
                        id=BlockIoUid(
                            block.name,
                            instance,
                            io.name,
                        ),
                        default_value=io.default,
                        io_type=io.type,
                    )
                else:
                    for io_index in range(io.length):
                        yield BlockIoFlat(
                            id=BlockIoUid(
                                block.name,
                                instance,
                                io.name,
                                io_index,
                            ),
                            io_type=io.type,
                            default_value=io.default,
                            combine=io.combine,
                        )


@dataclass(frozen=True)
class PinFlattened:
    """Describes an IO between the pinmux and the pins."""

    index: int
    group_name: str
    block_io_links: list[BlockIoUid]

    group_index: int | None = None

    @property
    def name(self) -> str:
        if self.group_index is None:
            return f"{self.group_name}"
        else:
            return f"{self.group_name}_{self.group_index}"

    @property
    def idx_param(self) -> str:
        return f"PINIDX_{self.name}".upper()


def flatten_pins(pins: list[Pin]) -> Iterator[PinFlattened]:
    pin_index = 0
    for pin in pins:
        if pin.length is None:
            yield PinFlattened(pin_index, pin.name, pin.block_ios)
            pin_index += 1
        else:
            for group_index in range(pin.length):
                block_io_links = [
                    BlockIoUid(
                        block_io.block,
                        block_io.instance,
                        block_io.io,
                        int(block_io.io_index) + group_index,
                    )
                    for block_io in pin.block_ios
                    # This is checked at validation time
                    if isinstance(block_io.io_index, int)
                ]
                yield PinFlattened(
                    pin_index, pin.name, block_io_links, group_index
                )
                pin_index += 1


BlockIoToPinsMap: TypeAlias = dict[BlockIoUid, list[PinFlattened]]
"""Maps a block name to a list of pins it connects to."""


def block_io_to_pin_map(
    blocks: list[BlockIoFlat], pins: list[PinFlattened]
) -> BlockIoToPinsMap:
    mapping: BlockIoToPinsMap = {block_io.id: [] for block_io in blocks}
    for pin in pins:
        for link in pin.block_io_links:
            mapping[link].append(pin)
    return mapping


class PinmuxIoToBlocks(NamedTuple):
    """Describes pinmux IO going to blocks"""

    direction: str
    width: str
    name: str
    instances: int


def pinmux_ios_to_blocks_iter(config: TopConfig) -> Iterator[PinmuxIoToBlocks]:
    for block in config.blocks:
        instances = block.instances
        for io in block.ios:
            name = f"{block.name}_{io.name}"
            width = "" if io.length is None else f"[{io.length - 1}:0] "
            match io.type:
                case BlockIoType.OUTPUT:
                    yield PinmuxIoToBlocks(
                        "input ", width, name + "_i", instances
                    )
                case BlockIoType.INPUT:
                    yield PinmuxIoToBlocks(
                        "output", width, name + "_o", instances
                    )
                case BlockIoType.INOUT:
                    yield PinmuxIoToBlocks(
                        "input ", width, name + "_i", instances
                    )
                    yield PinmuxIoToBlocks(
                        "input ", width, name + "_en_i", instances
                    )
                    yield PinmuxIoToBlocks(
                        "output", width, name + "_o", instances
                    )


class PinmuxIoToPins(NamedTuple):
    """Describes Pinmux IO going to pins"""

    width: str
    name: str


def ios_to_pins_iter(config: TopConfig) -> Iterator[PinmuxIoToPins]:
    return (
        PinmuxIoToPins(
            width="" if pin.length is None else f"[{pin.length - 1}:0] ",
            name=pin.name,
        )
        for pin in config.pins
    )


BlockIoId: TypeAlias = tuple[str, str]
"""
A tuple of block name and block IO name pair to
uniquely identify a block IO. i.e. (block_name, block_io_name)
"""
BlockIoConnectionMap: TypeAlias = dict[BlockIoId, list[list[list[str]]]]
"""
Maps a block IO to the pins it connects to.
block_io_pins[block_io_id][block_instance][index][connections] == pin_name
"""


def block_connections_map(config: TopConfig) -> BlockIoConnectionMap:
    block_connections: BlockIoConnectionMap = {}

    for block in config.blocks:
        instances = block.instances
        for io in block.ios:
            length = 1 if io.length is None else io.length
            block_connections[(block.name, io.name)] = [
                [[] for _ in range(length)] for _ in range(instances)
            ]

    for pin in config.pins:
        # Populate block parameters with which pins can connect to them.
        pin_length = 1 if pin.length is None else pin.length
        for pin_block_io in pin.block_ios:
            (block_io_name, index) = (
                ("ios", pin_block_io.io)
                if isinstance(pin_block_io.io, int)
                else (pin_block_io.io, 0)
            )
            block = config.get_block(pin_block_io.block)
            for block_io in block.ios:
                if block_io_name != block_io.name:
                    continue
                block_io_id: BlockIoId = (block.name, block_io_name)
                inst_connections = block_connections[block_io_id][
                    pin_block_io.instance
                ]
                for i in range(pin_length):
                    inst_connections[index + i].append(pin.name)

    return block_connections


class BlockIoInfo(NamedTuple):
    """Describes a block IO"""

    block: str
    io: str
    instance: int
    bit_index_str: str
    is_inout: bool


PinToBlockOutputMap: TypeAlias = dict[str, list[BlockIoInfo]]
"""
Maps a pin name to a the block outputs that connect to it.
"""


def pin_to_block_output_map(
    config: TopConfig, block_connections: BlockIoConnectionMap
) -> PinToBlockOutputMap:
    pin_to_block_output: PinToBlockOutputMap = {}

    for block in config.blocks:
        for io in block.ios:
            if io.type == BlockIoType.INPUT:
                continue

            connections = block_connections[(block.name, io.name)]
            for inst_idx, inst_pins in enumerate(connections):
                for bit_idx, pins in enumerate(inst_pins):
                    bit_str = "" if len(inst_pins) == 1 else f"[{bit_idx}]"
                    for pin_name in pins:
                        pin_to_block_output.setdefault(pin_name, []).append(
                            BlockIoInfo(
                                block.name,
                                io.name,
                                inst_idx,
                                bit_str,
                                io.type == BlockIoType.INOUT,
                            )
                        )

    return pin_to_block_output


class InputPin(NamedTuple):
    block_io: BlockIoFlat
    possible_pins: list[PinFlattened]
    num_options: int


def input_pins_iter(
    block_ios: list[BlockIoFlat], block_io_to_pins: BlockIoToPinsMap
) -> Iterator[InputPin]:
    for block_io in block_ios:
        if block_io.io_type != BlockIoType.INPUT and (
            block_io.io_type != BlockIoType.INOUT
            or block_io.combine != BlockIoCombine.MUX
        ):
            continue

        possible_pins = block_io_to_pins[block_io.id]

        yield InputPin(
            block_io,
            possible_pins,
            max(len(possible_pins) + 1, 2),
        )



class InOutPin(NamedTuple):
    block_input: str
    instance: int
    pins_to_combine: list[str]
    pin_selectors: list[int]
    combine_type: BlockIoCombine


def inout_pins_iter(
    config: TopConfig,
    block_connections: BlockIoConnectionMap,
    pin_to_block_outputs: PinToBlockOutputMap,
) -> Iterator[InOutPin]:
    for block in config.blocks:
        for io in block.ios:
            if io.type != BlockIoType.INOUT or io.combine not in (
                BlockIoCombine.AND,
                BlockIoCombine.OR,
            ):
                continue

            connections = block_connections[(block.name, io.name)]
            for inst_idx, inst_pins in enumerate(connections):
                assert len(inst_pins) == 1, (
                    "Currently we don't support indexing inout "
                    "signals that are combined through muxing."
                )
                combine_pins = inst_pins[0]
                input_name = f"{block.name}_{io.name}"
                combine_pin_selectors = []
                for pin_name in combine_pins:
                    pin = config.get_pin(pin_name)
                    for sel_idx, block_output in enumerate(
                        pin_to_block_outputs[pin.name]
                    ):
                        assert block_output.bit_index_str == "", (
                            "Combining indexed pins is currently "
                            "unsupported."
                        )
                        if (
                            block_output.block,
                            block_output.io,
                            block_output.instance,
                        ) == (block.name, io.name, inst_idx):
                            combine_pin_selectors.append(1 << (sel_idx + 1))
                            break
                assert len(combine_pins) == len(
                    combine_pin_selectors
                ), "Could not fill combine pin selectors properly."
                yield InOutPin(
                    input_name,
                    inst_idx,
                    combine_pins,
                    combine_pin_selectors,
                    io.combine,
                )


class OutputPin(NamedTuple):
    pin_name: str
    pin_idx: int
    idx_str: str
    """If pin array, array index after underscore e.g. '_1'"""
    idx_alt: str
    """If pin array, array index surrounded by square brackets e.g. '[1]'"""
    connected_block_io: list[BlockIoInfo]


def output_pins_iter(
    config: TopConfig, pin_to_block_outputs: PinToBlockOutputMap
) -> Iterator[OutputPin]:
    pin_index = 0
    for pin in config.pins:
        if outputs := pin_to_block_outputs.get(pin.name):
            if pin.length is None:
                yield OutputPin(pin.name, pin_index, "", "", outputs)
                pin_index += 1
            else:
                assert pin.length == len(
                    outputs
                ), f"Arrayed pin '{pin.name}' must have complete mapping"
                for i in range(pin.length):
                    yield OutputPin(
                        pin.name, pin_index, f"_{i}", f"[{i}]", [outputs[i]]
                    )
                    pin_index += 1


def generate_top(config: TopConfig) -> None:
    """Generate a top from a top configuration."""

    block_ios = list(flatten_block_ios(config.blocks))
    pins = list(flatten_pins(config.pins))

    block_io_to_pins = block_io_to_pin_map(block_ios, pins)

    # pprint([b.name for b in block_ios])
    #pprint(block_io_to_pins)

    pinmux_ios_to_blocks = list(pinmux_ios_to_blocks_iter(config))
    pinmux_ios_to_pins: list[None] = [] # list(ios_to_pins_iter(config))

    #block_connections = block_connections_map(config)
    #pin_to_block_outputs = pin_to_block_output_map(config, block_connections)

    input_pins = list(input_pins_iter(block_ios, block_io_to_pins))
    output_pins: list[None] = [] #list(output_pins_iter(config, pin_to_block_outputs))
    inout_pins: list[None] = []

    from pprint import pprint
    #pprint(pins)
    pprint(input_pins)

    #list(
    #    inout_pins_iter(config, block_connections, pin_to_block_outputs)
    #)

    # Then we use those parameters to generate our SystemVerilog using Mako
    template_variables = {
        "gpio_num": config.get_block("gpio").instances,
        "uart_num": config.get_block("uart").instances,
        "i2c_num": config.get_block("i2c").instances,
        "spi_num": config.get_block("spi").instances,
        "block_ios": pinmux_ios_to_blocks,
        "pin_ios": pinmux_ios_to_pins,
        "pins": pins,
        "input_list": input_pins,
        "output_list": output_pins,
        "combine_list": inout_pins,
    }
    for template_file, output_file in (
        ("data/xbar_main.hjson", "data/xbar_main_generated.hjson"),
        (
            "rtl/templates/sonata_xbar_main.sv.tpl",
            "rtl/bus/sonata_xbar_main.sv",
        ),
        ("rtl/templates/sonata_pkg.sv.tpl", "rtl/system/sonata_pkg.sv"),
        ("rtl/templates/pinmux.sv.tpl", "rtl/system/pinmux.sv"),
        #("doc/ip/pinmux.md.tpl", "doc/ip/pinmux.md"),
    ):
        print("Generating from template: " + template_file)
        content = Template(filename=template_file).render(**template_variables)
        Path(output_file).write_text(content)

    subprocess.call(["sh", "util/generate_xbar.sh"])
