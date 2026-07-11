`timescale 1ns / 1ps
module Mux3(
input logic [31:0] in1, in2, in3, 
input logic [1:0] sel,
output logic [31:0] out
);

always @ (*)begin
    case (sel)
        2'b00: out = in1;
        2'b01: out = in2;
        2'b10: out = in3;
        default: out = 32'd0;
            
    endcase

end



endmodule
