module DATAPATH_TB ();

	localparam  	NUMBER_OF_REGISTERS			= 32;
	localparam  	REGISTER_WIDTH 				= 32;
	localparam  	REGISTER_INITIAL_VALUE 		= 0;
	localparam 		REGISTER_ADDRESS_WIDTH 		= $clog2(NUMBER_OF_REGISTERS);

	logic 							 	clk;
	logic 							 	rst;
	logic                              	update_regfile;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_address;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_address;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src2_address;
	logic [ALU_CTRL_WIDTH-1:0]   	 	alu_ctrl;	
	logic [REGISTER_WIDTH-1:0] 		 	immediate;
	write_back_sel_t					write_back_sel;
	logic        						update_data_mem;
	logic [1:0]  						data_mem_data_width;
	operand_a_sel_t						operand_a_sel;
	operand_b_sel_t				 		operand_b_sel;
	next_pc_sel_t 						next_pc_sel;
	comparison_t 						comparison_type;
	logic [REGISTER_WIDTH-1:0] 		 	instruction;
	logic 							 	branch_eq;
	logic 							 	branch_lt;

	initial begin
		$dumpfile("datapath_tb.vcd");
		$dumpvars(0, DATAPATH_TB);
		#10;
		$finish();
	end

endmodule