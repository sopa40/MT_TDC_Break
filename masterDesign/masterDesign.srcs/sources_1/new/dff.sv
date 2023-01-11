`timescale 1ns / 1ps

//with sync reset
module dff(input d, clk, reset, output logic q);
   
    always_ff @(posedge clk) begin
        if (reset == 1)
            q <= 0;
        else
            q <= d;
    end
endmodule
