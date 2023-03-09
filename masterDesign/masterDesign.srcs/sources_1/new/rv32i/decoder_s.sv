module DECODER_S (
	input  logic [31:0] instruction,
	output logic [4:0]  src1,
	output logic [4:0]  src2,
	output logic [31:0] imm,
	output logic [2:0]  funct3
);

	assign src1 	= instruction[19:15];
	assign src2 	= instruction[24:20];
	assign imm 		= {{21{instruction[31]}}, {instruction[30:25], instruction[11:7]}};
	assign funct3 	= instruction[14:12];

endmodule