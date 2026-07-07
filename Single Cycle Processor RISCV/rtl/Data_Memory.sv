
module data_memory(A, WD, clk,rst, WE, RD);

input logic [31:0] A, WD;
input logic clk, rst, WE;
output logic [31:0] RD;

logic [7:0] memory [1023:0];
integer i;
always @ (posedge clk or posedge rst) begin
    if (rst) begin
    for(i = 0; i<=1023; i = i+1)
    memory[i] <= 8'b0;
    end
    else if (WE) begin
     memory[A]     <= WD[7:0];
     memory[A + 1] <= WD[15:8];
     memory[A + 2] <= WD[23:16];
     memory[A + 3] <= WD[31:24];
    end
    else begin
        for(i = 0; i<=1023; i = i+1)
        memory[i] <= 8'b0;
    end 
end

always @(*) begin

    RD[7:0] <= memory[A];
    RD[15:8] <= memory[A+1];
    RD[23:16] <= memory[A+2];
    RD[31:24] <= memory[A+3];
end
endmodule
