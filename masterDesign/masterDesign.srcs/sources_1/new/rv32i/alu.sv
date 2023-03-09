module ALU
#(
    parameter OPERAND_WIDTH=32
)(
    input           [ALU_CTRL_WIDTH-1:0]   alu_op,
    input    logic  [OPERAND_WIDTH-1:0]    operand_a,
    input    logic  [OPERAND_WIDTH-1:0]    operand_b,
    output   logic  [OPERAND_WIDTH-1:0]    result,
    output   logic                         result_equals_zero
);

    assign result_equals_zero = (result == 'b0);

    always @(*) begin
        case (alu_op)
            ALU_OP_ADD:    result = operand_a +   operand_b;
            ALU_OP_SUB:    result = operand_a -   operand_b;
            ALU_OP_SLL:    result = operand_a <<  operand_b[4:0];
            ALU_OP_SRL:    result = operand_a >>  operand_b[4:0];
            ALU_OP_SRA:    result = operand_a >>> operand_b[4:0];
            ALU_OP_SEQ:    result = {31'b0, operand_a == operand_b};
            ALU_OP_SLT:    result = {31'b0, operand_a < operand_b};
            ALU_OP_SLTU:   result = {31'b0, $unsigned(operand_a) < $unsigned(operand_b)};
            ALU_OP_XOR:    result = operand_a ^ operand_b;
            ALU_OP_OR:     result = operand_a | operand_b;
            ALU_OP_AND:    result = operand_a & operand_b;
            ALU_OP_ID_A:   result = operand_a;
            ALU_OP_ID_B:   result = operand_b;
            default:       result = 'b0;
        endcase
    end
endmodule