
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
