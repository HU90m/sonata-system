// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// sonata package

package sonata_pkg;

  localparam int unsigned GPIO_NUM = ${gpio_num};
  localparam int unsigned UART_NUM = ${uart_num};
  localparam int unsigned I2C_NUM  = ${i2c_num};
  localparam int unsigned SPI_NUM  = ${spi_num};

  typedef struct packed {
    % for width, name in pin_ios:
    logic ${width}${name};
    % endfor
  } sonata_pin_names_t;

  localparam int unsigned NUM_PINS = $bits(sonata_pin_names_t);

  typedef union {
    sonata_pin_names_t names;
    logic array[NUM_PINS];
  } sonata_pins_t;

endpackage : sonata_pkg
