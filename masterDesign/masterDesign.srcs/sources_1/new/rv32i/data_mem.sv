module DATA_MEM 
#(
	parameter  WORD_SIZE		= 32,
	parameter  NUMBER_OF_WORDS	= 1024,
	localparam ADDRESS_WIDTH	= 32
)(
	input  logic 						clk,
	input  logic 						rst,
	input  logic [ADDRESS_WIDTH-1:0] 	address,
	input  logic 					 	update_data,
	input  logic [WORD_SIZE-1:0]	 	w_data,
	input  memory_access_width_t		data_width,
	output logic [WORD_SIZE-1:0]     	r_data
);

	logic [7:0] data_memory [NUMBER_OF_WORDS<<2];

	integer i;
	always_ff @(posedge clk) begin

		if (rst) begin
			for (i=0; i<NUMBER_OF_WORDS<<2; i=i+1) begin
				data_memory[i] <= 'd0;
			end
		end else begin
			case (data_width)
				MEMORY_ACCESS_WORD: begin
					if (update_data) begin // read word
						r_data[7:0]   <= data_memory[address];
						r_data[15:8]  <= data_memory[address+1];
						r_data[23:16] <= data_memory[address+2];
						r_data[31:24] <= data_memory[address+3];
					end else begin // write word
						data_memory[address]   <= w_data[7:0];
						data_memory[address+1] <= w_data[15:8];
						data_memory[address+2] <= w_data[23:16];
						data_memory[address+3] <= w_data[31:24];
					end
				end

				MEMORY_ACCESS_HALFWORD: begin
					if (update_data) begin // read halfword
						r_data[7:0]   <= data_memory[address];
						r_data[15:8]  <= data_memory[address+1];
					end else begin // write halfword
						data_memory[address]   <= w_data[7:0];
						data_memory[address+1] <= w_data[15:8];
					end
				end

				MEMORY_ACCESS_BYTE: begin
					if (update_data) begin // read word
						r_data[7:0]   <= data_memory[address];
					end else begin // write word
						data_memory[address]   <= w_data[7:0];
					end
				end
			endcase
		end
	end
endmodule