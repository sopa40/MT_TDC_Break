// REGISTERS
localparam 	
			X0  = 5'b00000,
			X1  = 5'b00001,
			X2  = 5'b00010,
			X3  = 5'b00011,
			X4  = 5'b00100,
			X5  = 5'b00101,
			X6  = 5'b00110,
			X7  = 5'b00111,
			X8  = 5'b01000,
			X9  = 5'b01001,
			X10 = 5'b01010,
			X11 = 5'b01011,
			X12 = 5'b01100,
			X13 = 5'b01101,
			X14 = 5'b01110,
			X15 = 5'b01111,
			X16 = 5'b10000,
			X17 = 5'b10001,
			X18 = 5'b10010,
			X19 = 5'b10011,
			X20 = 5'b10100,
			X21 = 5'b10101,
			X22 = 5'b10110,
			X23 = 5'b10111,
			X24 = 5'b11000,
			X25 = 5'b11001,
			X26 = 5'b11010,
			X27 = 5'b11011,
			X28 = 5'b11100,
			X29 = 5'b11101,
			X30 = 5'b11110,
			X31 = 5'b11111;

// OPCODES
localparam 	OPCODE_WIDTH	 = 7;
localparam  
			OPCODE_R_TYPE 	 = 7'b0110011,
			OPCODE_I_TYPE 	 = 7'b0010011,
			OPCODE_LOAD_TYPE = 7'b0000011, // I-Type but dedicated opcode 
			OPCODE_S_TYPE 	 = 7'b0100011,
			OPCODE_B_TYPE 	 = 7'b1100011,
			OPCODE_U_TYPE 	 = 7'b0110111,
			OPCODE_JAL 		 = 7'b1101111, // J-Type but dedicated opcode
			OPCODE_LUI 		 = 7'b0110111, // U-Type but dedicated opcode
			OPCODE_AUPIC	 = 7'b0010111, // U-Type but dedicated opcode
			OPCODE_JALR		 = 7'b1100111; // I-Type but dedicated opcode

// ALU OPERATION WIDTH
localparam ALU_CTRL_WIDTH = 5;
// ALU OPERATIONS
localparam  
			ALU_OP_ADD 	= 5'b00001,
			ALU_OP_SUB 	= 5'b00010,
			ALU_OP_SLL 	= 5'b00011,
			ALU_OP_SRL 	= 5'b00100,
			ALU_OP_SRA 	= 5'b00101,
			ALU_OP_SEQ 	= 5'b00110,
			ALU_OP_SLT 	= 5'b00111,
			ALU_OP_SLTU	= 5'b01000,
			ALU_OP_XOR 	= 5'b01001,
			ALU_OP_OR  	= 5'b01010,
			ALU_OP_AND 	= 5'b01011,
			ALU_OP_ID_A = 5'b01100,
			ALU_OP_ID_B = 5'b01101;

// Arithmetic I-Type Instructions
localparam 
			I_TYPE_ADDI_FUNC_3  = 3'b000,
			I_TYPE_SLTI_FUNC_3  = 3'b010,
			I_TYPE_SLTIU_FUNC_3 = 3'b011,
			I_TYPE_XORI_FUNC_3  = 3'b100,
			I_TYPE_ORI_FUNC_3   = 3'b110,
			I_TYPE_ANDI_FUNC_3  = 3'b111,
			I_TYPE_SLLI_FUNC_3  = 3'b001,
			I_TYPE_SRLI_FUNC_3  = 3'b101,
			I_TYPE_SRAI_FUNC_3  = 3'b101; // in addition, bit 30 (in immediate) has to be set.

// Load I-Type Instructions
localparam 
			I_TYPE_LB_FUNC_3	= 3'b000,
			I_TYPE_LH_FUNC_3	= 3'b001,
			I_TYPE_LW_FUNC_3	= 3'b010,
			I_TYPE_LBU_FUNC_3	= 3'b100,
			I_TYPE_LHU_FUNC_3	= 3'b101;

