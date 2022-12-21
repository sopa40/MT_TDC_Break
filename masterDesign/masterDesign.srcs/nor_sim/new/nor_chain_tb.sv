`timescale 1ns / 1ps

module nor_chain_tb();

    reg a;
    wire b;
    wire [9:0] mux_in;
    nor_chain uut(.a(a), .mux_in(mux_in), .b(b));
    
    initial begin 
        a <= 0;
        
        //delay for initialization
        #100 
        
        a <= 1;
        #20 a <= 0;
        #20 a <= 1'bz;
        #20 a <= 0;
    end

endmodule
