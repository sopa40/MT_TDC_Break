/*
Datapath:
Part of the processor that contains the hardware necessary to perform operations required by the processor.
*/

module DATAPATH 
#(
	parameter  		NUMBER_OF_REGISTERS			= 32,
	parameter  		REGISTER_WIDTH 				= 32,
	parameter  		REGISTER_INITIAL_VALUE 		= 0,
	localparam 		REGISTER_ADDRESS_WIDTH 		= $clog2(NUMBER_OF_REGISTERS)
)(
	input  logic 							 	clk,
	input  logic 							 	rst,
	input  logic                              	update_regfile,
	input  logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_address,
	input  logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_address,
	input  logic [REGISTER_ADDRESS_WIDTH-1:0] 	src2_address,
	input  logic [ALU_CTRL_WIDTH-1:0]   	 	alu_ctrl,			
	input  logic [REGISTER_WIDTH-1:0] 		 	immediate,
	input  write_back_sel_t						write_back_sel,
	input  logic        						update_data_mem,
	input  logic [1:0]  						data_mem_data_width,
	input  operand_a_sel_t						operand_a_sel,
	input  operand_b_sel_t				 		operand_b_sel,
	input  next_pc_sel_t 						next_pc_sel,
	input  comparison_t 						comparison_type,
	
	output logic [REGISTER_WIDTH-1:0] 		 	instruction,
	output logic 							 	branch_eq,
	output logic 							 	branch_lt
);

	/////////////////////////////////////////////////////////////////////////
	//////////////////////////// PROGRAM COUNTER ////////////////////////////
	/////////////////////////////////////////////////////////////////////////
	logic [REGISTER_WIDTH-1:0] current_pc;
	logic [REGISTER_WIDTH-1:0] upcoming_pc;
	logic [REGISTER_WIDTH-1:0] incremented_pc;
	PC_INCREMENTER pc_incrementer (
		.pc				(current_pc),
		.incremented_pc	(incremented_pc)
	);
	defparam pc_incrementer.WIDTH = REGISTER_WIDTH;
	
	PROGRAM_COUNTER pc (
		.clk	(clk),
		.rst	(rst),
		.pc_in	(upcoming_pc),
		.pc_out	(current_pc)
	);
	defparam pc.ADDRESS_WIDTH = 32;
	defparam pc.START_PC      = 'h00000000;

	always_comb begin
		case (next_pc_sel)
			INCREMENTED_PC: upcoming_pc = incremented_pc;
			JUMP_PC: 		upcoming_pc = alu_output;
		endcase
	end

	/////////////////////////////////////////////////////////////////////////
	/////////////////////////// INSTRUCTION MEMORY //////////////////////////
	/////////////////////////////////////////////////////////////////////////
	INSTRUCTION_MEMORY imem (
		.address	(current_pc),
		.instruction(instruction)
	);

	/////////////////////////////////////////////////////////////////////////
	///////////////////////////// REGISTER FILE /////////////////////////////
	/////////////////////////////////////////////////////////////////////////
	logic [REGISTER_WIDTH-1:0] dest_value;
	logic [REGISTER_WIDTH-1:0] src1_data;
	logic [REGISTER_WIDTH-1:0] src2_data;
	REGISTERFILE registerfile (
		.clk         	(clk),
		.rst         	(rst),
		.we 		 	(update_regfile),
		.dest_address	(dest_address),
		.src1_address	(src1_address),
		.src2_address	(src2_address),
		.dest_value  	(dest_value),
		.src1_data   	(src1_data),
		.src2_data   	(src2_data)
	);
	defparam registerfile.NUMBER_OF_REGISTERS 		= NUMBER_OF_REGISTERS;
	defparam registerfile.REGISTER_WIDTH 			= REGISTER_WIDTH;
	defparam registerfile.REGISTER_INITIAL_VALUE 	= REGISTER_INITIAL_VALUE;

	/////////////////////////////////////////////////////////////////////////
	////////////////////////////// COMPARATOR ///////////////////////////////
	/////////////////////////////////////////////////////////////////////////
	COMPARATOR comparator(
		.val_a			(src1_data),
		.val_b			(src2_data),
		.comparison_type(comparison_type),
		.eq 			(branch_eq),
		.lt          	(branch_lt)
	);

	/////////////////////////////////////////////////////////////////////////
	//////////////////////////////// ALU ////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////
	logic [REGISTER_WIDTH-1:0] 	first_alu_operand;
	logic [REGISTER_WIDTH-1:0] 	second_alu_operand;
	logic 		  				result_equals_zero;
	logic [REGISTER_WIDTH-1:0] 	alu_output;
	ALU alu (
		.alu_op				(alu_ctrl),
		.operand_a			(first_alu_operand),
		.operand_b			(second_alu_operand),
		.result 			(alu_output),
		.result_equals_zero (result_equals_zero)
	);
	defparam alu.OPERAND_WIDTH = 32;

	always_comb begin
		case (operand_a_sel)
			OPERAND_1_DATA_SRC1: 	first_alu_operand = src1_data;
			OPERAND_1_PC:			first_alu_operand = current_pc;
		endcase
	end

	always_comb begin
		case (operand_b_sel)
			OPERAND_2_DATA_SRC2: 	second_alu_operand = src2_data;
			OPERAND_2_IMMEDIATE: 	second_alu_operand = immediate;
		endcase
	end

	/////////////////////////////////////////////////////////////////////////
	////////////////////////////// COMPARATOR ///////////////////////////////
	/////////////////////////////////////////////////////////////////////////
	logic [31:0] data_mem_read_data;
	DATA_MEM data_mem (
		.clk 			(clk),
		.rst 			(rst),
		.address 		(alu_output),
		.update_data	(update_data_mem),
		.w_data 		(src2_data),
		.data_width 	(data_mem_data_width),
		.r_data 		(data_mem_read_data)
	);
	defparam data_mem.WORD_SIZE			= 32;
	defparam data_mem.NUMBER_OF_WORDS	= 1024;

	always_comb begin
		case (write_back_sel)
			WRITE_BACK_MEMORY:		dest_value = data_mem_read_data;
			WRITE_BACK_ALU:			dest_value = alu_output;
			WRITE_BACK_PC_PLUS_4:	dest_value = incremented_pc;
		endcase
	end

endmodule