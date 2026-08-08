design.sv:

`timescale 1ns/1ps

module adder (
  input wire [3:0] a,
  input wire [3:0] b,
  output wire [3:0] sum,
  output wire carry
);
  
  assign {carry, sum} = a + b;
  
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_adder;
  
  reg [3:0] test_a;
  reg [3:0] test_b;
  wire [3:0] test_sum;
  wire test_carry;
  
  adder uut (
    .a(test_a),
    .b(test_b),
    .sum(test_sum),
    .carry(test_carry)
  );
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_adder);
    
    test_a = 4'b1001; test_b = 4'b0101; #10;
    test_a = 4'b0101; test_b = 4'b1001; #10;
    test_a = 4'b0111; test_b = 4'b0011; #10;
    test_a = 4'b1111; test_b = 4'b0001; #10;
    test_a = 4'b1011; test_b = 4'b1101; #10;
    
    $finish;
    
  end
  
endmodule



EDA Playground file link - https://www.edaplayground.com/x/tbDJ
