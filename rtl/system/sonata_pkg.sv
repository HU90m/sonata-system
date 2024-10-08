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

  localparam int unsigned PIN_NUM = 87;

  localparam int unsigned PINIDX_SER0_TX = 0;
  localparam int unsigned PINIDX_SER0_RX = 1;
  localparam int unsigned PINIDX_SER1_TX = 2;
  localparam int unsigned PINIDX_SER1_RX = 3;
  localparam int unsigned PINIDX_RS232_TX = 4;
  localparam int unsigned PINIDX_RS232_RX = 5;
  localparam int unsigned PINIDX_SCL0 = 6;
  localparam int unsigned PINIDX_SDA0 = 7;
  localparam int unsigned PINIDX_SCL1 = 8;
  localparam int unsigned PINIDX_SDA1 = 9;
  localparam int unsigned PINIDX_APPSPI_D0 = 10;
  localparam int unsigned PINIDX_APPSPI_D1 = 11;
  localparam int unsigned PINIDX_APPSPI_CLK = 12;
  localparam int unsigned PINIDX_LCD_COPI = 13;
  localparam int unsigned PINIDX_LCD_CLK = 14;
  localparam int unsigned PINIDX_ETHMAC_COPI = 15;
  localparam int unsigned PINIDX_ETHMAC_CIPO = 16;
  localparam int unsigned PINIDX_ETHMAC_SCLK = 17;
  localparam int unsigned PINIDX_RPH_G0 = 18;
  localparam int unsigned PINIDX_RPH_G1 = 19;
  localparam int unsigned PINIDX_RPH_G2_SDA = 20;
  localparam int unsigned PINIDX_RPH_G3_SCL = 21;
  localparam int unsigned PINIDX_RPH_G4 = 22;
  localparam int unsigned PINIDX_RPH_G5 = 23;
  localparam int unsigned PINIDX_RPH_G6 = 24;
  localparam int unsigned PINIDX_RPH_G7_CE1 = 25;
  localparam int unsigned PINIDX_RPH_G8_CE0 = 26;
  localparam int unsigned PINIDX_RPH_G9_CIPO = 27;
  localparam int unsigned PINIDX_RPH_G10_COPI = 28;
  localparam int unsigned PINIDX_RPH_G11_SCLK = 29;
  localparam int unsigned PINIDX_RPH_G12 = 30;
  localparam int unsigned PINIDX_RPH_G13 = 31;
  localparam int unsigned PINIDX_RPH_TXD0 = 32;
  localparam int unsigned PINIDX_RPH_RXD0 = 33;
  localparam int unsigned PINIDX_RPH_G16_CE2 = 34;
  localparam int unsigned PINIDX_RPH_G17 = 35;
  localparam int unsigned PINIDX_RPH_G18 = 36;
  localparam int unsigned PINIDX_RPH_G19_CIPO = 37;
  localparam int unsigned PINIDX_RPH_G20_COPI = 38;
  localparam int unsigned PINIDX_RPH_G21_SCLK = 39;
  localparam int unsigned PINIDX_RPH_G22 = 40;
  localparam int unsigned PINIDX_RPH_G23 = 41;
  localparam int unsigned PINIDX_RPH_G24 = 42;
  localparam int unsigned PINIDX_RPH_G25 = 43;
  localparam int unsigned PINIDX_RPH_G26 = 44;
  localparam int unsigned PINIDX_RPH_G27 = 45;
  localparam int unsigned PINIDX_AH_TMPIO0 = 46;
  localparam int unsigned PINIDX_AH_TMPIO1 = 47;
  localparam int unsigned PINIDX_AH_TMPIO2 = 48;
  localparam int unsigned PINIDX_AH_TMPIO3 = 49;
  localparam int unsigned PINIDX_AH_TMPIO4 = 50;
  localparam int unsigned PINIDX_AH_TMPIO5 = 51;
  localparam int unsigned PINIDX_AH_TMPIO6 = 52;
  localparam int unsigned PINIDX_AH_TMPIO7 = 53;
  localparam int unsigned PINIDX_AH_TMPIO8 = 54;
  localparam int unsigned PINIDX_AH_TMPIO9 = 55;
  localparam int unsigned PINIDX_AH_TMPIO10 = 56;
  localparam int unsigned PINIDX_AH_TMPIO11 = 57;
  localparam int unsigned PINIDX_AH_TMPIO12 = 58;
  localparam int unsigned PINIDX_AH_TMPIO13 = 59;
  localparam int unsigned PINIDX_AH_TMPIO14 = 60;
  localparam int unsigned PINIDX_AH_TMPIO15 = 61;
  localparam int unsigned PINIDX_AH_TMPIO16 = 62;
  localparam int unsigned PINIDX_AH_TMPIO17 = 63;
  localparam int unsigned PINIDX_MB2 = 64;
  localparam int unsigned PINIDX_MB3 = 65;
  localparam int unsigned PINIDX_MB4 = 66;
  localparam int unsigned PINIDX_MB5 = 67;
  localparam int unsigned PINIDX_MB6 = 68;
  localparam int unsigned PINIDX_MB7 = 69;
  localparam int unsigned PINIDX_MB8 = 70;
  localparam int unsigned PINIDX_PMOD0_0 = 71;
  localparam int unsigned PINIDX_PMOD0_1 = 72;
  localparam int unsigned PINIDX_PMOD0_2 = 73;
  localparam int unsigned PINIDX_PMOD0_3 = 74;
  localparam int unsigned PINIDX_PMOD0_4 = 75;
  localparam int unsigned PINIDX_PMOD0_5 = 76;
  localparam int unsigned PINIDX_PMOD0_6 = 77;
  localparam int unsigned PINIDX_PMOD0_7 = 78;
  localparam int unsigned PINIDX_PMOD1_0 = 79;
  localparam int unsigned PINIDX_PMOD1_1 = 80;
  localparam int unsigned PINIDX_PMOD1_2 = 81;
  localparam int unsigned PINIDX_PMOD1_3 = 82;
  localparam int unsigned PINIDX_PMOD1_4 = 83;
  localparam int unsigned PINIDX_PMOD1_5 = 84;
  localparam int unsigned PINIDX_PMOD1_6 = 85;
  localparam int unsigned PINIDX_PMOD1_7 = 86;

  typedef logic sonata_pins_t[PIN_NUM];

endpackage : sonata_pkg
