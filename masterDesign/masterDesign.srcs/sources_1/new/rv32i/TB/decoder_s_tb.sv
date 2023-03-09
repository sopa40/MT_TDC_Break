module DECODER_S_TB ();

	logic [31:0] instruction;
	logic [4:0]  src1;
	logic [4:0]  src2;
	logic [31:0] imm;
	logic [2:0]  funct3;

	DECODER_S deocder_s (
		.instruction	(instruction),
		.src1			(src1),
		.src2			(src2),
		.imm			(imm),
		.funct3			(funct3)
	);

	initial begin
		$dumpfile("decoder_s_tb.vcd");
		$dumpvars(0, DECODER_S_TB);

		#10;
		$finish();
	end

endmodule