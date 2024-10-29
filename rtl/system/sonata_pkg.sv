// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// sonata package

package sonata_pkg;

  // Number of Instances
  localparam int unsigned GPIO_BOARD_NUM = 1;
  localparam int unsigned GPIO_RPH_NUM = 1;
  localparam int unsigned GPIO_AH_NUM = 1;
  localparam int unsigned GPIO_PMOD0_NUM = 1;
  localparam int unsigned GPIO_PMOD1_NUM = 1;
  localparam int unsigned PWM_NUM = 1;
  localparam int unsigned UART_NUM = 3;
  localparam int unsigned I2C_NUM = 2;
  localparam int unsigned SPI_NUM = 4;

  // Width of block IO arrays
  localparam int unsigned GPIO_BOARD_GPO_WIDTH = 8;
  localparam int unsigned GPIO_BOARD_GPI_WIDTH = 17;
  localparam int unsigned GPIO_RPH_GPIO_WIDTH = 28;
  localparam int unsigned GPIO_AH_GPIO_WIDTH = 14;
  localparam int unsigned GPIO_PMOD0_GPIO_WIDTH = 8;
  localparam int unsigned GPIO_PMOD1_GPIO_WIDTH = 8;
  localparam int unsigned PWM_PWM_WIDTH = 7;
  localparam int unsigned SPI_CS_WIDTH = 4;

  // Number of input, output, and inout pins
  localparam int unsigned IN_PIN_NUM = 25;
  localparam int unsigned OUT_PIN_NUM = 32;
  localparam int unsigned INOUT_PIN_NUM = 64;

  localparam int unsigned IN_PIN_USRSW_0 = 0;
  localparam int unsigned IN_PIN_USRSW_1 = 1;
  localparam int unsigned IN_PIN_USRSW_2 = 2;
  localparam int unsigned IN_PIN_USRSW_3 = 3;
  localparam int unsigned IN_PIN_USRSW_4 = 4;
  localparam int unsigned IN_PIN_USRSW_5 = 5;
  localparam int unsigned IN_PIN_USRSW_6 = 6;
  localparam int unsigned IN_PIN_USRSW_7 = 7;
  localparam int unsigned IN_PIN_NAVSW_0 = 8;
  localparam int unsigned IN_PIN_NAVSW_1 = 9;
  localparam int unsigned IN_PIN_NAVSW_2 = 10;
  localparam int unsigned IN_PIN_NAVSW_3 = 11;
  localparam int unsigned IN_PIN_NAVSW_4 = 12;
  localparam int unsigned IN_PIN_SELSW_0 = 13;
  localparam int unsigned IN_PIN_SELSW_1 = 14;
  localparam int unsigned IN_PIN_SELSW_2 = 15;
  localparam int unsigned IN_PIN_SER0_RX = 16;
  localparam int unsigned IN_PIN_SER1_RX = 17;
  localparam int unsigned IN_PIN_RS232_RX = 18;
  localparam int unsigned IN_PIN_APPSPI_D1 = 19;
  localparam int unsigned IN_PIN_ETHMAC_CIPO = 20;
  localparam int unsigned IN_PIN_MICROSD_DAT0 = 21;
  localparam int unsigned IN_PIN_MICROSD_DET = 22;
  localparam int unsigned IN_PIN_MB3 = 23;
  localparam int unsigned IN_PIN_MB8 = 24;

  localparam int unsigned OUT_PIN_USRLED_0 = 0;
  localparam int unsigned OUT_PIN_USRLED_1 = 1;
  localparam int unsigned OUT_PIN_USRLED_2 = 2;
  localparam int unsigned OUT_PIN_USRLED_3 = 3;
  localparam int unsigned OUT_PIN_USRLED_4 = 4;
  localparam int unsigned OUT_PIN_USRLED_5 = 5;
  localparam int unsigned OUT_PIN_USRLED_6 = 6;
  localparam int unsigned OUT_PIN_USRLED_7 = 7;
  localparam int unsigned OUT_PIN_SER0_TX = 8;
  localparam int unsigned OUT_PIN_SER1_TX = 9;
  localparam int unsigned OUT_PIN_RS232_TX = 10;
  localparam int unsigned OUT_PIN_APPSPI_D0 = 11;
  localparam int unsigned OUT_PIN_APPSPI_CLK = 12;
  localparam int unsigned OUT_PIN_APPSPI_CS = 13;
  localparam int unsigned OUT_PIN_ETHMAC_COPI = 14;
  localparam int unsigned OUT_PIN_ETHMAC_SCLK = 15;
  localparam int unsigned OUT_PIN_ETHMAC_CS = 16;
  localparam int unsigned OUT_PIN_ETHMAC_RST = 17;
  localparam int unsigned OUT_PIN_MICROSD_CLK = 18;
  localparam int unsigned OUT_PIN_MICROSD_CMD = 19;
  localparam int unsigned OUT_PIN_MICROSD_DAT3 = 20;
  localparam int unsigned OUT_PIN_LCD_COPI = 21;
  localparam int unsigned OUT_PIN_LCD_CLK = 22;
  localparam int unsigned OUT_PIN_LCD_CS = 23;
  localparam int unsigned OUT_PIN_LCD_RST = 24;
  localparam int unsigned OUT_PIN_LCD_DC = 25;
  localparam int unsigned OUT_PIN_LCD_BACKLIGHT = 26;
  localparam int unsigned OUT_PIN_MB1 = 27;
  localparam int unsigned OUT_PIN_MB2 = 28;
  localparam int unsigned OUT_PIN_MB4 = 29;
  localparam int unsigned OUT_PIN_MB7 = 30;
  localparam int unsigned OUT_PIN_MB10 = 31;

  localparam int unsigned INOUT_PIN_SCL0 = 0;
  localparam int unsigned INOUT_PIN_SDA0 = 1;
  localparam int unsigned INOUT_PIN_SCL1 = 2;
  localparam int unsigned INOUT_PIN_SDA1 = 3;
  localparam int unsigned INOUT_PIN_RPH_G0 = 4;
  localparam int unsigned INOUT_PIN_RPH_G1 = 5;
  localparam int unsigned INOUT_PIN_RPH_G2_SDA = 6;
  localparam int unsigned INOUT_PIN_RPH_G3_SCL = 7;
  localparam int unsigned INOUT_PIN_RPH_G4 = 8;
  localparam int unsigned INOUT_PIN_RPH_G5 = 9;
  localparam int unsigned INOUT_PIN_RPH_G6 = 10;
  localparam int unsigned INOUT_PIN_RPH_G7_SPI0_CE1 = 11;
  localparam int unsigned INOUT_PIN_RPH_G8_SPI0_CE0 = 12;
  localparam int unsigned INOUT_PIN_RPH_G9_CIPO = 13;
  localparam int unsigned INOUT_PIN_RPH_G10_COPI = 14;
  localparam int unsigned INOUT_PIN_RPH_G11_SCLK = 15;
  localparam int unsigned INOUT_PIN_RPH_G12 = 16;
  localparam int unsigned INOUT_PIN_RPH_G13 = 17;
  localparam int unsigned INOUT_PIN_RPH_TXD0 = 18;
  localparam int unsigned INOUT_PIN_RPH_RXD0 = 19;
  localparam int unsigned INOUT_PIN_RPH_G16_SPI1_CE2 = 20;
  localparam int unsigned INOUT_PIN_RPH_G17_SPI1_CE1 = 21;
  localparam int unsigned INOUT_PIN_RPH_G18_SPI1_CE0 = 22;
  localparam int unsigned INOUT_PIN_RPH_G19_SPI1_CIPO = 23;
  localparam int unsigned INOUT_PIN_RPH_G20_SPI1_COPI = 24;
  localparam int unsigned INOUT_PIN_RPH_G21_SPI1_SCLK = 25;
  localparam int unsigned INOUT_PIN_RPH_G22 = 26;
  localparam int unsigned INOUT_PIN_RPH_G23 = 27;
  localparam int unsigned INOUT_PIN_RPH_G24 = 28;
  localparam int unsigned INOUT_PIN_RPH_G25 = 29;
  localparam int unsigned INOUT_PIN_RPH_G26 = 30;
  localparam int unsigned INOUT_PIN_RPH_G27 = 31;
  localparam int unsigned INOUT_PIN_AH_TMPIO0 = 32;
  localparam int unsigned INOUT_PIN_AH_TMPIO1 = 33;
  localparam int unsigned INOUT_PIN_AH_TMPIO2 = 34;
  localparam int unsigned INOUT_PIN_AH_TMPIO3 = 35;
  localparam int unsigned INOUT_PIN_AH_TMPIO4 = 36;
  localparam int unsigned INOUT_PIN_AH_TMPIO5 = 37;
  localparam int unsigned INOUT_PIN_AH_TMPIO6 = 38;
  localparam int unsigned INOUT_PIN_AH_TMPIO7 = 39;
  localparam int unsigned INOUT_PIN_AH_TMPIO8 = 40;
  localparam int unsigned INOUT_PIN_AH_TMPIO9 = 41;
  localparam int unsigned INOUT_PIN_AH_TMPIO10 = 42;
  localparam int unsigned INOUT_PIN_AH_TMPIO11 = 43;
  localparam int unsigned INOUT_PIN_AH_TMPIO12 = 44;
  localparam int unsigned INOUT_PIN_AH_TMPIO13 = 45;
  localparam int unsigned INOUT_PIN_MB5 = 46;
  localparam int unsigned INOUT_PIN_MB6 = 47;
  localparam int unsigned INOUT_PIN_PMOD0_0 = 48;
  localparam int unsigned INOUT_PIN_PMOD0_1 = 49;
  localparam int unsigned INOUT_PIN_PMOD0_2 = 50;
  localparam int unsigned INOUT_PIN_PMOD0_3 = 51;
  localparam int unsigned INOUT_PIN_PMOD0_4 = 52;
  localparam int unsigned INOUT_PIN_PMOD0_5 = 53;
  localparam int unsigned INOUT_PIN_PMOD0_6 = 54;
  localparam int unsigned INOUT_PIN_PMOD0_7 = 55;
  localparam int unsigned INOUT_PIN_PMOD1_0 = 56;
  localparam int unsigned INOUT_PIN_PMOD1_1 = 57;
  localparam int unsigned INOUT_PIN_PMOD1_2 = 58;
  localparam int unsigned INOUT_PIN_PMOD1_3 = 59;
  localparam int unsigned INOUT_PIN_PMOD1_4 = 60;
  localparam int unsigned INOUT_PIN_PMOD1_5 = 61;
  localparam int unsigned INOUT_PIN_PMOD1_6 = 62;
  localparam int unsigned INOUT_PIN_PMOD1_7 = 63;

  typedef logic [   IN_PIN_NUM-1:0] sonata_in_pins_t;
  typedef logic [  OUT_PIN_NUM-1:0] sonata_out_pins_t;
  typedef logic [INOUT_PIN_NUM-1:0] sonata_inout_pins_t;

endpackage : sonata_pkg
