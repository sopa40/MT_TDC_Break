module instruction_mem_tb();
	    
	localparam NUMBER_OF_INSTRUCTIONS 	= 1024;
	localparam INSTRUCTION_WIDTH 	  	= 32;
	localparam ADDRESS_WIDTH   			= 32;
	
	logic [ADDRESS_WIDTH-1:0] 		address;
	logic [INSTRUCTION_WIDTH-1:0] 	instruction;
	INSTRUCTION_MEMORY imem (
		.address(address),
		.instruction(instruction)
	);
	defparam imem.NUMBER_OF_INSTRUCTIONS	= NUMBER_OF_INSTRUCTIONS;
	defparam imem.INSTRUCTION_WIDTH   		= INSTRUCTION_WIDTH;
	defparam imem.ADDRESS_WIDTH				= ADDRESS_WIDTH;

	initial begin
		$dumpfile("instruction_mem_tb.vcd");
		$dumpvars(0, instruction_mem_tb);
		#0;
		address = 32'h00000000;
		#10;
		address = 32'h00000001;
		#10;
		address = 32'h00000004;
		#10;
		address = 32'h00000007;
		#10;
		address = 32'h00000008;
		#10;
		address = 32'h00000020;
		$display("isntruction_mem_tb Done.");
		#10;
		$finish();
	end
endmodule