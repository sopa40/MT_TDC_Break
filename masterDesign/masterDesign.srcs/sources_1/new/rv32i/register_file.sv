module REGISTERFILE 
#(
    parameter  NUMBER_OF_REGISTERS      = 32, 
    parameter  REGISTER_WIDTH           = 32, 
    parameter  REGISTER_INITIAL_VALUE   = 0, 
    localparam REGISTER_ADDRESS_WIDTH   = $clog2(NUMBER_OF_REGISTERS)
)(
    input  logic                                        clk,
    input  logic                                        rst,
    input  logic                                        we,
    input  logic [REGISTER_ADDRESS_WIDTH-1:0]           dest_address,
    input  logic [REGISTER_ADDRESS_WIDTH-1:0]           src1_address,
    input  logic [REGISTER_ADDRESS_WIDTH-1:0]           src2_address,
    input  logic [REGISTER_WIDTH-1:0]                   dest_value,
    
    output logic [REGISTER_WIDTH-1:0]                   src1_data,
    output logic [REGISTER_WIDTH-1:0]                   src2_data
);

    logic [NUMBER_OF_REGISTERS-1:0] register_values [REGISTER_WIDTH-1:0];
    
    genvar i;
    generate
    for (i=0; i < NUMBER_OF_REGISTERS; i=i+1) begin
        if (i == 0) begin
            REGISTER X0 (
                .clk      (clk),
                .rst      (rst),
                .we       (1'b0),
                .set_value('d0),
                .value    (register_values[0])
            );
            defparam X0.INITIAL_VALUE = 0;
        end else begin
            REGISTER Xi (
                .clk        (clk), 
                .rst        (rst), 
                .we         ( we && (dest_address == i) ), 
                .set_value  (dest_value), 
                .value      (register_values[i])
            );
            defparam Xi.INITIAL_VALUE = REGISTER_INITIAL_VALUE;
        end
    end
    endgenerate

    assign src1_data = register_values[src1_address];
    assign src2_data = register_values[src2_address];
    
endmodule