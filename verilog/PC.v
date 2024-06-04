module PC (
    input clk,
    input [`INSTR_SIZE-1:0] PCNext, output reg[`INSTR_SIZE-1:0] PCOut
);

always @(posedge clk) begin
    PCOut <= PCNext;
end

endmodule