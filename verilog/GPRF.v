module GPRF (
    input clk,
    input [4:0] rn1,
    input [4:0] rn2,
    input we,
    input [4:0] outputReg,
    input [31:0] data,

    output [31:0] val1,
    output [31:0] val2
);

reg [31:0] regs [31:0] /*verilator public*/; // for dump trace

// read registers
assign val1 = (rn1 == 0) ? 0 : registers[rn1];
assign val2 = (rn2 == 0) ? 0 : registers[rn2];

// write to register wn
always @(negedge clk) begin
    if(we && wn != 0) begin
        registers[outputReg] <= data;
    end
end

endmodule