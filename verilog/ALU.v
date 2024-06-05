`include "CONSTANTS.v"

module ALU
(
    input [`REG_SIZE-1:0] A,
    input [`REG_SIZE-1:0] B,
    input [2:0] ALU_OP,
    output [`REG_SIZE-1:0] OUT    
);

assign OUT = (ALU_OP == `ALU_ADD) ? A+B:
             (ALU_OP == `ALU_SUB) ? A-B:
             (ALU_OP == `ALU_AND) ? A&B:
             (ALU_OP == `ALU_OR) ? A|B:
             (ALU_OP == `ALU_XOR) ? A^B:
             A;

endmodule