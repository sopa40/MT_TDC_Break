`timescale 1ns / 1ps

module delay_chain 
#(    parameter INV_DELAY_LEN_INPUT = 2,
      parameter NOR_DELAY_LEN_INPUT = 2)
     
 (      input              delay_in, 
        input [$clog2(INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT) - 1 : 0] sel,
        output logic       delay_out);
    
    
    logic trans;
    logic chain_out;
    // how to sum the size into 1 variable??
    //e.g.  const logic delay_len = INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT;
    logic [INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT - 1 : 0] mux_in;
    
    
    
    inv_chain #(.INV_DELAY_LEN(INV_DELAY_LEN_INPUT)) inv_delay_line(.a(delay_in), 
                            .mux_in(mux_in [INV_DELAY_LEN_INPUT - 1 : 0]), .b(trans));
    nor_chain #(.NOR_DELAY_LEN(NOR_DELAY_LEN_INPUT)) nor_delay_line(.a(trans), 
                            .mux_in(mux_in[INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT - 1 : INV_DELAY_LEN_INPUT]), .b(chain_out));
                            
    generic_mux #(.NUMBER(INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT)) sel_mux (.sel(sel), .mux_in(mux_in[INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT - 1 : 0]), .mux_out(delay_out));
    
endmodule
