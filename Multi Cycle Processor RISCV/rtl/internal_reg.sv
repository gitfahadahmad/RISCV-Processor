`timescale 1ns / 1ps


module internal_reg(
input clk,
input rst,
input EN,
input [31:0] RD, //input data
output reg [31:0] out //output data

    );

always @(posedge clk or posedge rst) begin
    if (rst) 
        out <= 32'b0;
    else if (EN) 
        out <= RD; // If EN=0, it naturally holds its value safely
end
    
    
endmodule

