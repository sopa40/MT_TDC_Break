`timescale 1ns / 1ps

`include "uart_defs.sv"

module uart_tx(
        input logic clk,
        input logic rst,
        input logic [7:0] data_in,
        input logic en,
        output logic dout,
        output logic rdy);

logic [7:0] data = 8'h00;
logic [1:0] state = `UART_START;
logic [2:0] bit_cnt = 3'b000;
logic[14:0] etu_cnt = 9'b0; //for baudrate 9600

wire etu_full;
assign etu_full = (etu_cnt == `UART_FULL_ETU);

initial begin
    dout <= 1'b1;
    rdy <= 1'b1;
end

always @(posedge clk)
begin
	if (rst)
	begin
		state <= `UART_START;
		dout <= 1'b1;
		rdy <= 1'b1;
	end

	else
	begin
		// Default assignments
		etu_cnt <= (etu_cnt + 1);
		dout <= dout;
		rdy <= rdy;
		data <= data;
		state <= state;
		bit_cnt <= bit_cnt;

		case(state)

			// Idle, waiting for enable
			`UART_START:
			begin
				if(en == 1)
				begin
					// Start bit
					dout <= 1'b0;
					data <= data_in;
					state <= `UART_DATA;
					etu_cnt <= 9'd0;
					bit_cnt <= 3'd0;
					rdy <= 1'b0;
				end
			end

			// Data Bits
			`UART_DATA:
			if(etu_full)
			begin
				etu_cnt <= 9'd0;
				bit_cnt <= (bit_cnt + 1);

				dout <= data[0];
				data <= {data[0], data[7:1]};

				if(bit_cnt == 3'd7)
				begin
					state <= `UART_STOP;
				end
			end

			// Stop Bit(s)
			`UART_STOP:
			if(etu_full)
			begin
				etu_cnt <= 9'd0;
				dout <= 1'b1;
				state <= `UART_IDLE;
			end

			// Idle time before restarting
			`UART_IDLE:
			if(etu_full)
			begin
				rdy <= 1'b1;
				state <= `UART_START;
			end

			default:
				$display ("UART TX: Invalid state 0x%X", state);

		endcase
	end
end

endmodule