// B-Type Instructions
localparam 
			B_TYPE_BEQ_FUNC_3 	= 3'b000,
			B_TYPE_BNE_FUNC_3 	= 3'b001,
			B_TYPE_BLT_FUNC_3 	= 3'b100,
			B_TYPE_BGE_FUNC_3 	= 3'b101,
			B_TYPE_BLTU_FUNC_3 	= 3'b110,
			B_TYPE_BGEU_FUNC_3 	= 3'b111;

// Arithmetic R-Type Instructions
localparam
			R_TYPE_ADD_FUNCT_7 	= 7'b0000000,
			R_TYPE_ADD_FUNCT_3 	= 3'b000,
			R_TYPE_SUB_FUNCT_7 	= 7'b0100000,
			R_TYPE_SUB_FUNCT_3 	= 3'b000,
			R_TYPE_SLL_FUNCT_7 	= 7'b0000000,
			R_TYPE_SLL_FUNCT_3 	= 3'b001,
			R_TYPE_SLT_FUNCT_7 	= 7'b0000000,
			R_TYPE_SLT_FUNCT_3 	= 3'b010,
			R_TYPE_SLTU_FUNCT_7	= 7'b0000000,
			R_TYPE_SLTU_FUNCT_3	= 3'b011,
			R_TYPE_XOR_FUNCT_7 	= 7'b0000000,
			R_TYPE_XOR_FUNCT_3 	= 3'b100,
			R_TYPE_SRL_FUNCT_7 	= 7'b0000000,
			R_TYPE_SRL_FUNCT_3 	= 3'b101,
			R_TYPE_SRA_FUNCT_7 	= 7'b0100000,
			R_TYPE_SRA_FUNCT_3 	= 3'b101,
			R_TYPE_OR_FUNCT_7 	= 7'b0000000,
			R_TYPE_OR_FUNCT_3 	= 3'b110,
			R_TYPE_AND_FUNCT_7 	= 7'b0000000,
			R_TYPE_AND_FUNCT_3 	= 3'b111;

// S-Type Instructions
localparam 
			S_TYPE_SB_FUNC3		= 3'b000,
			S_TYPE_SH_FUNC3		= 3'b001,
			S_TYPE_SW_FUNC3		= 3'b010;

typedef enum {MEMORY_ACCESS_WORD, MEMORY_ACCESS_HALFWORD, MEMORY_ACCESS_BYTE} 	memory_access_width_t;
typedef enum {WRITE_BACK_MEMORY, WRITE_BACK_ALU, WRITE_BACK_PC_PLUS_4} 			write_back_sel_t;
typedef enum {OPERAND_1_DATA_SRC1, OPERAND_1_PC} 								operand_a_sel_t;
typedef enum {OPERAND_2_DATA_SRC2, OPERAND_2_IMMEDIATE} 						operand_b_sel_t;
typedef enum {INCREMENTED_PC, JUMP_PC}											next_pc_sel_t;
typedef enum {DATA_MEMORY_BYTE, DATA_MEMORY_HALFWORD, DATA_MEMORY_WORD} 		data_memory_access_width_t;
typedef enum {COMPARISON_SIGNED, COMPARISON_UNSIGNED} 							comparison_t;

// UART state machine 
typedef enum {IDLE, RCV_FIRST_BYTE, RCV_SECOND_BYTE, RCVD, SET_DONE} state_t;
`define UART_START  2'b00
`define UART_DATA   2'b01
`define UART_STOP   2'b10
`define UART_IDLE   2'b11

`define SYSTEM_CLOCK    12000000

`define BAUD_RATE       9600   
`define UART_FULL_ETU   (`SYSTEM_CLOCK/`BAUD_RATE)
`define UART_HALF_ETU   ((`SYSTEM_CLOCK/`BAUD_RATE)/2)