
module adder32bit(a, b, sum);

input logic [31:0] a, b;
output logic [31:0] sum;

assign sum = a+b;

endmodule