`timescale 1ns / 1ps

module ALU(
    input      [31:0] SrcA, //Data from the Address 1
    input      [31:0] SrcB, // Data from the Address 2 or the Extend block(immediate value)
    input      [2:0]  ALUControl, // 3 bit signal from the control unit to check for which function to perform on the address values
    output reg [31:0] ALUResult, // it is the ALU ALUResult that is being fed to data memory for reading or writing data, or for storing the address to register file
    output reg        zero_flag // zero flag to check for the equal statement later
);
    always @(*) begin
        ALUResult = 32'b0;



    case(ALUControl)
        3'b000: ALUResult = SrcA + SrcB;            // ADD
        3'b001: ALUResult = SrcA - SrcB;            // SUB
        3'b010: ALUResult = SrcA & SrcB;            // AND
        3'b011: ALUResult = SrcA | SrcB;            // OR
        3'b100: ALUResult = SrcA ^ SrcB;            // XOR
        3'b101: ALUResult = SrcA << SrcB[4:0];      // SLL
        3'b110: ALUResult = SrcA >> SrcB[4:0];      // SRL
    default: ALUResult = 32'b0;    // DEFAULT CASE
    endcase
        zero_flag = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
    end
endmodule