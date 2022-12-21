`timescale 1ns / 1ps

module inv_pair_tb();
    
    reg a;
    wire b;
    wire [9:0] mux_in;
    inv_chain uut(.a(a), .mux_in(mux_in), .b(b));
    
    initial begin 
        a <= 0;
        
        //delay for initialization
        #100 
         
        forever #20 a <= ~a;
    end
    
    
    
endmodule
