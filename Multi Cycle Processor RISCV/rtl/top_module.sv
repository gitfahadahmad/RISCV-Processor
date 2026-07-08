`timescale 1ns / 1ps

module top_module(
input clk,
input rst

    );

     
    wire WE;              // Write Enable in memory
    wire [31:0] A;        // Address (driven by ALUResult) of memory
    wire [31:0] WD;       // Write Data on the memory
    wire [31:0] RD;   // Read Data
    wire PCWrite; //PC WRITE ENABLE FROM THE CONTROL UNIT
    wire [31:0]PC_reg_out; // output of the PC internal register
    wire [31:0]PC_reg_in; // input of the PC internal register
    wire [31:0]pc_to_instr_data_mem;
    wire AdrSrc;
    wire MemWrite; // write enable signsl for the instruction data memory
    wire [31:0]instr_data_mem_out; // output of instruction data memory 32 bit RD
    wire IRWrite; // control signal for storing the old pc and the instruction that is being fetched from the instruction data memory
    wire [31:0] old_pc_out; // output wire of the register to link it with the mux
    wire [31:0] instruction; // instruction wire to feed the instruction to different modules to perform the operations
    wire [31:0] read_data_out; // data out of the read data register to result mux
    wire [31:0] reg_file_data_1; // reg file source A address wire
    wire [31:0] reg_file_data_2; // reg file source B address wire
    wire RegWrite; // register file write enable signal
    wire [1:0] ImmSrc; // control signal for the Extend(immediate) block 
    wire [31:0] ImmExt_out; // output of the immediate extend block to feed the mux of the alu
    wire [31:0] RD1_out;
    wire [31:0] RD2_out;
    wire [31:0]mux_Src_A_out;
    wire [1:0] ALUSrcA;
    wire [31:0]mux_Src_B_out;
    wire [1:0] ALUSrcB;   
    
    wire [2:0]ALUControl;
    wire [31:0]ALUResult;
    wire Zero;
    wire [31:0] ALUOut; 
    wire [31:0]Result_mux_alu_out;
    wire [1:0]ResultSrc; 
    
    
// Instentiating the program counter PC
internal_reg internal_register_PC(
.clk(clk),
.rst(rst),
.EN(PCWrite),
.RD(Result_mux_alu_out), //input data in pc from the result mux
.out(PC_reg_out)); // data out from the pc to mux

//instentiating the mux 1 which takes the input from the PC and give out to the Instruction / Data Memory
 mux_2x1 pc_mux(
.out(pc_to_instr_data_mem),
.s(AdrSrc),
.x(PC_reg_out), // if AdrSrc = 0 // output from the pc register
.y(Result_mux_alu_out) // if AdrSrc = 1 output from the result mux
);

//instentiating the instruction data memory which takes the pc address 32 bits as input and performs the read or write data operations on the nen write signal 
instr_data_mem instruction_data_memory(
.clk(clk),
.A(pc_to_instr_data_mem),    
.WD(RD2_out),   // write 32 bits data coming from the register file // RD2_out is the out of the intermediate register RD2
.WE(MemWrite),  // write enable signal  
.RD(instr_data_mem_out)); //data out port 32 bits to read data from the instruction data memory

//instentiating the register for old pc storing 
internal_reg old_pc_storing(
.clk(clk),
.rst(rst),
.EN(IRWrite), // enable signal
.RD(PC_reg_out), // input is the PC_reg_out to store the pc
.out(old_pc_out)); //output is the 32 bit old pc out

// instentiating the register to store the instruction fetched from the instruction data memory
internal_reg instruction_register(
.clk(clk),
.rst(rst),
.EN(IRWrite), // enable signal
.RD(instr_data_mem_out), //input is the instr_data_mem_out that is fetched from the instruction data memory
.out(instruction));// output is 32 bit instruction that is being used for performing different opperations

//register to store the read data instruction for multiple use
internal_reg read_data(
.clk(clk),
.rst(rst),
.EN(1'b1),
.RD(instr_data_mem_out), // input from the instruction data memory
.out(read_data_out)); // output to the result multiplexer

// register files 
REG_FILE register_file(
.A1(instruction[19:15]), //A1 source 1 address
.A2(instruction[24:20]), //A2 source 2 address
.A3(instruction[11:7]), //A3 // address to write data
.WD3(Result_mux_alu_out), // wd3 // output coming from the result mux
.RD1(reg_file_data_1), // rd1 // reg_file_data_1 is the address of the source A
.RD2(reg_file_data_2), // rd2  // reg_file_data_2 is the address of the source B
.WE3(RegWrite), // we3 // register write enable signal for the register file
.clock(clk),
.reset(rst)
    );

// immediate generator
imm_Gen extend_block(
.instruction(instruction), //instruction 32 bits used to fetch the immediate based on the types of the instruction
.ImmSrc(ImmSrc),     // it is a two bit control signal for the immediate extend control logic from the ALU to process based on instruction types     
.immediate_output(ImmExt_out) // output of the immediate extend block
);    

// intermediate register for A(RD1)  
internal_reg internal_register_RD1(
.clk(clk),
.rst(rst),
.EN(1'b1),
.RD(reg_file_data_1), //INPUT IS THE RD1 OF THE REGISTER FILE
.out(RD1_out)); // rd1 out to the mux

// intermediate register for B(RD2)
internal_reg internal_register_RD2(
.clk(clk),
.rst(rst),
.EN(1'b1),
.RD(reg_file_data_2), // INPUT IS THE REGISTER FILE OF THE RD2
.out(RD2_out)); // Rd2 out to mux and also to the instruction data memory WD


// mux 3 to 1 for the PC, OLD PC and the RD1 descision
mux_3x1 mux_Src_A(
.out(mux_Src_A_out),
.s(ALUSrcA),
.d0(PC_reg_out), // pc out
.d1(old_pc_out), // old pc 
.d2(RD1_out) // A(RD1)
);

// mux 3 to 1 for RD2, IMM_EXTEND, and the +4 
mux_3x1 mux_Src_B(
.out(mux_Src_B_out),
.s(ALUSrcB),
.d0(RD2_out), // rd2(B)
.d1(ImmExt_out), // immediate out 
.d2(32'd4) // +4
);


//ALU BLOCK
ALU ALU_unit(
.SrcA(mux_Src_A_out), //Data from the mux src a
.SrcB(mux_Src_B_out), // Data from the mux src b
.ALUControl(ALUControl), // 3 bit signal from the control unit to check for which function to perform on the address values
.ALUResult(ALUResult), // it is the ALU ALUResult that is being fed to data memory for reading or writing data, or for storing the address to register file
.zero_flag(Zero) // zero flag to check for the equal statement later
);

internal_reg internal_register_Alu_out(
.clk(clk),
.rst(rst),
.EN(1'b1),
.RD(ALUResult),//input from the ALU Result
.out(ALUOut));// output to the reult mux

// mux 3 to 1 for alu out , and the read_data register
mux_3x1 mux_ALUOut(
.out(Result_mux_alu_out),
.s(ResultSrc),
.d0(ALUOut), // ALUOut for multiple use
.d1(read_data_out), // read_data_register output for multiple use
.d2(ALUResult) //  for multipe use ALUResult
);

//Control UNit instance which have all the modules Main Fsm and the ALU CONTROL UNIT AND THE IMMSRC GEN
Control_Unit control_unit(
.CLK(clk) ,
.rst(rst) ,
.Instr(instr_data_mem_out) , // feeding the 32 bit instruction
.Zero(Zero) ,
.PCWrite(PCWrite) ,
.AdrSrc(AdrSrc) ,
.MemWrite(MemWrite) ,
.IRWrite(IRWrite) ,
.RegWrite(RegWrite) ,   
.ResultSrc(ResultSrc) ,
.ALUControl(ALUControl) ,
.ALUSrcB(ALUSrcB) ,
.ALUSrcA(ALUSrcA) ,
.ImmSrc(ImmSrc) 
);
    
    
    
endmodule
