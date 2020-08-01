`include "ALU.sv"
`include "debounce.sv"

module top(
	input i_clk,
	input [10:0] i_btn,
	output [11:0] o_led
	);

	typedef enum logic[2:0] {S_OP, S_REG_SEL, S_REG_EDIT, S_X_REG_SEL, S_Y_REG_SEL, S_RES_REG_SEL, S_RES} states;
	states state;
	logic[2:0] op;
	logic[7:0] x;
	logic[7:0] y;
	logic[7:0] res;
	logic[2:0] x_reg;
	logic[2:0] y_reg;
	logic[2:0] res_reg;
	logic[2:0] sel_reg;

	logic[7:0] reg0;
	logic[7:0] reg1;
	logic[7:0] reg2;
	logic[7:0] reg3;
	logic[7:0] reg4;
	logic[7:0] reg5;
	logic[7:0] reg6;
	logic[7:0] reg7;

	logic[10:0] prev_btn;
	logic[10:0] button_events;
	wire[10:0] btn_debounced;
	logic[11:0] led_state;

	debounce #(11) debouncer0(i_clk, i_btn, btn_debounced);
	ALU alu0(op, x, y, res);

	always_comb begin
		case(x_reg)
			0: x = reg0;
			1: x = reg1;
			2: x = reg2;
			3: x = reg3;
			4: x = reg4;
			5: x = reg5;
			6: x = reg6;
			7: x = reg7;
		endcase

		case(y_reg)
			0: y = reg0;
			1: y = reg1;
			2: y = reg2;
			3: y = reg3;
			4: y = reg4;
			5: y = reg5;
			6: y = reg6;
			7: y = reg7;
		endcase
	end

	always_ff @(posedge i_clk) begin
		button_events <= prev_btn & ~btn_debounced;
		prev_btn <= btn_debounced;
	end

	always_ff @(posedge i_clk)
	begin
		case(state)
			S_OP: begin
				op <= op ^ button_events[2:0];
				led_state <= {9'b0, op};
				if(button_events[8])
					state <= S_REG_SEL;
			end
			S_REG_SEL: begin
				sel_reg <= sel_reg ^ button_events[2:0];
				led_state <= {9'b000100000, sel_reg};
				if(button_events[8])
					state <= S_X_REG_SEL;
				if(button_events[9])
					state <= S_REG_EDIT;
			end
			S_REG_EDIT: begin
				case(sel_reg)
					0: {led_state[7:0], reg0} <= {2{reg0 ^ button_events[7:0]}};
					1: {led_state[7:0], reg1} <= {2{reg1 ^ button_events[7:0]}};
					2: {led_state[7:0], reg2} <= {2{reg2 ^ button_events[7:0]}};
					3: {led_state[7:0], reg3} <= {2{reg3 ^ button_events[7:0]}};
					4: {led_state[7:0], reg4} <= {2{reg4 ^ button_events[7:0]}};
					5: {led_state[7:0], reg5} <= {2{reg5 ^ button_events[7:0]}};
					6: {led_state[7:0], reg6} <= {2{reg6 ^ button_events[7:0]}};
					7: {led_state[7:0], reg7} <= {2{reg7 ^ button_events[7:0]}};
				endcase
				led_state[11:8] <= 4'b0010;
				if(button_events[9])
					state <= S_REG_SEL;
			end
			S_X_REG_SEL: begin
				x_reg <= x_reg ^ button_events[2:0];
				led_state <= {9'b001100000, x_reg};
				if(button_events[8])
					state <= S_Y_REG_SEL;
			end
			S_Y_REG_SEL: begin
				y_reg <= y_reg ^ button_events[2:0];
				led_state <= {9'b010000000, y_reg};
				if(button_events[8])
					state <= S_RES_REG_SEL;
			end
			S_RES_REG_SEL: begin
				res_reg <= res_reg ^ button_events[2:0];
				led_state <= {9'b010100000, res_reg};
				if(button_events[8])
					state <= S_RES;
			end
			S_RES: begin
				led_state <= {4'b0110, res};
				if(button_events[10]) begin
					case(res_reg)
						0: reg0 <= res;
						1: reg1 <= res;
						2: reg2 <= res;
						3: reg3 <= res;
						4: reg4 <= res;
						5: reg5 <= res;
						6: reg6 <= res;
						7: reg7 <= res;
					endcase
				end
				if(button_events[8])
					state <= S_OP;
			end
		endcase
	end
	assign o_led = {led_state[11:8], ~led_state[7:0]};
endmodule