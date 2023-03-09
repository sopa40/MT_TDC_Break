module DECODER_J_TB();

    logic [31:0] instruction;
    logic [31:0] imm;
    logic [4:0]  dest;
	
    DECODER_J decoder_j(
        .*
    );

    initial begin
        $dumpfile("decoder_j_tb.vcd");
        $dumpvars(0, DECODER_J_TB);

        // 32'bIMMEDIATE_RD_0010011
        #10;
        instruction = 10101010101010101010_00000_1101111; // jal x0, -351574
        #10;
        instruction = 01010101010101010101_00100_1101111; // jal x4, 351572
        #10;
        instruction = 01010101010101010110_01000_1101111; // jal x8, 355668
        #10;
        instruction = 10000000000000000000_01000_1101111; // jal x8, -1048576
        #10;
        $finish();
    end

endmodule