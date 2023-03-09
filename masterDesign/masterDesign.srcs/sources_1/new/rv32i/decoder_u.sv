module DECODER_U (
	input  logic [31:0] instruction,
	output logic [31:0] imm,
	output logic [4:0]  dest
);	
	assign imm  = {instruction[31:12], {12{1'b0}} };
	assign dest = instruction[11:7];
endmodule