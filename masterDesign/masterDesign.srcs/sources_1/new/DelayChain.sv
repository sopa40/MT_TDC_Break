module DelayChain
#(
    parameter  MAXIMUM_COARSE_DELAY_CHAIN_LENGTH         = 256,
    parameter  MAXIMUM_FINE_DELAY_CHAIN_LENGTH           = 256,
    localparam MAXIMUM_COARSE_DELAY_CHAIN_LENGTH_WIDTH   = $clog2(MAXIMUM_COARSE_DELAY_CHAIN_LENGTH),
    localparam MAXIMUM_FINE_DELAY_CHAIN_LENGTH_WIDTH     = $clog2(MAXIMUM_FINE_DELAY_CHAIN_LENGTH)
)(
    input  logic                                                    signal,
    input  logic [MAXIMUM_COARSE_DELAY_CHAIN_LENGTH_WIDTH-1:0]      number_of_active_coarse_delay_elements,
    input  logic [MAXIMUM_COARSE_DELAY_CHAIN_LENGTH_WIDTH-1:0]      number_of_active_fine_delay_elements,
    output logic                                                    delayed_signal
);
    
    logic intercoarse; // haha, good one!
    PDL coarse_pdl (
        .signal                         (signal),
        .active_number_of_delay_units   (number_of_active_coarse_delay_elements),
        .delayed_signal                 (intercoarse)
    );  
    defparam coarse_pdl.MAXIMUM_DELAY_CHAIN_LENGTH  = MAXIMUM_COARSE_DELAY_CHAIN_LENGTH;
    defparam coarse_pdl.COARSE_GRAINED_DELAY        = 1'b1;

    PDL fine_pdl (
        .signal                         (intercoarse),
        .active_number_of_delay_units   (number_of_active_fine_delay_elements),
        .delayed_signal                 (delayed_signal)
    );
    defparam coarse_pdl.MAXIMUM_DELAY_CHAIN_LENGTH  = MAXIMUM_FINE_DELAY_CHAIN_LENGTH;
    defparam coarse_pdl.COARSE_GRAINED_DELAY        = 1'b0;

endmodule
