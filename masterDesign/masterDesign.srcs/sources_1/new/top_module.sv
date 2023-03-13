`timescale 1ns / 1ps

`ifndef SET_LEN_START_CMD
    `define SET_LEN_START_CMD 8'h73
`endif

`ifndef SET_LEN_SUCCESS_RESPONSE
    `define SET_LEN_SUCCESS_RESPONSE 8'h76
`endif

module top_module
(
                    input logic         clk,
                    input logic [1:0]   btn,
                    input logic         uart_rx,
                    output logic [3:0]  led,
                    output logic [2:0]  rgb,
                    output logic        tx,                     
                    /* reference data for delay line */
                    output logic        pio1, 
                    /* actual data after delay line */
                    output logic        pio9, 
                    /* whole chain output */
                    output logic        pio16, 
                    /* clock output */
                    output logic        pio40
);
    /* rst vars */
    logic rst, rst_indicator;
    /* delay vars */
    localparam MAXIMUM_COARSE_DELAY_CHAIN_LENGTH         = 256;
    localparam MAXIMUM_FINE_DELAY_CHAIN_LENGTH           = 256;
    localparam MAXIMUM_COARSE_DELAY_CHAIN_LENGTH_WIDTH   = $clog2(MAXIMUM_COARSE_DELAY_CHAIN_LENGTH);
    localparam MAXIMUM_FINE_DELAY_CHAIN_LENGTH_WIDTH     = $clog2(MAXIMUM_FINE_DELAY_CHAIN_LENGTH);
    logic [MAXIMUM_COARSE_DELAY_CHAIN_LENGTH_WIDTH-1:0]   number_of_active_coarse_delay_elements;
    logic [MAXIMUM_FINE_DELAY_CHAIN_LENGTH_WIDTH-1:0]     number_of_active_fine_delay_elements;
    logic core_clk, data_ref, data_actual;
    /* Chain output */
    logic xor_result, error;
    /* UART RX vars */
    logic rx_indicator, valid;
    logic [7:0] rx_data_out;
    /* UART TX vars */
    logic en, rdy;
    logic [7:0] tx_data_in;
    /* UART state machine */
    state_t current_state;
    
    /* Signal outputs */
    assign pio1 = data_ref;  
    assign pio9 = data_actual;
    assign pio16 = error;
    assign pio40 = clk;
    
    assign rst = btn[0];
    assign led[3] = rst_indicator;
    
    /* 24MHz clk */
    logic clk_24Mhz;
    logic locked;
    clock_gen_24MHz (.clk_in(clk), .clk_out(clk_24Mhz), .locked(locked), .reset(rst));
  
    /* delay chain module */
    dff lauch_dff(.d(core_clk), .clk(clk_24Mhz), .reset(rst), .q(data_ref));
    
    DelayChain delay_chain (
        .signal                                  (data_ref),
        .number_of_active_coarse_delay_elements  (number_of_active_coarse_delay_elements),
        .number_of_active_fine_delay_elements    (number_of_active_fine_delay_elements),
        .delayed_signal                          (data_actual)
    );
    defparam delay_chain.MAXIMUM_COARSE_DELAY_CHAIN_LENGTH  = MAXIMUM_COARSE_DELAY_CHAIN_LENGTH;
    defparam delay_chain.MAXIMUM_FINE_DELAY_CHAIN_LENGTH    = MAXIMUM_FINE_DELAY_CHAIN_LENGTH;
    
    xor_gate data_comp(.a(data_ref), .b(data_actual), .c(xor_result));
    dff capture_dff(.d(xor_result), .clk(clk_24Mhz), .reset(rst), .q(error));
    
    /* UART module */
    assign led[0] = rx_indicator;
    uart_rx uart_reader(.clk(clk), .rst(rst), 
                .din(uart_rx), .data_out(rx_data_out), .valid(valid));
    uart_tx uart_writer(.clk(clk), .rst(rst), .data_in(tx_data_in), .en(en), .dout(tx), .rdy(rdy));
    
    /* CORE */ 
    //CORE core();
    
    /* Core and delay chain clocking */
    always_ff @ (posedge clk_24Mhz) begin
        if (rst) begin
            core_clk <= 0;
            rst_indicator <= 1;
            /* disable other LEDs */ 
            led[2:1] <= 3'b000;
            rgb[2:0] <= 3'b111;
        end
        else begin
            rst_indicator <= 0;
            core_clk <= ~core_clk;
        end  
    end
    
    /* Mainly UART Clocking */
    always_ff @ (posedge clk) begin
        if (rst) begin
            rx_indicator <= 0;
        end 
        else begin
            /* UART Code */
            en <= en;
            case (current_state)
                IDLE: begin
                    en <= 0;
                    if (valid && rx_data_out == `SET_LEN_START_CMD) begin
                        current_state <= RCV_FIRST_BYTE;
                    end
                end
                RCV_FIRST_BYTE: begin
                    if (valid) begin
                        number_of_active_coarse_delay_elements[MAXIMUM_COARSE_DELAY_CHAIN_LENGTH_WIDTH-1:0] <= rx_data_out[7:0];
                        current_state <= RCV_SECOND_BYTE;
                    end
                end
                RCV_SECOND_BYTE: begin
                    if (valid) begin
                        number_of_active_fine_delay_elements[MAXIMUM_FINE_DELAY_CHAIN_LENGTH_WIDTH-1:0] <= rx_data_out[7:0];
                        current_state <= RCVD;
                    end
                end
                RCVD: begin
                    if (rdy) begin
                        current_state <= SET_DONE;
                    end
                end
                SET_DONE: begin
                    if (rdy) begin
                        rx_indicator <= ~rx_indicator;
                        tx_data_in[7:0] <= `SET_LEN_SUCCESS_RESPONSE;
                        en <= 1;
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule
