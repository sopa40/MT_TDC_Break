module PROGRAM_COUNTER_TB();

    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, PROGRAM_COUNTER_TB);
        $finish();
    end
    
endmodule