module instruction_memory(A, RD);
input logic [31:0] A;
output logic [31:0] RD;

logic [7:0] memory [1023:0];

initial begin
    // Init memory to 0
    integer i;
    for (i = 0; i < 1024; i = i + 1) memory[i] = 8'h00;

    // 0x00: addi x1, x0, 15    (x1 = 15) -> 00f00093
    memory[0] = 8'h93; memory[1] = 8'h00; memory[2] = 8'hf0; memory[3] = 8'h00;
    
    // 0x04: addi x2, x0, 10    (x2 = 10) -> 00a00113
    memory[4] = 8'h13; memory[5] = 8'h01; memory[6] = 8'ha0; memory[7] = 8'h00;
    
    // 0x08: add x3, x1, x2     (x3 = 25) -> 002081b3
    memory[8] = 8'hb3; memory[9] = 8'h81; memory[10] = 8'h20; memory[11] = 8'h00;
    
    // 0x0C: sub x4, x1, x2     (x4 = 5)  -> 40208233
    memory[12] = 8'h33; memory[13] = 8'h82; memory[14] = 8'h20; memory[15] = 8'h40;
    
    // 0x10: and x5, x1, x2     (x5 = 10) -> 0020f2b3
    memory[16] = 8'hb3; memory[17] = 8'hf2; memory[18] = 8'h20; memory[19] = 8'h00;
    
    // 0x14: or x6, x1, x2      (x6 = 15) -> 0020e333
    memory[20] = 8'h33; memory[21] = 8'he3; memory[22] = 8'h20; memory[23] = 8'h00;
    
    // 0x18: slt x7, x2, x1     (x7 = 1)  -> 001123b3
    memory[24] = 8'hb3; memory[25] = 8'h23; memory[26] = 8'h11; memory[27] = 8'h00;
    
    // 0x1C: sw x3, 0(x0)       (Mem[0] = 25) -> 00302023
    memory[28] = 8'h23; memory[29] = 8'h20; memory[30] = 8'h30; memory[31] = 8'h00;
    
    // 0x20: lw x8, 0(x0)       (x8 = Mem[0] = 25) -> 00002403
    memory[32] = 8'h03; memory[33] = 8'h24; memory[34] = 8'h00; memory[35] = 8'h00;
    
    // 0x24: beq x3, x8, 8      (Branch to 0x2C) -> 00818463
    memory[36] = 8'h63; memory[37] = 8'h84; memory[38] = 8'h81; memory[39] = 8'h00;
    
    // 0x28: addi x9, x0, 1     (TRAP 1: Should be skipped) -> 00100493
    memory[40] = 8'h93; memory[41] = 8'h04; memory[42] = 8'h10; memory[43] = 8'h00;
    
// 0x2C: jal x10, 8         (Jump to 0x34, x10 = 0x30) -> 0080056f
        memory[44] = 8'h6f; memory[45] = 8'h05; memory[46] = 8'h80; memory[47] = 8'h00;
    
    // 0x30: addi x9, x0, 2     (TRAP 2: Should be skipped) -> 00200493
    memory[48] = 8'h93; memory[49] = 8'h04; memory[50] = 8'h20; memory[51] = 8'h00;
    
    // 0x34: beq x0, x0, 0      (End Simulation Loop) -> 00000063
    memory[52] = 8'h63; memory[53] = 8'h00; memory[54] = 8'h00; memory[55] = 8'h00;
end

assign RD = {memory[A+3], memory[A+2], memory[A+1], memory[A]};

endmodule