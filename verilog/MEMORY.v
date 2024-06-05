`include "CONSTANTS.v"

module MEMORY
(
    input [`INSTR_SIZE-1:0] ALU_OUT,
    input [`REG_NUM_SIZE-1:0] RD,
    input WE,
    input MEM_WE,
    input MEM_TO_REG,
    input [`INSTR_SIZE-1:0] WD,
    input clk,
    input rst,

    output [`INSTR_SIZE-1:0] WB_D,
    output [`REG_NUM_SIZE-1:0] WB_A,
    output WB_WE,
    output [`INSTR_SIZE-1:0] BP_MEM
);

wire [`INSTR_SIZE-1:0] WB_D_wire;
wire [`INSTR_SIZE-1:0] MEM_RD;

reg WB_WE_reg;
reg [`INSTR_SIZE-1:0] WB_D_reg;
reg [`REG_NUM_SIZE-1:0] WB_A_reg;

DATA_MEMORY data_mem (
    .WE(MEM_WE),
    .WD(WD),
    .A(ALU_OUT),
    .clk(clk),
    .rst(rst),

    .RD(MEM_RD)
);

assign WB_D_wire = MEM_TO_REG ? MEM_RD : ALU_OUT;

always @(posedge clk or negedge rst) begin
    if (rst) begin
        WB_WE_reg <= 1'b0;
        WB_A_reg <= 5'b00000;
        WB_D_reg <= 32'h00000000;
    end
    else begin
        WB_WE_reg <= MEM_WE;
        WB_A_reg <= RD;
        WB_D_reg <= WB_D_wire;
    end
end

assign WB_D = WB_D_reg;
assign WB_A = WB_A_reg;
assign WB_WE = WB_WE_reg;
assign BP_MEM = ALU_OUT;

endmodule