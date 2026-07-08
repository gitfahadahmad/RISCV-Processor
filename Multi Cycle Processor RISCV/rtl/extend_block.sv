`timescale 1ns/1ps

// Extender Block
module imm_Gen(
    input      [31:0] instruction, //instruction 32 bits used to fetch the immediate based on the types of the instruction
    input      [1:0]  ImmSrc,     // it is a two bit control signal for the immediate extend control logic from the ALU to process based on instruction types     
    output reg [31:0] immediate_output // output of the immediate extend block
);
    wire [11:0] load_im; //we have the 12 bit immediate in the I type instruction
    wire [11:0] store_im; // we have the 12 bit immediate in the S type instruction
    wire [12:0] branch_im; // we have the 13 bit immediate in the B type instruction due to the lsb set to zero by default
    wire [20:0] jump_im; // we have the 21 bits immediate in the J type instructions

    assign load_im   = instruction[31:20]; // I type
    assign store_im  = {instruction[31:25], instruction[11:7]}; // S type
    assign branch_im = {instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // B type
    
    assign jump_im   = {instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // J type

    always @(*) begin
        case(ImmSrc)
            2'b00: immediate_output = {{20{load_im[11]}}, load_im};
            2'b01: immediate_output = {{20{store_im[11]}}, store_im};
            2'b10: immediate_output = {{19{branch_im[12]}}, branch_im};
            2'b11: immediate_output = {{11{jump_im[20]}}, jump_im};
            default: immediate_output = 32'b0;
        endcase
    end
endmodule