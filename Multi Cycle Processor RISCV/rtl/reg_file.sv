`timescale 1ns/1ps

module REG_FILE (
    input      [4:0]  A1, A2, A3, //A1, A2 (Source addresses), A3(destination address) 
    input      [31:0] WD3,// WD3
    output     [31:0] RD1, RD2, // RD1, RD2
    input             WE3, clock, reset //  WE3 = we3 write enable
);
    reg [31:0] reg_memory [31:0];  // 32 by 32 memory registers
    integer i;

    always@(posedge clock or posedge reset) begin
        if (reset) begin 
            for (i = 0; i < 32; i = i + 1) begin
                reg_memory[i] <= 32'b0; 
            end
        end
        else if (WE3 && (A3 != 0)) begin // destination address 0 cannot be overwritten cause it is hard written to zero
            reg_memory[A3] <= WD3;
        end
    end

    assign RD1 = reg_memory[A1]; //Rd1 assigned the value of the register[a1]
    assign RD2 = reg_memory[A2]; // Rd2 assigned the value of the register[a2]
endmodule