module Extend_tb;

 logic [31:0] Instruction;
 logic [1:0] ImmSrc;
 logic [31:0] ImmExt;

 Extend uut (.Instruction(Instruction),.ImmSrc(ImmSrc), .ImmExt(ImmExt));
 
 initial begin
  $monitor("Time: %0d | ImmSrc = %h | Instruction = %h | ImmExt = %h ",
         $time, ImmSrc, Instruction, ImmExt);
         
 ImmSrc = 00; //I type
 Instruction = 32'h12345678;
 #10; 

 ImmSrc = 01; //S type
 Instruction = 32'h12345678;
 #10; 
 
 ImmSrc = 10; //B type
 Instruction = 32'h12345678;
 #10; 
 
  ImmSrc = 11; //J type
 Instruction = 32'h12345678;
 #10;  
ImmSrc = 2'b00; // I type
  Instruction = 32'hDEADBEEF; 
  #10; 

  ImmSrc = 2'b01; // S type
  Instruction = 32'hDEADBEEF;
  #10; 
 
  ImmSrc = 2'b10; // B type
  Instruction = 32'hDEADBEEF;
  #10; 
 
  ImmSrc = 2'b11; // J type
  Instruction = 32'hDEADBEEF;
  #10;
 
 $finish;
 
 end
endmodule