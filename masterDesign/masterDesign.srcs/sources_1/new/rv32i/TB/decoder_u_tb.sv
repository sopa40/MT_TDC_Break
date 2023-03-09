module DECODER_U_TB ();
	
	logic [31:0] instruction;
	logic [31:0] imm;
	logic [4:0]  dest;

	DECODER_U decoder_u (
		.instruction(instruction),
		.imm(imm),
		.dest(dest)
	);

	initial begin
		$dumpfile("decoder_u_tb.vcd");
		$dumpvars(0, DECODER_U_TB);

		#10;
		$finish();
	end

endmodule