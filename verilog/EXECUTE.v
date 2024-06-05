`include "CONSTANTS.v"

module EXECUTE (
    input [31:0] CONTROL_EX,
    input MEM_WE_DE,
    input WE_DE,
    input MEM_TO_REG_DE,
    input [`REG_SIZE-1:0] D1,
    input [`REG_SIZE-1:0] D2,
    input [24:0] IMM,
    input [`INSTR_SIZE-1:0] PC_EX,
    input [1:0] HU_RS1,
    input [1:0] HU_RS2,
    input [`REG_SIZE-1:0] BP_MEM,
    input [`REG_SIZE-1:0] BP_WB,
    input clk,
    input rst,

    output [`REG_SIZE-1:0] ALU_OUT,
    output PC_R,
    output [`REG_NUM_SIZE-1:0] RD,
    output MEM_WE_ME,
    output WE_ME,
    output MEM_TO_REG_ME,
    output [`INSTR_SIZE-1:0] PC_DISP,
    output [`REG_SIZE-1:0] WD_ME
);

wire [`REG_SIZE-1:0] RS1_V, RS2_V, RS2V_ALU_INP;

assign RS1_V = (HU_RS1 == 2'b00) ? D1:
               (HU_RS1 == 2'b01) ? BP_MEM : BP_WB;

assign RS2_V = (HU_RS2 == 2'b00) ? D2:
               (HU_RS2 == 2'b01) ? BP_MEM : BP_WB;

// imms
wire [`INSTR_SIZE-1:0] IMM_I, IMM_S, IMM_B;

assign IMM_I = { {20{IMM[24]}}, IMM[24:13] };
assign IMM_S = { {20{IMM[24]}}, IMM[24:18], IMM[4:0]};
assign IMM_B = { {20{IMM[24]}}, IMM[0], IMM[23:18], IMM[4:1], 1'b0 };

assign RS2V_ALU_INP = (CONTROL_EX[`ALU_SRC_BITS] == `ALU_SRC_REG) ? RS2_V:
                      (CONTROL_EX[`ALU_SRC_BITS] == `ALU_SRC_IMM) ? IMM_I:
                      (CONTROL_EX[`ALU_SRC_BITS] == `ALU_SRC_STORE) ? IMM_S: IMM_B;

COND_CTRL Cond_ctrl (
    .RS1V(RS1_V),
    .RS2V(RS2_V),
    .OP(IMM[7:5]),
    .BRN_COND(CONTROL_EX[`BRN_COND_BITS]),
    .PC_R(PC_R)
);

wire [`REG_SIZE-1:0] ALU_OUT_WIRE;

ALU alu (
    .A(RS1_V),
    .B(RS2V_ALU_INP),
    .ALU_OP(CONTROL_EX[`ALU_OP_BITS]),
    .OUT(ALU_OUT_WIRE)
);

reg [`REG_SIZE-1:0] ALU_OUT_reg, PC_DISP_reg, WD_reg;
reg MEM_WE_ME_reg, WE_ME_reg, MEM_TO_REG_reg;
reg [`REG_NUM_SIZE-1:0] RD_reg;

always @(posedge clk or negedge rst) begin
    if(rst) begin
        MEM_WE_ME_reg       <= 1'b0;
        WE_ME_reg           <= 1'b0;
        MEM_TO_REG_reg      <= 1'b0;
        ALU_OUT_reg         <= `INSTR_SIZE_ZEROS;
        PC_DISP_reg         <= `INSTR_SIZE_ZEROS;
        WD_reg              <= `INSTR_SIZE_ZEROS;
        RD_reg              <= 5'b00000;
    end
    else begin
        MEM_WE_ME_reg       <= MEM_WE_DE;
        WE_ME_reg           <= WE_DE;
        MEM_TO_REG_reg      <= MEM_TO_REG_DE;
        ALU_OUT_reg         <= ALU_OUT_WIRE;
        PC_DISP_reg         <= IMM_B;
        WD_reg              <= D1;
        RD_reg              <= IMM[4:0];
    end
end

assign MEM_WE_ME = MEM_WE_ME_reg;
assign WE_ME = WE_ME_reg;
assign MEM_TO_REG_ME = MEM_TO_REG_reg;
assign ALU_OUT = ALU_OUT_reg;
assign PC_DISP = PC_DISP_reg;
assign WD_ME = WD_reg;
assign RD = RD_reg;

endmodule