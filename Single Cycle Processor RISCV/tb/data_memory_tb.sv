module data_memory_tb;

 logic [31:0] A, WD;
 logic clk, rst, WE;
 logic [31:0] RD;

logic [7:0] memory [1023:0];

data_memory uut (A, WD, clk,rst, WE, RD);

always #5 clk <= ~clk;

initial begin
clk = 0;
rst =1;
#10;

rst =0;
A = 0;
WE =1;
WD = 32'h000000001;
#10

A = 0;
WD = 32'h000000000;

#100;
$finish;
end


endmodule