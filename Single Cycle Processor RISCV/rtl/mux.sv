`timescale 1ns / 1ps

module mux2_1(PCSrc, PCPlus4, PCTarget, PCNext);
//IO defining
input logic PCSrc;
input logic [31:0] PCPlus4, PCTarget;
output logic [31:0] PCNext;

//logic for the mux
assign PCNext = PCSrc ? PCTarget : PCPlus4;

endmodule

module mux3_1(a, b, c, sel, out);

input logic [31:0] a, b, c;
input logic [1:0] sel;
output logic [31:0] out;

always @(*)
    if(sel == 2'b00) begin
         out = a;
    end else if (sel == 2'b01) begin
        out = b;
    end else begin
         out = c;
    end
 
endmodule