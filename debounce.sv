module debounce(
	input i_clk,
	input [WIDTH - 1:0] i_btn,
	output [WIDTH - 1:0] o_btn
	);
	parameter WIDTH = 1;
	parameter WAIT = 18;
	logic[WIDTH - 1:0] sync = 0;
	logic[WIDTH - 1:0] cur_state = 0;
	logic[WIDTH - 1:0] prev_state = 0;
	logic[WAIT - 1:0] counter = 0;
	logic[WIDTH - 1:0] debounced;

	always_ff @(posedge i_clk)
		{prev_state, cur_state, sync} <= {cur_state, sync, i_btn};
	always_ff @(posedge i_clk)
		if(counter == 0)
		begin
			debounced <= cur_state;
			counter <= ~0;
		end else
			counter <= counter - 1'b1;
	assign o_btn = debounced;
endmodule