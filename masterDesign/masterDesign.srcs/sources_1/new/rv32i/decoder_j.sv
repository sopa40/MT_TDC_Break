module DECODER_J (
	input  logic [31:0] instruction,
	output logic [31:0] imm,
	output logic [4:0]  dest
);
	//000000000000_00000000_0_0000000000_0

	/*
	assign imm = {
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[31],
		instruction[19],
		instruction[18],
		instruction[17],
		instruction[16],
		instruction[15],
		instruction[14],
		instruction[13],
		instruction[12],
		instruction[20],
		instruction[30],
		instruction[29],
		instruction[28],
		instruction[27],
		instruction[26],
		instruction[25],
		instruction[24],
		instruction[23],
		instruction[22],
		instruction[21]
	};
	*/

	assign imm = {
		{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0
	};

	assign dest 	= instruction[11:7];

endmodule

