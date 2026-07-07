module mux3_1_tb();

logic [31:0] a, b, c, out;
logic [1:0] sel;

mux3_1 uut(.a(a), .b(b), .c(c), .sel(sel), .out(out));


initial begin
$monitor("Time: %0d | a = %h | b = %h | c = %h | sel = %h | out = %h",
        $time, a, b, c, sel, out);

//test1
sel = 2'b00;
a = 32'h00000000;
b = 32'h00000001;
c = 32'h00000002;
#10;
//test2
sel = 2'b01;
a = 32'h00000000;
b = 32'h00000001;
c = 32'h00000002;
#10;
//test3
sel = 2'b10;
a = 32'h00000000;
b = 32'h00000001;
c = 32'h00000002;
#10;

$display("Simulation Ended: out = %h", out);
$finish;
end
endmodule