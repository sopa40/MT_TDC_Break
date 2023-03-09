module INSTRUCTION_MEMORY
#(
	parameter NUMBER_OF_INSTRUCTIONS	= 1024, 
	parameter INSTRUCTION_WIDTH			= 32,
	parameter ADDRESS_WIDTH				= 32
)(
	input  logic [ADDRESS_WIDTH-1:0] 			address,
	output logic [INSTRUCTION_WIDTH-1:0] 		instruction
);

	logic [INSTRUCTION_WIDTH-1:0] instruction_memory [0:NUMBER_OF_INSTRUCTIONS-1];

	initial begin
		assert (INSTRUCTION_WIDTH % 4 == 0);
		$readmemh("./ROMS/hex.mem", instruction_memory);
		//$readmemb("./ROMS/bin.mem", instruction_memory);
	end
	
	assign instruction = instruction_memory[address>>2];
	
endmodule