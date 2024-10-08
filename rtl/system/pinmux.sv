// Copyright lowRISC contributors
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// rtl/system/pinmux.sv is automatically generated using util/top_gen.py from rtl/templates/pinmux.sv.tpl
// Please make any edits to the template file.

module pinmux
  import sonata_pkg::sonata_pins_t;
(
  // Clock and reset.
  input logic clk_i,
  input logic rst_ni,

  // List of block IOs.
  input  logic uart_tx_i[5],
  output logic uart_rx_o[5],
  input  logic i2c_scl_i[2],
  input  logic i2c_scl_en_i[2],
  output logic i2c_scl_o[2],
  input  logic i2c_sda_i[2],
  input  logic i2c_sda_en_i[2],
  output logic i2c_sda_o[2],
  input  logic spi_sck_i[5],
  input  logic spi_tx_i[5],
  output logic spi_rx_o[5],
  input  logic [31:0] gpio_ios_i[3],
  input  logic [31:0] gpio_ios_en_i[3],
  output logic [31:0] gpio_ios_o[3],

  // Pin Signals
  input  sonata_pins_t from_pins_i,
  output sonata_pins_t from_pins_en_o,
  output sonata_pins_t to_pins_o,
  output sonata_pins_t to_pins_en_o,

  // TileLink interfaces.
  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o
);
  // Local parameters.
  localparam int unsigned RegAddrWidth = 12;
  localparam int unsigned BusDataWidth = 32;

  // Register control signals.
  logic reg_we;
  logic [RegAddrWidth-1:0] reg_addr;
  /* verilator lint_off UNUSEDSIGNAL */
  logic [BusDataWidth-1:0] reg_wdata;
  /* verilator lint_on UNUSEDSIGNAL */
  logic [(BusDataWidth/8)-1:0] reg_be;
  logic [BusDataWidth-1:0] reg_rdata;

  logic unused_reg_signals;

  //TODO allow reading selector values.
  assign reg_rdata = BusDataWidth'('0);

  tlul_adapter_reg #(
    .EnableRspIntgGen ( 1            ),
    .RegAw            ( RegAddrWidth ),
    .RegDw            ( BusDataWidth ),
    .AccessLatency    ( 1            )
  ) u_tlul_adapter_reg (
    .clk_i        (clk_i),
    .rst_ni       (rst_ni),

    // TL-UL interface.
    .tl_i         (tl_i),
    .tl_o         (tl_o),

    // Control interface.
    .en_ifetch_i  (prim_mubi_pkg::MuBi4False),
    .intg_error_o (),

    // Register interface.
    .re_o         (),
    .we_o         (reg_we),
    .addr_o       (reg_addr),
    .wdata_o      (reg_wdata),
    .be_o         (reg_be),
    .busy_i       (1'b0),
    .rdata_i      (reg_rdata),
    .error_i      (1'b0)
  );

  // Outputs - Blocks IO is muxed to choose which drives the output and output
  // enable of a physical pin

  // Inputs - Physical pin inputs are muxed to particular block IO
  assign from_pins_en_o = '{default: 'b1};


  logic [1:0] uart_0_rx_sel;
  logic uart_0_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_0_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      uart_0_rx_sel <= 2'b10;
    end else begin
      if (reg_we & uart_0_rx_sel_addressed) begin
        uart_0_rx_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) uart_0_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      from_pins_i[PINIDX_SER0_RX]
    }),
    .sel_i(uart_0_rx_sel),
    .out_o(uart_o[0])
  );

  logic [1:0] uart_1_rx_sel;
  logic uart_1_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_1_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      uart_1_rx_sel <= 2'b10;
    end else begin
      if (reg_we & uart_1_rx_sel_addressed) begin
        uart_1_rx_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) uart_1_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      from_pins_i[PINIDX_SER1_RX]
    }),
    .sel_i(uart_1_rx_sel),
    .out_o(uart_o[1])
  );

  logic [1:0] uart_2_rx_sel;
  logic uart_2_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_2_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      uart_2_rx_sel <= 2'b10;
    end else begin
      if (reg_we & uart_2_rx_sel_addressed) begin
        uart_2_rx_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) uart_2_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      from_pins_i[PINIDX_RPH_RXD0]
    }),
    .sel_i(uart_2_rx_sel),
    .out_o(uart_o[2])
  );

  logic [1:0] uart_3_rx_sel;
  logic uart_3_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_3_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 0 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      uart_3_rx_sel <= 2'b10;
    end else begin
      if (reg_we & uart_3_rx_sel_addressed) begin
        uart_3_rx_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) uart_3_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      from_pins_i[PINIDX_MB8]
    }),
    .sel_i(uart_3_rx_sel),
    .out_o(uart_o[3])
  );

  logic [1:0] uart_4_rx_sel;
  logic uart_4_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign uart_4_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      uart_4_rx_sel <= 2'b10;
    end else begin
      if (reg_we & uart_4_rx_sel_addressed) begin
        uart_4_rx_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) uart_4_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b1,
      from_pins_i[PINIDX_RS232_RX]
    }),
    .sel_i(uart_4_rx_sel),
    .out_o(uart_o[4])
  );

  logic [1:0] spi_0_rx_sel;
  logic spi_0_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_0_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      spi_0_rx_sel <= 2'b10;
    end else begin
      if (reg_we & spi_0_rx_sel_addressed) begin
        spi_0_rx_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) spi_0_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_APPSPI_D1]
    }),
    .sel_i(spi_0_rx_sel),
    .out_o(spi_o[0])
  );

  logic [1:0] spi_1_rx_sel;
  logic spi_1_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_1_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      spi_1_rx_sel <= 2'b10;
    end else begin
      if (reg_we & spi_1_rx_sel_addressed) begin
        spi_1_rx_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) spi_1_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(spi_1_rx_sel),
    .out_o(spi_o[1])
  );

  logic [1:0] spi_2_rx_sel;
  logic spi_2_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_2_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 4 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      spi_2_rx_sel <= 2'b10;
    end else begin
      if (reg_we & spi_2_rx_sel_addressed) begin
        spi_2_rx_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) spi_2_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_ETHMAC_CIPO]
    }),
    .sel_i(spi_2_rx_sel),
    .out_o(spi_o[2])
  );

  logic [2:0] spi_3_rx_sel;
  logic spi_3_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_3_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      spi_3_rx_sel <= 3'b10;
    end else begin
      if (reg_we & spi_3_rx_sel_addressed) begin
        spi_3_rx_sel <= reg_wdata[0+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) spi_3_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G9_CIPO],
      from_pins_i[PINIDX_AH_TMPIO12]
    }),
    .sel_i(spi_3_rx_sel),
    .out_o(spi_o[3])
  );

  logic [2:0] spi_4_rx_sel;
  logic spi_4_rx_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign spi_4_rx_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      spi_4_rx_sel <= 3'b10;
    end else begin
      if (reg_we & spi_4_rx_sel_addressed) begin
        spi_4_rx_sel <= reg_wdata[8+:3];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(3)
  ) spi_4_rx_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G19_CIPO],
      from_pins_i[PINIDX_MB3]
    }),
    .sel_i(spi_4_rx_sel),
    .out_o(spi_o[4])
  );

  logic [1:0] gpio_0_ios_0_sel;
  logic gpio_0_ios_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_0_sel_addressed) begin
        gpio_0_ios_0_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G0]
    }),
    .sel_i(gpio_0_ios_0_sel),
    .out_o(gpio_o[0][0])
  );

  logic [1:0] gpio_0_ios_1_sel;
  logic gpio_0_ios_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 8 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_1_sel_addressed) begin
        gpio_0_ios_1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G1]
    }),
    .sel_i(gpio_0_ios_1_sel),
    .out_o(gpio_o[0][1])
  );

  logic [1:0] gpio_0_ios_2_sel;
  logic gpio_0_ios_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_2_sel_addressed) begin
        gpio_0_ios_2_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G2_SDA]
    }),
    .sel_i(gpio_0_ios_2_sel),
    .out_o(gpio_o[0][2])
  );

  logic [1:0] gpio_0_ios_3_sel;
  logic gpio_0_ios_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_3_sel_addressed) begin
        gpio_0_ios_3_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G3_SCL]
    }),
    .sel_i(gpio_0_ios_3_sel),
    .out_o(gpio_o[0][3])
  );

  logic [1:0] gpio_0_ios_4_sel;
  logic gpio_0_ios_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_4_sel_addressed) begin
        gpio_0_ios_4_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G4]
    }),
    .sel_i(gpio_0_ios_4_sel),
    .out_o(gpio_o[0][4])
  );

  logic [1:0] gpio_0_ios_5_sel;
  logic gpio_0_ios_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 12 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_5_sel_addressed) begin
        gpio_0_ios_5_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G5]
    }),
    .sel_i(gpio_0_ios_5_sel),
    .out_o(gpio_o[0][5])
  );

  logic [1:0] gpio_0_ios_6_sel;
  logic gpio_0_ios_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_6_sel_addressed) begin
        gpio_0_ios_6_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G6]
    }),
    .sel_i(gpio_0_ios_6_sel),
    .out_o(gpio_o[0][6])
  );

  logic [1:0] gpio_0_ios_7_sel;
  logic gpio_0_ios_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_7_sel_addressed) begin
        gpio_0_ios_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G7_CE1]
    }),
    .sel_i(gpio_0_ios_7_sel),
    .out_o(gpio_o[0][7])
  );

  logic [1:0] gpio_0_ios_8_sel;
  logic gpio_0_ios_8_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_8_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_8_sel_addressed) begin
        gpio_0_ios_8_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G8_CE0]
    }),
    .sel_i(gpio_0_ios_8_sel),
    .out_o(gpio_o[0][8])
  );

  logic [1:0] gpio_0_ios_9_sel;
  logic gpio_0_ios_9_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 16 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_9_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_9_sel_addressed) begin
        gpio_0_ios_9_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G9_CIPO]
    }),
    .sel_i(gpio_0_ios_9_sel),
    .out_o(gpio_o[0][9])
  );

  logic [1:0] gpio_0_ios_10_sel;
  logic gpio_0_ios_10_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_10_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_10_sel_addressed) begin
        gpio_0_ios_10_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G10_COPI]
    }),
    .sel_i(gpio_0_ios_10_sel),
    .out_o(gpio_o[0][10])
  );

  logic [1:0] gpio_0_ios_11_sel;
  logic gpio_0_ios_11_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_11_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_11_sel_addressed) begin
        gpio_0_ios_11_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G11_SCLK]
    }),
    .sel_i(gpio_0_ios_11_sel),
    .out_o(gpio_o[0][11])
  );

  logic [1:0] gpio_0_ios_12_sel;
  logic gpio_0_ios_12_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_12_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_12_sel_addressed) begin
        gpio_0_ios_12_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G12]
    }),
    .sel_i(gpio_0_ios_12_sel),
    .out_o(gpio_o[0][12])
  );

  logic [1:0] gpio_0_ios_13_sel;
  logic gpio_0_ios_13_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 20 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_13_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_13_sel_addressed) begin
        gpio_0_ios_13_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G13]
    }),
    .sel_i(gpio_0_ios_13_sel),
    .out_o(gpio_o[0][13])
  );

  logic [1:0] gpio_0_ios_14_sel;
  logic gpio_0_ios_14_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_14_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_14_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_14_sel_addressed) begin
        gpio_0_ios_14_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_14_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_TXD0]
    }),
    .sel_i(gpio_0_ios_14_sel),
    .out_o(gpio_o[0][14])
  );

  logic [1:0] gpio_0_ios_15_sel;
  logic gpio_0_ios_15_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_15_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_15_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_15_sel_addressed) begin
        gpio_0_ios_15_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_15_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_RXD0]
    }),
    .sel_i(gpio_0_ios_15_sel),
    .out_o(gpio_o[0][15])
  );

  logic [1:0] gpio_0_ios_16_sel;
  logic gpio_0_ios_16_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_16_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_16_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_16_sel_addressed) begin
        gpio_0_ios_16_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_16_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G16_CE2]
    }),
    .sel_i(gpio_0_ios_16_sel),
    .out_o(gpio_o[0][16])
  );

  logic [1:0] gpio_0_ios_17_sel;
  logic gpio_0_ios_17_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_17_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 24 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_17_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_17_sel_addressed) begin
        gpio_0_ios_17_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_17_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G17]
    }),
    .sel_i(gpio_0_ios_17_sel),
    .out_o(gpio_o[0][17])
  );

  logic [1:0] gpio_0_ios_18_sel;
  logic gpio_0_ios_18_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_18_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_18_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_18_sel_addressed) begin
        gpio_0_ios_18_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_18_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G18]
    }),
    .sel_i(gpio_0_ios_18_sel),
    .out_o(gpio_o[0][18])
  );

  logic [1:0] gpio_0_ios_19_sel;
  logic gpio_0_ios_19_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_19_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_19_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_19_sel_addressed) begin
        gpio_0_ios_19_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_19_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G19_CIPO]
    }),
    .sel_i(gpio_0_ios_19_sel),
    .out_o(gpio_o[0][19])
  );

  logic [1:0] gpio_0_ios_20_sel;
  logic gpio_0_ios_20_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_20_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_20_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_20_sel_addressed) begin
        gpio_0_ios_20_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_20_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G20_COPI]
    }),
    .sel_i(gpio_0_ios_20_sel),
    .out_o(gpio_o[0][20])
  );

  logic [1:0] gpio_0_ios_21_sel;
  logic gpio_0_ios_21_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_21_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 28 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_21_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_21_sel_addressed) begin
        gpio_0_ios_21_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_21_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G21_SCLK]
    }),
    .sel_i(gpio_0_ios_21_sel),
    .out_o(gpio_o[0][21])
  );

  logic [1:0] gpio_0_ios_22_sel;
  logic gpio_0_ios_22_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_22_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_22_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_22_sel_addressed) begin
        gpio_0_ios_22_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_22_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G22]
    }),
    .sel_i(gpio_0_ios_22_sel),
    .out_o(gpio_o[0][22])
  );

  logic [1:0] gpio_0_ios_23_sel;
  logic gpio_0_ios_23_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_23_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_23_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_23_sel_addressed) begin
        gpio_0_ios_23_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_23_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G23]
    }),
    .sel_i(gpio_0_ios_23_sel),
    .out_o(gpio_o[0][23])
  );

  logic [1:0] gpio_0_ios_24_sel;
  logic gpio_0_ios_24_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_24_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_24_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_24_sel_addressed) begin
        gpio_0_ios_24_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_24_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G24]
    }),
    .sel_i(gpio_0_ios_24_sel),
    .out_o(gpio_o[0][24])
  );

  logic [1:0] gpio_0_ios_25_sel;
  logic gpio_0_ios_25_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_25_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 32 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_25_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_25_sel_addressed) begin
        gpio_0_ios_25_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_25_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G25]
    }),
    .sel_i(gpio_0_ios_25_sel),
    .out_o(gpio_o[0][25])
  );

  logic [1:0] gpio_0_ios_26_sel;
  logic gpio_0_ios_26_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_26_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_26_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_26_sel_addressed) begin
        gpio_0_ios_26_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_26_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G26]
    }),
    .sel_i(gpio_0_ios_26_sel),
    .out_o(gpio_o[0][26])
  );

  logic [1:0] gpio_0_ios_27_sel;
  logic gpio_0_ios_27_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_27_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_27_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_27_sel_addressed) begin
        gpio_0_ios_27_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_27_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_RPH_G27]
    }),
    .sel_i(gpio_0_ios_27_sel),
    .out_o(gpio_o[0][27])
  );

  logic [1:0] gpio_0_ios_28_sel;
  logic gpio_0_ios_28_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_28_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_28_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_28_sel_addressed) begin
        gpio_0_ios_28_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_28_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_0_ios_28_sel),
    .out_o(gpio_o[0][28])
  );

  logic [1:0] gpio_0_ios_29_sel;
  logic gpio_0_ios_29_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_29_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 36 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_29_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_29_sel_addressed) begin
        gpio_0_ios_29_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_29_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_0_ios_29_sel),
    .out_o(gpio_o[0][29])
  );

  logic [1:0] gpio_0_ios_30_sel;
  logic gpio_0_ios_30_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_30_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_30_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_30_sel_addressed) begin
        gpio_0_ios_30_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_30_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_0_ios_30_sel),
    .out_o(gpio_o[0][30])
  );

  logic [1:0] gpio_0_ios_31_sel;
  logic gpio_0_ios_31_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_0_ios_31_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_0_ios_31_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_0_ios_31_sel_addressed) begin
        gpio_0_ios_31_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_0_ios_31_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_0_ios_31_sel),
    .out_o(gpio_o[0][31])
  );

  logic [1:0] gpio_1_ios_0_sel;
  logic gpio_1_ios_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_0_sel_addressed) begin
        gpio_1_ios_0_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO0]
    }),
    .sel_i(gpio_1_ios_0_sel),
    .out_o(gpio_o[1][0])
  );

  logic [1:0] gpio_1_ios_1_sel;
  logic gpio_1_ios_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 40 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_1_sel_addressed) begin
        gpio_1_ios_1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO1]
    }),
    .sel_i(gpio_1_ios_1_sel),
    .out_o(gpio_o[1][1])
  );

  logic [1:0] gpio_1_ios_2_sel;
  logic gpio_1_ios_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_2_sel_addressed) begin
        gpio_1_ios_2_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO2]
    }),
    .sel_i(gpio_1_ios_2_sel),
    .out_o(gpio_o[1][2])
  );

  logic [1:0] gpio_1_ios_3_sel;
  logic gpio_1_ios_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_3_sel_addressed) begin
        gpio_1_ios_3_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO3]
    }),
    .sel_i(gpio_1_ios_3_sel),
    .out_o(gpio_o[1][3])
  );

  logic [1:0] gpio_1_ios_4_sel;
  logic gpio_1_ios_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_4_sel_addressed) begin
        gpio_1_ios_4_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO4]
    }),
    .sel_i(gpio_1_ios_4_sel),
    .out_o(gpio_o[1][4])
  );

  logic [1:0] gpio_1_ios_5_sel;
  logic gpio_1_ios_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 44 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_5_sel_addressed) begin
        gpio_1_ios_5_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO5]
    }),
    .sel_i(gpio_1_ios_5_sel),
    .out_o(gpio_o[1][5])
  );

  logic [1:0] gpio_1_ios_6_sel;
  logic gpio_1_ios_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_6_sel_addressed) begin
        gpio_1_ios_6_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO6]
    }),
    .sel_i(gpio_1_ios_6_sel),
    .out_o(gpio_o[1][6])
  );

  logic [1:0] gpio_1_ios_7_sel;
  logic gpio_1_ios_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_7_sel_addressed) begin
        gpio_1_ios_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO7]
    }),
    .sel_i(gpio_1_ios_7_sel),
    .out_o(gpio_o[1][7])
  );

  logic [1:0] gpio_1_ios_8_sel;
  logic gpio_1_ios_8_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_8_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_8_sel_addressed) begin
        gpio_1_ios_8_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO8]
    }),
    .sel_i(gpio_1_ios_8_sel),
    .out_o(gpio_o[1][8])
  );

  logic [1:0] gpio_1_ios_9_sel;
  logic gpio_1_ios_9_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 48 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_9_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_9_sel_addressed) begin
        gpio_1_ios_9_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO9]
    }),
    .sel_i(gpio_1_ios_9_sel),
    .out_o(gpio_o[1][9])
  );

  logic [1:0] gpio_1_ios_10_sel;
  logic gpio_1_ios_10_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_10_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_10_sel_addressed) begin
        gpio_1_ios_10_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO10]
    }),
    .sel_i(gpio_1_ios_10_sel),
    .out_o(gpio_o[1][10])
  );

  logic [1:0] gpio_1_ios_11_sel;
  logic gpio_1_ios_11_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_11_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_11_sel_addressed) begin
        gpio_1_ios_11_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO11]
    }),
    .sel_i(gpio_1_ios_11_sel),
    .out_o(gpio_o[1][11])
  );

  logic [1:0] gpio_1_ios_12_sel;
  logic gpio_1_ios_12_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_12_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_12_sel_addressed) begin
        gpio_1_ios_12_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO12]
    }),
    .sel_i(gpio_1_ios_12_sel),
    .out_o(gpio_o[1][12])
  );

  logic [1:0] gpio_1_ios_13_sel;
  logic gpio_1_ios_13_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 52 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_13_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_13_sel_addressed) begin
        gpio_1_ios_13_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO13]
    }),
    .sel_i(gpio_1_ios_13_sel),
    .out_o(gpio_o[1][13])
  );

  logic [1:0] gpio_1_ios_14_sel;
  logic gpio_1_ios_14_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_14_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_14_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_14_sel_addressed) begin
        gpio_1_ios_14_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_14_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO14]
    }),
    .sel_i(gpio_1_ios_14_sel),
    .out_o(gpio_o[1][14])
  );

  logic [1:0] gpio_1_ios_15_sel;
  logic gpio_1_ios_15_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_15_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_15_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_15_sel_addressed) begin
        gpio_1_ios_15_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_15_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO15]
    }),
    .sel_i(gpio_1_ios_15_sel),
    .out_o(gpio_o[1][15])
  );

  logic [1:0] gpio_1_ios_16_sel;
  logic gpio_1_ios_16_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_16_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_16_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_16_sel_addressed) begin
        gpio_1_ios_16_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_16_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO16]
    }),
    .sel_i(gpio_1_ios_16_sel),
    .out_o(gpio_o[1][16])
  );

  logic [1:0] gpio_1_ios_17_sel;
  logic gpio_1_ios_17_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_17_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 56 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_17_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_17_sel_addressed) begin
        gpio_1_ios_17_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_17_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_AH_TMPIO17]
    }),
    .sel_i(gpio_1_ios_17_sel),
    .out_o(gpio_o[1][17])
  );

  logic [1:0] gpio_1_ios_18_sel;
  logic gpio_1_ios_18_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_18_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_18_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_18_sel_addressed) begin
        gpio_1_ios_18_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_18_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_18_sel),
    .out_o(gpio_o[1][18])
  );

  logic [1:0] gpio_1_ios_19_sel;
  logic gpio_1_ios_19_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_19_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_19_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_19_sel_addressed) begin
        gpio_1_ios_19_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_19_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_19_sel),
    .out_o(gpio_o[1][19])
  );

  logic [1:0] gpio_1_ios_20_sel;
  logic gpio_1_ios_20_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_20_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_20_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_20_sel_addressed) begin
        gpio_1_ios_20_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_20_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_20_sel),
    .out_o(gpio_o[1][20])
  );

  logic [1:0] gpio_1_ios_21_sel;
  logic gpio_1_ios_21_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_21_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 60 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_21_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_21_sel_addressed) begin
        gpio_1_ios_21_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_21_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_21_sel),
    .out_o(gpio_o[1][21])
  );

  logic [1:0] gpio_1_ios_22_sel;
  logic gpio_1_ios_22_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_22_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_22_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_22_sel_addressed) begin
        gpio_1_ios_22_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_22_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_22_sel),
    .out_o(gpio_o[1][22])
  );

  logic [1:0] gpio_1_ios_23_sel;
  logic gpio_1_ios_23_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_23_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_23_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_23_sel_addressed) begin
        gpio_1_ios_23_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_23_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_23_sel),
    .out_o(gpio_o[1][23])
  );

  logic [1:0] gpio_1_ios_24_sel;
  logic gpio_1_ios_24_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_24_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_24_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_24_sel_addressed) begin
        gpio_1_ios_24_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_24_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_24_sel),
    .out_o(gpio_o[1][24])
  );

  logic [1:0] gpio_1_ios_25_sel;
  logic gpio_1_ios_25_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_25_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 64 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_25_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_25_sel_addressed) begin
        gpio_1_ios_25_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_25_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_25_sel),
    .out_o(gpio_o[1][25])
  );

  logic [1:0] gpio_1_ios_26_sel;
  logic gpio_1_ios_26_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_26_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_26_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_26_sel_addressed) begin
        gpio_1_ios_26_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_26_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_26_sel),
    .out_o(gpio_o[1][26])
  );

  logic [1:0] gpio_1_ios_27_sel;
  logic gpio_1_ios_27_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_27_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_27_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_27_sel_addressed) begin
        gpio_1_ios_27_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_27_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_27_sel),
    .out_o(gpio_o[1][27])
  );

  logic [1:0] gpio_1_ios_28_sel;
  logic gpio_1_ios_28_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_28_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_28_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_28_sel_addressed) begin
        gpio_1_ios_28_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_28_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_28_sel),
    .out_o(gpio_o[1][28])
  );

  logic [1:0] gpio_1_ios_29_sel;
  logic gpio_1_ios_29_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_29_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 68 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_29_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_29_sel_addressed) begin
        gpio_1_ios_29_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_29_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_29_sel),
    .out_o(gpio_o[1][29])
  );

  logic [1:0] gpio_1_ios_30_sel;
  logic gpio_1_ios_30_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_30_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_30_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_30_sel_addressed) begin
        gpio_1_ios_30_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_30_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_30_sel),
    .out_o(gpio_o[1][30])
  );

  logic [1:0] gpio_1_ios_31_sel;
  logic gpio_1_ios_31_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_1_ios_31_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_1_ios_31_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_1_ios_31_sel_addressed) begin
        gpio_1_ios_31_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_1_ios_31_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_1_ios_31_sel),
    .out_o(gpio_o[1][31])
  );

  logic [1:0] gpio_2_ios_0_sel;
  logic gpio_2_ios_0_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_0_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_0_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_0_sel_addressed) begin
        gpio_2_ios_0_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_0_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_0]
    }),
    .sel_i(gpio_2_ios_0_sel),
    .out_o(gpio_o[2][0])
  );

  logic [1:0] gpio_2_ios_1_sel;
  logic gpio_2_ios_1_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_1_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 72 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_1_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_1_sel_addressed) begin
        gpio_2_ios_1_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_1_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_1]
    }),
    .sel_i(gpio_2_ios_1_sel),
    .out_o(gpio_o[2][1])
  );

  logic [1:0] gpio_2_ios_2_sel;
  logic gpio_2_ios_2_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_2_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_2_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_2_sel_addressed) begin
        gpio_2_ios_2_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_2_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_2]
    }),
    .sel_i(gpio_2_ios_2_sel),
    .out_o(gpio_o[2][2])
  );

  logic [1:0] gpio_2_ios_3_sel;
  logic gpio_2_ios_3_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_3_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_3_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_3_sel_addressed) begin
        gpio_2_ios_3_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_3_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_3]
    }),
    .sel_i(gpio_2_ios_3_sel),
    .out_o(gpio_o[2][3])
  );

  logic [1:0] gpio_2_ios_4_sel;
  logic gpio_2_ios_4_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_4_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_4_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_4_sel_addressed) begin
        gpio_2_ios_4_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_4_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_4]
    }),
    .sel_i(gpio_2_ios_4_sel),
    .out_o(gpio_o[2][4])
  );

  logic [1:0] gpio_2_ios_5_sel;
  logic gpio_2_ios_5_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_5_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 76 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_5_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_5_sel_addressed) begin
        gpio_2_ios_5_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_5_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_5]
    }),
    .sel_i(gpio_2_ios_5_sel),
    .out_o(gpio_o[2][5])
  );

  logic [1:0] gpio_2_ios_6_sel;
  logic gpio_2_ios_6_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_6_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_6_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_6_sel_addressed) begin
        gpio_2_ios_6_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_6_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_6]
    }),
    .sel_i(gpio_2_ios_6_sel),
    .out_o(gpio_o[2][6])
  );

  logic [1:0] gpio_2_ios_7_sel;
  logic gpio_2_ios_7_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_7_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_7_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_7_sel_addressed) begin
        gpio_2_ios_7_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_7_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD0_7]
    }),
    .sel_i(gpio_2_ios_7_sel),
    .out_o(gpio_o[2][7])
  );

  logic [1:0] gpio_2_ios_8_sel;
  logic gpio_2_ios_8_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_8_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_8_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_8_sel_addressed) begin
        gpio_2_ios_8_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_8_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_0]
    }),
    .sel_i(gpio_2_ios_8_sel),
    .out_o(gpio_o[2][8])
  );

  logic [1:0] gpio_2_ios_9_sel;
  logic gpio_2_ios_9_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_9_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 80 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_9_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_9_sel_addressed) begin
        gpio_2_ios_9_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_9_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_1]
    }),
    .sel_i(gpio_2_ios_9_sel),
    .out_o(gpio_o[2][9])
  );

  logic [1:0] gpio_2_ios_10_sel;
  logic gpio_2_ios_10_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_10_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 84 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_10_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_10_sel_addressed) begin
        gpio_2_ios_10_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_10_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_2]
    }),
    .sel_i(gpio_2_ios_10_sel),
    .out_o(gpio_o[2][10])
  );

  logic [1:0] gpio_2_ios_11_sel;
  logic gpio_2_ios_11_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_11_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 84 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_11_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_11_sel_addressed) begin
        gpio_2_ios_11_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_11_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_3]
    }),
    .sel_i(gpio_2_ios_11_sel),
    .out_o(gpio_o[2][11])
  );

  logic [1:0] gpio_2_ios_12_sel;
  logic gpio_2_ios_12_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_12_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 84 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_12_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_12_sel_addressed) begin
        gpio_2_ios_12_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_12_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_4]
    }),
    .sel_i(gpio_2_ios_12_sel),
    .out_o(gpio_o[2][12])
  );

  logic [1:0] gpio_2_ios_13_sel;
  logic gpio_2_ios_13_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_13_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 84 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_13_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_13_sel_addressed) begin
        gpio_2_ios_13_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_13_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_5]
    }),
    .sel_i(gpio_2_ios_13_sel),
    .out_o(gpio_o[2][13])
  );

  logic [1:0] gpio_2_ios_14_sel;
  logic gpio_2_ios_14_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_14_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 88 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_14_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_14_sel_addressed) begin
        gpio_2_ios_14_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_14_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_6]
    }),
    .sel_i(gpio_2_ios_14_sel),
    .out_o(gpio_o[2][14])
  );

  logic [1:0] gpio_2_ios_15_sel;
  logic gpio_2_ios_15_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_15_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 88 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_15_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_15_sel_addressed) begin
        gpio_2_ios_15_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_15_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      from_pins_i[PINIDX_PMOD1_7]
    }),
    .sel_i(gpio_2_ios_15_sel),
    .out_o(gpio_o[2][15])
  );

  logic [1:0] gpio_2_ios_16_sel;
  logic gpio_2_ios_16_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_16_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 88 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_16_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_16_sel_addressed) begin
        gpio_2_ios_16_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_16_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_16_sel),
    .out_o(gpio_o[2][16])
  );

  logic [1:0] gpio_2_ios_17_sel;
  logic gpio_2_ios_17_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_17_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 88 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_17_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_17_sel_addressed) begin
        gpio_2_ios_17_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_17_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_17_sel),
    .out_o(gpio_o[2][17])
  );

  logic [1:0] gpio_2_ios_18_sel;
  logic gpio_2_ios_18_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_18_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 92 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_18_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_18_sel_addressed) begin
        gpio_2_ios_18_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_18_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_18_sel),
    .out_o(gpio_o[2][18])
  );

  logic [1:0] gpio_2_ios_19_sel;
  logic gpio_2_ios_19_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_19_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 92 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_19_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_19_sel_addressed) begin
        gpio_2_ios_19_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_19_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_19_sel),
    .out_o(gpio_o[2][19])
  );

  logic [1:0] gpio_2_ios_20_sel;
  logic gpio_2_ios_20_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_20_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 92 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_20_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_20_sel_addressed) begin
        gpio_2_ios_20_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_20_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_20_sel),
    .out_o(gpio_o[2][20])
  );

  logic [1:0] gpio_2_ios_21_sel;
  logic gpio_2_ios_21_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_21_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 92 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_21_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_21_sel_addressed) begin
        gpio_2_ios_21_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_21_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_21_sel),
    .out_o(gpio_o[2][21])
  );

  logic [1:0] gpio_2_ios_22_sel;
  logic gpio_2_ios_22_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_22_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 96 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_22_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_22_sel_addressed) begin
        gpio_2_ios_22_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_22_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_22_sel),
    .out_o(gpio_o[2][22])
  );

  logic [1:0] gpio_2_ios_23_sel;
  logic gpio_2_ios_23_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_23_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 96 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_23_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_23_sel_addressed) begin
        gpio_2_ios_23_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_23_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_23_sel),
    .out_o(gpio_o[2][23])
  );

  logic [1:0] gpio_2_ios_24_sel;
  logic gpio_2_ios_24_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_24_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 96 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_24_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_24_sel_addressed) begin
        gpio_2_ios_24_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_24_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_24_sel),
    .out_o(gpio_o[2][24])
  );

  logic [1:0] gpio_2_ios_25_sel;
  logic gpio_2_ios_25_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_25_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 96 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_25_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_25_sel_addressed) begin
        gpio_2_ios_25_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_25_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_25_sel),
    .out_o(gpio_o[2][25])
  );

  logic [1:0] gpio_2_ios_26_sel;
  logic gpio_2_ios_26_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_26_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 100 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_26_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_26_sel_addressed) begin
        gpio_2_ios_26_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_26_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_26_sel),
    .out_o(gpio_o[2][26])
  );

  logic [1:0] gpio_2_ios_27_sel;
  logic gpio_2_ios_27_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_27_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 100 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_27_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_27_sel_addressed) begin
        gpio_2_ios_27_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_27_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_27_sel),
    .out_o(gpio_o[2][27])
  );

  logic [1:0] gpio_2_ios_28_sel;
  logic gpio_2_ios_28_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_28_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 100 &
    reg_be[2] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_28_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_28_sel_addressed) begin
        gpio_2_ios_28_sel <= reg_wdata[16+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_28_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_28_sel),
    .out_o(gpio_o[2][28])
  );

  logic [1:0] gpio_2_ios_29_sel;
  logic gpio_2_ios_29_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_29_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 100 &
    reg_be[3] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_29_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_29_sel_addressed) begin
        gpio_2_ios_29_sel <= reg_wdata[24+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_29_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_29_sel),
    .out_o(gpio_o[2][29])
  );

  logic [1:0] gpio_2_ios_30_sel;
  logic gpio_2_ios_30_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_30_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 104 &
    reg_be[0] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_30_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_30_sel_addressed) begin
        gpio_2_ios_30_sel <= reg_wdata[0+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_30_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_30_sel),
    .out_o(gpio_o[2][30])
  );

  logic [1:0] gpio_2_ios_31_sel;
  logic gpio_2_ios_31_sel_addressed;

  // Register addresses of 0x800 to 0xfff are block IO selectors, which are packed with 4 per 32-bit word.
  assign gpio_2_ios_31_sel_addressed =
    reg_addr[RegAddrWidth-1] == 1'b1 &
    reg_addr[RegAddrWidth-2:0] == 104 &
    reg_be[1] == 1'b1;

  always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      // Select second input by default so that pins are connected to the first block that is specified in the configuration.
      gpio_2_ios_31_sel <= 2'b10;
    end else begin
      if (reg_we & gpio_2_ios_31_sel_addressed) begin
        gpio_2_ios_31_sel <= reg_wdata[8+:2];
      end
    end
  end

  prim_onehot_mux #(
    .Width(1),
    .Inputs(2)
  ) gpio_2_ios_31_mux (
    .clk_i,
    .rst_ni,
    .in_i({
      1'b0,
      1'b0
    }),
    .sel_i(gpio_2_ios_31_sel),
    .out_o(gpio_o[2][31])
  );

  // Combining inputs for combinable inouts
endmodule
