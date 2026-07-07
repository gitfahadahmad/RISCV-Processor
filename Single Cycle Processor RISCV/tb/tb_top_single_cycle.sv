
`timescale 1ns / 1ps

module tb_top;

logic clk;
logic rst;

top dut (.clk(clk), .rst(rst));

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1;
    #15; 
    rst = 0;
    
    $display("=================================================");
    $display("Starting Single Cycle RISC-V Verification Test");
    $display("=================================================");
    $display("Time\tPC\t\tInstr\t\tALU_Result\tReadData");
end

always @(posedge clk) begin
    if (!rst) begin
        $display("%0t\t%h\t%h\t%h\t%h", 
                 $time, dut.PC, dut.Instr, dut.ALUResult, dut.ReadData);
                 
        // If PC reaches 0x34, our program successfully finished
        if (dut.PC == 32'h00000034) begin
            $display("\n=================================================");
            $display("Program reached End Loop. Verifying Registers...");
            $display("=================================================");
            
            // Checking all final register values directly from the Register File
            $display("x1  (addi) : Expected = 0000000f, Actual = %h", dut.RF.memory[1]);
            $display("x2  (addi) : Expected = 0000000a, Actual = %h", dut.RF.memory[2]);
            $display("x3  (add)  : Expected = 00000019, Actual = %h", dut.RF.memory[3]);
            $display("x4  (sub)  : Expected = 00000005, Actual = %h", dut.RF.memory[4]);
            $display("x5  (and)  : Expected = 0000000a, Actual = %h", dut.RF.memory[5]);
            $display("x6  (or)   : Expected = 0000000f, Actual = %h", dut.RF.memory[6]);
            $display("x7  (slt)  : Expected = 00000001, Actual = %h", dut.RF.memory[7]);
            $display("x8  (lw)   : Expected = 00000019, Actual = %h", dut.RF.memory[8]);
            $display("x9  (trap) : Expected = 00000000, Actual = %h", dut.RF.memory[9]);
            $display("x10 (jal)  : Expected = 00000030, Actual = %h", dut.RF.memory[10]);
            
            $display("\n=================================================");
            // Final Boolean Check
            if (dut.RF.memory[1] == 15 &&
                dut.RF.memory[2] == 10 &&
                dut.RF.memory[3] == 25 &&
                dut.RF.memory[4] == 5  &&
                dut.RF.memory[5] == 10 &&
                dut.RF.memory[6] == 15 &&
                dut.RF.memory[7] == 1  &&
                dut.RF.memory[8] == 25 &&
                dut.RF.memory[9] == 0  &&
                dut.RF.memory[10] == 48) begin
                $display(">>> ALL TESTS PASSED SUCCESSFULLY! <<<");
            end else begin
                $display(">>> ERROR: ONE OR MORE TESTS FAILED! <<<");
            end
            $display("=================================================\n");
            
            $finish; // Stop simulation automatically
        end
    end
end

// Failsafe timeout to prevent true infinite loops in simulation if something breaks
initial begin
    #1000;
    $display("\nTIMEOUT: Simulation ran out of time! Check your branches/jumps.");
    $finish;
end

endmodule