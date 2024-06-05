`include "CONSTANTS.v"

module DATA_MEMORY
#(parameter N = 17)
(
    input WE,
    input [`INSTR_SIZE-1:0] WD,
    input [`INSTR_SIZE-1:0] A,
    input clk,
    input rst,

    output [`INSTR_SIZE-1:0] RD
);

reg[`INSTR_SIZE-1:0] Memory [((1<<N)-1):0];

always @(posedge clk) begin
    if (WE) begin
        Memory[A] <= WD;
    end
end

assign RD = rst ? `INSTR_SIZE_ZEROS : Memory[A];

endmodule