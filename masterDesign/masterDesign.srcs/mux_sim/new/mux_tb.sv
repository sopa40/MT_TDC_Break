`timescale 1ns / 1ps

module mux_tb();

    logic [3:0] mux_in;
    logic [1:0] select;
    logic out;
    
    generic_mux #(.NUMBER(4)) uut(.sel(select), .mux_in(mux_in), .out(out));
    
    initial begin
        mux_in[0] = 1;
        mux_in[1] = 0;
        mux_in[2] = 1;
        mux_in[3] = 0;
        
        select = 2;
        
        forever begin
            #40 select = select + 1;
            $display("select value is: %b", out);
        end    
    end

endmodule
