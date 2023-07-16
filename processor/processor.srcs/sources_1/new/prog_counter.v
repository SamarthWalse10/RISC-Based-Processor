`timescale 1ns / 1ps


module prog_counter #(parameter PROG_MEM_ADDR_WIDTH = 16)(
    input clk,
    input rst,
    input jump,
    input branch,
    input [PROG_MEM_ADDR_WIDTH-1:0]prog_counter_offset,
    output reg [PROG_MEM_ADDR_WIDTH-1:0]cnt_out
);

reg [PROG_MEM_ADDR_WIDTH-1:0] temp;

always @(posedge clk) begin
    if (rst) begin
        temp = 0;
    end else if (jump == 1 && branch == 0) begin
        temp = prog_counter_offset;
    end else if (branch == 1 && jump == 0) begin
        temp = temp + prog_counter_offset;
    end else begin
        temp = temp + 1;
    end
    cnt_out = temp;
end

endmodule
