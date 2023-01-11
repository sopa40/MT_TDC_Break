`timescale 1ns / 1ps

module top_tb();

    logic btn, rgb, led, clk, tx, uart_rx, pio1, pio9;
    
    top_module uut(btn, rgb, led, clk, tx, uart_rx, pio1, pio9);
    
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
