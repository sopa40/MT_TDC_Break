module PC_INCREMENTER 
#(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] pc,
    output logic [WIDTH-1:0] incremented_pc
);
    assign incremented_pc = pc + 4;
endmodule