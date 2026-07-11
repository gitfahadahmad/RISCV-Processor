`timescale 1ns / 1ps

module StateRegEn (
    input  logic             clk,
    input  logic             rst,
    input  logic              EN,
    input  logic       [31:0] in,
    output logic       [31:0] out,
    input logic               clr

);

always_ff @(posedge clk or posedge rst)
    if (rst)       out <= '0;
    else if (clr)  out <= '0;
    else if (!EN)  out <= in;
            


endmodule