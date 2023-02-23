// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Thu Feb 23 15:32:36 2023
// Host        : DESKTOP-ROSU00D running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/vivado_pj/masterDesign/masterDesign.gen/sources_1/ip/clock_gen_24MHz/clock_gen_24MHz_stub.v
// Design      : clock_gen_24MHz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clock_gen_24MHz(clk_out, reset, locked, clk_in)
/* synthesis syn_black_box black_box_pad_pin="clk_out,reset,locked,clk_in" */;
  output clk_out;
  input reset;
  output locked;
  input clk_in;
endmodule
