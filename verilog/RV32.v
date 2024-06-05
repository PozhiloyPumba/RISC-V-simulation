`include "CONSTANTS.v"

module RV32
(
	input clk,
	input rst
);

wire [`INSTR_SIZE-1:0] PC_EX, PC_DISP, PC_DE, INSTR_D;
wire PC_R;
wire WB_WE;

wire [1:0] HU_RS1, HU_RS2;

wire MEM_WE_DE, 
     MEM_TO_REG_DE,
     WE_DE;

wire MEM_WE_EX, 
     MEM_TO_REG_EX,
     WE_EX;

wire MEM_WE_ME, 
     MEM_TO_REG_ME,
     WE_ME;

wire [`REG_SIZE-1:0] WB_data, D1, D2, BP_MEM, BP_WB;
wire [31:0] CTRL_EX;
wire [24:0] IMM;
wire [`REG_NUM_SIZE-1:0] WB_A, RD, RS1_EX, RS2_EX;

wire [`REG_SIZE-1:0] ALU_OUT, WD_ME;

FETCH fetch(
	.clk(clk),
    .rst(rst),
    .PC_R(PC_R),
    .PC_EX(PC_EX),
    .PC_DISP(PC_DISP),

    .INSTR_D(INSTR_D),
    .PC_DE(PC_DE)
);

DECODE decode(
    .clk(clk),
    .rst(rst),
    .PC_DE(PC_DE),
    .INSTR(INSTR_D),
    .WB_A(WB_A),
    .WB_D(WB_data),
    .WB_WE(WB_WE),
    
    // think about it
    .CONTROL_EX(CTRL_EX),
    .MEM_WE(MEM_WE_DE),
    .D2(D2),
    .D1(D1),
    .IMM(IMM),
	.DE_WE(WE_DE),
    .PC_EX(PC_EX),
	.MEM_TO_REG(MEM_TO_REG_DE),
	.RS1_EX(RS1_EX),
	.RS2_EX(RS2_EX)
);

EXECUTE exec(
    .CONTROL_EX(CTRL_EX),
    .MEM_WE_DE(MEM_WE_DE),
    .WE_DE(WE_DE),
    .MEM_TO_REG_DE(MEM_TO_REG_DE),
    .D1(D1),
    .D2(D2),
    .IMM(IMM),
    .PC_EX(PC_EX),
    .HU_RS1(HU_RS1),
    .HU_RS2(HU_RS2),
    .BP_MEM(BP_MEM),
    .BP_WB(WB_data),
    .clk(clk),
    .rst(rst),

    .ALU_OUT(ALU_OUT),
    .PC_R(PC_R),
    .RD(RD),
    .MEM_WE_ME(MEM_WE_ME),
    .WE_ME(WE_ME),
    .MEM_TO_REG_ME(MEM_TO_REG_ME),
    .PC_DISP(PC_DISP),
    .WD_ME(WD_ME)
);

MEMORY mem
(
    .ALU_OUT(ALU_OUT),
    .RD(RD),
    .WE(WE_ME),
    .MEM_WE(MEM_WE_ME),
    .MEM_TO_REG(MEM_TO_REG_ME),
    .WD(WD_ME),
    .clk(clk),
    .rst(rst),

    .WB_D(WB_data),
    .WB_A(WB_A),
    .WB_WE(WB_WE),
    .BP_MEM(BP_MEM)
);

endmodule