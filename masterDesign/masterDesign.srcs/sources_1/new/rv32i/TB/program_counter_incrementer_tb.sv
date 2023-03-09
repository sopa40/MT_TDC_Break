module PROGRAM_COUNTER_INCREMENTER_TB();

    initial begin
        $dumpfile("program_counter_incrementer_tb.vcd");
        $dumpvars(0, PROGRAM_COUNTER_INCREMENTER_TB);
        $finish();
    end
    
endmodule