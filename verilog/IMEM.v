`include "CONSTANTS.v"

module IMEM
#(parameter N = 17)
(
    input rst,
    input [`INSTR_SIZE-1:0] A,
    output [`INSTR_SIZE-1:0] D
);

reg	[`INSTR_SIZE-1:0] mem_buff [((1<<N)-1):0] /*verilator public*/;

assign D = rst ? {`INSTR_SIZE{1'b0}} : mem_buff[A[18:2]];

endmodule