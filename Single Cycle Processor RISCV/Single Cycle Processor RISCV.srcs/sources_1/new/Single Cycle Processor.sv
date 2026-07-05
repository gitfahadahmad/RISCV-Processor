`timescale 1ns / 1ps

module mux2_1(PCSrc, PCPlus4, PCTarget, PCNext);
//IO defining
input logic PCSrc;
input logic [31:0] PCPlus4, PCTarget;
output logic [31:0] PCNext;

//logic for the mux
assign PCNext = PCSrc ? PCTarget : PCPlus4;

endmodule

module mux3_1(a, b, c, sel, out);

input logic [31:0] a, b, c;
input logic [1:0] sel;
output logic [31:0] out;

always @(*)
    if(sel == 2'b00) begin
    assign out = a;
    end else if (sel == 2'b01) begin
    assign out = b;
    end else begin
    assign out = c;
    end
 
endmodule

module PC_Counter(clk, rst, PCNext, PC);

input logic clk, rst;
input logic [31:0] PCNext; //input wire
output logic [31:0] PC; // output wire

always @(posedge clk or posedge rst) begin

    if(rst) begin
        PC <= 32'b0;
    end
    else begin
        PC <= PCNext;
    end
end
endmodule

module adder32bit(a, b, sum);

input logic [31:0] a, b;
output logic [31:0] sum;

assign sum = a+b;

endmodule


//module instruction_memory(A, RD);
//input logic [31:0] A;
//output logic [31:0] RD;

//logic [7:0] memory [1023:0];

//initial begin
//// Instruction 0 (PC=0): addi x1, x0, 10
//memory[0] = 8'h93;
//memory[1] = 8'h00;
//memory[2] = 8'ha0;
//memory[3] = 8'h00;

//// Instruction 1 (PC=4): addi x2, x0, 20
//memory[4] = 8'h13;
//memory[5] = 8'h01;
//memory[6] = 8'h40;
//memory[7] = 8'h01;

//// Instruction 2 (PC=8): sw x2, 80(x1)
//memory[8]  = 8'h23;
//memory[9]  = 8'ha8;
//memory[10] = 8'h20;
//memory[11] = 8'h04;

//// Instruction 3 (PC=12): lw x4, 80(x1)
//memory[12] = 8'h03;
//memory[13] = 8'ha2;
//memory[14] = 8'h00;
//memory[15] = 8'h05;

//// Instruction 4 (PC=16): beq x4, x2, offset +8
//// If x4 == x2, it jumps to PC=24 (label)
//memory[16] = 8'h63;
//memory[17] = 8'h04;
//memory[18] = 8'h22;
//memory[19] = 8'h00;

//// Instruction 5 (PC=20): addi x5, x4, 50
//// Executes only if the branch above is NOT taken
//memory[20] = 8'h93;
//memory[21] = 8'h02;
//memory[22] = 8'h22;
//memory[23] = 8'h03;

//// Instruction 6 (PC=24): addi x5, x4, 400
//// Branch target (label)
//memory[24] = 8'h93;
//memory[25] = 8'h02;
//memory[26] = 8'h02;
//memory[27] = 8'h19;

//// Instruction 7 (PC=28): jal x6, -12
//// Stores return address (PC+4 = 32) in x6 and jumps back to PC=16
//// (the beq instruction)
//memory[28] = 8'h6f;
//memory[29] = 8'hf3;
//memory[30] = 8'h5f;
//memory[31] = 8'hff;
//end

//assign RD = {memory[A+3], memory[A+2], memory[A+1], memory[A]};

//endmodule
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



module register_file(clk, rst, A1, A2, A3, WD3,WE3, RD1, RD2);

input logic clk, WE3, rst;
input logic [4:0] A1, A2, A3;
input logic [31:0] WD3;
output logic [31:0] RD1, RD2;

logic [31:0] memory [31:0];
integer i;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        for (i = 0; i<=31; i=i+1) begin
        memory[i] <= 32'd0;
        end
    end
    else if (WE3 && (A3 != 0)) memory[A3] <= WD3;
 end

assign  RD1 = memory[A1];
assign  RD2 = memory[A2];

endmodule

module Extend(Instruction,ImmSrc, ImmExt);

input logic [31:0] Instruction;
input logic [1:0] ImmSrc;
output logic [31:0] ImmExt;

logic [31:0] Itype_imm, Stype_imm, Btype_imm, Utype_imm, Jtype_imm;

assign Itype_imm = {{20{Instruction[31]}},Instruction[31:20]}; //I type 
assign Stype_imm = {{20{Instruction[31]}},Instruction[31:25], Instruction[11:7]}; //S type 
assign Btype_imm = {{20{Instruction[31]}}, Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};// b type
assign Jtype_imm = {{12{Instruction[31]}},Instruction[19:12], Instruction[20] ,Instruction[30:21], 1'b0}; //J type 

always @(*) begin
case(ImmSrc)
        2'b00: ImmExt = Itype_imm;
        2'b01: ImmExt = Stype_imm;
        2'b10: ImmExt = Btype_imm;
        2'b11: ImmExt = Jtype_imm;
        default: ImmExt = 32'b0;

endcase
end

endmodule

module ALU(SrcA, SrcB, ALUControl, ALUResult, Zero);

input logic [31:0] SrcA,SrcB;
input logic [2:0]ALUControl;
output logic [31:0] ALUResult;
output logic Zero;

always @(*) begin
    case(ALUControl)
        3'b000: ALUResult = SrcA + SrcB; //add
        3'b001: ALUResult = SrcA - SrcB; //Sub
        3'b010: ALUResult = SrcA & SrcB; //and
        3'b011: ALUResult = SrcA | SrcB; //or
//        3'b100: ALUResult = SrcA + SrcB //add
        3'b101: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;  //set less then slt
        default: ALUResult = 32'b0; 
    endcase
    
    Zero = (ALUResult == 32'b0) ? 1'b1: 1'b0;
end

endmodule


module data_memory(A, WD, clk,rst, WE, RD);

input logic [31:0] A, WD;
input logic clk, rst, WE;
output logic [31:0] RD;

logic [7:0] memory [1023:0];
integer i;
always @ (posedge clk or posedge rst) begin
    if (rst) begin
    for(i = 0; i<=1023; i = i+1)
    memory[i] <= 8'b0;
    end
    else if (WE) begin
     memory[A]     <= WD[7:0];
     memory[A + 1] <= WD[15:8];
     memory[A + 2] <= WD[23:16];
     memory[A + 3] <= WD[31:24];
    end
    else begin
        for(i = 0; i<=1023; i = i+1)
        memory[i] <= 8'b0;
    end 
end

always @(*) begin

    RD[7:0] <= memory[A];
    RD[15:8] <= memory[A+1];
    RD[23:16] <= memory[A+2];
    RD[31:24] <= memory[A+3];
end
endmodule


module main_decoder(op, ResultSrc, ImmSrc, ALUOp, MemWrite, ALUSrc, RegWrite, Branch, Jump);

input logic [6:0] op;
output logic [1:0] ResultSrc, ImmSrc, ALUOp;
output logic MemWrite, ALUSrc, RegWrite, Branch, Jump;

always @(*) begin
case(op)
//lw opcode 0000011
7'b0000011 : begin 
          RegWrite <= 1'b1;
          ImmSrc <= 2'b00 ;
          ALUSrc <= 1'b1;
          MemWrite <= 1'b0;
          ResultSrc <= 2'b01;
          Branch <= 1'b0;
          ALUOp  <= 2'b00; 
          Jump <= 1'b0;
end

//sw opcode 0100011
7'b0100011 : begin 
          RegWrite <= 1'b0;
          ImmSrc <= 2'b01 ;
          ALUSrc <= 1'b1;
          MemWrite <= 1'b1;
          ResultSrc <= 2'bxx;
          Branch <= 1'b0;
          ALUOp  <= 2'b00; 
          Jump <= 1'b0;
end

//R type opcode 0110011
7'b0110011 : begin 
          RegWrite <= 1'b1;
          ImmSrc <= 2'bxx ;
          ALUSrc <= 1'b0;
          MemWrite <= 1'b0;
          ResultSrc <= 2'b00;
          Branch <= 1'b0;
          ALUOp  <= 2'b10; 
          Jump <= 1'b0;
end

//beq opcode 1100011
7'b1100011 : begin 
          RegWrite <= 1'b0;
          ImmSrc <= 2'b10 ;
          ALUSrc <= 1'b0;
          MemWrite <= 1'b0;
          ResultSrc <= 2'bxx;
          Branch <= 1'b1;
          ALUOp  <= 2'b01; 
          Jump <= 1'b0;
end


//I type ALU opcode 0010011
7'b0010011 : begin 
          RegWrite <= 1'b1;
          ImmSrc <= 2'b00 ;
          ALUSrc <= 1'b1;
          MemWrite <= 1'b0;
          ResultSrc <= 2'b00;
          Branch <= 1'b0;
          ALUOp  <= 2'b10; 
          Jump <= 1'b0;
end


//jal opcode 1101111
7'b1101111 : begin 
          RegWrite <= 1'b1;
          ImmSrc <= 2'b11 ;
          ALUSrc <= 1'bx;
          MemWrite <= 1'b0;
          ResultSrc <= 2'b10;
          Branch <= 1'b0;
          ALUOp  <= 2'bxx; 
          Jump <= 1'b1;
end
default: begin
              RegWrite <= 1'b0;
              ImmSrc <= 2'b00;
              ALUSrc <= 1'b0;
              MemWrite <= 1'b0;
              ResultSrc <= 2'b00;
              Branch <= 1'b0;
              ALUOp  <= 2'b00; 
              Jump <= 1'b0;
    end

endcase
end
endmodule  

module ALUDecoder(op, funct3,funct7_5, ALUOp, ALUControl);

input logic [6:0] op;
input logic [2:0] funct3;
input logic  funct7_5;
input logic [1:0] ALUOp;
output logic [2:0] ALUControl;

always @(*) begin
    case(ALUOp) 
    2'b00 : ALUControl = 3'b000; //add for lw sw
    2'b01 : ALUControl = 3'b001; //sub for beq
    2'b10 : 
            case(funct3)
            3'b000: 
                if(op[5] && funct7_5)
                    ALUControl = 3'b001; //sub
                else ALUControl = 3'b000; // add
                
            3'b010 : ALUControl = 3'b101; //slt
            3'b110 : ALUControl = 3'b011; //or
            3'b111 : ALUControl = 3'b010; //and 
            default: ALUControl = 3'b000;               
            endcase
     default: ALUControl = 3'b000;
     endcase
end
endmodule


module Control_Unit(op, funct3, funct7_5, Zero, PCSrc, ALUControl, ResultSrc, ImmSrc,
MemWrite, ALUSrc, RegWrite);

input logic [6:0]op;
input logic [2:0] funct3;
input logic Zero;
input logic funct7_5;

output logic PCSrc;
output logic [2:0] ALUControl;
output logic [1:0] ResultSrc, ImmSrc; 
output logic MemWrite, ALUSrc, RegWrite;

logic Branch, Jump;
logic [1:0] ALUOp;


//MAIN DECODER 
main_decoder maindecoder1(.op(op), 
.ResultSrc(ResultSrc), .ImmSrc(ImmSrc), .ALUOp(ALUOp), .MemWrite(MemWrite), 
.ALUSrc(ALUSrc), .RegWrite(RegWrite), .Branch(Branch), .Jump(Jump));

//ALU DECODER
ALUDecoder aludecoder1(.op(op), .funct3(funct3),.funct7_5(funct7_5), 
.ALUOp(ALUOp), .ALUControl(ALUControl));

assign PCSrc = (Branch & Zero) | Jump;

endmodule


//TOP MODULE


module top(input logic clk, rst);

//Wires defining
logic PCSrc;
logic [31:0] PCPlus4, PCTarget;
logic [31:0] PCNext;
logic [31:0] PC; // output wire
logic [31:0] A;
logic [31:0] RD;
logic [31:0] Instr;
logic [6:0]op;
logic [2:0] funct3;
logic Zero;
logic funct7_5;
logic [2:0] ALUControl;
logic [1:0] ResultSrc, ImmSrc; 
logic MemWrite, ALUSrc, RegWrite;
logic WE3;
logic [4:0] A1, A2, A3;
logic [31:0] WD3;
logic [31:0] RD1, RD2;
logic [31:0] Instruction;
logic [31:0] ImmExt;
logic [31:0] SrcA,SrcB;
logic [31:0] ALUResult;
logic [31:0] WD;
logic [31:0] ReadData;
logic [31:0] Result;

//PC MUX
mux2_1 pcmux(PCSrc, PCPlus4, PCTarget, PCNext);

//PC Counter reg
PC_Counter PCCounterreg(clk, rst, PCNext, PC);

//Instruction Memory
instruction_memory im(.A(PC), .RD(Instr));

//PCPlus4 adder
adder32bit pcplus4(.a(PC), .b(32'd4), .sum(PCPlus4));

//PCTarget adder
adder32bit pctarget(.a(PC), .b(ImmExt), .sum(PCTarget));


// Control Unit
Control_Unit CU(.op(Instr[6:0]), .funct3(Instr[14:12]), .funct7_5(Instr[30]), 
.Zero(Zero), .PCSrc(PCSrc), .ALUControl(ALUControl), 
.ResultSrc(ResultSrc), .ImmSrc(ImmSrc),
.MemWrite(MemWrite), .ALUSrc(ALUSrc), .RegWrite(RegWrite));

//Register File
register_file RF(.clk(clk), .rst(rst), 
.A1(Instr[19:15]), .A2(Instr[24:20]), .A3(Instr[11:7]), 
.WD3(Result),.WE3(RegWrite), 
.RD1(SrcA), .RD2(RD2));

//Extend Block
Extend extend(.Instruction(Instr),.ImmSrc(ImmSrc), .ImmExt(ImmExt));

//ALU MUX
mux2_1 alumux(.PCSrc(ALUSrc), .PCPlus4(RD2), .PCTarget(ImmExt), .PCNext(SrcB));

//ALU 
 ALU aluunit(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .Zero(Zero));

// Data Memory
data_memory DM(.A(ALUResult), .WD(RD2), .clk(clk),.rst(rst), .WE(MemWrite), .RD(ReadData));

//result mux
mux3_1 result_mux(.a(ALUResult), .b(ReadData), .c(PCPlus4), .sel(ResultSrc), .out(Result));
endmodule