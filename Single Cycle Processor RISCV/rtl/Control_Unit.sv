
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
