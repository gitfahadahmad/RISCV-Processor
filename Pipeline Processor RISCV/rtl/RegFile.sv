`timescale 1ns / 1ps

module RegFile(

input logic [4:0] A1,
input logic [4:0] A2,
input logic [4:0] A3,
input logic[31:0] WD3,
output logic[31:0] RD1,
output logic[31:0] RD2,
input logic WE3,
input logic clk,
input logic rst
   );
   
   logic [31:0] reg_memory [31:0];
   integer i; //loop variable
always@(negedge clk or posedge rst) begin
   if(rst) begin
      for (i=0;i<32; i=i+1) begin
         reg_memory[i] <= 32'b0;
      end
      end
   else if (WE3 && (A3!=0)) begin
   reg_memory[A3]<=WD3;
    end
end
    assign RD1 = reg_memory[A1];
    assign RD2 = reg_memory[A2];
           

endmodule
