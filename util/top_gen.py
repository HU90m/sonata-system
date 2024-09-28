#!/usr/bin/env python3.10
# Copyright lowRISC contributors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import subprocess
from enum import Enum
from pathlib import Path
from pprint import pprint
from typing import Iterator, NamedTuple, TypeAlias

import toml
from mako.template import Template
from pydantic import BaseModel, field_validator, model_validator
from typing_extensions import Self


class BlockIoType(str, Enum):
    INOUT = "inout"
    INPUT = "input"
    OUTPUT = "output"


class BlockIoCombine(str, Enum):
    AND = "and"
    OR = "or"
    MUX = "mux"


class BlockIo(BaseModel, frozen=True):
    name: str
    type: BlockIoType
    combine: BlockIoCombine | None = None
    default: int = 0
    length: int | None = None

    @model_validator(mode="after")
    def verify_square(self) -> Self:
        assert (
            self.type != BlockIoType.INOUT or self.default == 0
        ), "An inout block IO cannot have a default value other than 0."
        return self


class Block(BaseModel, frozen=True):
    name: str
    instances: int
    ios: list[BlockIo]

    @field_validator("instances")
    @staticmethod
    def check_pins(instances: int) -> int:
        if instances < 1:
            raise ValueError("Must have one or more instances of a block.")
        return instances


class PinBlockIoPointer(BaseModel, frozen=True):
    block: str
    instance: int
    io: str | int


class Pin(BaseModel, frozen=True):
    name: str
    length: int | None = None
    block_ios: list[PinBlockIoPointer]


class TopConfig(BaseModel, frozen=True):
    blocks: list[Block]
    pins: list[Pin]

    @field_validator("pins")
    @staticmethod
    def check_pins(pins: list[Pin]) -> list[Pin]:
        all_names = {pin.name for pin in pins}
        if len(all_names) != len(pins):
            raise ValueError("All pins must have unique names.")
        return pins

    def get_block(self, name: str) -> Block:
        try:
            return next(block for block in self.blocks if block.name == name)
        except StopIteration:
            print(f"A '{name}' block could not be found.")
            exit(3)

    def get_pin(self, name: str) -> Pin:
        try:
            return next(pin for pin in self.pins if pin.name == name)
        except StopIteration:
            print(f"A pin named '{name}' could not be found.")
            exit(3)


class PinmuxIoToBlocks(NamedTuple):
    direction: str
    width: str
    name: str
    instances: int


