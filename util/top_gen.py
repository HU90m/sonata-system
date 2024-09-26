#!/usr/bin/env python3.10
# Copyright lowRISC contributors
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

import subprocess
from enum import Enum
from pathlib import Path
from typing import NamedTuple

import toml
from mako.template import Template
from pydantic import BaseModel, field_validator, model_validator
from typing_extensions import Self

# from pprint import pprint


class BlockIoType(str, Enum):
    INOUT = "inout"
    INPUT = "input"
    OUTPUT = "output"


class BlockIoCombine(str, Enum):
    AND = "and"
    OR = "or"
    MUX = "mux"


class BlockIo(BaseModel):
    name: str
    type: BlockIoType
    combine: str | None = None
    default: int = 0
    length: int | None = None
    pins: list[list[list[str]]] = []

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


class PinBlockIoPointer(BaseModel, frozen=True):
    block: str
    instance: int
    io: str | int


class Pin(BaseModel, frozen=True):
    name: str
    length: int | None = None
    block_ios: list[PinBlockIoPointer]


class Config(BaseModel, frozen=True):
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


if __name__ == "__main__":
    # load the configuration
    toml_path = Path("data/top_config.toml")
    with toml_path.open() as file:
        config = Config(**toml.load(file))

    # blocks
    gpio = config.get_block("gpio")
    uart = config.get_block("uart")
    i2c = config.get_block("i2c")
    spi = config.get_block("spi")

    # Parse blocks
    block_ios = []

    for block in config.blocks:
        instances = block.instances
        for io in block.ios:
            name = block.name + "_" + io.name

            # Generate pinmux module input and outputs
            (width, length) = (
                (f"[{io.length - 1}:0] ", io.length)
                if io.name == "ios" and io.length is not None
                else ("", 1)
            )
            match io.type:
                case BlockIoType.OUTPUT:
                    block_ios.append(("input ", width, name + "_i", instances))
                case BlockIoType.INPUT:
                    block_ios.append(("output", width, name + "_o", instances))
                case BlockIoType.INOUT:
                    block_ios.append(("input ", width, name + "_i", instances))
                    block_ios.append(
                        ("input ", width, name + "_en_i", instances)
                    )
                    block_ios.append(("output", width, name + "_o", instances))

            io.pins = [[[] for _ in range(instances)] for _ in range(length)]

    # the pins that a block IO can connect to
    # block_io_pins[block_name][index][block_instance][connections]
    # == pin_name
    block_io_pins: dict[str, list[list[list[str]]]] = {}

    pin_ios = []
    for pin in config.pins:
        (width, arrayed) = (
            (f"[{pin.length - 1}:0] ", True)
            if pin.length is not None
            else ("", False)
        )

        pin_ios.append((width, pin.name))

        # Populate block parameters with which pins can connect to them.
        for block_io in pin.block_ios:
            (block_io_name, index) = (
                ("ios", block_io.io)
                if isinstance(block_io.io, int)
                else (block_io.io, 0)
            )
            for bio2 in config.get_block(block_io.block).ios:
                if block_io_name == bio2.name:
                    if arrayed and pin.length is not None:
                        for i in range(pin.length):
                            bio2.pins[index + i][block_io.instance].append(
                                pin.name
                            )
                    else:
                        bio2.pins[index][block_io.instance].append(pin.name)

    # After populating the pins field in block parameters generate input list
    # and populate outputs for pins.
    input_list = []
    combine_list = []

    class BlockPointer(NamedTuple):
        block: str
        io: str
        instance: int
        bit_index_str: str
        is_inout: bool

    # maps a pin name to a list of blocks
    block_outputs: dict[str, list[BlockPointer]] = {}

    for block in config.blocks:
        for io in block.ios:
            if io.type == BlockIoType.INPUT or (
                io.type == BlockIoType.INOUT
                and io.combine == BlockIoCombine.MUX
            ):
                for bit_idx, pin_list in enumerate(io.pins):
                    bit_str = "" if len(io.pins) == 1 else f"_{bit_idx}"
                    for inst_idx, pins in enumerate(pin_list):
                        default_value = f"1'b{io.default}"
                        input_pins = [default_value]
                        for pin_name in pins:
                            pin_with_idx = pin_name
                            pin = config.get_pin(pin_name)
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
                        input_list.append(
                            (
                                f"{block.name}_{io.name}",
                                inst_idx,
                                bit_idx,
                                bit_str,
                                input_pins,
                            )
                        )
            if io.type in (BlockIoType.OUTPUT, BlockIoType.INOUT):
                for bit_idx, pin_list in enumerate(io.pins):
                    bit_str = "" if len(io.pins) == 1 else f"[{bit_idx}]"

                    for inst_idx, pins in enumerate(pin_list):
                        for pin_name in pins:
                            pin = config.get_pin(pin_name)
                            block_outputs.setdefault(pin.name, []).append(
                                BlockPointer(
                                    block.name,
                                    io.name,
                                    inst_idx,
                                    bit_str,
                                    io.type == BlockIoType.INOUT,
                                )
                            )
    for block in config.blocks:
        for io in block.ios:
            if (
                io.type == BlockIoType.INOUT
                and io.combine != BlockIoCombine.MUX
            ):
                if len(io.pins) != 1:
                    print(
                        "Currently we don't support indexing inout "
                        + "signals that are combined through muxing."
                    )
                    exit()
                for inst_idx, pins in enumerate(io.pins[0]):
                    input_name = block.name + "_" + io.name
                    combine_pins = pins
                    combine_pin_selectors = []
                    for pin_name in combine_pins:
                        pin = config.get_pin(pin_name)
                        for sel_idx, block_output in enumerate(
                            block_outputs[pin.name]
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
                    combine_list.append(
                        (
                            input_name,
                            inst_idx,
                            combine_pins,
                            combine_pin_selectors,
                            io.combine,
                        )
                    )

    output_list: list[tuple[str, str, str, list[BlockPointer]]] = []

    for pin in config.pins:
        if outputs := block_outputs.get(pin.name):
            if pin.length is not None:
                if pin.length != len(outputs):
                    print(
                        "Arrayed pin must have complete mapping: " + pin.name
                    )
                    exit()
                output_list.extend(
                    (pin.name, f"_{i}", f"[{i}]", [outputs[i]])
                    for i in range(pin.length)
                )
            else:
                output_list.append((pin.name, "", "", outputs))

    class BlockIoTuple(NamedTuple):
        direction: str
        width: str
        name: str
        instances: int

    class PinIoTuple(NamedTuple):
        width: str
        name: str

    class InputListTuple(NamedTuple):
        block_input: str
        instances: int
        bit_idx: int
        bit_str: int

    class OutputListTuple(NamedTuple):
        pin_output: str
        idx_str: str  # index with preceding underscore
        idx_alt: str  # index surrounded by square brackets
        block_ptr: BlockPointer

    # block_ios = [BlockIoTuple(*block_io) for block_io in block_ios]
    # pin_ios = [PinIoTuple(*pin_io) for pin_io in pin_ios]

    # pprint(block_ios)
    # pprint(pin_ios)
    # pprint(input_list)
    # pprint(output_list)
    # pprint(combine_list)

    # Then we use those parameters to generate our SystemVerilog using Mako
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
        template = Template(filename=template_file)
        content = template.render(
            gpio_num=gpio.instances,
            uart_num=uart.instances,
            i2c_num=i2c.instances,
            spi_num=spi.instances,
            block_ios=block_ios,
            pin_ios=pin_ios,
            input_list=input_list,
            output_list=output_list,
            combine_list=combine_list,
        )
        generated_file = Path(output_file)
        generated_file.write_text(content)

    subprocess.call(["sh", "util/generate_xbar.sh"])
