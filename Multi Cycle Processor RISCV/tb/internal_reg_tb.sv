`timescale 1ns / 1ps

module internal_reg_tb( clk, rst, EN, RD, out);
    
input reg clk;
input reg rst;
input reg EN;
input reg [31:0] RD;
output wire [31:0] out;



internal_reg uut ( .clk(clk), .rst(rst), .EN(EN), .RD(RD), .out(out));
    always #5 clk = ~clk;

initial begin

clk = 0;
rst = 0;
EN = 0;
RD = 32'b0;

#20;

RD = 32'b1;

#20;

EN = 1;
RD = 32'hFFFFFFFF;

#20;

rst = 1;
EN = 0;
RD = 32'h0000000F;

#20;

rst = 0;
RD = 32'hFFFFFFFF;


#200;

$finish;

end



endmodule
