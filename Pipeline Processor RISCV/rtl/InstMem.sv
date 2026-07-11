`timescale 1ns / 1ps

module InstMem(
input logic [31:0] A, 
output logic [31:0] RD
);

logic [7:0] Memory [31:0]; //byte adressable memory 32 byte

initial begin
        // -------------------------------------------------------------
        // THE ULTIMATE PIPELINE TEST
        // This single block tests Forwarding, Load Stalls, and Branch Flushes.
        // -------------------------------------------------------------

        // Instruction 0 (PC = 0): addi x1, x0, 5
        // Purpose: Setup value for x1
        // Machine Code: 0x00_50_00_93
        Memory[0] = 8'h93;
        Memory[1] = 8'h00;
        Memory[2] = 8'h50;
        Memory[3] = 8'h00;

        // Instruction 1 (PC = 4): add x2, x1, x1
        // Purpose: [VERIFY FORWARDING] Immediately uses x1. Will trigger
        //          ForwardAE and ForwardBE to grab '5' from the MEM stage.
        // Machine Code: 0x00_10_81_33
        Memory[4] = 8'h33;
        Memory[5] = 8'h81;
        Memory[6] = 8'h10;
        Memory[7] = 8'h00;

        // Instruction 2 (PC = 8): lw x3, 0(x0)
        // Purpose: Setup for stall. Loads DataMem[0] into x3. 
        // Machine Code: 0x00_00_21_83
        Memory[8]  = 8'h83;
        Memory[9]  = 8'h21;
        Memory[10] = 8'h00;
        Memory[11] = 8'h00;

        // Instruction 3 (PC = 12): add x4, x3, x2
        // Purpose: [VERIFY LOAD-USE STALL] Tries to use x3 while the lw is 
        //          still in Execute. Will force the PC to stall at 16 for 1 cycle.
        // Machine Code: 0x00_21_82_33
        Memory[12] = 8'h33;
        Memory[13] = 8'h82;
        Memory[14] = 8'h21;
        Memory[15] = 8'h00;

        // Instruction 4 (PC = 16): beq x1, x1, 12
        // Purpose: [VERIFY BRANCH FLUSH] Since x1 == x1 (5 == 5), branch is TAKEN.
        //          It will jump forward 12 bytes to Instruction 7 (PC = 28).
        // Machine Code: 0x00_c0_86_63 
        Memory[16] = 8'h63;
        Memory[17] = 8'h86;
        Memory[18] = 8'h0c;  // Target offset = 12
        Memory[19] = 8'h00;

        // Instruction 5 (PC = 20): addi x5, x0, 99
        // Purpose: BAD INSTRUCTION. Should be flushed (turned to bubble) by the branch!
        // Machine Code: 0x06_30_02_93
        Memory[20] = 8'h93;
        Memory[21] = 8'h02;
        Memory[22] = 8'h30;
        Memory[23] = 8'h06;

        // Instruction 6 (PC = 24): addi x6, x0, 99
        // Purpose: BAD INSTRUCTION. Should also be flushed by the branch!
        // Machine Code: 0x06_30_03_13
        Memory[24] = 8'h13;
        Memory[25] = 8'h03;
        Memory[26] = 8'h30;
        Memory[27] = 8'h06;

        // Instruction 7 (PC = 28): add x7, x4, x1
        // Purpose: BRANCH TARGET. Execution resumes here.
        // Machine Code: 0x00_12_03_b3
        Memory[28] = 8'hb3;
        Memory[29] = 8'h03;
        Memory[30] = 8'h12;
        Memory[31] = 8'h00;

        // Instruction 8 (PC = 32): nop 
        // Purpose: Buffer to let the final instruction writeback to the register file
        // Machine Code: 0x00_00_00_13
        Memory[32] = 8'h13;
        Memory[33] = 8'h00;
        Memory[34] = 8'h00;
        Memory[35] = 8'h00;
    end

assign RD = {Memory[A+3], Memory[A+2], Memory[A+1], Memory[A]};


endmodule
