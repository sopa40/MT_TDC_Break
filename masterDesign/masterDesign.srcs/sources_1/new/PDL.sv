module PDL
#(
    parameter  MAXIMUM_DELAY_CHAIN_LENGTH = 256,
    parameter  COARSE_GRAINED_DELAY       = 1'b1, 
    localparam MAXIMUM_DELAY_CHAIN_LENGTH_WIDTH = $clog2(MAXIMUM_DELAY_CHAIN_LENGTH)
)(
    input  logic                                            signal,
    input  logic [MAXIMUM_DELAY_CHAIN_LENGTH_WIDTH-1:0]     active_number_of_delay_units,
    output logic                                            delayed_signal
);
    
    genvar i;
    generate
        logic [MAXIMUM_DELAY_CHAIN_LENGTH-1:0] intermediates;
        
        for (i=0; i<MAXIMUM_DELAY_CHAIN_LENGTH; i++) begin
            if (i==0) begin
                LUT lut_0(
                    .i0(signal),
                    .i1(COARSE_GRAINED_DELAY),
                    .i2(COARSE_GRAINED_DELAY),
                    .i3(COARSE_GRAINED_DELAY),
                    .i4(COARSE_GRAINED_DELAY),
                    .i5(COARSE_GRAINED_DELAY),
                    .o(intermediates[0])  
                );
            end else begin
                 LUT lut_i(
                    .i0(intermediates[i-1]),
                    .i1(COARSE_GRAINED_DELAY),
                    .i2(COARSE_GRAINED_DELAY),
                    .i3(COARSE_GRAINED_DELAY),
                    .i4(COARSE_GRAINED_DELAY),
                    .i5(COARSE_GRAINED_DELAY),
                    .o(intermediates[i])  
                );
            end
        end
        
        assign delayed_signal = intermediates[active_number_of_delay_units];
        
    endgenerate

endmodule
