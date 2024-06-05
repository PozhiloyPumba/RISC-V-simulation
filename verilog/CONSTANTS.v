`define INSTR_SIZE 32
`define REG_SIZE 32
`define INSTR_SIZE_ZEROS {`INSTR_SIZE{1'b0}}
`define REG_NUM_SIZE 5

`define ALU_OP_BITS 2:0
`define ALU_SRC_BITS 4:3
`define BRN_COND_BITS 5

// Constants for decoding
`define OPCODE_ARITHM_REG   7'b0110011
`define OPCODE_ARITHM_IMM   7'b0010011
`define OPCODE_LOAD         7'b0000011
`define OPCODE_STORE        7'b0100011
`define OPCODE_BRANCH       7'b1100011

// ALU control
`define ALU_SRC_REG            2'b00
`define ALU_SRC_IMM            2'b01
`define ALU_SRC_STORE          2'b10
`define ALU_SRC_BRANCH         2'b11

// ALU Ops
`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_AND 3'b010
`define ALU_OR  3'b011
`define ALU_XOR 3'b100
`define ALU_NO_OP 3'b101

// ALU operations
`define ALU_OP_ARITHM_REG   2'b00
`define ALU_OP_ARITHM_IMM   2'b01
`define ALU_OP_NO           2'b10