`timescale 1ns / 1ps

module nor_pair(input a, output logic b);

    (*DONT_TOUCH= "true"*) logic value, trans;

    module nor_gate(input a, b, output logic c);
        (*DONT_TOUCH= "true"*) assign c = ~(a|b);
    endmodule 

    initial begin
        (*DONT_TOUCH= "true"*) value <= 0;
    end  
    
    (*DONT_TOUCH= "true"*) nor_gate gate1(.a(a), .b(value), .c(trans));
    (*DONT_TOUCH= "true"*) nor_gate gate2(.a(trans), .b(value), .c(b));    

endmodule

module nor_chain #(parameter NOR_DELAY_LEN = 4)(input a,
                            output logic [NOR_DELAY_LEN - 1:0] mux_in, output logic b);
    
    (*DONT_TOUCH= "true"*) logic [NOR_DELAY_LEN - 1 : 0] trans;
    
    generate
        for (genvar i = 0; i < NOR_DELAY_LEN; i = i+1) begin
            if (i == 0) begin
                (*DONT_TOUCH= "true"*) nor_pair nor_pair_unit(.a(a), .b(trans[i])); 
            end           
            else begin
                (*DONT_TOUCH= "true"*) nor_pair nor_pair_unit(.a(trans[i-1]), .b(trans[i]));
            end
            (*DONT_TOUCH= "true"*) assign mux_in[i] = trans[i];
        end 
    endgenerate
    
    (*DONT_TOUCH= "true"*) assign b = trans[NOR_DELAY_LEN-1];  
endmodule
