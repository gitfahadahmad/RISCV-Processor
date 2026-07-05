
//module mux2_1tb;

////Wires defining
// logic s ;
// logic [31:0] x, y;
// logic [31:0] out;
 
 
// //instentiating the mux
//  mux2_1 uut(.PCSrc(s), .PCPlus4(x), .PCTarget(y), .PCNext(out));

// initial begin
 
// s = 1'b1;
// x  = 32'hFFFFFFFF;
// y = 32'h11111111;
 
// #10;
// s = 1'b0;
// x  = 32'hFFFFFFFF;
// y = 32'h11111111;
 
// end

//endmodule


//module tb_pc();

//logic clk, rst;
//logic [31:0] PCNext, PC;

//PC_Counter uut (.clk(clk), .rst(rst), .PCNext(PCNext), .PC(PC));
//always  begin
//#5 clk = ~clk;
//end 

//initial begin
//$monitor("Time: %0d ns | clk: %b | rst: %b | PCNext:%h | PC: %h ", $time , clk , rst, PCNext, PC);

//    clk = 0;
//    rst = 1;
//    PCNext = 32'h11111111;
//    #10;
    
//    clk = 1;
//    rst = 0;
//    PCNext = 32'h11111111;
//    #10; 

//    PCNext = 32'hFFFFFFFF;
//    #10;     
//    $display("Simulation Ended Final PC = %h ", PC);
//    $finish;
//end
//endmodule


//module mux3_1_tb();

//logic [31:0] a, b, c, out;
//logic [1:0] sel;

//mux3_1 uut(.a(a), .b(b), .c(c), .sel(sel), .out(out));


//initial begin
//$monitor("Time: %0d | a = %h | b = %h | c = %h | sel = %h | out = %h",
//        $time, a, b, c, sel, out);

////test1
//sel = 2'b00;
//a = 32'h00000000;
//b = 32'h00000001;
//c = 32'h00000002;
//#10;
////test2
//sel = 2'b01;
//a = 32'h00000000;
//b = 32'h00000001;
//c = 32'h00000002;
//#10;
////test3
//sel = 2'b10;
//a = 32'h00000000;
//b = 32'h00000001;
//c = 32'h00000002;
//#10;

//$display("Simulation Ended: out = %h", out);
//$finish;
//end
//endmodule

//module instruction_memory_tb();

//logic [31:0] A;
//logic [31:0] RD;
//logic [7:0] memory [1023:0];

//instruction_memory uut (.A(A), .RD(RD));

//initial begin

//$monitor("Time: %0d | A = %h | RD = %h ",
//        $time, A, RD);


//A = 32'd0;
//#10;

//A = 32'd4;
//#10;

//A = 32'd8;
//#10;

//A = 32'd12;
//#10;

//A = 32'd16;
//#10;

//A = 32'd20;
//#10;

//A = 32'd24;
//#10;
 
//$display("Simulation Ended: RD = %h", RD);
//$finish;

//end


//endmodule

//module regfile_tb;
// logic clk, WE3, rst;
// logic [4:0] A1, A2, A3;
// logic [31:0] WD3;
// logic [31:0] RD1, RD2;

//register_file uut2(clk, rst, A1, A2, A3, WD3,WE3, RD1, RD2);
//always #5 clk = ~clk;

//initial begin
//clk = 1'b0;
//rst = 1;
//A1 = 5'd0;
//A2 = 5'd0;
//A3 = 5'd0;

//#10;
//rst = 0;
//WE3 = 1;
//A3 = 5'd4;
//WD3 = 32'h0000fff1;
//#20;

//WE3 = 0;
//A1 = 5'd4;
////#20;

////rst = 0;
////WE3 = 1;
////A3 = 5'd4;
////WD3 = 32'h0000fff1;
////#20;

//A2 = 5'd4;
//#10;

//$finish;
//end

//endmodule



//module Extend_tb;

// logic [31:0] Instruction;
// logic [1:0] ImmSrc;
// logic [31:0] ImmExt;

// Extend uut (.Instruction(Instruction),.ImmSrc(ImmSrc), .ImmExt(ImmExt));
 
// initial begin
//  $monitor("Time: %0d | ImmSrc = %h | Instruction = %h | ImmExt = %h ",
//         $time, ImmSrc, Instruction, ImmExt);
         
// ImmSrc = 00; //I type
// Instruction = 32'h12345678;
// #10; 

// ImmSrc = 01; //S type
// Instruction = 32'h12345678;
// #10; 
 
// ImmSrc = 10; //B type
// Instruction = 32'h12345678;
// #10; 
 
//  ImmSrc = 11; //J type
// Instruction = 32'h12345678;
// #10;  
//ImmSrc = 2'b00; // I type
//  Instruction = 32'hDEADBEEF; 
//  #10; 

//  ImmSrc = 2'b01; // S type
//  Instruction = 32'hDEADBEEF;
//  #10; 
 
//  ImmSrc = 2'b10; // B type
//  Instruction = 32'hDEADBEEF;
//  #10; 
 
//  ImmSrc = 2'b11; // J type
//  Instruction = 32'hDEADBEEF;
//  #10;
 
// $finish;
 
// end
//endmodule

//module ALU_tb();

// logic [31:0] SrcA,SrcB;
// logic [2:0]ALUControl;
// logic [31:0] ALUResult;
// logic Zero;

//ALU uut (SrcA, SrcB, ALUControl, ALUResult, Zero);

//initial begin
//    ALUControl = 000;//add
//    SrcA = 32'h00000000;
//    SrcB = 32'h00000001;
//    #10;
    
//    ALUControl = 001;//Sub
//    #10;
//    ALUControl = 101;//slt
//    #10;
//    ALUControl = 011;//or
//    #10;    
//    ALUControl = 010;//and
//    #10;
//$finish;
//end

//endmodule

//module data_memory_tb;

// logic [31:0] A, WD;
// logic clk, rst, WE;
// logic [31:0] RD;

//logic [7:0] memory [1023:0];

//data_memory uut (A, WD, clk,rst, WE, RD);

//always #5 clk <= ~clk;

//initial begin
//clk = 0;
//rst =1;
//#10;

//rst =0;
//A = 0;
//WE =1;
//WD = 32'h000000001;
//#10

//A = 0;
//WD = 32'h000000000;

//#100;
//$finish;
//end


//endmodule


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