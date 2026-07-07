module ALU_tb();

 logic [31:0] SrcA,SrcB;
 logic [2:0]ALUControl;
 logic [31:0] ALUResult;
 logic Zero;

ALU uut (SrcA, SrcB, ALUControl, ALUResult, Zero);

initial begin
    ALUControl = 000;//add
    SrcA = 32'h00000000;
    SrcB = 32'h00000001;
    #10;
    
    ALUControl = 001;//Sub
    #10;
    ALUControl = 101;//slt
    #10;
    ALUControl = 011;//or
    #10;    
    ALUControl = 010;//and
    #10;
$finish;
end

endmodule