`timescale 1ns / 1ps

module delay_chain 
#(    parameter INV_DELAY_LEN_INPUT = 2,
      parameter NOR_DELAY_LEN_INPUT = 2)
     
 (      input              a, 
        output logic       b);
    
    
    logic trans;
    logic delay_out;
    // how to sum the size into 1 variable??
    //e.g.  const logic delay_len = INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT;
    logic [INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT - 1 : 0] mux_in ;
    logic [$clog2(INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT) - 1 : 0] sel ;
    
    (*DONT_TOUCH= "true"*) inv_chain #(.INV_DELAY_LEN(INV_DELAY_LEN_INPUT)) inv_delay_line(.a(a), 
                            .mux_in(mux_in [INV_DELAY_LEN_INPUT - 1 : 0]), .b(trans));
    nor_chain #(.NOR_DELAY_LEN(NOR_DELAY_LEN_INPUT)) nor_delay_line(.a(trans), 
                            .mux_in(mux_in[INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT - 1 : INV_DELAY_LEN_INPUT]), .b(b));
                            
    //generic_mux #(.NUMBER(INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT)) sel_mux (.sel(sel), .mux_in(mux_in[INV_DELAY_LEN_INPUT + NOR_DELAY_LEN_INPUT - 1 : 0]), .out(b));
    
endmodule
