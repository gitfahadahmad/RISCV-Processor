`timescale 1ns / 1ps



module DataMem(
input logic clk, WE, 
input logic [31:0] A, WD, 
output logic [31:0] RD 
);

//1 KB byte-adressable memory 
logic [7:0] memory [1023:0];



always @(posedge clk) begin 
// WRITE Operation 
    if (WE) begin 
        memory[A] <= WD[7:0];
        memory[A + 1] <= WD[15:8];
        memory[A + 2] <= WD[23:16];
        memory[A + 3] <= WD[31:24];
    end 
end

// READ Operation 
always @ (*) begin
        RD [7:0] = memory[A];
        RD [15:8] = memory[A + 1];
        RD [23:16] = memory[A + 2];
        RD [31:24] = memory[A + 3];
    end
     

endmodule