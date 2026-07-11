`timescale 1ns / 1ps

module Fetch(
input logic [31:0] PCTargetE,
input logic PCSrcE, clk, rst, StallF, StallD, FlushD,
output logic [31:0] InstrD, PCD, PCPlus4D
    );
    
    logic [31:0] PCPlus4F, PCFin, PCFout, InstrF;
    
    Mux2 inputMux(PCPlus4F, PCTargetE, PCSrcE, PCFin); //format: in1, in2, sel, out
        
    StateRegEn PCBuffer(clk, rst, StallF, PCFin, PCFout, 1'b0); //format: clk, rst, EN, in, out, clr

    adder plus4adder (PCFout, 32'd4, PCPlus4F); //format in1, in2, sum
    
    InstMem instructionMemory (PCFout, InstrF); // A, RD
    
    StateRegEn InstrDbuffer(clk, rst, StallD, InstrF, InstrD, FlushD);  //format: clk, rst, EN, in, out, clr
    
    StateRegEn PCDbuffer(clk, rst, StallD, PCFout, PCD, FlushD); //format: clk, rst, EN, in, out, clr
    
    StateRegEn PCPlus4FDbuffer(clk, rst, StallD, PCPlus4F, PCPlus4D, FlushD);  //format: clk, rst, EN, in, out, clr
    
endmodule
