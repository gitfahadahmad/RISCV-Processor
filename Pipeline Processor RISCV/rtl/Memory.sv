`timescale 1ns / 1ps

module Memory(
input logic clk, rst, RegWriteM, MemWriteM,  
input logic [1:0] ResultSrcM,
input logic [31:0] ALUResultM, WriteDataM, PCPlus4M, 
input logic [4:0] RdM,

output logic RegWriteW,
output logic [31:0] ALUResultW, ReadDataW, PCPlus4W,
output logic [4:0] RdW,
output logic [1:0] ResultSrcW
    );

    logic [31:0] ReadDataM;
    
    DataMem DataMem (clk, MemWriteM, ALUResultM, WriteDataM, ReadDataM); //format: clk, WE, A, WD, RD
    
StateReg #(.WIDTH(1)) u1 (clk, rst, RegWriteM,  RegWriteW, 1'b0);
StateReg #(.WIDTH(2)) u2 (clk, rst, ResultSrcM, ResultSrcW, 1'b0);

StateReg u3 (clk, rst, ALUResultM, ALUResultW, 1'b0); // 32-bit default
StateReg u4 (clk, rst, ReadDataM,  ReadDataW, 1'b0);  // 32-bit default

StateReg #(.WIDTH(5)) u5 (clk, rst, RdM, RdW, 1'b0);

StateReg u6 (clk, rst, PCPlus4M, PCPlus4W, 1'b0);     // 32-bit default

endmodule
