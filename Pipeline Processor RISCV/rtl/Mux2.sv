`timescale 1ns / 1ps
module Mux2(
input logic [31:0] in1, in2,
input logic sel,
output logic [31:0] out
);

assign out = sel? in2 : in1;

endmodule
