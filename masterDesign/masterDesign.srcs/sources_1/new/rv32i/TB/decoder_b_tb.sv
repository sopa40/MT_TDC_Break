module DECODER_B_TB ();
	logic [31:0] instruction;
	logic [4:0]  src1;
	logic [4:0]  src2;
	logic [31:0] imm;
	logic [2:0]  funct3;
	DECODER_B decoder_b (
		.instruction	(instruction),
		.src1			(src1),
		.src2			(src2),
		.imm			(imm),
		.funct3			(funct3)
	);
	initial begin
		$dumpfile("decoder_b_tb.vcd");
		$dumpvars(0, DECODER_B_TB);
		#10;
		instruction = 32'b0000000_00001_00010_000_00001_1100011; // beq x2, x1, 2048
		#10;
		instruction = 32'b0101000_10001_11010_001_00001_1100011; // bne x26, x17, 3328
		#10;
		instruction = 32'b1111000_10101_01010_100_00000_1100011; // blt x10, x21, -2304
		#10;
		instruction = 32'b0000000_00001_00000_101_00100_1100011; // bge x0, x1, 4
		#10;
		instruction = 32'b0000000_00001_00010_111_00010_1100011; // bgeu x2, x1, 2
		#10;
		$finish();
	end
endmodule