module ALU_TB();
    
    logic [4:0]  alu_op;
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [31:0] result;
    logic        result_equals_zero;
    
    ALU alu (
        .alu_op             (alu_op),
        .operand_a          (operand_a),
        .operand_b          (operand_b),
        .result             (result),
        .result_equals_zero (result_equals_zero)
    );

    integer i;

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, ALU_TB);

        #0;
        operand_a = 32'h0;
        operand_b = 32'h0;
        alu_op    = 5'b00000;
        
        #10;
        operand_a = 32'h11223344;
        for (i=0; i<11; i=i+1) begin
            alu_op = i;
            #5;
        end

        #10;
        operand_b = 32'haabbccdd;
        for (i=0; i<11; i=i+1) begin
            alu_op = i;
            #5;
        end
        
        #10;
        $finish();
    end
endmodule