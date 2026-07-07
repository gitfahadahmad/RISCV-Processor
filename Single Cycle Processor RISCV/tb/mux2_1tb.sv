module mux2_1tb;

//Wires defining
 logic s ;
 logic [31:0] x, y;
 logic [31:0] out;
 
 
 //instentiating the mux
  mux2_1 uut(.PCSrc(s), .PCPlus4(x), .PCTarget(y), .PCNext(out));

 initial begin
 
 s = 1'b1;
 x  = 32'hFFFFFFFF;
 y = 32'h11111111;
 
 #10;
 s = 1'b0;
 x  = 32'hFFFFFFFF;
 y = 32'h11111111;
 
 end

endmodule