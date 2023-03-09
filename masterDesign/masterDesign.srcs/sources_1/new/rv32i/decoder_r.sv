module DECODER_R (
	input  [31:0] instruction,
	output [4:0] src1,
	output [4:0] src2,
	output [4:0] dest,
	output [2:0] funct3,
	output [6:0] funct7
);

	assign src1 	= instruction[19:15];
	assign src2 	= instruction[24:20];
	assign dest 	= instruction[11:7];
	assign funct3 	= instruction[14:12];
	assign funct7 	= instruction[31:25];

endmodule