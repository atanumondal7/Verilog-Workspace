design.sv:

`timescale 1ns/1ps

module subtractor (
  input wire [3:0] a,
  input wire [3:0] b,
  output reg [3:0] result,
  output reg negative
);
  always @(*) begin
    
  if (a >= b) begin
    negative <= 1'b0; 
  	result <= a + (~b + 1);
  end
  
  else begin
    result <= 4'b0000;
    negative <= 1'b1;
  end
    
  end
  
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_subtractor;
  
  reg [3:0] test_a;
  reg [3:0] test_b;
  wire [3:0] test_result;
  wire test_negative;
  
  subtractor uut (
    .a(test_a),
    .b(test_b),
    .result(test_result),
    .negative(test_negative)
  );
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_subtractor);
    
    test_a = 4'b0111; test_b = 4'b0011; #10;
    test_a = 4'b1001; test_b = 4'b0101; #10;
    test_a = 4'b0011; test_b = 4'b1011; #10;
    
    $finish;
    
  end
  
 endmodule



 EDA Playground file link - https://www.edaplayground.com/x/qwVw