def ios_to_blocks_iter(config: TopConfig) -> Iterator[PinmuxIoToBlocks]:
    for block in config.blocks:
        instances = block.instances
        for io in block.ios:
            name = f"{block.name}_{io.name}"
            width = "" if io.length is None else f"[{io.length - 1}:0] "
            # Generate pinmux module input and outputs
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
PinName: TypeAlias = str
BlockIoConnectionMap: TypeAlias = dict[BlockIoId, list[list[list[PinName]]]]
"""
the pins that a block IO can connect to
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
        for pin_block_io in pin.block_ios:
            (block_io_name, index) = (
                ("ios", pin_block_io.io)
                if isinstance(pin_block_io.io, int)
                else (pin_block_io.io, 0)
            )
            block = config.get_block(pin_block_io.block)
            for block_io in block.ios:
                if block_io_name == block_io.name:
                    block_io_id: BlockIoId = (block.name, block_io_name)
                    if pin.length is not None:
                        for i in range(pin.length):
                            block_connections[block_io_id][
                                pin_block_io.instance
                            ][index + i].append(pin.name)
                    else:
                        block_connections[block_io_id][pin_block_io.instance][
                            index
                        ].append(pin.name)

    return block_connections


class BlockIoInfo(NamedTuple):
    block: str
    io: str
    instance: int
    bit_index_str: str
    is_inout: bool


PinIoConnectionMap: TypeAlias = dict[str, list[BlockIoInfo]]


def pin_connections_map(
    config: TopConfig, block_connections: BlockIoConnectionMap
) -> PinIoConnectionMap:
    pin_connections: PinIoConnectionMap = {}

    for block in config.blocks:
        for io in block.ios:
            if io.type in (BlockIoType.OUTPUT, BlockIoType.INOUT):
                connections = block_connections[(block.name, io.name)]
                for inst_idx, inst_pins in enumerate(connections):
                    for bit_idx, pins in enumerate(inst_pins):
                        bit_str = "" if len(inst_pins) == 1 else f"[{bit_idx}]"
                        for pin_name in pins:
                            pin = config.get_pin(pin_name)
                            pin_connections.setdefault(pin.name, []).append(
                                BlockIoInfo(
                                    block.name,
                                    io.name,
                                    inst_idx,
                                    bit_str,
                                    io.type == BlockIoType.INOUT,
                                )
                            )

    return pin_connections


class InputListTuple(NamedTuple):
    block_input: str
    instances: int
    bit_idx: int
    bit_str: str
    pinmux_input_connections: list[str]


def input_list_iter(
    config: TopConfig, block_connections: BlockIoConnectionMap
) -> Iterator[InputListTuple]:
    for block in config.blocks:
        for io in block.ios:
            if io.type == BlockIoType.INPUT or (
                io.type == BlockIoType.INOUT
                and io.combine == BlockIoCombine.MUX
            ):
                connections = block_connections[(block.name, io.name)]
                for bit_idx in range(len(connections[0])):
                    for inst_idx in range(len(connections)):
                        inst_pins = connections[inst_idx]
                        pins = connections[inst_idx][bit_idx]

                        bit_str = "" if len(inst_pins) == 1 else f"_{bit_idx}"
                        default_value = f"1'b{io.default}"
                        input_pins = [default_value]
                        for pin_name in pins:
                            pin_with_idx = pin_name
                            pin = config.get_pin(pin_name)
                            # the pin is an array
                            if pin.length is not None:
                                if isinstance(pin.block_ios[0].io, int):
                                    pin_with_idx = (
                                        pin_name
                                        + f"[{bit_idx - pin.block_ios[0].io}]"
                                    )
                                else:
                                    print("This IO must be an int.")
                                    exit()
                            input_pins.append(pin_with_idx)
                        # Make sure there are always two values in the input
                        # list because the second one is always selected by
                        # default in the RTL.
                        if len(input_pins) == 1:
                            input_pins.append(default_value)
                        yield InputListTuple(
                            f"{block.name}_{io.name}",
                            inst_idx,
                            bit_idx,
                            bit_str,
                            input_pins,
                        )


class CombineListTuple(NamedTuple):
    block_input: str
    instance: int
    pins_to_combine: list[str]
    pin_selectors: list[int]
    combine_type: BlockIoCombine


def combine_list_iter(
    config: TopConfig,
    block_connections: BlockIoConnectionMap,
    pin_connections: PinIoConnectionMap,
) -> Iterator[CombineListTuple]:
    for block in config.blocks:
        for io in block.ios:
            if io.type == BlockIoType.INOUT and io.combine in (
                BlockIoCombine.AND,
                BlockIoCombine.OR,
            ):
                connections = block_connections[(block.name, io.name)]
                for inst_idx, inst_pins in enumerate(connections):
                    if len(inst_pins) != 1:
                        print(
                            "Currently we don't support indexing inout "
                            + "signals that are combined through muxing."
                        )
                        exit()
                    pins = inst_pins[0]

                    input_name = block.name + "_" + io.name
                    combine_pins = pins
                    combine_pin_selectors = []
                    for pin_name in combine_pins:
                        pin = config.get_pin(pin_name)
                        for sel_idx, block_output in enumerate(
                            pin_connections[pin.name]
                        ):
                            if block_output[3] != "":
                                print(
                                    "Combining indexed pins is currently "
                                    + "unsupported."
                                )
                                exit()
                            if block_output[0] is block.name and (
                                block_output[1] is io.name
                                and block_output[2] is inst_idx
                            ):
                                combine_pin_selectors.append(
                                    1 << (sel_idx + 1)
                                )
                                break
                    if len(combine_pins) != len(combine_pin_selectors):
                        print("Could not fill combine pin selectors properly.")
                        exit()
                    yield CombineListTuple(
                        input_name,
                        inst_idx,
                        combine_pins,
                        combine_pin_selectors,
                        io.combine,
                    )


class OutputListTuple(NamedTuple):
    pin_output: str
    idx_str: str  # index with preceding underscore
    idx_alt: str  # index surrounded by square brackets
    block_ptr: list[BlockIoInfo]


def output_list_iter(
    config: TopConfig, block_outputs: dict[str, list[BlockIoInfo]]
) -> Iterator[OutputListTuple]:
    for pin in config.pins:
        if outputs := block_outputs.get(pin.name):
            if pin.length is not None:
                if pin.length != len(outputs):
                    print(
                        "Arrayed pin must have complete mapping: " + pin.name
                    )
                    exit()
                for i in range(pin.length):
                    yield OutputListTuple(
                        pin.name, f"_{i}", f"[{i}]", [outputs[i]]
                    )
            else:
                yield OutputListTuple(pin.name, "", "", outputs)


def main() -> None:
    # load the configuration
    toml_path = Path("data/top_config.toml")
    with toml_path.open() as file:
        config = TopConfig(**toml.load(file))

    ios_to_blocks = list(ios_to_blocks_iter(config))
    ios_to_pins = list(ios_to_pins_iter(config))

    block_connections = block_connections_map(config)
    pin_connections = pin_connections_map(config, block_connections)

    # After populating the pins field in block parameters generate input list
    # and populate outputs for pins.
    input_list = list(input_list_iter(config, block_connections))
    output_list = list(output_list_iter(config, pin_connections))
    combine_list = list(
        combine_list_iter(config, block_connections, pin_connections)
    )

    pprint([])

    # Then we use those parameters to generate our SystemVerilog using Mako
    template_variables = {
        "gpio_num": config.get_block("gpio").instances,
        "uart_num": config.get_block("uart").instances,
        "i2c_num": config.get_block("i2c").instances,
        "spi_num": config.get_block("spi").instances,
        "block_ios": ios_to_blocks,
        "pin_ios": ios_to_pins,
        "input_list": input_list,
        "output_list": output_list,
        "combine_list": combine_list,
    }
    for template_file, output_file in (
        ("data/xbar_main.hjson", "data/xbar_main_generated.hjson"),
        (
            "rtl/templates/sonata_xbar_main.sv.tpl",
            "rtl/bus/sonata_xbar_main.sv",
        ),
        ("rtl/templates/sonata_pkg.sv.tpl", "rtl/system/sonata_pkg.sv"),
        ("rtl/templates/pinmux.sv.tpl", "rtl/system/pinmux.sv"),
        ("doc/ip/pinmux.md.tpl", "doc/ip/pinmux.md"),
    ):
        print("Generating from template: " + template_file)
        content = Template(filename=template_file).render(**template_variables)
        Path(output_file).write_text(content)

    subprocess.call(["sh", "util/generate_xbar.sh"])


if __name__ == "__main__":
    main()
