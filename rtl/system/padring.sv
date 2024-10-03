// Copyright lowRISC contributors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

module padring
  import sonata_pkg::sonata_pins_t;
  import sonata_pkg::NUM_PINS;
(
  inout wire sonata_pins_t pins_io,

  output sonata_pins_t from_pins_o,
  input sonata_pins_t from_pins_en_i,
  input sonata_pins_t to_pins_en_i,
  input sonata_pins_t to_pins_i
);
  prim_pad_wrapper_pkg::pad_attr_t pad_attr = '{
    default:'0,
    drive_strength: '1
  };

  prim_pad_wrapper u_pad[NUM_PINS] (
    .inout_io (pins_io.array),
    .in_o (from_pins_o.array),
    .ie_i (from_pins_en_i.array),
    .out_i (to_pins_i.array),
    .oe_i (to_pins_en_i.array),
    .attr_i (pad_attr),

    // Don't care
    .in_raw_o (),
    // Unused in the generic wrapper
    .clk_scan_i (),
    .scanmode_i (),
    .pok_i ()
  );
endmodule : padring
