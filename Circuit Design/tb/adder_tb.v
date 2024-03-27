`timescale 1ns/1ps

module adder_tb();

reg [3:0] a_tb, b_tb;
wire [3:0] o_tb;

initial begin
a_tb = 0;
b_tb = 0;
#5 
a_tb = 1;
#5 
b_tb = 4;
#5
$stop();
end

adder DUT(.a(a_tb), .b(b_tb), .o(o_tb));

endmodule 
