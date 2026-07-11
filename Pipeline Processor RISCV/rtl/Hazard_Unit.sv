`timescale 1ns / 1ps

module Hazard_Unit(
input logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
input logic PCSrcE, RegWriteM, RegWriteW,
input logic [1:0] ResultSrcE,

output logic StallF, StallD, FlushD, FlushE,
output logic [1:0] ForwardAE, ForwardBE
    );

logic lwStall;

always @ (*) begin 
    if((Rs1E == RdM) && RegWriteM && (Rs1E != 0)) 
        ForwardAE = 2'b10;
    else if((Rs1E == RdW) && RegWriteW && (Rs1E != 0)) 
        ForwardAE = 2'b01;
    else
        ForwardAE = 2'b00;
end

always @ (*) begin 
    if((Rs2E == RdM) && RegWriteM && (Rs2E != 0)) 
        ForwardBE = 2'b10;
    else if((Rs2E == RdW) && RegWriteW && (Rs2E != 0)) 
        ForwardBE = 2'b01;
    else
        ForwardBE = 2'b00;
end


assign lwStall = ResultSrcE[0] & ((Rs1D == RdE) | (Rs2D == RdE));
assign StallF   = lwStall;
assign StallD  = lwStall;

assign FlushD = PCSrcE;
assign FlushE  = lwStall | PCSrcE;

endmodule
