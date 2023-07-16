`timescale 1ns / 1ps


module data_mem #(parameter DATA_MEM_WIDTH = 32, parameter DATA_MEM_ADDR_WIDTH = 17)(
    input clk,
    input [DATA_MEM_ADDR_WIDTH-1:0] addr,
    input  wr_en,
    input [DATA_MEM_WIDTH-1:0]wr_data,
    output [DATA_MEM_WIDTH-1:0]rd_data
);

reg [DATA_MEM_WIDTH-1:0] mem[0:(2**DATA_MEM_ADDR_WIDTH)-1];

initial begin
        mem[0] = 32'b00000000000000000000000000000000;
        mem[1] = 32'b00000000000000000000000011001000;
        mem[2] = 32'b00000000000000000000000000001010;  
        mem[3] = 32'b00000000000000000000000000000010;  
        mem[4] = 32'b00000000000000000000000000000000;  
        mem[5] = 32'b00000000000000000000000000000000;  
        mem[6] = 32'b00000000000000000000000000000000;  
end

always @(posedge clk) begin
    if (wr_en) begin
        mem[addr] <= wr_data;
    end
end

assign rd_data = mem[addr];

endmodule

