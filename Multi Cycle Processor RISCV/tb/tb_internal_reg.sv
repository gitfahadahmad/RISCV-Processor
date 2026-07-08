`timescale 1ns / 1ps

module internal_reg_tb;

    // Inputs
    reg clk;
    reg rst;
    reg EN;
    reg [31:0] RD;

    // Outputs
    wire [31:0] out;

    // Instantiate the Unit Under Test (UUT)
    internal_reg uut (
        .clk(clk), 
        .rst(rst), 
        .EN(EN), 
        .RD(RD), 
        .out(out)
    );

    // Clock generation (100 MHz -> 10ns period)
    always begin
        #5 clk = ~clk;
    end // <-- Fixed the syntax error here

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 0;
        EN = 0;
        RD = 32'b0;

        // 1. Test Asynchronous Reset
        #10 rst = 1;
        #15 rst = 0; // De-assert reset after 15ns
        
        // 2. Test EN = 0 (Data should NOT be loaded)
        @(posedge clk);
        RD = 32'hDEADBEEF;
        EN = 0;
        
        // 3. Test EN = 1 (Data should load on next posedge)
        @(posedge clk);
        #1; // Small delay after clock edge to mimic setup/hold
        EN = 1;
        RD = 32'hA5A5A5A5;
        
        @(posedge clk);
        #1;
        RD = 32'h12345678; // Change data while EN is still 1
        
        // 4. Test Hold Value (EN drops to 0, data changes, output should stay 0x12345678)
        @(posedge clk);
        #1;
        EN = 0;
        RD = 32'hFFFFFFFF; 
        
        // 5. Test Mid-operation Async Reset
        #15;
        rst = 1; // Assert reset asynchronously 
        #10;
        rst = 0;

        // End simulation
        #20;
        $display("Simulation complete.");
        $finish;
    end
      
    // Monitor changes in the console
    initial begin
        $monitor("Time=%0t | rst=%b | EN=%b | RD=%h | out=%h", $time, rst, EN, RD, out);
    end

endmodule