`timescale 1ns / 1ps

//taken from https://electronics.stackexchange.com/questions/552516/how-to-build-large-multiplexers-using-systemverilog

module generic_mux #(parameter NUMBER = 2, 
                     localparam SELECT_W = $clog2(NUMBER)) 
 (input logic [SELECT_W-1:0] sel, 
  input logic [NUMBER-1:0] mux_in,                   
  output logic out);
  
  assign out = mux_in[sel];
    
endmodule 
