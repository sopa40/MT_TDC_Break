`timescale 1ns / 1ps

module ring_oscillator #(
  parameter int OSC_INV_NUMBER = 3   // Number of inverters in the chain
) (
  output logic out
);

  (*DONT_TOUCH= "true"*) logic [OSC_INV_NUMBER-1:0] inv;    

  generate
    genvar i;
    for (i = 0; i < OSC_INV_NUMBER; i++) begin
      (*DONT_TOUCH= "true"*) assign inv[i] = (i == 0) ? !inv[OSC_INV_NUMBER-1] : !inv[i-1];
    end
  endgenerate
  
  assign out = inv[OSC_INV_NUMBER-1];

endmodule
