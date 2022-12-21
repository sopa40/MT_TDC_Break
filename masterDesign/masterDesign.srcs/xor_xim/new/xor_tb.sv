`timescale 1ns / 1ps

module xor_tb();
    
    reg a, b;
    wire c;
    
    xor_gate uut(.a(a), .b(b), .c(c));
    
    initial begin 
        a <= 0;
        b <= 1;
        //delay for initialization
        #100 
        
        a = 0; b = 0;
        #100 a = 0; b = 1;
        #100 a = 1; b = 0; 
        #100 a = 1; b = 1; 
    end
    
    
    
endmodule
