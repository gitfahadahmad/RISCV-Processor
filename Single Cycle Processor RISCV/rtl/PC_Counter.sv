
module PC_Counter(clk, rst, PCNext, PC);

input logic clk, rst;
input logic [31:0] PCNext; //input wire
output logic [31:0] PC; // output wire

always @(posedge clk or posedge rst) begin

    if(rst) begin
        PC <= 32'b0;
    end
    else begin
        PC <= PCNext;
    end
end
endmodule