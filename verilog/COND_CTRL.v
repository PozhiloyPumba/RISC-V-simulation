`include "CONSTANTS.v"

module COND_CTRL (
    input [`REG_SIZE-1:0] RS1V,
    input [`REG_SIZE-1:0] RS2V,
    input [2:0] OP,
    input BRN_COND,

    output PC_R
);

wire tmp;
assign tmp = (OP == 3'b000) ? (RS1V == RS2V):
             (OP == 3'b001) ? (RS1V != RS2V):
             (OP == 3'b100) ? (RS1V < RS2V) :
             (OP == 3'b101) ? (RS1V >= RS2V):
             1'b0;

assign PC_R = tmp & BRN_COND;

endmodule