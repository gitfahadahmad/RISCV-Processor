
module register_file(clk, rst, A1, A2, A3, WD3,WE3, RD1, RD2);

input logic clk, WE3, rst;
input logic [4:0] A1, A2, A3;
input logic [31:0] WD3;
output logic [31:0] RD1, RD2;

logic [31:0] memory [31:0];
integer i;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        for (i = 0; i<=31; i=i+1) begin
        memory[i] <= 32'd0;
        end
    end
    else if (WE3 && (A3 != 0)) memory[A3] <= WD3;
 end

assign  RD1 = memory[A1];
assign  RD2 = memory[A2];

endmodule