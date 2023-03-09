module registerfile_tb();

    logic clk;
    initial clk = 0;
    always #5 clk = ~clk;

    localparam NUMBER_OF_REGISTERS = 32;
    localparam REGISTER_WIDTH = 32;
    localparam REGISTER_INITIAL_VALUE = 0;
    localparam REGISTER_ADDRESS_WIDTH=$clog2(NUMBER_OF_REGISTERS);

    logic rst, we;
    logic [REGISTER_ADDRESS_WIDTH-1:0] dest_address, src1_address, src2_address;
    logic [REGISTER_WIDTH] dest_value;
    wire  [REGISTER_WIDTH-1:0] src1_data, src2_data;

    REGISTERFILE rf (
        .clk(clk),
        .rst(rst),
        .we(we),

        .dest_address(dest_address),
        .src1_address(src1_address),
        .src2_address(src2_address),
        
        .dest_value(dest_value),
        .src1_data(src1_data),
        .src2_data(src2_data)
    );
    defparam rf.NUMBER_OF_REGISTERS = NUMBER_OF_REGISTERS;
    defparam rf.REGISTER_WIDTH = REGISTER_WIDTH;
    defparam rf.REGISTER_INITIAL_VALUE = 0;

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, registerfile_tb);

        #0;
        rst          = 0;
        we           = 0;
        dest_address = 5'd0;
        src1_address = 5'd0;
        src2_address = 5'd0;
        dest_value   = 32'd0;

        #10;
        dest_address = 5'd0;
        dest_value = 32'haabbccdd;
        we = 1;

        #10;
        rst          = 0;
        we           = 0;
        dest_address = 5'd1;
        src1_address = 5'd0;
        src2_address = 5'd1;
        dest_value   = 32'd187;

        #10;
        rst          = 0;
        we           = 1;
        dest_address = 5'd1;
        src1_address = 5'd0;
        src2_address = 5'd1;
        dest_value   = 32'd187;
        
        #10;
        rst          = 1;
        we           = 1;
        dest_address = 5'd1;
        src1_address = 5'd0;
        src2_address = 5'd1;
        dest_value   = 32'd187;

        #10;
        rst          = 0;
        we           = 0;
        dest_address = 5'd0;
        src1_address = 5'd0;
        src2_address = 5'd0;
        dest_value   = 32'd0;    

        #10;
        $finish();
    end

endmodule