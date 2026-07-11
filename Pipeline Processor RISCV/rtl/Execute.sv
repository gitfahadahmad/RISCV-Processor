`timescale 1ns / 1ps

module Execute(
input logic clk, rst, RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, 
input logic [1:0] ResultSrcE, 
input logic [2:0] ALUControlE, 
input logic [31:0] RD1E, RD2E, PCE, PCPlus4E, ImmExtE,
input logic [4:0] RdE,
input logic [1:0] ForwardAE, ForwardBE, //inputs from hazard unit
input logic [31:0] ResultW, //output from last Mux3 from Writeback stage

output logic RegWriteM, MemWriteM, PCSrcE, 
output logic [1:0] ResultSrcM,
output logic [31:0] ALUResultM, WriteDataM, PCPlus4M, PCTargetE,
output logic [4:0] RdM
     );

    logic ZeroE;
    logic [31:0] SrcBE, ALUResusltE, SrcAE, mux3bOut;
    
    Mux3 mux3A (RD1E, ResultW, ALUResultM, ForwardAE, SrcAE);//in1, in2, in3, sel, out
    
    Mux3 mux3B (RD2E, ResultW, ALUResultM, ForwardBE, mux3bOut); //in1, in2, in3, sel, out
       
    Mux2 mux1(mux3bOut, ImmExtE, ALUSrcE, SrcBE);
   
    ALU mainALU(SrcAE, SrcBE, ALUControlE, ALUResusltE, ZeroE);//format: in1, in2. control, out, zeroflg 
    
    assign PCSrcE = JumpE | (ZeroE & BranchE);
    
    adder adder(PCE, ImmExtE, PCTargetE);
    
StateReg #(.WIDTH(1)) u1 (clk, rst, RegWriteE,   RegWriteM, 1'b0);
StateReg #(.WIDTH(2)) u2 (clk, rst, ResultSrcE,  ResultSrcM, 1'b0);
StateReg #(.WIDTH(1)) u3 (clk, rst, MemWriteE,   MemWriteM, 1'b0);

StateReg u4 (clk, rst, ALUResusltE, ALUResultM, 1'b0); // 32-bit default
StateReg u5 (clk, rst, mux3bOut,    WriteDataM, 1'b0); // 32-bit default

StateReg #(.WIDTH(5)) u6 (clk, rst, RdE, RdM, 1'b0);

StateReg u7 (clk, rst, PCPlus4E, PCPlus4M, 1'b0);      // 32-bit default


endmodule
