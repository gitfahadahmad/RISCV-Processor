`timescale 1ns / 1ps



module mux_2x1 (
    output logic [31:0] out,
    input  logic        s,
    input  logic [31:0] x,y
);
    assign out = s ? y : x;
endmodule

module mux_3x1 (
    output logic [31:0] out,
    input  logic [1:0]  s,
    input  logic [31:0] d0, d1, d2
);
    assign out = (s == 2'b00) ? d0 : 
                 (s == 2'b01) ? d1 : 
                                d2;
endmodule