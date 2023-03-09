module COMPARATOR 
#(
	parameter VALUE_WIDTH = 32
)(
	input  logic [VALUE_WIDTH-1:0] 	val_a,
	input  logic [VALUE_WIDTH-1:0] 	val_b,
	input  comparison_t 			comparison_type,
	output logic 					eq,
	output logic 					lt
);

	assign eq = 
		(comparison_type == COMPARISON_UNSIGNED) 
			? ($unsigned(val_a) == $unsigned(val_b)) 
			: ($signed(val_a) == $signed(val_b));

	assign lt = 
		(comparison_type == COMPARISON_UNSIGNED) 
			? ($unsigned(val_a) <  $unsigned(val_b)) 
			: ($signed(val_a) <  $signed(val_b));

endmodule