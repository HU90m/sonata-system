// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// sonata package

package sonata_pkg;

  localparam int unsigned GPIO_NUM = 3;
  localparam int unsigned UART_NUM = 5;
  localparam int unsigned I2C_NUM  = 2;
  localparam int unsigned SPI_NUM  = 5;


  typedef struct packed {
    logic ser0_tx;
    logic ser0_rx;
    logic ser1_tx;
    logic ser1_rx;
    logic rs232_tx;
    logic rs232_rx;
    logic scl0;
    logic sda0;
    logic scl1;
    logic sda1;
    logic appspi_d0;
    logic appspi_d1;
    logic appspi_clk;
    logic lcd_copi;
    logic lcd_clk;
    logic ethmac_copi;
    logic ethmac_cipo;
    logic ethmac_sclk;
    logic rph_g0;
    logic rph_g1;
    logic rph_g2_sda;
    logic rph_g3_scl;
    logic rph_g4;
    logic rph_g5;
    logic rph_g6;
    logic rph_g7_ce1;
    logic rph_g8_ce0;
    logic rph_g9_cipo;
    logic rph_g10_copi;
    logic rph_g11_sclk;
    logic rph_g12;
    logic rph_g13;
    logic rph_txd0;
    logic rph_rxd0;
    logic rph_g16_ce2;
    logic rph_g17;
    logic rph_g18;
    logic rph_g19_cipo;
    logic rph_g20_copi;
    logic rph_g21_sclk;
    logic rph_g22;
    logic rph_g23;
    logic rph_g24;
    logic rph_g25;
    logic rph_g26;
    logic rph_g27;
    logic ah_tmpio0;
    logic ah_tmpio1;
    logic ah_tmpio2;
    logic ah_tmpio3;
    logic ah_tmpio4;
    logic ah_tmpio5;
    logic ah_tmpio6;
    logic ah_tmpio7;
    logic ah_tmpio8;
    logic ah_tmpio9;
    logic ah_tmpio10;
    logic ah_tmpio11;
    logic ah_tmpio12;
    logic ah_tmpio13;
    logic ah_tmpio14;
    logic ah_tmpio15;
    logic ah_tmpio16;
    logic ah_tmpio17;
    logic mb2;
    logic mb3;
    logic mb4;
    logic mb5;
    logic mb6;
    logic mb7;
    logic mb8;
    logic [7:0] pmod0;
    logic [7:0] pmod1;
  } sonata_pin_names_t;
  typedef union {
    sonata_pin_names_t names;
    logic array[$size(sonata_pin_names_t)];
  } sonata_pins_t;

endpackage : sonata_pkg
