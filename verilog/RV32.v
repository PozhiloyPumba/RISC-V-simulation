`include "CONSTANTS.v"

module RV32
(
	input clk,
	input rst
);

wire [`INSTR_SIZE-1:0] PC_EX, PC_DISP, PC_DE, INSTR_D;
wire PC_R;

assign PC_R = 1'b0; 
FETCH fetch(
	.clk(clk),              .INSTR_D(INSTR_D),
    .rst(rst),              .PC_DE(PC_DE),
    .PC_R(PC_R),
    .PC_EX(PC_EX),
    .PC_DISP(PC_DISP)
);

endmodule