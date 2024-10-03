// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Sonata system top level for the Sonata PCB
module top_sonata
  import sonata_pkg::sonata_pins_t;
(
  input  logic mainClk,
  input  logic nrst,

  output logic [7:0] usrLed,
  output logic       led_bootok,
  output logic       led_halted,
  output logic       led_cheri,
  output logic       led_legacy,
  output logic [8:0] cheriErr,

  input  logic [4:0] navSw,
  input  logic [7:0] usrSw,
  input  logic [2:0] selSw,

  output logic       lcd_rst,
  output logic       lcd_dc,
  output logic       lcd_copi,
  output logic       lcd_clk,
  output logic       lcd_cs,
  output logic       lcd_backlight,

  output logic       ethmac_rst,
  output logic       ethmac_copi,
  output logic       ethmac_sclk,
  input  logic       ethmac_cipo,
  input  logic       ethmac_intr,
  output logic       ethmac_cs,

  output logic       rgbled0,

  // UART 0
  output logic       ser0_tx,
  input  logic       ser0_rx,

  // UART 1
  output logic       ser1_tx,
  input  logic       ser1_rx,

  // RS-232
  output logic       rs232_tx,
  input  logic       rs232_rx,

  // QWIIC (Sparkfun) buses
  inout  logic       scl0,  // qwiic0 and Arduino Header
  inout  logic       sda0,

  inout  logic       scl1,  // qwiic1
  inout  logic       sda1,

  // R-Pi header I2C buses
  inout  logic       rph_g3_scl,  // SCL1/GPIO3 on Header
  inout  logic       rph_g2_sda,  // SDA1/GPIO2

  inout  logic       rph_g1,  // ID_SC for HAT ID EEPROM
  inout  logic       rph_g0,  // ID_SD

  // R-Pi header SPI buses
  inout  logic       rph_g11_sclk, // SPI0
  inout  logic       rph_g10_copi, // SPI0
  inout  logic       rph_g9_cipo,  // SPI0
  output logic       rph_g8_ce0,   // SPI0
  output logic       rph_g7_ce1,   // SPI0

  inout  logic       rph_g21_sclk, // SPI1
  inout  logic       rph_g20_copi, // SPI1
  inout  logic       rph_g19_cipo, // SPI1
  output logic       rph_g18,      // SPI1 CE0
  output logic       rph_g17,      // SPI1 CE1
  output logic       rph_g16_ce2,  // SPI1

  // R-Pi header UART
  inout  logic       rph_txd0,
  inout  logic       rph_rxd0,

  // R-Pi header GPIO
  inout  logic       rph_g27,
  inout  logic       rph_g26,
  inout  logic       rph_g25,
  inout  logic       rph_g24,
  inout  logic       rph_g23,
  inout  logic       rph_g22,
  inout  logic       rph_g13,
  inout  logic       rph_g12,
  inout  logic       rph_g6,
  inout  logic       rph_g5,
  inout  logic       rph_g4,

  // Arduino shield GPIO
  inout  logic       ah_tmpio0,
  inout  logic       ah_tmpio1,
  inout  logic       ah_tmpio2,
  inout  logic       ah_tmpio3,
  inout  logic       ah_tmpio4,
  inout  logic       ah_tmpio5,
  inout  logic       ah_tmpio6,
  inout  logic       ah_tmpio7,
  inout  logic       ah_tmpio8,
  inout  logic       ah_tmpio9,
  inout  logic       ah_tmpio16,

  // Arduino shield SPI bus
  output logic       ah_tmpio10, // Chip select
  inout  logic       ah_tmpio11, // COPI
  inout  logic       ah_tmpio12, // CIPO or GP
  inout  logic       ah_tmpio13, // SCLK

  // Arduino shield analog(ue) pins digital inputs
  input logic [5:0]  ard_an_di,

  // Arduino shield analog(ue) pins actual analog(ue) input pairs
  input wire  [5:0]  ard_an_p,
  input wire  [5:0]  ard_an_n,

  // mikroBUS Click other
  output logic       mb10, // PWM
  input  logic       mb9,  // Interrupt
  output logic       mb0,  // Reset

  // mikroBUS Click UART
  input  logic       mb8,  // RX
  output logic       mb7,  // TX

  // mikroBUS Click I2C bus
  inout  logic       mb6,  // SCL
  inout  logic       mb5,  // SDA

  // mikroBUS Click SPI
  output logic       mb4,  // COPI
  input  logic       mb3,  // CIPO
  output logic       mb2,  // SCK
  output logic       mb1,  // Chip select

  // PMODs
  inout  logic [7:0] pmod0,
  inout  logic [7:0] pmod1,

  // Status input from USB transceiver
  input  logic       usrusb_vbusdetect,

  // Control of USB transceiver
  output logic       usrusb_softcn,
  // Configure the USB transceiver for Full Speed operation.
  output logic       usrusb_spd,

  // Reception from USB host via transceiver
  input  logic       usrusb_v_p,
  input  logic       usrusb_v_n,
  input  logic       usrusb_rcv,

  // Transmission to USB host via transceiver
  output logic       usrusb_vpo,
  output logic       usrusb_vmo,

  // Always driven configuration signals to the USB transceiver.
  output logic       usrusb_oe,
  output logic       usrusb_sus,

  // User JTAG
  input  logic       tck_i,
  input  logic       tms_i,
  input  logic       td_i,
  output logic       td_o,

  // SPI flash interface
  output logic       appspi_clk,
  output logic       appspi_d0, // COPI (controller output peripheral input)
  input  logic       appspi_d1, // CIPO (controller input peripheral output)
  output logic       appspi_d2, // WP_N (write protect negated)
  output logic       appspi_d3, // HOLD_N or RESET_N
  output logic       appspi_cs, // Chip select negated

  inout  wire [7:0]  hyperram_dq,
  inout  wire        hyperram_rwds,
  output wire        hyperram_ckp,
  output wire        hyperram_ckn,
  output wire        hyperram_nrst,
  output wire        hyperram_cs
);
  import sonata_pkg::*;

  // System clock frequency.
  parameter int unsigned SysClkFreq = 30_000_000;
  parameter int unsigned HRClkFreq  = 100_000_000;

  parameter SRAMInitFile    = "";
  parameter DisableHyperram = 1'b0;

  // Main system clock and reset
  logic main_clk_buf;
  logic clk_sys;
  logic rst_sys_n;

  // USB device clock and reset
  logic clk_usb;
  wire  rst_usb_n = rst_sys_n;

  logic clk_hr, clk_hr90p, clk_hr3x;

  logic [7:0] reset_counter;
  logic pll_locked;
  logic rst_btn;

  logic [4:0] nav_sw_n;
  logic [7:0] user_sw_n;
  logic [2:0] sel_sw_n;

  assign led_bootok = rst_sys_n;

  // Switch inputs have pull-ups and switches pull to ground when on. Invert here so CPU sees 1 for
  // on and 0 for off.
  assign nav_sw_n = ~navSw;
  assign user_sw_n = ~usrSw;
  assign sel_sw_n = ~selSw;

  assign usrusb_spd = 1'b1;  // Full Speed operation.

  logic dp_en_d2p;
  logic rx_enable_d2p;
  assign usrusb_oe  = !dp_en_d2p;  // Active low Output Enable.
  assign usrusb_sus = !rx_enable_d2p;

  logic cheri_en;

  tlul_pkg::tl_h2d_t tl_pinmux_h2d;
  tlul_pkg::tl_d2h_t tl_pinmux_d2h;

  logic uart_tx[UART_NUM];
  logic uart_rx[UART_NUM];
  logic i2c_scl_h2d[I2C_NUM];
  logic i2c_scl_en_h2d[I2C_NUM];
  logic i2c_scl_d2h[I2C_NUM];
  logic i2c_sda_h2d[I2C_NUM];
  logic i2c_sda_en_h2d[I2C_NUM];
  logic i2c_sda_d2h[I2C_NUM];
  logic spi_sck[SPI_NUM];
  logic spi_tx[SPI_NUM];
  logic spi_rx[SPI_NUM];
  logic [31:0] gpio_out[GPIO_NUM];
  logic [31:0] gpio_out_en[GPIO_NUM];
  logic [31:0] gpio_in[GPIO_NUM];


  wire sonata_pins_t pins;
  sonata_pins_t from_pins, from_pins_en, to_pins, to_pins_en;


  padring u_padring (
    .pins_io        (pins       ),
    .from_pins_o    (from_pins   ),
    .from_pins_en_i (from_pins_en),
    .to_pins_i      (to_pins     ),
    .to_pins_en_i   (to_pins_en  )
  );

  pinmux u_pinmux (
    .clk_i(clk_sys),
    .rst_ni(rst_sys_n),

    .uart_tx_i(uart_tx),
    .uart_rx_o(uart_rx),
    .i2c_scl_i(i2c_scl_h2d),
    .i2c_scl_en_i(i2c_scl_en_h2d),
    .i2c_scl_o(i2c_scl_d2h),
    .i2c_sda_i(i2c_sda_h2d),
    .i2c_sda_en_i(i2c_sda_en_h2d),
    .i2c_sda_o(i2c_sda_d2h),
    .spi_sck_i(spi_sck),
    .spi_tx_i(spi_tx),
    .spi_rx_o(spi_rx),
    .gpio_ios_i(gpio_out),
    .gpio_ios_en_i(gpio_out_en),
    .gpio_ios_o(gpio_in),

    .from_pins_i    (from_pins   ),
    .from_pins_en_o (from_pins_en),
    .to_pins_o      (to_pins     ),
    .to_pins_en_o   (to_pins_en  ),

    .tl_i(tl_pinmux_h2d),
    .tl_o(tl_pinmux_d2h)
  );

  assign pins.names.ser0_tx = ser0_tx;
  assign pins.names.ser0_rx = ser0_rx;
  assign pins.names.ser1_tx = ser1_tx;
  assign pins.names.ser1_rx = ser1_rx;
  assign pins.names.rs232_tx = rs232_tx;
  assign pins.names.rs232_rx = rs232_rx;
  assign pins.names.scl0 = scl0;
  assign pins.names.sda0 = sda0;
  assign pins.names.scl1 = scl1;
  assign pins.names.sda1 = sda1;
  assign pins.names.lcd_copi = lcd_copi;
  assign pins.names.lcd_clk = lcd_clk;
  assign pins.names.appspi_d0 = appspi_d0;
  assign pins.names.appspi_d1 = appspi_d1;
  assign pins.names.appspi_clk = appspi_clk;
  assign pins.names.ethmac_copi = ethmac_copi;
  assign pins.names.ethmac_cipo = ethmac_cipo;
  assign pins.names.ethmac_sclk = ethmac_sclk;
  assign pins.names.rph_g0 = rph_g0;
  assign pins.names.rph_g1 = rph_g1;
  assign pins.names.rph_g2_sda = rph_g2_sda;
  assign pins.names.rph_g3_scl = rph_g3_scl;
  assign pins.names.rph_g4 = rph_g4;
  assign pins.names.rph_g5 = rph_g5;
  assign pins.names.rph_g6 = rph_g6;
  assign pins.names.rph_g7_ce1 = 'bz; // Already connected in manual GPIO.
  assign pins.names.rph_g8_ce0 = 'bz; // Already connected in manual GPIO.
  assign pins.names.rph_g9_cipo = rph_g9_cipo;
  assign pins.names.rph_g10_copi = rph_g10_copi;
  assign pins.names.rph_g11_sclk = rph_g11_sclk;
  assign pins.names.rph_g12 = rph_g12;
  assign pins.names.rph_g13 = rph_g13;
  assign pins.names.rph_txd0 = rph_txd0;
  assign pins.names.rph_rxd0 = rph_rxd0;
  assign pins.names.rph_g16_ce2 = 'bz; // Already connected in manual GPIO.
  assign pins.names.rph_g17 = 'bz; // Already connected in manual GPIO.
  assign pins.names.rph_g18 = 'bz; // Already connected in manual GPIO.
  assign pins.names.rph_g19_cipo = rph_g19_cipo;
  assign pins.names.rph_g20_copi = rph_g20_copi;
  assign pins.names.rph_g21_sclk = rph_g21_sclk;
  assign pins.names.rph_g22 = rph_g22;
  assign pins.names.rph_g23 = rph_g23;
  assign pins.names.rph_g24 = rph_g24;
  assign pins.names.rph_g25 = rph_g25;
  assign pins.names.rph_g26 = rph_g26;
  assign pins.names.rph_g27 = rph_g27;
  assign pins.names.ah_tmpio0 = ah_tmpio0;
  assign pins.names.ah_tmpio1 = ah_tmpio1;
  assign pins.names.ah_tmpio2 = ah_tmpio2;
  assign pins.names.ah_tmpio3 = ah_tmpio3;
  assign pins.names.ah_tmpio4 = ah_tmpio4;
  assign pins.names.ah_tmpio5 = ah_tmpio5;
  assign pins.names.ah_tmpio6 = ah_tmpio6;
  assign pins.names.ah_tmpio7 = ah_tmpio7;
  assign pins.names.ah_tmpio8 = ah_tmpio8;
  assign pins.names.ah_tmpio9 = ah_tmpio9;
  assign pins.names.ah_tmpio10 = 'bz; // Already connected in manual GPIO.
  assign pins.names.ah_tmpio11 = ah_tmpio11;
  assign pins.names.ah_tmpio12 = ah_tmpio12;
  assign pins.names.ah_tmpio13 = ah_tmpio13;
  assign pins.names.ah_tmpio14 = 'bz;
  assign pins.names.ah_tmpio15 = 'bz;
  assign pins.names.ah_tmpio16 = ah_tmpio16;
  assign pins.names.ah_tmpio17 = 'bz;
  assign pins.names.mb2 = mb2;
  assign pins.names.mb3 = mb3;
  assign pins.names.mb4 = mb4;
  assign pins.names.mb5 = mb5;
  assign pins.names.mb6 = mb6;
  assign pins.names.mb7 = mb7;
  assign pins.names.mb8 = mb8;
  assign pins.names.pmod0 = pmod0;
  assign pins.names.pmod1 = pmod1;



  // Enable CHERI by default.
  logic enable_cheri;
  assign enable_cheri = 1'b1;

  logic rgbled_dout;
  logic [7:0] unused_gp_o;

  sonata_system #(
    .PwmWidth        (  1             ),
    .CheriErrWidth   (  9             ),
    .SRAMInitFile    ( SRAMInitFile   ),
    .SysClkFreq      ( SysClkFreq     ),
    .HRClkFreq       ( HRClkFreq      ),
    .DisableHyperram ( DisableHyperram )
  ) u_sonata_system (
    // Main system clock and reset
    .clk_sys_i      (clk_sys),
    .rst_sys_ni     (rst_sys_n),

    // USB device clock and reset
    .clk_usb_i      (clk_usb),
    .rst_usb_ni     (rst_usb_n),

    // Hyperram clocks
    .clk_hr_i       (clk_hr),
    .clk_hr90p_i    (clk_hr90p),
    .clk_hr3x_i     (clk_hr3x),

    // GPIO
    .gp_i           ({
                      15'b0,
                      sel_sw_n, // Software selection switches
                      mb9, // mikroBUS Click interrupt
                      user_sw_n, // user switches
                      nav_sw_n // joystick
                    }),
    .gp_o           ({
                      unused_gp_o,
                      mb0, // mikroBUS Click reset
                      mb1, // mikroBUS Click chip select
                      ah_tmpio10, // Arduino shield chip select
                      rph_g18, rph_g17, rph_g16_ce2, // R-Pi SPI1 chip select
                      rph_g8_ce0, rph_g7_ce1, // R-Pi SPI0 chip select
                      ethmac_rst, ethmac_cs, // Ethernet
                      appspi_cs, // Flash
                      usrLed, // User LEDs (8 bits)
                      lcd_backlight, lcd_dc, lcd_rst, lcd_cs // LCD screen
                    }),
    .gp_o_en        (),

    // Arduino Shield Analog(ue)
    .ard_an_di_i    (ard_an_di),
    .ard_an_p_i     (ard_an_p),
    .ard_an_n_i     (ard_an_n),

    // PWM
    .pwm_o({mb10}),

    // GPIO headers
    .gp_headers_i   (gpio_in),
    .gp_headers_o   (gpio_out),
    .gp_headers_o_en(gpio_out_en),

    // UARTs
    .uart_rx_i     (uart_rx),
    .uart_tx_o     (uart_tx),

    // I2C hosts
    .i2c_scl_i     (i2c_scl_d2h),
    .i2c_scl_o     (i2c_scl_h2d),
    .i2c_scl_en_o  (i2c_scl_en_h2d),
    .i2c_sda_i     (i2c_sda_d2h),
    .i2c_sda_o     (i2c_sda_h2d),
    .i2c_sda_en_o  (i2c_sda_en_h2d),

    // SPI connections for
    // - LCD screen
    // - Flash memory
    // - Ethernet
    // - 2x Raspberry Pi HAT
    // - Arduino Shield
    // - mikroBUS Click
    .spi_rx_i  (spi_rx),
    .spi_tx_o  (spi_tx),
    .spi_sck_o (spi_sck),
    // Interrupt for Ethernet is out of band
    .spi_eth_irq_ni (ethmac_intr),

    // CHERI signals
    .cheri_en_i     (enable_cheri),
    .cheri_err_o    (cheriErr),
    .cheri_en_o     (cheri_en),


    // Reception from USB host via transceiver
    .usb_dp_i         (usrusb_v_p),
    .usb_dn_i         (usrusb_v_n),
    .usb_rx_d_i       (usrusb_rcv),

    // Transmission to USB host via transceiver
    .usb_dp_o         (usrusb_vpo),
    .usb_dp_en_o      (dp_en_d2p),
    .usb_dn_o         (usrusb_vmo),
    .usb_dn_en_o      (),

    // Configuration and control of USB transceiver
    .usb_sense_i      (usrusb_vbusdetect),
    .usb_dp_pullup_o  (usrusb_softcn),
    .usb_dn_pullup_o  (),
    .usb_rx_enable_o  (rx_enable_d2p),

    // User JTAG
    .tck_i,
    .tms_i,
    .trst_ni(rst_sys_n),
    .td_i,
    .td_o,

    .rgbled_dout_o(rgbled_dout),

    .hyperram_dq,
    .hyperram_rwds,
    .hyperram_ckp,
    .hyperram_ckn,
    .hyperram_nrst,
    .hyperram_cs,

    .tl_pinmux_o(tl_pinmux_h2d),
    .tl_pinmux_i(tl_pinmux_d2h)
  );

  assign rgbled0 = ~rgbled_dout;

  // Tie flash wp_n and hold_n to 1 as they're active low and we don't need either signal
  assign appspi_d2 = 1'b1;
  assign appspi_d3 = 1'b1;

  assign led_cheri = cheri_en;
  assign led_legacy = ~cheri_en;
  assign led_halted = 1'b0;

  // Produce 50 MHz system clock from 25 MHz Sonata board clock.
  clkgen_sonata #(
    .SysClkFreq(SysClkFreq),
    .HRClkFreq (HRClkFreq)
  ) u_clkgen(
    .IO_CLK    (mainClk),
    .IO_CLK_BUF(main_clk_buf),
    .clk_sys,
    .clk_usb,
    .clk_hr,
    .clk_hr90p,
    .clk_hr3x,
    .locked    (pll_locked)
  );

  // Produce reset signal at beginning of time and when button pressed.
  assign rst_btn = ~nrst;

  rst_ctrl u_rst_ctrl (
    .clk_i       (main_clk_buf),
    .pll_locked_i(pll_locked),
    .rst_btn_i   (rst_btn),
    .rst_no      (rst_sys_n)
  );
endmodule
