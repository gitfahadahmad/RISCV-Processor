`timescale 1ns / 1ps

module Control_Unit(
    input logic CLK,
    input logic rst,
    input logic [31:0] Instr,
    input logic Zero,
    
    output logic PCWrite,
    output logic AdrSrc,
    output logic MemWrite,
    output logic IRWrite,
    output logic RegWrite,
    
    output logic [1:0] ResultSrc,
    output logic [2:0] ALUControl,
    output logic [1:0] ALUSrcB,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ImmSrc 
);

    // Internal wires connecting the Main FSM to the ALU Decoder
    logic [1:0] ALUOp;
    logic Branch;
    logic PCUpdate;

    // --- Low-Level View Logic Gates ---
    // PCWrite gate logic: PCWrite = (Branch & Zero) | PCUpdate
    assign PCWrite = (Branch & Zero) | PCUpdate;

    // --- Submodule Instantiations ---

    // 1. Main FSM
    main_FSM main_fsm_inst (
        .CLK(CLK),
        .rst(rst),
        .op(Instr[6:0]),          // op6:0 from Instr
        .Branch(Branch),
        .PCUpdate(PCUpdate),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),  
        .ResultSrc(ResultSrc),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .AdrSrc(AdrSrc),
        .ALUOp(ALUOp)
    );

    // 2. ALU Decoder
    ALU_Control alu_decoder_inst (
        .ALUOp(ALUOp),
        .func3(Instr[14:12]),     // funct3 from Instr
        .func7_5(Instr[30]),      // funct7_5 from Instr
        .op5(Instr[5]),           // op5 required by your ALU_Control module
        .ALUControl(ALUControl)
    );

    // 3. Instruction/Immediate Decoder
    always @ (*) begin
    case (Instr[6:0])
    7'd3: ImmSrc = 2'b00;
    7'd35: ImmSrc = 2'b01;
    7'd51: ImmSrc = 2'bxx;
    7'd99: ImmSrc = 2'b10;
    7'd111: ImmSrc = 2'b11;
    default: ImmSrc = 2'bxx;
    endcase 
    end

endmodule


module main_FSM(
    input logic CLK,
    input logic rst,
    input logic [6:0] op,
    
    output logic       Branch,
    output logic       PCUpdate,
    output logic       RegWrite,
    output logic       MemWrite,
    output logic       IRWrite,  
      
    output logic [1:0] ResultSrc,
    output logic [1:0] ALUSrcA,
    output logic [1:0] ALUSrcB,

    output logic       AdrSrc,
    
    output logic [1:0] ALUOp
);

    // State encoding
    parameter S0 = 4'b0000, //FETCH
              S1 = 4'b0001, // DECODE
              S2 = 4'b0010, //MEMADR
              S3 = 4'b0011, //MEMREAD
              S4 = 4'b0100, //MEMWB
              S5 = 4'b0101, //MEMWRITE
              S6 = 4'b0110, //EXECUTE R
              S7 = 4'b0111, //ALUWB
              S8 = 4'b1000, //EXECUTE I
              S9 = 4'b1001, //JAL
              S10 = 4'b1010;//BEQ



  logic [3:0] state, next_state;

    // State register
    always @(posedge CLK or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state) //STATE TRANSITION LOGIC
            S0: next_state = S1;
            S1: begin
                    case (op) //moving from s1 decode to the other states on the base of opcode
                        7'b0000011, 7'b0100011: next_state = S2;// s1 decode to s2 memadress state s2 for lw and sw 
                        7'b0110011:             next_state = S6; // if opcode is R type we move from the S1 Decode TO S6 Execute R state
                        7'b0010011:             next_state = S8; // if opcode is I type instruction S1: Decode to S8: Execute I 
                        7'b1101111:             next_state = S9; // if opcode is J type instruction S1: Decode to S9: JAL 
                        7'b1100011:             next_state = S10; // if opcode is B type instruction S1: Decode to S10: BEQ
                        default:                next_state = S0; // by default we  remain on the default state
                    endcase     
                end
            S2: begin 
                    case (op) //moving from the S2: MemAdr to other states on the base of opcode
                        7'b0000011: next_state = S3; // if opcode is I type lw we move from S2: MemAdr to S3: MemRead 
                        7'b0100011:             next_state = S5; // if opcode is S type sw we move from S2: MemAdr to S5: MemWrite
                        default:                next_state = S0; // by default we  remain on the default state
                    endcase                
                end
   
            S3: next_state = S4 ; // MEMREAD TO MEMWRITEBACK
            S4: next_state = S0; //MEMWB TO FETCH
            S5: next_state = S0; // MEMWRITE TO FETCH
   
            S6: next_state = S7; //EXECUTE R TO ALUWB
            S7: next_state = S0; //ALUWB TO FETCH
            S8: next_state = S7; // EXECUTE I TO ALUWB
            S9: next_state = S7; // JAL TO ALUWB

            S10: next_state = S0; //BEQ TO FETCH
            default: next_state = S0; // DEFAULT FETCH
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        
        //default values 
        Branch =    1'b0;
        PCUpdate =  1'b0;
        RegWrite =  1'b0;
        MemWrite =  1'b0;
        IRWrite =   1'b0;
        ResultSrc = 2'b00;
        ALUSrcB =   2'b00;
        ALUSrcA =   2'b00;
        AdrSrc =   1'b0;
        ALUOp =    2'b00;
        
        case (state)
        S0: begin  //FETCH
//                Branch =    1'b0;
                PCUpdate =  1'b1;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
                IRWrite =   1'b1;
                ResultSrc = 2'b10;
                ALUSrcB =   2'b10;
                ALUSrcA =   2'b00;
                AdrSrc =   1'b0;
                ALUOp =    2'b00;            
            end
            
        S1: begin //DECODE
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
//                ResultSrc = 2'bxx;
                ALUSrcB =   2'b01;
                ALUSrcA =   2'b01;
//                AdrSrc =   1'bx;
                ALUOp =    2'b00;                       
            end
        

        S2: begin //MEMADR
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
//                ResultSrc = 2'bxx;
                ALUSrcB =   2'b01;
                ALUSrcA =   2'b10;
//                AdrSrc =   1'bx;
                ALUOp =    2'b00;            
            end
            
        S3: begin // MemRead
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
                ResultSrc = 2'b00;
//                ALUSrcB =   2'bxx;
//                ALUSrcA =   2'bxx;
                AdrSrc =   1'b1;
//                ALUOp =    2'bxx;                       
            end


        S4: begin  //MemWB
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
                RegWrite =  1'b1;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
                ResultSrc = 2'b01;
//                ALUSrcB =   2'bxx;
//                ALUSrcA =   2'bxx;
//                AdrSrc =   1'bx;
//                ALUOp =    2'bxx;            
            end
       
        S5: begin //MemWrite
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
                MemWrite =  1'b1;
//                IRWrite =   1'b0;
                ResultSrc = 2'b00;
//                ALUSrcB =   2'bxx;
//                ALUSrcA =   2'bxx;
                AdrSrc =   1'b1;
//                ALUOp =    2'bxx;                       
            end

        S6: begin //Execute R
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
//                ResultSrc = 2'bxx;
                ALUSrcB =   2'b00;
                ALUSrcA =   2'b10;
//                AdrSrc =   1'bx;
                ALUOp =    2'b10;            
            end
        
        S7: begin //ALUWB
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
                RegWrite =  1'b1;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
                ResultSrc = 2'b00;
//                ALUSrcB =   2'bxx;
//                ALUSrcA =   2'bxx;
//                AdrSrc =   1'bx;
//                ALUOp =    2'bxx;                       
            end


        S8: begin // Execute I
//                Branch =    1'b0;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
//                ResultSrc = 2'bxx;
                ALUSrcB =   2'b01;
                ALUSrcA =   2'b10;
//                AdrSrc =   1'bx;
                ALUOp =    2'b10;            
            end
        
        S9: begin // JAL
//                Branch =    1'b0;
                PCUpdate =  1'b1;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
                ResultSrc = 2'b00;
                ALUSrcB =   2'b10;
                ALUSrcA =   2'b01;
//                AdrSrc =   1'bx;
                ALUOp =    2'b00;                       
            end

        S10: begin //Beq
                Branch =    1'b1;
//                PCUpdate =  1'b0;
//                RegWrite =  1'b0;
//                MemWrite =  1'b0;
//                IRWrite =   1'b0;
                ResultSrc = 2'b00;
                ALUSrcB =   2'b00;
                ALUSrcA =   2'b10;
//                AdrSrc =   1'bx;
                ALUOp =    2'b01;                       
            end
                
        default: begin 
                 Branch =    1'b0;
                 PCUpdate =  1'b0;
                 RegWrite =  1'b0;
                 MemWrite =  1'b0;
                 IRWrite =   1'b0;
                 ResultSrc = 2'b00;
                 ALUSrcB =   2'b00;
                 ALUSrcA =   2'b00;
                 AdrSrc =   1'b0;
                 ALUOp =    2'b00;               
                 end  
        endcase
    end

endmodule



module ALU_Control(
input logic [1:0] ALUOp,
input logic [2:0] func3,
input logic func7_5,
input logic op5,
output logic [2:0] ALUControl
);
    
       parameter ALU_ADD = 3'b000, 
                 ALU_SUB = 3'b001, 
                 ALU_AND = 3'b010, 
                 ALU_OR  = 3'b011, 
                 ALU_XOR = 3'b100, 
                 ALU_SLL = 3'b101, 
                 ALU_SRL = 3'b110;
 
     always_comb begin
         case (ALUOp)
             2'b00: ALUControl = ALU_ADD; 
             2'b01: ALUControl = ALU_SUB; 
             
             2'b10: begin
                 case (func3)
                     3'b000:  
                        begin 
                        if({op5, func7_5}  == 2'b11)
                            ALUControl = ALU_SUB;
                        else 
                            ALUControl = ALU_ADD;
                        end
                     3'b001:  ALUControl = ALU_SLL;                      
                     3'b100:  ALUControl = ALU_XOR;                      
                     3'b101:  ALUControl = ALU_SRL;                      
                     3'b110:  ALUControl = ALU_OR;                       
                     3'b111:  ALUControl = ALU_AND;                      
                     default: ALUControl = ALU_ADD;
                 endcase
             end
 
 
             default: ALUControl = ALU_ADD;
         endcase
     end
     
    
endmodule


