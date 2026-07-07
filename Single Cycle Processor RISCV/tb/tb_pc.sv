module tb_pc();

logic clk, rst;
logic [31:0] PCNext, PC;

PC_Counter uut (.clk(clk), .rst(rst), .PCNext(PCNext), .PC(PC));
always  begin
#5 clk = ~clk;
end 

initial begin
$monitor("Time: %0d ns | clk: %b | rst: %b | PCNext:%h | PC: %h ", $time , clk , rst, PCNext, PC);

    clk = 0;
    rst = 1;
    PCNext = 32'h11111111;
    #10;
    
    clk = 1;
    rst = 0;
    PCNext = 32'h11111111;
    #10; 

    PCNext = 32'hFFFFFFFF;
    #10;     
    $display("Simulation Ended Final PC = %h ", PC);
    $finish;
end
endmodule