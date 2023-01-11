`timescale 1ns / 1ps

//-------------------------------specify delay length in TOP module or in delay chain module? 
`ifndef INV_DELAY_LEN
    `define INV_DELAY_LEN 1000
`endif

`ifndef NOR_DELAY_LEN
    `define NOR_DELAY_LEN 96
`endif

module top_module(btn, rgb, led, clk, tx, uart_rx, pio1, pio9, pio40);
    input clk; 
    input logic [1 : 0] btn;
    output logic [2 : 0] rgb;
    output logic [3 : 0] led;
    input logic uart_rx;
    output logic tx;
    // mirrored clk
    output pio1;
    // delay output
    output pio9;
    // dff output
    output pio40;
    
    // delay vars
    logic launch_reset, capture_reset;
    logic dff_input; 
    logic data_ref, data_actual;
    logic xor_result;
    logic error;
    logic [31:0] data_reg;
    
    // UART vars
    logic valid, rst;
    logic state;
    logic [7:0] rx_data_out;
    logic en, rdy;
    logic [7:0] tx_data_in;
    
    // for testing of delay of each delay unit
    assign pio1 = clk;
    assign pio9 = data_actual;
    assign pio40 = data_ref;
    
    // delay chain code
    dff lauch_dff(.d(dff_input), .clk(clk), .reset(launch_reset), .q(data_ref));
    
    delay_chain #(.INV_DELAY_LEN_INPUT(`INV_DELAY_LEN), .NOR_DELAY_LEN_INPUT(`NOR_DELAY_LEN)) delay (.a(data_ref), .b(data_actual));
    
    xor_gate data_comp(.a(data_ref), .b(data_actual), .c(xor_result));
    
    dff capture_dff(.d(xor_result), .clk(clk), .reset(capture_reset), .q(error));
    
    // UART code
    assign rgb[2] = state;
    
    uart_rx uart_reader(.clk(clk), .rst(rst), 
                .din(uart_rx), .data_out(rx_data_out), .valid(valid));
    
    uart_tx uart_writer(.clk(clk), .rst(rst), .data_in(tx_data_in), .en(en), .dout(tx), .rdy(rdy));
    
    // for UART echoing
    // assign tx_data_in = rx_data_out;
    
    initial begin 
        dff_input <= 0;
        state <= 0;
        rst <= 0;
        valid <= 0;
        rx_data_out <= 0;
        data_reg <= 32'h48;
    end
    
    always @ (posedge clk) begin
        dff_input <= ~dff_input;
        state <= state;
        en <= en; 
        if (valid && rdy && rx_data_out == 8'h73) begin
            en <= 1;
            state <= ~state;
            tx_data_in <= data_reg[7:0];
        end     
        else
            en <= 0;    
    end

endmodule
