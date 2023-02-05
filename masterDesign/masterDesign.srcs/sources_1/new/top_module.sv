`timescale 1ns / 1ps

//-------------------------------specify delay length in TOP module or in delay chain module? 
`ifndef INV_DELAY_LEN
    `define INV_DELAY_LEN 4000
`endif

`ifndef NOR_DELAY_LEN
    `define NOR_DELAY_LEN 20
`endif

`ifndef DIVISOR_SIZE 
    // 100 Hz
    `define DIVISOR_SIZE 60000
`endif

module top_module(btn, rgb, led, clk, tx, uart_rx, pio1, pio9, pio16, pio40, pio48);
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
    
    // 100 MHz clock
    /*
    logic clk_100mhz;
    clk_gen_100 clkgen(
        .clk_in(src_clk),
        .locked(locked),
        .reset(rst),
        .clk_out(clk_100mhz)  
    );
    */ 
    
    // reference data for delay line
    output logic pio1;
    // actual data after delay line
    output logic pio9;
    //whole chain output
    output logic pio16;
    // clock output
    output logic pio40;
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
    assign pio48 = delay_input;
      
    // delay chain code
    dff lauch_dff(.d(delay_input), .clk(clk), .reset(launch_reset), .q(data_ref));
   
    (*DONT_TOUCH= "true"*) delay_chain #(.INV_DELAY_LEN_INPUT(`INV_DELAY_LEN), .NOR_DELAY_LEN_INPUT(`NOR_DELAY_LEN)) delay (.delay_in(data_ref), .sel(sel), .delay_out(data_actual));
    
    xor_gate data_comp(.a(data_ref), .b(data_actual), .c(xor_result));
    
    dff capture_dff(.d(xor_result), .clk(clk), .reset(capture_reset), .q(error));
    
    // UART code
    assign rgb[2] = color_indicator;
    
    uart_rx uart_reader(.clk(clk), .rst(rst), 
                .din(uart_rx), .data_out(rx_data_out), .valid(valid));
    
    uart_tx uart_writer(.clk(clk), .rst(rst), .data_in(tx_data_in), .en(en), .dout(tx), .rdy(rdy));
    
    // for UART echoing
    // assign tx_data_in = rx_data_out;
    
    initial begin 
        color_indicator <= 0;
        delay_input <= 0;
        sel <= 200;
        launch_reset <= 0;
        capture_reset <= 0;
        rst <= 0;
        valid <= 0;
        rx_data_out <= 0;
        data_reg <= 32'h48;
    end
    
    always_ff @ (posedge clk) begin
        /* Divisor code */
        clk_div_cnt <= clk_div_cnt + 1;
        if (clk_div_cnt >= (`DIVISOR_SIZE-1)) begin
            clk_div_cnt <= 0;
        end
        clk_variable <= (clk_div_cnt < `DIVISOR_SIZE/2) ? 1 : 0;
        
        /* UART Code */
        color_indicator <= color_indicator;
        en <= en;
        case (current_state)
            IDLE: begin
                en <= 0;
                if (valid && rx_data_out == 8'h73) begin
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
                    en <= 1;
                    current_state <= SET_DONE;
                end
            end
            SET_DONE: begin
                if (rdy) begin
                    color_indicator <= ~color_indicator;
                    tx_data_in[7:0] <= 8'h76;
                    en <= 1;
                    current_state <= IDLE;
                end
            end
            
        endcase
        /*
        if (valid && rdy && rx_data_out == 8'h73) begin
            en <= 1;
            color_indicator <= ~color_indicator;
            tx_data_in <= data_reg[7:0];
        end
        if (rdy && tx_data_in == 8'h73) begin
            en <= 1;
            tx_data_in <= data_reg[15:8];
        end 
        else
            en <= 0;   */           
    end
        
    
    always_ff @ (posedge clk_variable) begin
        delay_input <= ~delay_input;
    end

endmodule
