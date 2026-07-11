`timescale 1ns / 1ps

module Decode(
input logic clk, rst, RegWriteW, FlushE, 
input logic [31:0] InstrD, PCD, PCPlus4D, ResultW,
input logic [4:0] RdW,

output logic RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, 
output logic [1:0] ResultSrcE, 
output logic [2:0] ALUControlE, 
output logic [4:0] RdE, Rs1E, Rs2E,//Rs1E and Rs2E used for hazarUnit  
output logic [31:0] RD1E, RD2E, PCE, PCPlus4E, ImmExtE
    );
    
    logic [2:0] ALUControlD;
    logic RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD;
    logic [1:0] ImmSrcD, ResultSrcD;
    logic [4:0] RdD, Rs1D, Rs2D; //Rs1D and Rs2D for hazardUnit
    logic [31:0] ImmExtD;
    
    logic [31:0] RD1D, RD2D;
    
    assign RdD = InstrD[11:7];
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
     
    ControlUnit mainControlUnit 
        (//INPUTS 
         .op(InstrD[6:0]),
         .func3(InstrD[14:12]), 
         .func7_5(InstrD[30]),
          //OUTPUTS 
         .RegWriteD(RegWriteD),
         .ResultSrcD(ResultSrcD), 
         .MemWriteD(MemWriteD),
         .JumpD(JumpD),
         .BranchD(BranchD),
         .ALUControlD(ALUControlD),
         .ALUSrcD(ALUSrcD),
         .ImmSrcD(ImmSrcD)      
         );
    
    
 
    ImmExtend immExtender(.ImmSrc(ImmSrcD), .instruction(InstrD), .ImmExtD(ImmExtD));//by position 
        
    
    
    RegFile RegisterFile (
        .clk(clk),
        .rst(rst),
        .A1(InstrD[19:15]),
        .A2(InstrD[24:20]),
        .A3(RdW),
        .WD3(ResultW),
        .RD1(RD1D),
        .RD2(RD2D),
        .WE3(RegWriteW)
    );
    
    
    
StateReg #(.WIDTH(1))  u1  (.clk(clk), .rst(rst), .in(RegWriteD),   .out(RegWriteE),      .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(2))  u2  (.clk(clk), .rst(rst), .in(ResultSrcD),  .out(ResultSrcE),     .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(1))  u3  (.clk(clk), .rst(rst), .in(MemWriteD),   .out(MemWriteE),      .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(1))  u4  (.clk(clk), .rst(rst), .in(JumpD),       .out(JumpE),          .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(1))  u5  (.clk(clk), .rst(rst), .in(BranchD),     .out(BranchE),        .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(3))  u6  (.clk(clk), .rst(rst), .in(ALUControlD), .out(ALUControlE),    .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(1))  u7  (.clk(clk), .rst(rst), .in(ALUSrcD),     .out(ALUSrcE),        .clr(FlushE), .clr(1'b0));

StateReg #(.WIDTH(32)) u8  (.clk(clk), .rst(rst), .in(RD1D),        .out(RD1E),           .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(32)) u9  (.clk(clk), .rst(rst), .in(RD2D),        .out(RD2E),           .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(32)) u10 (.clk(clk), .rst(rst), .in(PCD),         .out(PCE),            .clr(FlushE), .clr(1'b0));

StateReg #(.WIDTH(5))  u11 (.clk(clk), .rst(rst), .in(RdD),         .out(RdE),            .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(5))  u14 (.clk(clk), .rst(rst), .in(Rs1D),         .out(Rs1E),          .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(5))  u15 (.clk(clk), .rst(rst), .in(Rs2D),         .out(Rs2E),          .clr(FlushE), .clr(1'b0));



StateReg #(.WIDTH(32)) u12 (.clk(clk), .rst(rst), .in(ImmExtD),     .out(ImmExtE),         .clr(FlushE), .clr(1'b0));
StateReg #(.WIDTH(32)) u13 (.clk(clk), .rst(rst), .in(PCPlus4D),    .out(PCPlus4E),        .clr(FlushE), .clr(1'b0));
    
endmodule
