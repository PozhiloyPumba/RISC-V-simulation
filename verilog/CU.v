module CU
(
    input [`INSTR_SIZE-1:0] INSTRD,
    output [2:0] ALU_OP,
    output [1:0] ALU_SRC,
    output BRN_COND,
    output MEM_WE,
    output DE_WE,
    output MEM_TO_REG
);

wire [1:0] ALU_OP_MODE;

MAIN_CONTROLLER main_ctrl (
    .opcode(INSTRD[6:0]),
    .ALU_OP_MODE(ALU_OP_MODE),
    .ALU_SRC(ALU_SRC),
    .BRN_COND(BRN_COND),
    .MEM_WE(MEM_WE),
    .DE_WE(DE_WE),
    .MEM_TO_REG(MEM_TO_REG)
);

ALU_DECODER alu_dec (
    .ALU_OP_MODE(ALU_OP_MODE),
    .funct3(INSTRD[14:12]),
    .funct7(INSTRD[31:25]),

    .ALU_OP(ALU_OP)
);

endmodule