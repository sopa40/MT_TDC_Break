`timescale 1ns / 1ps

module top_module(btn, rgb, led, clk, tx, uart_rx);
    input logic clk;
    input logic [1 : 0] btn;
    output logic [2 : 0] rgb;
    output logic [3 : 0] led;
    input logic uart_rx;
    output logic tx;
    
    logic valid, rst;
    logic state;
    logic [7:0] rx_data_out;
    logic en, rdy;
    logic [7:0] tx_data_in;
    
    assign led[1 : 0] = btn[0] ? 2'b11 : 2'b00;
    assign led[3 : 2] = btn[1] ? 2'b11 : 2'b00;
    
    //red
    assign rgb[2] = state;
    
    uart_rx uart_reader(.clk(clk), .rst(rst), 
                .din(uart_rx), .data_out(rx_data_out), .valid(valid));
    
    uart_tx uart_writer(.clk(clk), .rst(rst), .data_in(tx_data_in), .en(en), .dout(tx), .rdy(rdy));
    
    // for UART echoing
    assign tx_data_in = rx_data_out;
    
    initial begin 
        state <= 0;
        rst <= 0;
        valid <= 0;
        rx_data_out <= 0;
    end
    
    always @ (posedge clk) begin
        state <= state;
        en <= en; 
        if (valid && rdy) begin
            en <= 1;
            state <= ~state;
        end     
        else
            en <= 0;    
    end
endmodule
