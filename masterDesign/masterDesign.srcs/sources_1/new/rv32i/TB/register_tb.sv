module register_tb();
    
    localparam WIDTH = 32;
    localparam INITIAL_VALUE = 0;
        
    logic clk, rst, we;
    logic [WIDTH-1:0] set_value;

    wire [WIDTH-1:0] value;

    REGISTER r (.clk(clk), .rst(rst), .we(we), .set_value(set_value), .value(value));
    defparam r.WIDTH = 32;
    defparam r.INITIAL_VALUE = 0;

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);
        #0;
        rst = 0;
        we = 0;
        set_value = {WIDTH{1'b0}};;
        #10;
        set_value = {WIDTH{1'b1}};
        #10;
        we = 1;
        #10;
        we = 0;
        #10;
        rst = 1;
        #10;
        rst = 0;    
        we = 1;
        $display("register_tb Done.");
        #10;
        $finish();
    end
endmodule