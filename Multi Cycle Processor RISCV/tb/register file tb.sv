`timescale 1ns/1ps

module REG_FILE_tb;

    // Testbench Signals
    reg  [4:0]  A1;
    reg  [4:0]  A2;
    reg  [4:0]  A3;
    reg  [31:0] WD3;
    reg         WE3;
    reg         clock;
    reg         reset;
    
    wire [31:0] RD1;
    wire [31:0] RD2;

    // Instantiate the Unit Under Test (UUT)
    REG_FILE uut (
        .A1(A1), 
        .A2(A2), 
        .A3(A3), 
        .WD3(WD3), 
        .RD1(RD1), 
        .RD2(RD2), 
        .WE3(WE3), 
        .clock(clock), 
        .reset(reset)
    );

    // Clock Generation (100 MHz -> 10ns period)
    always #5 clock = ~clock;

    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 0;
        A1 = 5'b0;
        A2 = 5'b0;
        A3 = 5'b0;
        WD3 = 32'b0;
        WE3 = 0;

        #10;
        $display("=== STARTING REGISTER FILE VERIFICATION ===");

        // ----------------------------------------------------
        // TEST 1: Asynchronous Reset Behavior
        // ----------------------------------------------------
        reset = 1;
        #12;          // Hold reset active across a clock edge
        reset = 0;
        
        // Read a couple of registers to check if they cleared to 0
        A1 = 5'd5; 
        A2 = 5'd10;
        #1;           // Small delay for combinational paths to settle
        if (RD1 === 32'b0 && RD2 === 32'b0)
            $display("Time: %0t | >>> TEST 1 PASSED: Reset cleared memory array.", $time);
        else
            $display("Time: %0t | >>> TEST 1 FAILED ❌: Expected 0, Got RD1=%h, RD2=%h", $time, RD1, RD2);

        // ----------------------------------------------------
        // TEST 2: Basic Synchronous Write & Combinational Read
        // ----------------------------------------------------
        @(posedge clock);
        #1;           // Small step past clock edge to avoid race conditions
        A3 = 5'd5;
        WD3 = 32'hAAAA_BBBB;
        WE3 = 1;      // Enable writing
        
        @(posedge clock); // Wait for the positive edge to latch data
        #1;
        WE3 = 0;      // Immediately disable write
        A1 = 5'd5;    // Point read port 1 to register 5
        #1;
        if (RD1 === 32'hAAAA_BBBB)
            $display("Time: %0t | >>> TEST 2 PASSED: Successfully wrote and read 0xAAAABBBB to Reg 5.", $time);
        else
            $display("Time: %0t | >>> TEST 2 FAILED ❌: Expected 0xAAAABBBB, Got 0x%h", $time, RD1);

        // ----------------------------------------------------
        // TEST 3: Hardwired Zero Protection (Register 0 Check)
        // ----------------------------------------------------
        @(posedge clock);
        #1;
        A3 = 5'd0;    // Target register 0
        WD3 = 32'hDEAD_BEEF;
        WE3 = 1;
        
        @(posedge clock);
        #1;
        WE3 = 0;
        A1 = 5'd0;    // Read back register 0
        #1;
        if (RD1 === 32'b0)
            $display("Time: %0t | >>> TEST 3 PASSED: Register 0 successfully blocked updates.", $time);
        else
            $display("Time: %0t | >>> TEST 3 FAILED ❌: Reg 0 was overwritten! Got 0x%h", $time, RD1);

        // ----------------------------------------------------
        // TEST 4: Write Enable (WE3 = 0) Gate Check
        // ----------------------------------------------------
        @(posedge clock);
        #1;
        A3 = 5'd12;
        WD3 = 32'h5555_6666;
        WE3 = 0;      // Disabled write enable!
        
        @(posedge clock);
        #1;
        A1 = 5'd12;
        #1;
        if (RD1 === 32'b0)
            $display("Time: %0t | >>> TEST 4 PASSED: WE3=0 successfully blocked the write attempt.", $time);
        else
            $display("Time: %0t | >>> TEST 4 FAILED ❌: Wrote data even though WE3 was low. Got 0x%h", $time, RD1);

        // ----------------------------------------------------
        // TEST 5: Dual Read Ports (Simultaneous Read)
        // ----------------------------------------------------
        // First, write valid data to register 20
        @(posedge clock);
        #1;
        A3 = 5'd20;
        WD3 = 32'h1234_5678;
        WE3 = 1;
        @(posedge clock);
        #1;
        WE3 = 0;
        
        // Now, read Reg 5 (contains 0xAAAABBBB) and Reg 20 simultaneously
        A1 = 5'd5;
        A2 = 5'd20;
        #1;
        if (RD1 === 32'hAAAA_BBBB && RD2 === 32'h1234_5678)
            $display("Time: %0t | >>> TEST 5 PASSED: Both read ports output valid parallel data.", $time);
        else
            $display("Time: %0t | >>> TEST 5 FAILED ❌: Dual read mismatch. RD1=%h, RD2=%h", $time, RD1, RD2);

        // ----------------------------------------------------
        $display("=== VERIFICATION COMPLETE ===");
        $finish;
    end

endmodule