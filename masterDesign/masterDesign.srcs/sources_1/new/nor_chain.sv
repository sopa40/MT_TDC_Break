`timescale 1ns / 1ps

module nor_pair(input a, output logic b);

    logic value, trans;

    module nor_gate(input a, b, output logic c);
        assign c = ~(a|b);
    endmodule 

    initial begin
        value <= 0;
    end  
    
    nor_gate gate1(.a(a), .b(value), .c(trans));
    nor_gate gate2(.a(trans), .b(value), .c(b));    

endmodule

module nor_chain #(parameter NOR_DELAY_LEN = 4)(input a,
                            output logic [NOR_DELAY_LEN - 1:0] mux_in, output logic b);
    
    logic [NOR_DELAY_LEN - 1 : 0] trans;
    
    generate
        for (genvar i = 0; i < NOR_DELAY_LEN; i = i+1) begin
            if (i == 0) begin
                nor_pair nor_pair_unit(.a(a), .b(trans[i])); 
            end           
            else begin
                nor_pair nor_pair_unit(.a(trans[i-1]), .b(trans[i]));
            end
            assign mux_in[i] = trans[i];
        end 
    endgenerate
    
    assign b = trans[NOR_DELAY_LEN-1];  
endmodule
