
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