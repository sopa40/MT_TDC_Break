/*
Controlpath:
Part of the processor which tells the datapath what needs to be done.
*/

module CONTROLPATH
#(
	parameter  INSTRUCTION_WIDTH 		= 32,
	parameter  REGISTER_WIDTH 			= 32,
	parameter  NUMBER_OF_REGISTERS 		= 32,
	localparam REGISTER_ADDRESS_WIDTH 	= $clog2(NUMBER_OF_REGISTERS)
)(
	input  logic 								rst,
	input  logic [INSTRUCTION_WIDTH-1:0] 		instruction,
	input  logic 								branch_eq,
	input  logic 								branch_lt,
	
	output logic 								update_regfile,
	output logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_address,
	output logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_address,
	output logic [REGISTER_ADDRESS_WIDTH-1:0] 	src2_address,
	output logic [ALU_CTRL_WIDTH-1:0]   	  	alu_ctrl,
	output logic [REGISTER_WIDTH-1:0] 			immediate,
	output write_back_sel_t						write_back_sel,
	output logic 								update_data_mem,
	output logic [1:0]							data_mem_data_width,
	output next_pc_sel_t 						next_pc_sel,
	output operand_a_sel_t						operand_a_sel,
	output operand_b_sel_t						operand_b_sel,
	output comparison_t 						comparison_type
);

	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_R;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src2_R; 
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_R;
	logic [2:0] 						funct3_R;
	logic [6:0] 						funct7_R;
	DECODER_R decoder_r (
		.instruction	(instruction),
		.src1 			(src1_R),
		.src2       	(src2_R),
		.dest 			(dest_R),
		.funct3     	(funct3_R),
		.funct7 		(funct7_R)
	);

	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_I;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_I;
	logic [REGISTER_WIDTH-1:0] 			imm_I;
	logic [2:0] 						funct3_I;
	DECODER_I decoder_i (
		.instruction	(instruction),
		.src1 			(src1_I),
		.imm 			(imm_I),
		.dest 			(dest_I),
		.funct3 		(funct3_I)
	);

	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_S;
	logic [REGISTER_ADDRESS_WIDTH-1:0]	src2_S;
	logic [REGISTER_WIDTH-1:0] 			imm_S;
	logic [2:0] 						funct3_S;
	DECODER_S decoder_s (
		.instruction	(instruction),
		.src1 			(src1_S),
		.src2 			(src2_S),
		.imm 			(imm_S),
		.funct3 		(funct3_S)
	);

	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src1_B;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	src2_B;
	logic [REGISTER_WIDTH-1:0] 			imm_B;
	logic [2:0] 						funct3_B;
	DECODER_B decoder_b (
		.instruction	(instruction),	
		.src1 			(src1_B),
		.src2 			(src2_B),
		.imm 			(imm_B),
		.funct3 		(funct3_B)
	);

	logic [REGISTER_WIDTH-1:0] 			imm_J;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_J;
	DECODER_J decoder_j (
		.instruction	(instruction),
		.imm 			(imm_J),
		.dest 			(dest_J)
	);

	logic [REGISTER_WIDTH-1:0] 			imm_U;
	logic [REGISTER_ADDRESS_WIDTH-1:0] 	dest_U;
	DECODER_U decoder_u (
		.instruction	(instruction),
		.imm			(imm_U),
		.dest			(dest_U)
	);

	always_comb begin

		if (rst) begin
			update_regfile 			= 'b0;
			dest_address   			= 'b0;
			src1_address   			= 'b0;
			src2_address   			= 'b0;
			alu_ctrl       			= 'b0;
			immediate				= 'b0;
			update_data_mem 		= 'b0;
			data_mem_data_width 	= DATA_MEM_WORD;
			comparison_type			= COMPARISON_SIGNED;
			write_back_sel			= WRITE_BACK_ALU;
			operand_a_sel			= OPERAND_1_DATA_SRC1;
			operand_b_sel			= OPERAND_2_DATA_SRC2;
			next_pc_sel				= INCREMENTED_PC;

		end else begin

			case (instruction[OPCODE_WIDTH-1:0])
				
				/////////////////////////////////////////////////////////////////////////
				///////////////////////////////// R TYPE ////////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_R_TYPE: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_R;
					src1_address   			= src1_R;
					src2_address   			= src2_R;
					immediate				= 'b0;
					update_data_mem 		= 'b0;
					data_mem_data_width 	= DATA_MEM_WORD;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_DATA_SRC1;
					operand_b_sel			= OPERAND_2_DATA_SRC2;
					next_pc_sel				= INCREMENTED_PC;

					case ({funct7_R, funct3_R})
						{R_TYPE_ADD_FUNCT_7,  R_TYPE_ADD_FUNCT_3}: 	alu_ctrl = ALU_OP_ADD;
						{R_TYPE_SUB_FUNCT_7,  R_TYPE_SUB_FUNCT_3}: 	alu_ctrl = ALU_OP_SUB;
						{R_TYPE_SLL_FUNCT_7,  R_TYPE_SLL_FUNCT_3}:	alu_ctrl = ALU_OP_SLL;
						{R_TYPE_SLT_FUNCT_7,  R_TYPE_SLT_FUNCT_3}: 	alu_ctrl = ALU_OP_SLT;
						{R_TYPE_SLTU_FUNCT_7, R_TYPE_SLTU_FUNCT_3}:	alu_ctrl = ALU_OP_SLTU; 
						{R_TYPE_XOR_FUNCT_7,  R_TYPE_XOR_FUNCT_3}: 	alu_ctrl = ALU_OP_XOR;
						{R_TYPE_SRL_FUNCT_7,  R_TYPE_SRL_FUNCT_3}: 	alu_ctrl = ALU_OP_SRL;
						{R_TYPE_SRA_FUNCT_7,  R_TYPE_SRA_FUNCT_3}:	alu_ctrl = ALU_OP_SRA;
						{R_TYPE_OR_FUNCT_7,   R_TYPE_OR_FUNCT_3}: 	alu_ctrl = ALU_OP_OR;
						{R_TYPE_AND_FUNCT_7,  R_TYPE_AND_FUNCT_3}: 	alu_ctrl = ALU_OP_AND;
						
						default: begin // R-Type instruction opcode, but undefined..
							update_regfile 			= 'b0;
							dest_address   			= 'b0;
							src1_address   			= 'b0;
							src2_address   			= 'b0;
							immediate				= 'b0;
							alu_ctrl				= 'b0;
							update_data_mem 		= 'b0;
							data_mem_data_width 	= DATA_MEM_WORD;
							comparison_type			= COMPARISON_SIGNED;
							write_back_sel			= WRITE_BACK_ALU;
							operand_a_sel			= OPERAND_1_DATA_SRC1;
							operand_b_sel			= OPERAND_2_DATA_SRC2;
							next_pc_sel				= INCREMENTED_PC;
						end
					endcase
				end


				/////////////////////////////////////////////////////////////////////////
				///////////////////////////////// I TYPE ////////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_I_TYPE: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_I;
					src1_address   			= src1_I;
					src2_address   			= 'b0;
					immediate				= imm_I;
					update_data_mem 		= 'b0;
					data_mem_data_width 	= DATA_MEM_WORD;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_DATA_SRC1;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					next_pc_sel				= INCREMENTED_PC;
					
					case (funct3_I)
						I_TYPE_ADDI_FUNC_3: 	alu_ctrl = ALU_OP_ADD;
						I_TYPE_SLTI_FUNC_3:		alu_ctrl = ALU_OP_SLT;
						I_TYPE_SLTIU_FUNC_3:	alu_ctrl = ALU_OP_SLTU;
						I_TYPE_XORI_FUNC_3:		alu_ctrl = ALU_OP_XOR;
						I_TYPE_ORI_FUNC_3: 		alu_ctrl = ALU_OP_OR;
						I_TYPE_ANDI_FUNC_3: 	alu_ctrl = ALU_OP_AND;
						I_TYPE_SLLI_FUNC_3: 	alu_ctrl = ALU_OP_SLL;
						I_TYPE_SRLI_FUNC_3: 	alu_ctrl = ALU_OP_SRL;
						I_TYPE_SRAI_FUNC_3: 	alu_ctrl = ALU_OP_SRA;
						
						default: begin // I-Type instruction opcode, but undefined..
							update_regfile 			= 'b0;
							dest_address   			= 'b0;
							src1_address   			= 'b0;
							src2_address   			= 'b0;
							immediate				= 'b0;
							alu_ctrl				= 'b0;
							update_data_mem 		= 'b0;
							data_mem_data_width 	= DATA_MEM_WORD;
							comparison_type			= COMPARISON_SIGNED;
							write_back_sel			= WRITE_BACK_ALU;
							operand_a_sel			= OPERAND_1_DATA_SRC1;
							operand_b_sel			= OPERAND_2_DATA_SRC2;
							next_pc_sel				= INCREMENTED_PC;
						end
					endcase
				end


				/////////////////////////////////////////////////////////////////////////
				//////////////////////////////// LOAD TYPE //////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_LOAD_TYPE: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_I;
					src1_address   			= src1_I;
					src2_address   			= 'b0;
					immediate				= imm_I;
					alu_ctrl 				= ALU_OP_ADD;
					update_data_mem 		= 'b0;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_MEMORY;
					operand_a_sel			= OPERAND_1_DATA_SRC1;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					next_pc_sel				= INCREMENTED_PC;

					case (funct3_I)
						I_TYPE_LB_FUNC_3: 		data_mem_data_width 	= DATA_MEM_BYTE;
						I_TYPE_LH_FUNC_3:		data_mem_data_width 	= DATA_MEM_HALFWORD;
						I_TYPE_LW_FUNC_3:		data_mem_data_width 	= DATA_MEM_WORD;
						I_TYPE_LBU_FUNC_3:		data_mem_data_width 	= DATA_MEM_BYTE;
						I_TYPE_LHU_FUNC_3:		data_mem_data_width 	= DATA_MEM_HALFWORD;
						default: begin // Load type instruction opcode, but undefined..
							update_regfile 			= 'b0;
							dest_address   			= 'b0;
							src1_address   			= 'b0;
							src2_address   			= 'b0;
							immediate				= 'b0;
							alu_ctrl				= 'b0;
							update_data_mem 		= 'b0;
							data_mem_data_width 	= DATA_MEM_WORD;
							comparison_type			= COMPARISON_SIGNED;
							write_back_sel			= WRITE_BACK_ALU;
							operand_a_sel			= OPERAND_1_DATA_SRC1;
							operand_b_sel			= OPERAND_2_DATA_SRC2;
							next_pc_sel				= INCREMENTED_PC;
						end
					endcase
				end

				/////////////////////////////////////////////////////////////////////////
				////////////////////////////// STORE  TYPE //////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_S_TYPE: begin
					update_regfile 			= 'b0;
					dest_address   			= 'b0;
					src1_address   			= src1_S;
					src2_address   			= 'b0;
					immediate				= imm_S;
					alu_ctrl 				= ALU_OP_ADD;
					update_data_mem 		= 'b1;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_DATA_SRC1;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					next_pc_sel				= INCREMENTED_PC;

					case (funct3_S)
						S_TYPE_SB_FUNC3:	data_mem_data_width = DATA_MEM_BYTE;			
						S_TYPE_SH_FUNC3:	data_mem_data_width = DATA_MEM_HALFWORD;
						S_TYPE_SW_FUNC3:	data_mem_data_width = DATA_MEM_WORD;
						default: begin // Store type instruction opcode, but undefined.. 
							update_regfile 			= 'b0;
							dest_address   			= 'b0;
							src1_address   			= 'b0;
							src2_address   			= 'b0;
							immediate				= 'b0;
							alu_ctrl				= 'b0;
							update_data_mem 		= 'b0;
							data_mem_data_width 	= DATA_MEM_WORD;
							comparison_type			= COMPARISON_SIGNED;
							write_back_sel			= WRITE_BACK_ALU;
							operand_a_sel			= OPERAND_1_DATA_SRC1;
							operand_b_sel			= OPERAND_2_DATA_SRC2;
							next_pc_sel				= INCREMENTED_PC;
						end
					endcase
				end
				
				/////////////////////////////////////////////////////////////////////////
				///////////////////////////////// B TYPE ////////////////////////////////
				/////////////////////////////////////////////////////////////////////////				
				OPCODE_B_TYPE: begin
					update_regfile 			= 'b0;
					dest_address   			= 'b0;
					src1_address   			= src1_B;
					src2_address   			= src2_B;
					immediate				= imm_B;
					alu_ctrl 				= ALU_OP_ADD;
					update_data_mem 		= 'b0;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_PC;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					
					case (funct3_B)
						B_TYPE_BEQ_FUNC_3: 		begin
							comparison_type		= COMPARISON_SIGNED;
							next_pc_sel 		= (branch_eq) ? JUMP_PC : INCREMENTED_PC;
						end
						B_TYPE_BNE_FUNC_3:		begin
							comparison_type		= COMPARISON_SIGNED;
							next_pc_sel 		= (branch_eq) ? INCREMENTED_PC : JUMP_PC;
						end
						B_TYPE_BLT_FUNC_3:		begin
							comparison_type		= COMPARISON_SIGNED;
							next_pc_sel 		= (branch_lt) ? JUMP_PC : INCREMENTED_PC;
						end
						B_TYPE_BGE_FUNC_3:		begin	
							comparison_type		= COMPARISON_SIGNED;
							next_pc_sel 		= (branch_lt) ? INCREMENTED_PC : JUMP_PC;
						end
						B_TYPE_BGEU_FUNC_3:		begin
							comparison_type		= COMPARISON_UNSIGNED;
							next_pc_sel 		= (branch_eq) ? JUMP_PC : INCREMENTED_PC;
						end
						B_TYPE_BLTU_FUNC_3:		begin
							comparison_type		= COMPARISON_UNSIGNED;
							next_pc_sel 		= (branch_lt) ? JUMP_PC : INCREMENTED_PC;
						end
						default: begin // Branch type instruction opcode, but undefined.. 
							update_regfile 			= 'b0;
							dest_address   			= 'b0;
							src1_address   			= 'b0;
							src2_address   			= 'b0;
							immediate				= 'b0;
							alu_ctrl				= 'b0;
							update_data_mem 		= 'b0;
							data_mem_data_width 	= DATA_MEM_WORD;
							comparison_type			= COMPARISON_SIGNED;
							write_back_sel			= WRITE_BACK_ALU;
							operand_a_sel			= OPERAND_1_DATA_SRC1;
							operand_b_sel			= OPERAND_2_DATA_SRC2;
							next_pc_sel				= INCREMENTED_PC;
						end
					endcase
				end

				/////////////////////////////////////////////////////////////////////////
				//////////////////////////////// JAL TYPE ///////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_JAL: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_J;
					src1_address   			= 'b0;
					src2_address   			= 'b0;
					immediate				= imm_J;
					alu_ctrl				= ALU_OP_ADD;
					update_data_mem 		= 'b0;
					data_mem_data_width 	= DATA_MEM_WORD;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WB_INCREMENTED_PC;
					operand_a_sel			= OPERAND_1_PC;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					next_pc_sel				= JUMP_PC;
				end
				
				/////////////////////////////////////////////////////////////////////////
				//////////////////////////////// LUI TYPE ///////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_LUI: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_U;
					src1_address   			= 'b0;
					src2_address   			= 'b0;
					immediate				= imm_U;
					alu_ctrl				= ALU_OP_ID_B;
					update_data_mem 		= 'b0;
					data_mem_data_width 	= DATA_MEM_WORD;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_DATA_SRC1;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					next_pc_sel				= INCREMENTED_PC;
				end
				
				/////////////////////////////////////////////////////////////////////////
				/////////////////////////////// AUPIC TYPE //////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_AUPIC: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_U;
					src1_address   			= 'b0;
					src2_address   			= 'b0;
					immediate				= imm_U;
					alu_ctrl				= ALU_OP_ADD;
					update_data_mem 		= 'b0;
					data_mem_data_width 	= DATA_MEM_WORD;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_PC;
					operand_b_sel			= OPERAND_2_IMMEDIATE;
					next_pc_sel				= INCREMENTED_PC;
				end
				
				/////////////////////////////////////////////////////////////////////////
				/////////////////////////////// JALR TYPE ///////////////////////////////
				/////////////////////////////////////////////////////////////////////////
				OPCODE_JALR: begin
					update_regfile 			= 'b1;
					dest_address   			= dest_I;
					src1_address   			= src1_I;
					src2_address   			= 'b0;
					immediate				= imm_I;
					alu_ctrl				= ALU_OP_ADD;
					update_data_mem 		= 'b0;
					data_mem_data_width 	= DATA_MEM_WORD;
					comparison_type			= COMPARISON_SIGNED;
					write_back_sel			= WRITE_BACK_ALU;
					operand_a_sel			= OPERAND_1_PC;
					operand_b_sel			= OPERAND_2_DATA_SRC2;
					next_pc_sel				= JUMP_PC;
				end
			endcase
		end
	end
endmodule