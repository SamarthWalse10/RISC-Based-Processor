`timescale 1ns / 1ps


module processor_tb();
reg clk;
reg rst;

processor dut(.clk(clk), .rst(rst));

initial begin
    clk <= 0;
    forever #5 clk <= ~clk;
end

initial begin
    rst <= 0;
    #3 rst <= 1;
    #9 rst <= 0;
end

endmodule
