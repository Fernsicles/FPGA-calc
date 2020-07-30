module ALU(
	input logic[2:0] i_op,
	input logic[7:0] i_x,
	input logic[7:0] i_y,
	output wire[7:0] o_result
	);

	always_comb
	begin
		case(i_op)
			0: o_result = i_x + i_y;
			1: o_result = i_x - i_y;
			2: o_result = i_x & i_y;
			3: o_result = ~(i_x | i_y);
			4: o_result = i_x ^ i_y;
			5: o_result = i_x << i_y;
			6: o_result = i_x >> i_y;
			7: o_result = i_x >>> i_y;
		endcase
	end
endmodule