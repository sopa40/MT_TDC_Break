module PROGRAM_COUNTER 
#(
	parameter ADDRESS_WIDTH	= 32, 
	parameter START_PC		= 32'h08000000
)(
	input  logic 						clk,
	input  logic 						rst,
	input  logic [ADDRESS_WIDTH-1:0]	pc_in,
	output logic [ADDRESS_WIDTH-1:0] 	pc_out
);

always_ff @(posedge clk) begin
	if (rst) begin
		pc_out <= START_PC;
	end else begin
		pc_out <= pc_in;
	end
end

endmodule