calc: calc_par.bit
	sudo ~/xc6slx9_board.sh "pld load 0 calc_par.bit; exit"

calc_par.bit: calc_par.ncd
	bitgen -w calc_par.ncd

calc_par.ncd: calc.ncd
	par -w calc.ncd calc_par.ncd

calc.ncd: calc.ngd
	map -w calc.ngd

calc.ngd: calc.edif calc.ucf
	ngdbuild -p 6slx9tqg144-2 -uc calc.ucf calc.edif

calc.edif: calc.sv ALU.sv
	yosys -p 'read_verilog -sv calc.sv; opt; synth_xilinx -edif calc.edif'

clean:
	zsh --extendedglob -c "rm ^(*.(sv|ucf|dot)|makefile)"