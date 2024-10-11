// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Register Top module auto-generated by `reggen`

`include "prim_assert.sv"

module spi_reg_top (
  input clk_i,
  input rst_ni,
  // To HW
  output spi_reg_pkg::spi_reg2hw_t reg2hw, // Write
  input  spi_reg_pkg::spi_hw2reg_t hw2reg, // Read

  input  tlul_pkg::tl_h2d_t tl_i,
  output tlul_pkg::tl_d2h_t tl_o
);

  import spi_reg_pkg::* ;

  localparam int AW = 6;
  localparam int DW = 32;
  localparam int DBW = DW/8;                    // Byte Width

  // register signals
  logic           reg_we;
  logic           reg_re;
  logic [AW-1:0]  reg_addr;
  logic [DW-1:0]  reg_wdata;
  logic [DBW-1:0] reg_be;
  logic [DW-1:0]  reg_rdata;
  logic           reg_error;

  logic          addrmiss, wr_err;

  logic [DW-1:0] reg_rdata_next;
  logic reg_busy;

  tlul_pkg::tl_h2d_t tl_reg_h2d;
  tlul_pkg::tl_d2h_t tl_reg_d2h;


  // outgoing integrity generation
  tlul_pkg::tl_d2h_t tl_o_pre;
  tlul_rsp_intg_gen #(
    .EnableRspIntgGen(0),
    .EnableDataIntgGen(0)
  ) u_rsp_intg_gen (
    .tl_i(tl_o_pre),
    .tl_o(tl_o)
  );

  assign tl_reg_h2d = tl_i;
  assign tl_o_pre   = tl_reg_d2h;

  tlul_adapter_reg #(
    .RegAw(AW),
    .RegDw(DW),
    .EnableDataIntgGen(0)
  ) u_reg_if (
    .clk_i  (clk_i),
    .rst_ni (rst_ni),

    .tl_i (tl_reg_h2d),
    .tl_o (tl_reg_d2h),

    .en_ifetch_i(prim_mubi_pkg::MuBi4False),
    .intg_error_o(),

    .we_o    (reg_we),
    .re_o    (reg_re),
    .addr_o  (reg_addr),
    .wdata_o (reg_wdata),
    .be_o    (reg_be),
    .busy_i  (reg_busy),
    .rdata_i (reg_rdata),
    .error_i (reg_error)
  );

  // cdc oversampling signals

  assign reg_rdata = reg_rdata_next ;
  assign reg_error = addrmiss | wr_err;

  // Define SW related signals
  // Format: <reg>_<field>_{wd|we|qs}
  //        or <reg>_{wd|we|qs} if field == 1 or 0
  logic intr_state_we;
  logic intr_state_rx_full_qs;
  logic intr_state_rx_watermark_qs;
  logic intr_state_tx_empty_qs;
  logic intr_state_tx_watermark_qs;
  logic intr_state_complete_qs;
  logic intr_state_complete_wd;
  logic intr_enable_we;
  logic intr_enable_rx_full_qs;
  logic intr_enable_rx_full_wd;
  logic intr_enable_rx_watermark_qs;
  logic intr_enable_rx_watermark_wd;
  logic intr_enable_tx_empty_qs;
  logic intr_enable_tx_empty_wd;
  logic intr_enable_tx_watermark_qs;
  logic intr_enable_tx_watermark_wd;
  logic intr_enable_complete_qs;
  logic intr_enable_complete_wd;
  logic intr_test_we;
  logic intr_test_rx_full_wd;
  logic intr_test_rx_watermark_wd;
  logic intr_test_tx_empty_wd;
  logic intr_test_tx_watermark_wd;
  logic intr_test_complete_wd;
  logic cfg_we;
  logic [15:0] cfg_half_clk_period_qs;
  logic [15:0] cfg_half_clk_period_wd;
  logic cfg_msb_first_qs;
  logic cfg_msb_first_wd;
  logic cfg_cpha_qs;
  logic cfg_cpha_wd;
  logic cfg_cpol_qs;
  logic cfg_cpol_wd;
  logic control_we;
  logic control_tx_clear_wd;
  logic control_rx_clear_wd;
  logic control_tx_enable_qs;
  logic control_tx_enable_wd;
  logic control_rx_enable_qs;
  logic control_rx_enable_wd;
  logic [3:0] control_tx_watermark_qs;
  logic [3:0] control_tx_watermark_wd;
  logic [3:0] control_rx_watermark_qs;
  logic [3:0] control_rx_watermark_wd;
  logic control_int_loopback_qs;
  logic control_int_loopback_wd;
  logic control_sw_reset_wd;
  logic status_re;
  logic [7:0] status_tx_fifo_level_qs;
  logic [7:0] status_rx_fifo_level_qs;
  logic status_tx_fifo_full_qs;
  logic status_rx_fifo_empty_qs;
  logic status_idle_qs;
  logic start_we;
  logic [10:0] start_wd;
  logic rx_fifo_re;
  logic [7:0] rx_fifo_qs;
  logic tx_fifo_we;
  logic [7:0] tx_fifo_wd;
  logic info_re;
  logic [7:0] info_tx_fifo_depth_qs;
  logic [7:0] info_rx_fifo_depth_qs;
  logic cs_we;
  logic cs_cs_0_qs;
  logic cs_cs_0_wd;
  logic cs_cs_1_qs;
  logic cs_cs_1_wd;
  logic cs_cs_2_qs;
  logic cs_cs_2_wd;
  logic cs_cs_3_qs;
  logic cs_cs_3_wd;

  // Register instances
  // R[intr_state]: V(False)
  //   F[rx_full]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_rx_full (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_full.de),
    .d      (hw2reg.intr_state.rx_full.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_full.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_rx_full_qs)
  );

  //   F[rx_watermark]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_rx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.rx_watermark.de),
    .d      (hw2reg.intr_state.rx_watermark.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.rx_watermark.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_rx_watermark_qs)
  );

  //   F[tx_empty]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_tx_empty (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.tx_empty.de),
    .d      (hw2reg.intr_state.tx_empty.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.tx_empty.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_tx_empty_qs)
  );

  //   F[tx_watermark]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_tx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (1'b0),
    .wd     ('0),

    // from internal hardware
    .de     (hw2reg.intr_state.tx_watermark.de),
    .d      (hw2reg.intr_state.tx_watermark.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.tx_watermark.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_tx_watermark_qs)
  );

  //   F[complete]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessW1C),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_state_complete (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_state_we),
    .wd     (intr_state_complete_wd),

    // from internal hardware
    .de     (hw2reg.intr_state.complete.de),
    .d      (hw2reg.intr_state.complete.d),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_state.complete.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_state_complete_qs)
  );


  // R[intr_enable]: V(False)
  //   F[rx_full]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_rx_full (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_full_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_full.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_rx_full_qs)
  );

  //   F[rx_watermark]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_rx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_rx_watermark_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.rx_watermark.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_rx_watermark_qs)
  );

  //   F[tx_empty]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_tx_empty (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_tx_empty_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.tx_empty.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_tx_empty_qs)
  );

  //   F[tx_watermark]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_tx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_tx_watermark_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.tx_watermark.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_tx_watermark_qs)
  );

  //   F[complete]: 4:4
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_intr_enable_complete (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (intr_enable_we),
    .wd     (intr_enable_complete_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.intr_enable.complete.q),
    .ds     (),

    // to register interface (read)
    .qs     (intr_enable_complete_qs)
  );


  // R[intr_test]: V(True)
  logic intr_test_qe;
  logic [4:0] intr_test_flds_we;
  assign intr_test_qe = &intr_test_flds_we;
  //   F[rx_full]: 0:0
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_full (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_full_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[0]),
    .q      (reg2hw.intr_test.rx_full.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_full.qe = intr_test_qe;

  //   F[rx_watermark]: 1:1
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_rx_watermark (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_rx_watermark_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[1]),
    .q      (reg2hw.intr_test.rx_watermark.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.rx_watermark.qe = intr_test_qe;

  //   F[tx_empty]: 2:2
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_tx_empty (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_tx_empty_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[2]),
    .q      (reg2hw.intr_test.tx_empty.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.tx_empty.qe = intr_test_qe;

  //   F[tx_watermark]: 3:3
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_tx_watermark (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_tx_watermark_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[3]),
    .q      (reg2hw.intr_test.tx_watermark.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.tx_watermark.qe = intr_test_qe;

  //   F[complete]: 4:4
  prim_subreg_ext #(
    .DW    (1)
  ) u_intr_test_complete (
    .re     (1'b0),
    .we     (intr_test_we),
    .wd     (intr_test_complete_wd),
    .d      ('0),
    .qre    (),
    .qe     (intr_test_flds_we[4]),
    .q      (reg2hw.intr_test.complete.q),
    .ds     (),
    .qs     ()
  );
  assign reg2hw.intr_test.complete.qe = intr_test_qe;


  // R[cfg]: V(False)
  //   F[half_clk_period]: 15:0
  prim_subreg #(
    .DW      (16),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (16'h0),
    .Mubi    (1'b0)
  ) u_cfg_half_clk_period (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cfg_we),
    .wd     (cfg_half_clk_period_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cfg.half_clk_period.q),
    .ds     (),

    // to register interface (read)
    .qs     (cfg_half_clk_period_qs)
  );

  //   F[msb_first]: 29:29
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
  ) u_cfg_msb_first (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cfg_we),
    .wd     (cfg_msb_first_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cfg.msb_first.q),
    .ds     (),

    // to register interface (read)
    .qs     (cfg_msb_first_qs)
  );

  //   F[cpha]: 30:30
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_cfg_cpha (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cfg_we),
    .wd     (cfg_cpha_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cfg.cpha.q),
    .ds     (),

    // to register interface (read)
    .qs     (cfg_cpha_qs)
  );

  //   F[cpol]: 31:31
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_cfg_cpol (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cfg_we),
    .wd     (cfg_cpol_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cfg.cpol.q),
    .ds     (),

    // to register interface (read)
    .qs     (cfg_cpol_qs)
  );


  // R[control]: V(False)
  logic control_qe;
  logic [7:0] control_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_control0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&control_flds_we),
    .q_o(control_qe)
  );
  //   F[tx_clear]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_control_tx_clear (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_tx_clear_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[0]),
    .q      (reg2hw.control.tx_clear.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.control.tx_clear.qe = control_qe;

  //   F[rx_clear]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_control_rx_clear (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_rx_clear_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[1]),
    .q      (reg2hw.control.rx_clear.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.control.rx_clear.qe = control_qe;

  //   F[tx_enable]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_control_tx_enable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_tx_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[2]),
    .q      (reg2hw.control.tx_enable.q),
    .ds     (),

    // to register interface (read)
    .qs     (control_tx_enable_qs)
  );
  assign reg2hw.control.tx_enable.qe = control_qe;

  //   F[rx_enable]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_control_rx_enable (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_rx_enable_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[3]),
    .q      (reg2hw.control.rx_enable.q),
    .ds     (),

    // to register interface (read)
    .qs     (control_rx_enable_qs)
  );
  assign reg2hw.control.rx_enable.qe = control_qe;

  //   F[tx_watermark]: 7:4
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h0),
    .Mubi    (1'b0)
  ) u_control_tx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_tx_watermark_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[4]),
    .q      (reg2hw.control.tx_watermark.q),
    .ds     (),

    // to register interface (read)
    .qs     (control_tx_watermark_qs)
  );
  assign reg2hw.control.tx_watermark.qe = control_qe;

  //   F[rx_watermark]: 11:8
  prim_subreg #(
    .DW      (4),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (4'h0),
    .Mubi    (1'b0)
  ) u_control_rx_watermark (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_rx_watermark_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[5]),
    .q      (reg2hw.control.rx_watermark.q),
    .ds     (),

    // to register interface (read)
    .qs     (control_rx_watermark_qs)
  );
  assign reg2hw.control.rx_watermark.qe = control_qe;

  //   F[int_loopback]: 30:30
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_control_int_loopback (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_int_loopback_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[6]),
    .q      (reg2hw.control.int_loopback.q),
    .ds     (),

    // to register interface (read)
    .qs     (control_int_loopback_qs)
  );
  assign reg2hw.control.int_loopback.qe = control_qe;

  //   F[sw_reset]: 31:31
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (1'h0),
    .Mubi    (1'b0)
  ) u_control_sw_reset (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (control_we),
    .wd     (control_sw_reset_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (control_flds_we[7]),
    .q      (reg2hw.control.sw_reset.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.control.sw_reset.qe = control_qe;


  // R[status]: V(True)
  //   F[tx_fifo_level]: 7:0
  prim_subreg_ext #(
    .DW    (8)
  ) u_status_tx_fifo_level (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.tx_fifo_level.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_tx_fifo_level_qs)
  );

  //   F[rx_fifo_level]: 15:8
  prim_subreg_ext #(
    .DW    (8)
  ) u_status_rx_fifo_level (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rx_fifo_level.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_rx_fifo_level_qs)
  );

  //   F[tx_fifo_full]: 16:16
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_tx_fifo_full (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.tx_fifo_full.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_tx_fifo_full_qs)
  );

  //   F[rx_fifo_empty]: 17:17
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_rx_fifo_empty (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.rx_fifo_empty.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_rx_fifo_empty_qs)
  );

  //   F[idle]: 18:18
  prim_subreg_ext #(
    .DW    (1)
  ) u_status_idle (
    .re     (status_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.status.idle.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (status_idle_qs)
  );


  // R[start]: V(False)
  logic start_qe;
  logic [0:0] start_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_start0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&start_flds_we),
    .q_o(start_qe)
  );
  prim_subreg #(
    .DW      (11),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (11'h0),
    .Mubi    (1'b0)
  ) u_start (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (start_we),
    .wd     (start_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (start_flds_we[0]),
    .q      (reg2hw.start.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.start.qe = start_qe;


  // R[rx_fifo]: V(True)
  prim_subreg_ext #(
    .DW    (8)
  ) u_rx_fifo (
    .re     (rx_fifo_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.rx_fifo.d),
    .qre    (reg2hw.rx_fifo.re),
    .qe     (),
    .q      (reg2hw.rx_fifo.q),
    .ds     (),
    .qs     (rx_fifo_qs)
  );


  // R[tx_fifo]: V(False)
  logic tx_fifo_qe;
  logic [0:0] tx_fifo_flds_we;
  prim_flop #(
    .Width(1),
    .ResetValue(0)
  ) u_tx_fifo0_qe (
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .d_i(&tx_fifo_flds_we),
    .q_o(tx_fifo_qe)
  );
  prim_subreg #(
    .DW      (8),
    .SwAccess(prim_subreg_pkg::SwAccessWO),
    .RESVAL  (8'h0),
    .Mubi    (1'b0)
  ) u_tx_fifo (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (tx_fifo_we),
    .wd     (tx_fifo_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (tx_fifo_flds_we[0]),
    .q      (reg2hw.tx_fifo.q),
    .ds     (),

    // to register interface (read)
    .qs     ()
  );
  assign reg2hw.tx_fifo.qe = tx_fifo_qe;


  // R[info]: V(True)
  //   F[tx_fifo_depth]: 7:0
  prim_subreg_ext #(
    .DW    (8)
  ) u_info_tx_fifo_depth (
    .re     (info_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.info.tx_fifo_depth.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (info_tx_fifo_depth_qs)
  );

  //   F[rx_fifo_depth]: 15:8
  prim_subreg_ext #(
    .DW    (8)
  ) u_info_rx_fifo_depth (
    .re     (info_re),
    .we     (1'b0),
    .wd     ('0),
    .d      (hw2reg.info.rx_fifo_depth.d),
    .qre    (),
    .qe     (),
    .q      (),
    .ds     (),
    .qs     (info_rx_fifo_depth_qs)
  );


  // Subregister 0 of Multireg cs
  // R[cs]: V(False)
  //   F[cs_0]: 0:0
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
  ) u_cs_cs_0 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cs_we),
    .wd     (cs_cs_0_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cs[0].q),
    .ds     (),

    // to register interface (read)
    .qs     (cs_cs_0_qs)
  );

  //   F[cs_1]: 1:1
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
  ) u_cs_cs_1 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cs_we),
    .wd     (cs_cs_1_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cs[1].q),
    .ds     (),

    // to register interface (read)
    .qs     (cs_cs_1_qs)
  );

  //   F[cs_2]: 2:2
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
  ) u_cs_cs_2 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cs_we),
    .wd     (cs_cs_2_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cs[2].q),
    .ds     (),

    // to register interface (read)
    .qs     (cs_cs_2_qs)
  );

  //   F[cs_3]: 3:3
  prim_subreg #(
    .DW      (1),
    .SwAccess(prim_subreg_pkg::SwAccessRW),
    .RESVAL  (1'h1),
    .Mubi    (1'b0)
  ) u_cs_cs_3 (
    .clk_i   (clk_i),
    .rst_ni  (rst_ni),

    // from register interface
    .we     (cs_we),
    .wd     (cs_cs_3_wd),

    // from internal hardware
    .de     (1'b0),
    .d      ('0),

    // to internal hardware
    .qe     (),
    .q      (reg2hw.cs[3].q),
    .ds     (),

    // to register interface (read)
    .qs     (cs_cs_3_qs)
  );



  logic [10:0] addr_hit;
  always_comb begin
    addr_hit = '0;
    addr_hit[ 0] = (reg_addr == SPI_INTR_STATE_OFFSET);
    addr_hit[ 1] = (reg_addr == SPI_INTR_ENABLE_OFFSET);
    addr_hit[ 2] = (reg_addr == SPI_INTR_TEST_OFFSET);
    addr_hit[ 3] = (reg_addr == SPI_CFG_OFFSET);
    addr_hit[ 4] = (reg_addr == SPI_CONTROL_OFFSET);
    addr_hit[ 5] = (reg_addr == SPI_STATUS_OFFSET);
    addr_hit[ 6] = (reg_addr == SPI_START_OFFSET);
    addr_hit[ 7] = (reg_addr == SPI_RX_FIFO_OFFSET);
    addr_hit[ 8] = (reg_addr == SPI_TX_FIFO_OFFSET);
    addr_hit[ 9] = (reg_addr == SPI_INFO_OFFSET);
    addr_hit[10] = (reg_addr == SPI_CS_OFFSET);
  end

  assign addrmiss = (reg_re || reg_we) ? ~|addr_hit : 1'b0 ;

  // Check sub-word write is permitted
  always_comb begin
    wr_err = (reg_we &
              ((addr_hit[ 0] & (|(SPI_PERMIT[ 0] & ~reg_be))) |
               (addr_hit[ 1] & (|(SPI_PERMIT[ 1] & ~reg_be))) |
               (addr_hit[ 2] & (|(SPI_PERMIT[ 2] & ~reg_be))) |
               (addr_hit[ 3] & (|(SPI_PERMIT[ 3] & ~reg_be))) |
               (addr_hit[ 4] & (|(SPI_PERMIT[ 4] & ~reg_be))) |
               (addr_hit[ 5] & (|(SPI_PERMIT[ 5] & ~reg_be))) |
               (addr_hit[ 6] & (|(SPI_PERMIT[ 6] & ~reg_be))) |
               (addr_hit[ 7] & (|(SPI_PERMIT[ 7] & ~reg_be))) |
               (addr_hit[ 8] & (|(SPI_PERMIT[ 8] & ~reg_be))) |
               (addr_hit[ 9] & (|(SPI_PERMIT[ 9] & ~reg_be))) |
               (addr_hit[10] & (|(SPI_PERMIT[10] & ~reg_be)))));
  end

  // Generate write-enables
  assign intr_state_we = addr_hit[0] & reg_we & !reg_error;

  assign intr_state_complete_wd = reg_wdata[4];
  assign intr_enable_we = addr_hit[1] & reg_we & !reg_error;

  assign intr_enable_rx_full_wd = reg_wdata[0];

  assign intr_enable_rx_watermark_wd = reg_wdata[1];

  assign intr_enable_tx_empty_wd = reg_wdata[2];

  assign intr_enable_tx_watermark_wd = reg_wdata[3];

  assign intr_enable_complete_wd = reg_wdata[4];
  assign intr_test_we = addr_hit[2] & reg_we & !reg_error;

  assign intr_test_rx_full_wd = reg_wdata[0];

  assign intr_test_rx_watermark_wd = reg_wdata[1];

  assign intr_test_tx_empty_wd = reg_wdata[2];

  assign intr_test_tx_watermark_wd = reg_wdata[3];

  assign intr_test_complete_wd = reg_wdata[4];
  assign cfg_we = addr_hit[3] & reg_we & !reg_error;

  assign cfg_half_clk_period_wd = reg_wdata[15:0];

  assign cfg_msb_first_wd = reg_wdata[29];

  assign cfg_cpha_wd = reg_wdata[30];

  assign cfg_cpol_wd = reg_wdata[31];
  assign control_we = addr_hit[4] & reg_we & !reg_error;

  assign control_tx_clear_wd = reg_wdata[0];

  assign control_rx_clear_wd = reg_wdata[1];

  assign control_tx_enable_wd = reg_wdata[2];

  assign control_rx_enable_wd = reg_wdata[3];

  assign control_tx_watermark_wd = reg_wdata[7:4];

  assign control_rx_watermark_wd = reg_wdata[11:8];

  assign control_int_loopback_wd = reg_wdata[30];

  assign control_sw_reset_wd = reg_wdata[31];
  assign status_re = addr_hit[5] & reg_re & !reg_error;
  assign start_we = addr_hit[6] & reg_we & !reg_error;

  assign start_wd = reg_wdata[10:0];
  assign rx_fifo_re = addr_hit[7] & reg_re & !reg_error;
  assign tx_fifo_we = addr_hit[8] & reg_we & !reg_error;

  assign tx_fifo_wd = reg_wdata[7:0];
  assign info_re = addr_hit[9] & reg_re & !reg_error;
  assign cs_we = addr_hit[10] & reg_we & !reg_error;

  assign cs_cs_0_wd = reg_wdata[0];

  assign cs_cs_1_wd = reg_wdata[1];

  assign cs_cs_2_wd = reg_wdata[2];

  assign cs_cs_3_wd = reg_wdata[3];

  // Read data return
  always_comb begin
    reg_rdata_next = '0;
    unique case (1'b1)
      addr_hit[0]: begin
        reg_rdata_next[0] = intr_state_rx_full_qs;
        reg_rdata_next[1] = intr_state_rx_watermark_qs;
        reg_rdata_next[2] = intr_state_tx_empty_qs;
        reg_rdata_next[3] = intr_state_tx_watermark_qs;
        reg_rdata_next[4] = intr_state_complete_qs;
      end

      addr_hit[1]: begin
        reg_rdata_next[0] = intr_enable_rx_full_qs;
        reg_rdata_next[1] = intr_enable_rx_watermark_qs;
        reg_rdata_next[2] = intr_enable_tx_empty_qs;
        reg_rdata_next[3] = intr_enable_tx_watermark_qs;
        reg_rdata_next[4] = intr_enable_complete_qs;
      end

      addr_hit[2]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = '0;
        reg_rdata_next[3] = '0;
        reg_rdata_next[4] = '0;
      end

      addr_hit[3]: begin
        reg_rdata_next[15:0] = cfg_half_clk_period_qs;
        reg_rdata_next[29] = cfg_msb_first_qs;
        reg_rdata_next[30] = cfg_cpha_qs;
        reg_rdata_next[31] = cfg_cpol_qs;
      end

      addr_hit[4]: begin
        reg_rdata_next[0] = '0;
        reg_rdata_next[1] = '0;
        reg_rdata_next[2] = control_tx_enable_qs;
        reg_rdata_next[3] = control_rx_enable_qs;
        reg_rdata_next[7:4] = control_tx_watermark_qs;
        reg_rdata_next[11:8] = control_rx_watermark_qs;
        reg_rdata_next[30] = control_int_loopback_qs;
        reg_rdata_next[31] = '0;
      end

      addr_hit[5]: begin
        reg_rdata_next[7:0] = status_tx_fifo_level_qs;
        reg_rdata_next[15:8] = status_rx_fifo_level_qs;
        reg_rdata_next[16] = status_tx_fifo_full_qs;
        reg_rdata_next[17] = status_rx_fifo_empty_qs;
        reg_rdata_next[18] = status_idle_qs;
      end

      addr_hit[6]: begin
        reg_rdata_next[10:0] = '0;
      end

      addr_hit[7]: begin
        reg_rdata_next[7:0] = rx_fifo_qs;
      end

      addr_hit[8]: begin
        reg_rdata_next[7:0] = '0;
      end

      addr_hit[9]: begin
        reg_rdata_next[7:0] = info_tx_fifo_depth_qs;
        reg_rdata_next[15:8] = info_rx_fifo_depth_qs;
      end

      addr_hit[10]: begin
        reg_rdata_next[0] = cs_cs_0_qs;
        reg_rdata_next[1] = cs_cs_1_qs;
        reg_rdata_next[2] = cs_cs_2_qs;
        reg_rdata_next[3] = cs_cs_3_qs;
      end

      default: begin
        reg_rdata_next = '1;
      end
    endcase
  end

  // shadow busy
  logic shadow_busy;
  assign shadow_busy = 1'b0;

  // register busy
  assign reg_busy = shadow_busy;

  // Unused signal tieoff

  // wdata / byte enable are not always fully used
  // add a blanket unused statement to handle lint waivers
  logic unused_wdata;
  logic unused_be;
  assign unused_wdata = ^reg_wdata;
  assign unused_be = ^reg_be;

  // Assertions for Register Interface
  `ASSERT_PULSE(wePulse, reg_we, clk_i, !rst_ni)
  `ASSERT_PULSE(rePulse, reg_re, clk_i, !rst_ni)

  `ASSERT(reAfterRv, $rose(reg_re || reg_we) |=> tl_o_pre.d_valid, clk_i, !rst_ni)

  `ASSERT(en2addrHit, (reg_we || reg_re) |-> $onehot0(addr_hit), clk_i, !rst_ni)

  // this is formulated as an assumption such that the FPV testbenches do disprove this
  // property by mistake
  //`ASSUME(reqParity, tl_reg_h2d.a_valid |-> tl_reg_h2d.a_user.chk_en == tlul_pkg::CheckDis)

endmodule
