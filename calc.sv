`include "ALU.sv"
`include "debounce.sv"

module top(
	input i_clk,
	input [3:0] i_btn,
	output [7:0] o_led
	);

	typedef enum logic[1:0] {S_OP, S_X, S_Y, S_RES} states;
	states state;
	logic[2:0] op = 0;
	logic[2:0] x = 0;
	logic[2:0] y = 0;
	logic[3:0] prev_btn;
	logic[3:0] button_events;
	wire[3:0] btn_debounced;
	logic[7:0] led_state = ~0;
	wire[7:0] res;
	debounce debouncer0(i_clk, i_btn[0], btn_debounced[0]);
	debounce debouncer1(i_clk, i_btn[1], btn_debounced[1]);
	debounce debouncer2(i_clk, i_btn[2], btn_debounced[2]);
	debounce debouncer3(i_clk, i_btn[3], btn_debounced[3]);
	ALU alu0(op, {5'b0, x}, {5'b0, y}, res);

	always_ff @(posedge i_clk)
	begin
		button_events <= prev_btn & ~btn_debounced;
		prev_btn <= btn_debounced;
	end

	always_ff @(posedge i_clk)
	begin
		case(state)
			S_OP: begin
				op <= op ^ button_events[2:0];
				led_state <= {5'b10000, op};
				if(button_events[3])
					state <= S_X;
			end
			S_X: begin
				x <= x ^ button_events[2:0];
				led_state <= {5'b0, x};
				if(button_events[3])
					state <= S_Y;
			end
			S_Y: begin
				y <= y ^ button_events[2:0];
				led_state <= {5'b0, y};
				if(button_events[3])
					state <= S_RES;
			end
			S_RES: begin
				led_state <= res;
				if(|button_events)
				begin
					op <= 0;
					x <= 0;
					y <= 0;
					state <= S_OP;
				end
			end
		endcase
	end
	assign o_led = ~led_state;
endmodule