`include "CONSTANTS.v"

module ALU_DECODER (
    input [1:0] ALU_OP_MODE,
    input [6:0] funct7,
    input [2:0] funct3,

    output [2:0] ALU_OP
);

assign ALU_OP = ((ALU_OP_MODE == `ALU_OP_ARITHM_REG) && (funct3 == 3'b000) && (funct7 == 7'b0000000)) ? `ALU_ADD :  // ADD
                ((ALU_OP_MODE == `ALU_OP_ARITHM_REG) && (funct3 == 3'b000) && (funct7 == 7'b0100000)) ? `ALU_SUB :  // SUB
                ((ALU_OP_MODE == `ALU_OP_ARITHM_IMM) && (funct3 == 3'b000)) ? `ALU_ADD :  // ADDI
                ((ALU_OP_MODE == `ALU_OP_ARITHM_IMM) && (funct3 == 3'b010)) ? `ALU_ADD :  // LW, SW
                ((ALU_OP_MODE <= `ALU_OP_ARITHM_IMM) && (funct3 == 3'b111)) ? `ALU_AND :  // AND, ANDI
                ((ALU_OP_MODE <= `ALU_OP_ARITHM_IMM) && (funct3 == 3'b110)) ? `ALU_OR :   // OR, ORI
                `ALU_ADD; // default

endmodule