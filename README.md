# FPGA Demo Calculator
This project implements a simple (re: barebones) calculator.
The makefile and constraints file were written to be used on a Xilinx Spartan 6 FPGA, using the ISE toolchain.

## Usage
The calculator starts in the operator entry state. The first three buttons are used to enter a number, which corresponds to an operator:
addition, subtraction, bitwise and, bitwise nor, bitwise xor, left shift, right shift logical, and right shift arithmetic.
The fourth button acts as an enter key, moving to the next state.
The next two states are used to enter the operands, and are functionally the same as operator entry.
The last state displays the result of the operation on the LEDs, pressing any button transitions back to the first state.
