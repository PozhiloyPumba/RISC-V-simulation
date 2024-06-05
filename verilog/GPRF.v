module GPRF (
    input clk,
    input rst,
    input [`REG_NUM_SIZE-1:0] rn1,
    input [`REG_NUM_SIZE-1:0] rn2,
    input [`REG_NUM_SIZE-1:0] outputReg,
    input [`REG_SIZE-1:0] WB_data,
    input we,

    output [`REG_SIZE-1:0] D1,
    output [`REG_SIZE-1:0] D2
);

reg [(1 << `REG_NUM_SIZE)-1:0] regs [`REG_SIZE-1:0] /*verilator public*/; // for dump trace

// read registers
assign D1 = (rn1 == 0) || rst ? {`INSTR_SIZE{1'b0}} : regs[rn1];
assign D2 = (rn2 == 0) || rst ? {`INSTR_SIZE{1'b0}} : regs[rn2];

// write to register
always @(negedge clk) begin
    if(we) begin
        regs[outputReg] <= WB_data;
    end
end

endmodule