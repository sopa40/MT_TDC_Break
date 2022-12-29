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
    
    logic [31:0] cnt;
    
    //green
    assign rgb[1] = btn[1] ? 1 : 0;
    assign led[1 : 0] = btn[0] ? 2'b11 : 2'b00;
    assign led[3 : 2] = btn[1] ? 2'b11 : 2'b00;
    
    //red
    assign rgb[2] = state;
    
    assign en = btn[1];
    
    uart_rx uart_reader(.clk(clk), .rst(rst), 
                .din(uart_rx), .data_out(rx_data_out), .valid(valid));
    
    uart_tx uart_writer(.clk(clk), .rst(rst), .data_in(tx_data_in), .en(en), .dout(tx), .rdy(rdy));
    
    
    initial begin 
        state <= 0;
        rst <= 0;
        valid <= 0;
        cnt <= 0;
        tx_data_in <= 8'h48;
    end
    
    always @ (posedge clk) begin
        cnt <= cnt + 1;
        state <= state;
        //blue
        //rgb[0] <= cnt[25]; 
        if (valid) 
            state <= 1;
    end






//                      RX PART
// module top_module(input logic clk, output logic tx, input logic btn_0, output logic led0_b, output logic led0_g);
//    logic [7:0] data_out;
//    logic valid; 
//    logic [7:0] H_value = 8'h48;  
//    logic test;
//    logic [32:0] counter;
//    assign led0_g = 1;
//    uart_rx uart_reader(.clk(clk), .rst(rst), 
//                .din(uart_rx), .data_out(data_out), .valid(valid));
    
//    assign led0_b = (data_out[7:0] == H_value [7:0]) ? 1'b0 : 1'b1;
    
    
//    initial begin
//        test <= 1;
//    end
    
//    always @ (posedge clk) begin
//        if (counter < 1000000000)
//            test <= 1;
//        else
//            test <= 0; 
//    end
    
    
//                                   TX PART
//    logic [7:0] data_in;
//    logic en;
//    logic rdy, rst;
//    uart_tx uart_writer(.clk(clk), .rst(rst), .data_in(data_in), 
//                .en(en), .dout(tx), .rdy(rdy)); 
    
//    initial begin
//        data_in <= 8'h48;
//        en <= 1;
//        #10000 en <= 0;    
//    end
endmodule
