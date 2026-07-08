`timescale 1ns / 1ps

module ALU_tb;

    // Testbench Signals
    reg  [31:0] SrcA;
    reg  [31:0] SrcB;
    reg  [2:0]  ALUControl;
    
    wire [31:0] ALUResult;
    wire        zero_flag;

    // Instantiate the Unit Under Test (UUT)
    ALU uut (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .zero_flag(zero_flag)
    );

    initial begin
        $display("=== STARTING ALU MODULE VERIFICATION ===");

        // ----------------------------------------------------
        // TEST 1: ADD Operation (3'b000)
        // 15 + 25 = 40 (0x28), zero_flag should be 0
        // ----------------------------------------------------
        SrcA = 32'd15;
        SrcB = 32'd25;
        ALUControl = 3'b000;
        #10;
        if (ALUResult === 32'd40 && zero_flag === 1'b0)
            $display("Time: %0t | >>> TEST 1 (ADD) PASSED: 15 + 25 = %d (Zero=%b)", $time, ALUResult, zero_flag);
        else
            $display("Time: %0t | >>> TEST 1 (ADD) FAILED ❌: Got %d (Zero=%b)", $time, ALUResult, zero_flag);

        // ----------------------------------------------------
        // TEST 2: SUB Operation & Zero Flag Check (3'b001)
        // 50 - 50 = 0, zero_flag should assert to 1
        // ----------------------------------------------------
        SrcA = 32'd50;
        SrcB = 32'd50;
        ALUControl = 3'b001;
        #10;
        if (ALUResult === 32'd0 && zero_flag === 1'b1)
            $display("Time: %0t | >>> TEST 2 (SUB/ZERO) PASSED: 50 - 50 = %d (Zero=%b)", $time, ALUResult, zero_flag);
        else
            $display("Time: %0t | >>> TEST 2 (SUB/ZERO) FAILED ❌: Got %d (Zero=%b)", $time, ALUResult, zero_flag);

        // ----------------------------------------------------
        // TEST 3: Bitwise AND Operation (3'b010)
        // 0x0F0F0F0F & 0xFFFF0000 = 0x0F0F0000
        // ----------------------------------------------------
        SrcA = 32'h0F0F0F0F;
        SrcB = 32'hFFFF0000;
        ALUControl = 3'b010;
        #10;
        if (ALUResult === 32'h0F0F0000)
            $display("Time: %0t | >>> TEST 3 (AND) PASSED: Got 0x%h", $time, ALUResult);
        else
            $display("Time: %0t | >>> TEST 3 (AND) FAILED ❌: Expected 0x0F0F0000, Got 0x%h", $time, ALUResult);

        // ----------------------------------------------------
        // TEST 4: Bitwise OR Operation (3'b011)
        // 0x55555555 | 0xAAAAAAAA = 0xFFFFFFFF
        // ----------------------------------------------------
        SrcA = 32'h55555555;
        SrcB = 32'hAAAAAAAA;
        ALUControl = 3'b011;
        #10;
        if (ALUResult === 32'hFFFFFFFF)
            $display("Time: %0t | >>> TEST 4 (OR) PASSED: Got 0x%h", $time, ALUResult);
        else
            $display("Time: %0t | >>> TEST 4 (OR) FAILED ❌: Expected 0xFFFFFFFF, Got 0x%h", $time, ALUResult);

        // ----------------------------------------------------
        // TEST 5: Bitwise XOR Operation (3'b100)
        // 0x12345678 ^ 0x12345678 = 0x00000000 (Should trigger Zero Flag)
        // ----------------------------------------------------
        SrcA = 32'h12345678;
        SrcB = 32'h12345678;
        ALUControl = 3'b100;
        #10;
        if (ALUResult === 32'h00000000 && zero_flag === 1'b1)
            $display("Time: %0t | >>> TEST 5 (XOR) PASSED: Identical inputs xor'd to 0x%h (Zero=%b)", $time, ALUResult, zero_flag);
        else
            $display("Time: %0t | >>> TEST 5 (XOR) FAILED ❌: Got 0x%h (Zero=%b)", $time, ALUResult, zero_flag);

        // ----------------------------------------------------
        // TEST 6: Shift Left Logical - SLL (3'b101)
        // 0x00000001 << 4 = 0x00000010
        // ----------------------------------------------------
        SrcA = 32'h00000001;
        SrcB = 32'd4; // Shift amount
        ALUControl = 3'b101;
        #10;
        if (ALUResult === 32'h00000010)
            $display("Time: %0t | >>> TEST 6 (SLL) PASSED: 1 << 4 = 0x%h", $time, ALUResult);
        else
            $display("Time: %0t | >>> TEST 6 (SLL) FAILED ❌: Expected 0x00000010, Got 0x%h", $time, ALUResult);

        // ----------------------------------------------------
        // TEST 7: Shift Right Logical - SRL (3'b110)
        // 0x00000010 >> 4 = 0x00000001
        // ----------------------------------------------------
        SrcA = 32'h00000010;
        SrcB = 32'd4; 
        ALUControl = 3'b110;
        #10;
        if (ALUResult === 32'h00000001)
            $display("Time: %0t | >>> TEST 7 (SRL) PASSED: 0x10 >> 4 = 0x%h", $time, ALUResult);
        else
            $display("Time: %0t | >>> TEST 7 (SRL) FAILED ❌: Expected 0x00000001, Got 0x%h", $time, ALUResult);

        // ----------------------------------------------------
        // TEST 8: Default/Invalid Opcodes Protection Check
        // Undefined ALUControl should cleanly clear the outcome bus to 0
        // ----------------------------------------------------
        SrcA = 32'hFFFF_FFFF;
        SrcB = 32'hFFFF_FFFF;
        ALUControl = 3'b111; // Out of range function code
        #10;
        if (ALUResult === 32'd0 && zero_flag === 1'b1)
            $display("Time: %0t | >>> TEST 8 (Default Fallback) PASSED: Outputs safely zeroed out.", $time);
        else
            $display("Time: %0t | >>> TEST 8 (Default Fallback) FAILED ❌: Got 0x%h (Zero=%b)", $time, ALUResult, zero_flag);

        $display("=== VERIFICATION COMPLETE ===");
        $finish;
    end

endmodule