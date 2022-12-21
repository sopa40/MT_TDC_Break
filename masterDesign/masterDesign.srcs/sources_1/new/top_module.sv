`timescale 1ns / 1ps

//-------------------------------specify delay length in TOP module or in delay chain module? 
`ifndef INV_DELAY_LEN
    `define INV_DELAY_LEN 4
`endif

`ifndef NOR_DELAY_LEN
    `define NOR_DELAY_LEN 3
`endif

module top_module(input clk, output logic error);

    logic launch_reset, capture_reset;
    logic data_ref, data_actual;
    logic xor_result;
    
    dff lauch_dff(.d(data_ref), .clk(clk), .reset(launch_reset), .q(data_ref));
    
    delay_chain #(.INV_DELAY_LEN_INPUT(`INV_DELAY_LEN), .NOR_DELAY_LEN_INPUT(`NOR_DELAY_LEN)) delay (.a(data_ref), .b(data_actual));
    
    xor_gate data_comp(.a(data_ref), .b(data_actual), .c(xor_result));
    
    dff capture_dff(.d(xor_result), .clk(clk), .reset(capture_reset), .q(error));

endmodule
