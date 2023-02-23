`timescale 1ns / 1ps

`ifndef DIVISOR_SIZE 
    // 100 Hz - 60000
    `define DIVISOR_SIZE 20
`endif
 
`ifndef INV_DELAY_LEN
    `define INV_DELAY_LEN 500
`endif

`ifndef NOR_DELAY_LEN
    `define NOR_DELAY_LEN 4
`endif

`ifndef SET_LEN_START_CMD
    `define SET_LEN_START_CMD 8'h73
`endif

`ifndef SET_LEN_SUCCESS_RESPONSE
    `define SET_LEN_SUCCESS_RESPONSE 8'h76
`endif


module top_module(btn, rgb, led, clk, tx, uart_rx, pio1, pio9, pio16, pio40, pio46, pio48);
    input clk; 
    input logic [1 : 0] btn;
    output logic [2 : 0] rgb;
    output logic [3 : 0] led;
    input logic uart_rx;
    output logic tx;
    
    logic [`DIVISOR_SIZE-1:0] clk_div_cnt;
    logic clk_variable;
    
    logic rst;
    logic locked;
    
    // reference data for delay line
    output logic pio1;
    // actual data after delay line
    output logic pio9;
    //whole chain output
    output logic pio16;
    // clock output
    output logic pio40;
    // trigger XOR
    output logic pio46;
    // input delay line;
    output logic pio48;
    

    // delay vars
    logic launch_reset, capture_reset;
    logic delay_input, data_ref, data_actual;
    //MUX selector 
    logic [15 : 0] sel;
    logic xor_result;
    logic error;
    logic [31:0] data_reg;
    
    // UART vars
    logic valid;
    logic color_indicator;
    logic [7:0] rx_data_out;
    logic en, rdy;
    logic [7:0] tx_data_in;
    // UART state machine
    typedef enum {IDLE, RCV_FIRST_BYTE, RCV_SECOND_BYTE, RCVD, SET_DONE} state_t;
    state_t current_state;

    // for measurments for tuning:
    assign pio1 = data_ref;  
    assign pio9 = data_actual;
    assign pio16 = error;
    assign pio40 = clk;
    assign pio46 = xor_result;
    assign pio48 = delay_input;
    
    // 24MHz clk
    logic clk_24Mhz;
    logic locked;
    clock_gen_24MHz (.clk_in(clk), .clk_out(clk_24Mhz), .locked(locked), .reset(rst));
      
    // delay chain code
    dff lauch_dff(.d(delay_input), .clk(clk_24Mhz), .reset(launch_reset), .q(data_ref));
   
    delay_chain #(.INV_DELAY_LEN_INPUT(`INV_DELAY_LEN), .NOR_DELAY_LEN_INPUT(`NOR_DELAY_LEN)) delay (.delay_in(data_ref), .sel(sel), .delay_out(data_actual));
    
    xor_gate data_comp(.a(data_ref), .b(data_actual), .c(xor_result));
    
    dff capture_dff(.d(xor_result), .clk(clk_24Mhz), .reset(capture_reset), .q(error));
    
    // UART code
    assign rgb[2] = color_indicator;
    
    uart_rx uart_reader(.clk(clk_24Mhz), .rst(rst), 
                .din(uart_rx), .data_out(rx_data_out), .valid(valid));
    
    uart_tx uart_writer(.clk(clk_24Mhz), .rst(rst), .data_in(tx_data_in), .en(en), .dout(tx), .rdy(rdy));
    
    initial begin 
        color_indicator <= 0;
        delay_input <= 0;
        sel <= 100;
        launch_reset <= 0;
        capture_reset <= 0;
        rst <= 0;
        valid <= 0;
        rx_data_out <= 0;
        data_reg <= 32'h48;
    end
    
    always_ff @ (posedge clk_24Mhz) begin
        /* Divisor code */
        clk_div_cnt <= clk_div_cnt + 1;
        if (clk_div_cnt >= (`DIVISOR_SIZE-1)) begin
            clk_div_cnt <= 0;
        end
        clk_variable <= (clk_div_cnt < `DIVISOR_SIZE/2) ? 1 : 0;
        
        delay_input <= ~delay_input;
        
        /* UART Code */
        color_indicator <= color_indicator;
        en <= en;
        case (current_state)
            IDLE: begin
                en <= 0;
                if (valid && rx_data_out == `SET_LEN_START_CMD) begin
                    color_indicator <= ~color_indicator;
                    current_state <= RCV_FIRST_BYTE;
                end
            end
            RCV_FIRST_BYTE: begin
                if (valid) begin
                    color_indicator <= ~color_indicator;
                    sel[7:0] <= rx_data_out[7:0];
                    current_state <= RCV_SECOND_BYTE;
                end
            end
            RCV_SECOND_BYTE: begin
                if (valid) begin
                    color_indicator <= ~color_indicator;
                    sel[15:8] <= rx_data_out[7:0];
                    current_state <= RCVD;
                end
            end
            RCVD: begin
                if (rdy) begin
                    color_indicator <= ~color_indicator;
                    tx_data_in[7:0] <= sel[15:8];
                    current_state <= SET_DONE;
                end
            end
            SET_DONE: begin
                if (rdy) begin
                    color_indicator <= ~color_indicator;
                    tx_data_in[7:0] <= `SET_LEN_SUCCESS_RESPONSE;
                    en <= 1;
                    current_state <= IDLE;
                end
            end
            
        endcase     
    end


endmodule
