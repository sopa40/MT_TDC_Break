module CORE_TB();
    logic clk;
    logic rst;

    CORE core (
        .clk(clk),
        .rst(rst)
    );
    defparam core.INSTRUCTION_WIDTH         = 32;
    defparam core.NUMBER_OF_REGISTERS       = 32;
    defparam core.REGISTER_WIDTH            = 32;
    defparam core.REGISTER_INITIAL_VALUE    = 0;

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("core_tb.vcd");
        $dumpvars(0, CORE_TB);
        #0;
        rst = 0;
        #10;
        rst = 1;
        #10;
        rst = 0;
        #1000000;
        $finish();
    end
endmodule