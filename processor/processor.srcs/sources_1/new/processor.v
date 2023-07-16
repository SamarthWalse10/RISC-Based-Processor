`timescale 1ns / 1ps


module processor #(parameter PROG_MEM_ADDR_WIDTH = 16, parameter PROG_MEM_WIDTH = 32, parameter REGF_WIDTH = 32, REGF_DEPTH = 32, parameter OPCODE_WIDTH = 5, parameter OPRAND_WIDTH = 32, parameter ALU_OUT_WIDTH = 32, parameter DATA_MEM_WIDTH = 32, parameter DATA_MEM_ADDR_WIDTH = 17, parameter ADD = 5'd0, parameter SUB = 5'd1, parameter MUL = 5'd2, parameter NAND = 5'd3, parameter LW = 5'd4, parameter SW = 5'd5, parameter BREQ = 5'd6, parameter BRGT = 5'd7, parameter BRLT = 5'd8, parameter JUMP = 5'd9)(
    input clk,
    input rst
);

    wire [15:0]prog_addr;
    reg [15:0] prog_addr_inc_val_branch;
    reg [15:0] prog_counter_offset;
    wire [31:0]instr;
    wire [31:0]a, b;
    wire [31:0]data_mem_out;
    wire [31:0]alu_out;
    reg [4:0]opcode;
    reg ctrl1, ctrl2, ctrl3, ctrl4, ctrl5;
    reg [31:0]regf_data_in;
    reg [4:0]regf_rd_addr1;
    reg aEQb, aGTb, aLTb;

    always @(*) begin
        opcode <= instr[31:27];
    end

    prog_counter #(.PROG_MEM_ADDR_WIDTH(PROG_MEM_ADDR_WIDTH)) 
    pc(.clk(clk), .rst(rst), .jump(ctrl5), .branch(ctrl4), .prog_counter_offset(prog_counter_offset), .cnt_out(prog_addr));

    prog_mem #(.PROG_MEM_WIDTH(PROG_MEM_WIDTH), .PROG_MEM_ADDR_WIDTH(PROG_MEM_ADDR_WIDTH)) 
    pm(.addr(prog_addr), .instr(instr));

    always @(*) begin
        regf_rd_addr1 <= ctrl4 ? 5'b00000 : instr[21:17];
    end

    reg_file #(.REGF_WIDTH(REGF_WIDTH), .REGF_DEPTH(REGF_DEPTH)) 
    rf(.clk(clk), .rd_addr1(regf_rd_addr1), .rd_addr2(instr[16:12]), .rd_data1(a), .rd_data2(b), .wr_addr(instr[26:22]), .wr_en(ctrl1), .wr_data(regf_data_in));

    always @(*) begin
        aEQb <= a ? 1'b0 : 1'b1;
        aGTb <= ~a[31];
        aLTb <= a[31];
    end

    always @(*) begin
        prog_addr_inc_val_branch <= (aEQb & ctrl4 & (opcode == 5'd6)) ? $signed(instr[15:0]) : ((aGTb & ctrl4 & (opcode == 5'd7)) ? $signed(instr[15:0]) : ((aLTb & ctrl4 & (opcode == 5'd8)) ? $signed(instr[15:0]) : 16'd1));
    end
    always @(*) begin
        prog_counter_offset <= ctrl5 ? $signed(instr[15:0]) : prog_addr_inc_val_branch;
    end

    alu #(.OPCODE_WIDTH(OPCODE_WIDTH), .OPRAND_WIDTH(OPRAND_WIDTH), .ALU_OUT_WIDTH(ALU_OUT_WIDTH), .ADD(ADD), .SUB(SUB), .MUL(MUL), .NAND(NAND))
    alu(.oprand1(a), .oprand2(b), .opcode(opcode), .alu_out(alu_out));
    
    always @(*) begin
        regf_data_in <= ctrl2 ? data_mem_out : alu_out;
    end

    data_mem #(.DATA_MEM_WIDTH(DATA_MEM_WIDTH), .DATA_MEM_ADDR_WIDTH(DATA_MEM_ADDR_WIDTH))
    dm(.clk(clk), .addr(instr[16:0]), .wr_en(ctrl3), .wr_data(a), .rd_data(data_mem_out));

    always @(*) begin
        ctrl1 <= ~ctrl3 & ~ctrl4 & ~ctrl5;
    end
    always @(*) begin
        ctrl2 <= (opcode == LW);
    end
    always @(*) begin
        ctrl3 <= (opcode == SW);
    end
    always @(*) begin
        ctrl4 <= ((opcode == BREQ) | (opcode == BRGT) | (opcode == BRLT));
    end
    always @(*) begin
        ctrl5 <= (opcode == JUMP);
    end

endmodule

