`timescale 1ns/1ps

module imm_Gen_tb;

    // Testbench Signals
    reg  [31:0] instruction;
    reg  [1:0]  ImmSrc;
    wire [31:0] immediate_output;

    // Instantiate the Unit Under Test (UUT)
    imm_Gen uut (
        .instruction(instruction),
        .ImmSrc(ImmSrc),
        .immediate_output(immediate_output)
    );

    initial begin
        $display("=== STARTING IMMEDIATE GENERATOR VERIFICATION ===");

        // ----------------------------------------------------
        // TEST 1: I-Type Instruction (ImmSrc = 2'b00)
        // Example: lw x1, -4(x2) -> Instruction: 0xFFC12083
        // Expected Imm: 12'hFFC sign-extended -> 0xFFFFFFFC (-4)
        // ----------------------------------------------------
        instruction = 32'hFFC12083; 
        ImmSrc = 2'b00;
        #5;
        if (immediate_output === 32'hFFFFFFFC)
            $display("Time: %0t | >>> TEST 1 (I-Type) PASSED: Got 0x%h", $time, immediate_output);
        else
            $display("Time: %0t | >>> TEST 1 (I-Type) FAILED ❌: Expected 0xFFFFFFFC, Got 0x%h", $time, immediate_output);

        // ----------------------------------------------------
        // TEST 2: S-Type Instruction (ImmSrc = 2'b01)
        // Example: sw x1, 4(x2)  -> Instruction: 0x00112223
        // imm[11:5] = 7'b0000000, imm[4:0] = 5'b00100 -> Total Imm: 12'h004
        // Expected Imm: 32'h00000004 (+4)
        // ----------------------------------------------------
        instruction = 32'h00112223;
        ImmSrc = 2'b01;
        #5;
        if (immediate_output === 32'h00000004)
            $display("Time: %0t | >>> TEST 2 (S-Type) PASSED: Got 0x%h", $time, immediate_output);
        else
            $display("Time: %0t | >>> TEST 2 (S-Type) FAILED ❌: Expected 0x00000004, Got 0x%h", $time, immediate_output);

        // ----------------------------------------------------
        // TEST 3: B-Type Instruction (ImmSrc = 2'b10)
        // Example: beq x0, x0, -12 -> Instruction: 0xFE000AE3
        // Expected Imm: 32'hFFFFFFF4 (-12)
        // ----------------------------------------------------
        instruction = 32'hFE000AE3;
        ImmSrc = 2'b10;
        #5;
        if (immediate_output === 32'hFFFFFFF4)
            $display("Time: %0t | >>> TEST 3 (B-Type) PASSED: Got 0x%h", $time, immediate_output);
        else
            $display("Time: %0t | >>> TEST 3 (B-Type) FAILED ❌: Expected 0xF5FFFFFF4, Got 0x%h", $time, immediate_output);

        // ----------------------------------------------------
        // TEST 4: J-Type Instruction (ImmSrc = 2'b11)
        // Example: jal x3, 12 -> Instruction: 0x00C001EF
        // Expected Imm: 32'h0000000C (+12)
        // ----------------------------------------------------
        instruction = 32'h00C001EF;
        ImmSrc = 2'b11;
        #5;
        if (immediate_output === 32'h0000000C)
            $display("Time: %0t | >>> TEST 4 (J-Type) PASSED: Got 0x%h", $time, immediate_output);
        else
            $display("Time: %0t | >>> TEST 4 (J-Type) FAILED ❌: Expected 0x0000000C, Got 0x%h", $time, immediate_output);

        // ----------------------------------------------------
        // TEST 5: Default Case / Undefined Driver Check
        // If ImmSrc goes out of bounds, output should clear to 0
        // ----------------------------------------------------
        ImmSrc = 2'b10; // setting random baseline
        #1;
        ImmSrc = 2'bXX; // Force invalid selection state
        #5;
        if (immediate_output === 32'b0)
            $display("Time: %0t | >>> TEST 5 (Default/Safe) PASSED: Got 0x%h", $time, immediate_output);
        else
            $display("Time: %0t | >>> TEST 5 (Default/Safe) FAILED ❌: Expected 0x00000000, Got 0x%h", $time, immediate_output);

        $display("=== VERIFICATION COMPLETE ===");
        $finish;
    end

endmodule