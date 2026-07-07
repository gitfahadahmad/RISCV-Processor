module instruction_memory_tb();

logic [31:0] A;
logic [31:0] RD;
logic [7:0] memory [1023:0];

instruction_memory uut (.A(A), .RD(RD));

initial begin

$monitor("Time: %0d | A = %h | RD = %h ",
        $time, A, RD);


A = 32'd0;
#10;

A = 32'd4;
#10;

A = 32'd8;
#10;

A = 32'd12;
#10;

A = 32'd16;
#10;

A = 32'd20;
#10;

A = 32'd24;
#10;
 
$display("Simulation Ended: RD = %h", RD);
$finish;

end


endmodule