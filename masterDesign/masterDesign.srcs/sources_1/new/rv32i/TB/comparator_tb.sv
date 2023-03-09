module COMPARATOR_TB();

    localparam VALUE_WIDTH = 32;
    logic [VALUE_WIDTH-1:0] val_a;
    logic [VALUE_WIDTH-1:0] val_b;
    comparison_t 		    comparison_type;
    logic 		            eq;
    logic 		            lt;

    COMPARATOR cmp (
        .*
    );
    defparam cmp.VALUE_WIDTH = 32;

    initial begin
        $dumpfile("comparator_tb.vcd");
        $dumpvars(0, COMPARATOR_TB);
        #10;
        val_a           = 0;
        val_b           = 0;
        comparison_type = COMPARISON_SIGNED;
        #10;
        val_a           = 1;
        #10;
        val_b           = 1;
        #10;
        val_a           = 0;
        #10;
        val_b           = 0;
        #20;
        val_a           = 0;
        val_b           = 0;
        comparison_type = COMPARISON_UNSIGNED;
        #10;
        val_a           = 1;
        #10;
        val_b           = 1;
        #10;
        val_a           = 0;
        #10;
        val_b           = 0;
        #100;
        $finish();
    end

endmodule