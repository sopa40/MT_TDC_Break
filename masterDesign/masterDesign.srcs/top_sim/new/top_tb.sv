`timescale 1ns / 1ps

module top_tb();

    reg clk;
    wire b;
    
    top_module uut(.clk(clk), .error(b));
    
    initial begin 
        clk <= 0;
        
        //delay for initialization
        #20 
        uut.data_ref <= 1;
        uut.launch_reset <= 1;
        uut.capture_reset <= 1;
        uut.delay.sel <= 1;
        forever begin
            #5 clk <= ~clk; 
        end 
        
            
    end
    
    always @(*) begin
            #40 uut.data_ref <= 1'b0;
            #40 uut.data_ref <= 1'bz;
            #40 uut.data_ref <= 1'b1; 
            uut.delay.sel <= uut.delay.sel + 1;  
    end

    

endmodule
