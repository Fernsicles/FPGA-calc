module debounce(
	input i_clk,
	input i_btn,
	output o_btn
	);
	parameter WAIT = 18;
	logic sync = 0;
	logic cur_state = 0;
	logic prev_state = 0;
	logic[WAIT - 1:0] counter = 0;
	logic debounced;

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