module DECODER_I_TB();

	logic [31:0] 	instruction;
	logic [4:0]  	src1;
	logic [31:0] 	imm;
	logic [4:0]  	dest;
	logic [2:0]  	funct3;

    DECODER_I decoder_i(
        .*
    );

    initial begin
        $dumpfile("decoder_i_tb.vcd");
        $dumpvars(0, DECODER_I_TB);

        // 32'b000000000000_RS1_100_RD_0010011
        #10;
        instruction = 32'b000000000000_00010_100_00001_0010011; // xori x1, x2, 0
        #10;    
        instruction = 32'b101010101010_00100_111_10001_0010011; // andi x17, x4, -1366
        #10;
        instruction = 32'b010100110011_10010_100_00010_0010011; // xori x2, x18, 1331
        #10;
        instruction = 32'b000000000000_00010_110_00001_0010011; // ori x1, x2, 0
        #10;
        $finish();
    end


    
endmodule