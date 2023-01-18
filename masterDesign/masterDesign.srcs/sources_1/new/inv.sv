`timescale 1ns / 1ps

module inv_pair(input a, output logic b);

    (*DONT_TOUCH= "true"*) logic trans;

    module inv_gate(input a, output logic b);
        (*DONT_TOUCH= "true"*) assign b = ~a;
    endmodule
    
    (*DONT_TOUCH= "true"*) inv_gate inv_one(.a(a), .b(trans));
    (*DONT_TOUCH= "true"*) inv_gate inv_two(.a(trans), .b(b));

endmodule


module inv_chain #(parameter INV_DELAY_LEN = 10)(input a, output logic [INV_DELAY_LEN - 1:0] mux_in, 
                                                            output logic b);
    
    logic [INV_DELAY_LEN-1:0] trans;
    
    generate
        for (genvar i = 0; i < INV_DELAY_LEN; i = i+1) begin
            if (i == 0) begin
                (*DONT_TOUCH= "true"*) inv_pair inv_pair_unit(.a(a), .b(trans[i]));
            end        
            else begin
                (*DONT_TOUCH= "true"*) inv_pair inv_pair_unit(.a(trans[i-1]), .b(trans[i]));
            end
            (*DONT_TOUCH= "true"*) assign mux_in[i] = trans[i];
        end
    endgenerate
    
    (*DONT_TOUCH= "true"*) assign b = trans[INV_DELAY_LEN-1];  
    
     
    
endmodule