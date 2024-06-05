`include "CONSTANTS.v"

module FETCH (
    input clk,              output [`INSTR_SIZE-1:0] INSTR_D,
    input rst,              output [`INSTR_SIZE-1:0] PC_DE,
    input PC_R,
    input [`INSTR_SIZE-1:0] PC_EX,
    input [`INSTR_SIZE-1:0] PC_DISP
);

reg [`INSTR_SIZE-1:0] entry /* verilator public */;

wire [`INSTR_SIZE-1:0] PC /* verilator public */, PC_NEXT;

wire [`INSTR_SIZE-1:0] PC_1, PC_INC;
wire [`INSTR_SIZE-1:0] FETCHED_INSTR;

reg [`INSTR_SIZE-1:0] FETCHED_INSTR_reg;
reg [`INSTR_SIZE-1:0] PC_reg;

// PC increment
assign PC_1 = PC_R ? PC_EX : PC;
assign PC_INC = PC_R ? PC_DISP : 4;
assign PC_NEXT = PC_1 + PC_INC;

PC pc(
    .clk(clk),
    .rst(rst),
    .entry(entry),
    .PCNext(PC_NEXT), 
    .PCOut(PC)
);

// fetch instr
IMEM imem(
    .rst(rst),
    .A(PC),
    .D(FETCHED_INSTR)
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        FETCHED_INSTR_reg <= `INSTR_SIZE_ZEROS;
        PC_reg <= entry;
    end
    else begin
        FETCHED_INSTR_reg <= FETCHED_INSTR;
        PC_reg <= PC;
    end
end

assign INSTR_D = rst ? `INSTR_SIZE_ZEROS : FETCHED_INSTR_reg;
assign PC_DE = rst ? entry : PC_reg;

endmodule