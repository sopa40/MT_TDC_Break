module CORE 
#(
	parameter 		INSTRUCTION_WIDTH 			= 32,
	parameter  		NUMBER_OF_REGISTERS			= 32,
	parameter  		REGISTER_WIDTH 				= 32,
	parameter  		REGISTER_INITIAL_VALUE 		= 0,
	localparam 		REGISTER_ADDRESS_WIDTH 		= $clog2(NUMBER_OF_REGISTERS)
)(
	input logic clk,
	input logic rst
);

logic 									update_regfile;
logic [REGISTER_ADDRESS_WIDTH-1:0]   	dest_address;
logic [REGISTER_ADDRESS_WIDTH-1:0]   	src1_address;
logic [REGISTER_ADDRESS_WIDTH-1:0]   	src2_address;
logic [ALU_CTRL_WIDTH-1:0]   			alu_ctrl;
logic [INSTRUCTION_WIDTH-1:0]  			instruction;
logic [REGISTER_WIDTH-1:0] 				immediate;
write_back_sel_t						write_back_sel;
logic        						 	update_data_mem;
logic [31:0] 						 	data_mem_w_data;
memory_access_width_t					memory_access_width;
operand_a_sel_t							operand_a_sel;
operand_b_sel_t							operand_b_sel;
next_pc_sel_t							next_pc_sel;
comparison_t							comparison_type;
logic 									branch_eq;
logic 									branch_lt;

DATAPATH datapath (
	.clk 					(clk),
	.rst 					(rst),
	.update_regfile			(update_regfile),
	.dest_address			(dest_address),
	.src1_address			(src1_address),
	.src2_address			(src2_address),
	.alu_ctrl 				(alu_ctrl),
	.instruction 			(instruction),
	.immediate     			(immediate),
	.write_back_sel       	(write_back_sel),
	.update_data_mem		(update_data_mem),
	.memory_access_width	(memory_access_width),
	.operand_a_sel			(operand_a_sel),
	.operand_b_sel			(operand_b_sel),
	.next_pc_sel            (next_pc_sel),
	.comparison_type		(comparison_type),
	.branch_eq				(branch_eq),
	.branch_lt				(branch_lt)
);

CONTROLPATH controlpath (
	.rst 		 			(rst),
	.instruction 			(instruction),
	.branch_eq				(branch_eq),
	.branch_lt				(branch_lt),
	.update_regfile			(update_regfile),
	.dest_address  			(dest_address),
	.src1_address  			(src1_address),
	.src2_address  			(src2_address),
	.alu_ctrl 				(alu_ctrl),
	.immediate 				(immediate),
	.write_back_sel     	(write_back_sel),
	.update_data_mem		(update_data_mem),
	.memory_access_width	(memory_access_width),
	.next_pc_sel            (next_pc_sel),
	.operand_a_sel			(operand_a_sel),
	.operand_b_sel			(operand_b_sel),
	.comparison_type		(comparison_type)
);

endmodule