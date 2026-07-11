`timescale 1ns / 1ps



module Top(input logic  clk, rst);

//Fetch Wires 
logic [31:0] PCTargetE;
logic PCSrcE;
logic [31:0] InstrD, PCD, PCPlus4;

//Decode Wires
logic RegWriteW; 
logic [31:0] PCPlus4D, ResultW;
logic [4:0] RdW;

logic RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE;
logic [1:0] ResultSrcE;
logic [2:0] ALUControlE; 
logic [4:0] RdE;
logic [31:0] RD1E, RD2E, PCE, PCPlus4E, ImmExtE;

//Execute Wires 
logic RegWriteM, MemWriteM;
logic [1:0] ResultSrcM;
logic [31:0] ALUResultM, WriteDataM, PCPlus4M;
logic [4:0] RdM;

//Memory Wires 
logic [31:0] ALUResultW, ReadDataW, PCPlus4W;
logic [1:0] ResultSrcW;

//HAZARD UNIT Signals 
//Forward Logic Mux select lines for execute stage
logic [1:0] ForwardAE, ForwardBE;

logic StallF, StallD, FlushD, FlushE; //Signals from Hazard Unit

logic [4:0] Rs1E, Rs2E; //Hazard Unit Inputs 


Fetch fetch(.clk, .rst, .PCTargetE(PCTargetE), .PCSrcE(PCSrcE), .InstrD(InstrD), 
            .PCD(PCD), .PCPlus4D(PCPlus4D), .StallF(StallF), .StallD(StallD), 
            .FlushD(FlushD)
             ); 


Decode decode (.clk(clk), .rst(rst), .RegWriteW(RegWriteW), .InstrD(InstrD), .PCD(PCD), 
               .PCPlus4D(PCPlus4D), .ResultW(ResultW), .RdW(RdW), .RegWriteE(RegWriteE),
               .MemWriteE(MemWriteE), .JumpE(JumpE), .BranchE(BranchE), .ALUSrcE(ALUSrcE),
               .ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .RdE(RdE), .RD1E(RD1E),
               .RD2E(RD2E), .PCE(PCE), .PCPlus4E(PCPlus4E), .ImmExtE(ImmExtE), .Rs1E(Rs1E), 
               .Rs2E(Rs2E), .FlushE(FlushE) 
                );
 

Execute execute (.clk(clk), .rst(rst), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE),
                 .JumpE(JumpE), .BranchE(BranchE), .ALUSrcE(ALUSrcE), .ResultSrcE(ResultSrcE),
                 .ALUControlE(ALUControlE), .RD1E(RD1E), .RD2E(RD2E), .PCE(PCE), .PCPlus4E(PCPlus4E),
                 .ImmExtE(ImmExtE), .RdE(RdE), .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
                 .PCSrcE(PCSrcE), .ResultSrcM(ResultSrcM), .ALUResultM(ALUResultM),
                 .WriteDataM(WriteDataM), .PCPlus4M(PCPlus4M), .PCTargetE(PCTargetE), .RdM(RdM),
                 .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .ResultW(ResultW)
                  );


Memory memory (.clk(clk), .rst(rst), .RegWriteM(RegWriteM), .MemWriteM(MemWriteM),
               .ResultSrcM(ResultSrcM), .ALUResultM(ALUResultM), .WriteDataM(WriteDataM),
               .PCPlus4M(PCPlus4M), .RdM(RdM), .RegWriteW(RegWriteW),
               .ALUResultW(ALUResultW), .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W),
               .RdW(RdW), .ResultSrcW(ResultSrcW)
                );

WriteBack writeback (.RegWriteW(RegWriteW), .ALUResultW(ALUResultW),
                     .ReadDataW(ReadDataW), .PCPlus4W(PCPlus4W),
                     .RdW(RdW), .ResultSrcW(ResultSrcW),
                     .ResultW(ResultW)
                      );
                      

Hazard_Unit hazardUnit (.Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]), .Rs1E(Rs1E), .Rs2E(Rs2E),
                       .RdE(RdE), .RdM(RdM), .RdW(RdW),
                       .PCSrcE(PCSrcE), .RegWriteM(RegWriteM), .RegWriteW(RegWriteW),
                       .ResultSrcE(ResultSrcE),
                       .StallF(StallF), .StallD(StallD), .FlushD(FlushD), .FlushE(FlushE),
                       .ForwardAE(ForwardAE), .ForwardBE(ForwardBE)
                        );
                      
                      

endmodule
