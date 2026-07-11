`timescale 1ns / 1ps

module adder(
input logic [31:0] in1, in2,
output logic [31:0] sum
    );
    
    assign sum = in1 + in2;
endmodule
