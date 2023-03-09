module DATA_MEM_TB ();

	localparam WORD_SIZE 		= 32;
	localparam NUMBER_OF_WORDS 	= 1024;
	localparam ADDRESS_WIDTH 	= 32;

	logic 						clk;
	logic 						rst; 
	logic 						update_data;
	logic [ADDRESS_WIDTH-1:0] 	address;
	logic [WORD_SIZE-1:0] 		w_data, r_data;
	logic [1:0] 				data_width;

	DATA_MEM data_mem (
		.clk          	(clk),
		.rst 			(rst),
		.address 		(address),
		.update_data	(update_data),
		.w_data 		(w_data),
		.data_width     (data_width),
		.r_data 		(r_data)
	);
	defparam data_mem.WORD_SIZE 		= WORD_SIZE;
	defparam data_mem.NUMBER_OF_WORDS 	= NUMBER_OF_WORDS;

	always #5 clk = ~clk;

	initial begin

		$dumpfile("data_mem_tb.vcd");
		$dumpvars(0, DATA_MEM_TB);

		#0;
		clk = 0;
		rst = 0;
		update_data = 0;
		address = 0;
		w_data = 0;
		data_width = 0;

		#10;
		rst = 1;

		#10;
		rst = 0;

		#10;
		update_data = 1;
		address = 0;
		data_width = MEM_WORD;
		w_data = 'hAABBCCDD;

		#10;
		update_data = 1;
		address = 4;
		w_data = 'hEEFF0011;

		#10;
		address = 0;
		update_data = 0;

		#10;
		address = 0;

		#10;
		address = 1;

		#10;
		address = 2;

		#10;
		address = 3;

		#10; 
		address = 4;

		#10;
		update_data = 1;
		address = 0;
		w_data = 'h00002233;
		data_width = MEM_HALFWORD;

		#10;
		update_data = 0;
		w_data = 0;
		data_width = MEM_WORD;

		#10;
		update_data = 1;
		w_data = 'h00000044;
		data_width = MEM_BYTE;

		#10;
		update_data = 0;
		w_data = 0;
		data_width = MEM_WORD;

		#100;
		$finish();
	end

endmodule