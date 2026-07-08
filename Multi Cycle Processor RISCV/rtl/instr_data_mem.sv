`timescale 1ns / 1ps

module instr_data_mem(
    input clk,
    input [31:0] A,    
    input [31:0] WD,   
    input        WE,   
    output [31:0]  RD
);

    // Byte-addressable memory array (1024 bytes)
    reg [7:0] memory [1023:0];

    // Load instructions  from an external file
    initial begin
    // reads the instruction data from the instruction memory mem file
        $readmemh("instruction_memory_hex.mem", memory);
    end

    // WRITE OPERATION
    always @(posedge clk) begin
        if (WE) begin
            memory[A]     <= WD[7:0];
            memory[A + 1] <= WD[15:8];
            memory[A + 2] <= WD[23:16];
            memory[A + 3] <= WD[31:24];
        end
    end

    // READ OPERATION 
    assign RD[7:0]   = memory[A];
    assign RD[15:8]  = memory[A + 1];
    assign RD[23:16] = memory[A + 2];
    assign RD[31:24] = memory[A + 3];

endmodule