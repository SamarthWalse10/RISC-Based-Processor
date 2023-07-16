`timescale 1ns / 1ps


module alu #(parameter OPCODE_WIDTH = 5, parameter OPRAND_WIDTH = 32, parameter ALU_OUT_WIDTH = 32, parameter ADD = 5'd0, parameter SUB = 5'd1, parameter MUL = 5'd2, parameter NAND = 5'd3)(
    input [OPRAND_WIDTH-1:0] oprand1,   
    input [OPRAND_WIDTH-1:0] oprand2,
    input [OPCODE_WIDTH-1:0] opcode,
    output reg [ALU_OUT_WIDTH-1:0] alu_out
);

always @(*) begin
    case(opcode)
        ADD: alu_out = (oprand1 + oprand2);
        SUB: alu_out = (oprand1 - oprand2);
        MUL: alu_out = (oprand1 * oprand2);
        NAND: alu_out = ~(oprand1 & oprand2);
        default : alu_out = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
    endcase
end

endmodule
