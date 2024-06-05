`include "CONSTANTS.v"

module DECODE
(
    input clk,
    input rst,
    input [`INSTR_SIZE-1:0] PC_DE,
    input [`INSTR_SIZE-1:0] INSTR,
    input [`REG_NUM_SIZE-1:0] WB_A,
    input [`REG_SIZE-1:0] WB_D,
    input WB_WE,
    
    // think about it
    output [31:0] CONTROL_EX,

    output MEM_WE,
    output DE_WE,
    output MEM_TO_REG,
    output [`REG_SIZE-1:0] D2,
    output [`REG_SIZE-1:0] D1,
    output [24:0] IMM,
    output [`INSTR_SIZE-1:0] PC_EX,
    output [`REG_NUM_SIZE-1:0] RS1_EX,
    output [`REG_NUM_SIZE-1:0] RS2_EX
);

wire [31:0] CONTROL_EX_D;
wire MEM_WE_D, DE_WE_D, MEM_TO_REG_D;
wire [`REG_SIZE-1:0] D1_D, D2_D;

reg [31:0] CONTROL_EX_D_reg;
reg MEM_WE_D_reg, DE_WE_D_reg, MEM_TO_REG_D_reg;
reg [`INSTR_SIZE-1:0] D1_D_reg, D2_D_reg, PC_EX_reg;
reg [24:0] IMM_reg;
reg [4:0] RS1_EX_reg, RS2_EX_reg;

GPRF gprf(
    .clk(clk),
    .rst(rst),
    .rn1(INSTR[19:15]),
    .rn2(INSTR[24:20]),
    .outputReg(WB_A),
    .WB_data(WB_D),
    .we(WB_WE),
    .D1(D1_D),
    .D2(D2_D)
);

CU controlUnit (
    .INSTRD(INSTR),
    .ALU_OP(CONTROL_EX_D[`ALU_OP_BITS]),
    .ALU_SRC(CONTROL_EX_D[`ALU_SRC_BITS]),
    .BRN_COND(CONTROL_EX_D[`BRN_COND_BITS]),
    .MEM_WE(MEM_WE_D),
    .DE_WE(DE_WE_D),
    .MEM_TO_REG(MEM_TO_REG_D)
);

always @(posedge clk or negedge rst) begin
    if(rst) begin
        CONTROL_EX_D_reg <=   `INSTR_SIZE_ZEROS;
        MEM_WE_D_reg <=       1'b0;
        DE_WE_D_reg <=        1'b0;
        MEM_TO_REG_D_reg <=      1'b0;
        D1_D_reg <=           `INSTR_SIZE_ZEROS;
        D2_D_reg <=           `INSTR_SIZE_ZEROS;
        PC_EX_reg <=          `INSTR_SIZE_ZEROS;
        IMM_reg <=            25'h000000;
        RS1_EX_reg    <= 5'b00000;
        RS2_EX_reg    <= 5'b00000;
    end
    else begin
        CONTROL_EX_D_reg <= CONTROL_EX_D;
        MEM_WE_D_reg <= MEM_WE_D;
        DE_WE_D_reg <= DE_WE_D;
        MEM_TO_REG_D_reg <= MEM_TO_REG_D;
        D1_D_reg <= D1_D;
        D2_D_reg <= D2_D;
        PC_EX_reg <= PC_DE;
        IMM_reg <= INSTR[31:7];
        RS1_EX_reg <= INSTR[19:15];
        RS2_EX_reg <= INSTR[24:20];
    end
end

assign CONTROL_EX = CONTROL_EX_D_reg;
assign MEM_WE = MEM_WE_D_reg;
assign DE_WE = DE_WE_D_reg;
assign MEM_TO_REG = MEM_TO_REG_D_reg;
assign D1 = D1_D_reg;
assign D2 = D2_D_reg;
assign PC_EX = PC_EX_reg;
assign IMM = IMM_reg;
assign RS1_EX = RS1_EX_reg;
assign RS2_EX = RS2_EX_reg;

endmodule