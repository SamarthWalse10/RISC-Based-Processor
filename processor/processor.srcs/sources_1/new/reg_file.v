`timescale 1ns / 1ps


module reg_file #(parameter REGF_WIDTH = 32, parameter REGF_DEPTH = 32)(
    input clk,
    input [$clog2(REGF_DEPTH)-1:0] rd_addr1,
    input [$clog2(REGF_DEPTH)-1:0] rd_addr2,
    output [REGF_WIDTH-1:0] rd_data1,
    output [REGF_WIDTH-1:0] rd_data2,
    input [$clog2(REGF_DEPTH)-1:0]wr_addr,
    input wr_en,
    input [REGF_WIDTH-1:0] wr_data
);

reg [REGF_WIDTH-1:0] regs[0:REGF_DEPTH-1];

always @(posedge clk) begin
    if (wr_en) begin
        regs[wr_addr] <= wr_data;
    end
end

assign rd_data1 = regs[rd_addr1];
assign rd_data2 = regs[rd_addr2];

endmodule
