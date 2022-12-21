`timescale 1ns / 1ps

//with async reset
module dff(input d, clk, reset, output logic q);
   
    always_ff @(posedge clk, negedge reset) begin
        if (reset == 0)
            q <= 0;
        else
            q <= d;
    end
endmodule
