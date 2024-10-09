// Copyright lowRISC contributors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module padring #(
  parameter int unsigned NumberOfPins = 1
) (
  inout  wire  pins_io     [NumberOfPins],
  output logic from_pins_o [NumberOfPins],
  input  logic to_pins_en_i[NumberOfPins],
  input  logic to_pins_i   [NumberOfPins]
);
  prim_pad_wrapper_pkg::pad_attr_t pad_attr = '{
    default:'0,
    drive_strength: '1
  };

  prim_pad_wrapper u_pad[NumberOfPins] (
    .inout_io (pins_io     ),
    .in_o     (from_pins_o ),
    .ie_i     (1'b1        ),
    .out_i    (to_pins_i   ),
    .oe_i     (to_pins_en_i),
    .attr_i   (pad_attr    ),

    // Don't care
    .in_raw_o   (),
    // Unused in generic and Xilinx variant of the wrapper
    .clk_scan_i (),
    .scanmode_i (),
    .pok_i      ()
  );
endmodule : padring
