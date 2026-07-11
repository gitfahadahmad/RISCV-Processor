`timescale 1ns / 1ps

module StateReg #(
    parameter int WIDTH = 32
)(
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out,
    input logic clr
);

    always_ff @(posedge clk or posedge rst or posedge clr) begin
            if (rst)       
                out <= '0;
            else if (clr)  
                out <= '0;
            else  
                out <= in;
    end

endmodule