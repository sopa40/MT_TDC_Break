module REGISTER 
#(
    parameter WIDTH         = 32, 
    parameter INITIAL_VALUE = 0
)(
    input  logic clk,
    input  logic rst,
    input  logic we,
    input  logic [WIDTH-1:0] set_value,
    output logic [WIDTH-1:0] value
);

    always_ff @(posedge clk) begin
        if (rst) begin
            value <= INITIAL_VALUE;
        end else if (we) begin 
            value <= set_value;
        end
    end

endmodule