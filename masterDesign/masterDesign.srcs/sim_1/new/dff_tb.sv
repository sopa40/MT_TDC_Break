`timescale 1ns / 1ps

module dff_tb();
    reg d, clk, reset;
    wire q;
   
    
    dff out(.d(d), .clk(clk), .reset(reset), .q(q));  
    
    initial begin  
        clk <= 0;  
        d <= 0;  
        reset <= 0;  
        
        //delay for initialization
        #100 
        
        d <= 1;  
        
        #20 
        
        reset <= 1;  
        
        #20 
        
        forever #20 d <= ~d;
    end  
    
    always #10 clk = ~clk;
    
endmodule
