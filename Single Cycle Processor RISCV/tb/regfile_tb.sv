module regfile_tb;
 logic clk, WE3, rst;
 logic [4:0] A1, A2, A3;
 logic [31:0] WD3;
 logic [31:0] RD1, RD2;

register_file uut2(clk, rst, A1, A2, A3, WD3,WE3, RD1, RD2);
always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1;
A1 = 5'd0;
A2 = 5'd0;
A3 = 5'd0;

#10;
rst = 0;
WE3 = 1;
A3 = 5'd4;
WD3 = 32'h0000fff1;
#20;

WE3 = 0;
A1 = 5'd4;
//#20;

//rst = 0;
//WE3 = 1;
//A3 = 5'd4;
//WD3 = 32'h0000fff1;
//#20;

A2 = 5'd4;
#10;

$finish;
end

endmodule