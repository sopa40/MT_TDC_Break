module MUX_TB();

    initial begin
        $dumpfile("mux_tb.vcd");
        $dumpvars(0, MUX_TB);
        $finish();
    end
    
endmodule