module PC (
    input clk,
    input rst,
    input [`INSTR_SIZE-1:0] entry,
    input [`INSTR_SIZE-1:0] PCNext, output reg[`INSTR_SIZE-1:0] PCOut
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        PCOut <= entry - 4;
    end
    else begin
        PCOut <= PCNext;
    end
end

endmodule