module uart_rx(
        input logic clk,
        input logic rst,
        input logic din,
        output logic [7:0] data_out,
        output logic valid);

reg [1:0] state   = `UART_START;
reg [2:0] bit_cnt = 3'b0;
reg [14:0] etu_cnt = 9'b0; //for baudrate 9600

wire etu_full, etu_half;
assign etu_full = (etu_cnt == `UART_FULL_ETU);
assign etu_half = (etu_cnt == `UART_HALF_ETU);

initial begin
    data_out <= 8'b0;
    valid <= 1'b0;
end

always @(posedge clk)
begin
	if (rst)
	begin
		state <= `UART_START;
	end

	else
	begin
		// Default assignments
		valid <= 1'b0;
		etu_cnt <= (etu_cnt + 1);
		state <= state;
		bit_cnt <= bit_cnt;
		data_out <= data_out;

		case(state)
			// Waiting for Start Bits
			`UART_START:
			begin
				if(din == 1'b0)
				begin
					// wait .5 ETUs
					if(etu_half)
					begin
						state <= `UART_DATA;
						etu_cnt <= 9'd0;
						bit_cnt <= 3'd0;
						data_out <= 8'd0;
					end
				end
				else
					etu_cnt <= 9'd0;
			end

			// Data Bits
			`UART_DATA:
			if(etu_full)
			begin
				etu_cnt <= 9'd0;
				data_out <= {din, data_out[7:1]};
				bit_cnt <= (bit_cnt + 1);

				if(bit_cnt == 3'd7)
					state <= `UART_STOP;
			end

			// Stop Bit(s)
			`UART_STOP:
			if(etu_full)
			begin
				etu_cnt <= 9'd0;
				state <= `UART_START;
				// Check Stop bit
				valid <= din;
			end

			default:
				$display ("UART RX: Invalid state 0x%X", state);

		endcase
	end
end

endmodule
