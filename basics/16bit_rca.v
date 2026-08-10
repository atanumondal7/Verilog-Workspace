design.sv:

`timescale 1ns/1ps

module rca16bit(
  input wire [15:0] a,
  input wire [15:0] b,
  input wire cin,
  output wire [15:0] q,
  output wire cout
);
  
  wire c1, c2, c3;
  
  rca4bit rc1 (
    .a(a[3:0]),
    .b(b[3:0]),
    .cin(cin),
    .q(q[3:0]),
    .cout(c1)
  );
  
  rca4bit rc2 (
    .a(a[7:4]),
    .b(b[7:4]),
    .cin(c1),
    .q(q[7:4]),
    .cout(c2)
  );
  
  rca4bit rc3 (
    .a(a[11:8]),
    .b(b[11:8]),
    .cin(c2),
    .q(q[11:8]),
    .cout(c3)
  );
  
  rca4bit rc4 (
    .a(a[15:12]),
    .b(b[15:12]),
    .cin(c3),
    .q(q[15:12]),
    .cout(cout)
  );
  
endmodule
  
module rca4bit (
  input wire [3:0] a,
  input wire [3:0] b,
  input wire cin,
  output wire [3:0] q,
  output wire cout
);
  
  wire c1, c2, c3;
  
  fulladder rc1 (
    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .q(q[0]),
    .cout(c1)
  );
  
  fulladder rc2 (
    .a(a[1]),
    .b(b[1]),
    .cin(c1),
    .q(q[1]),
    .cout(c2)
  );
  
  fulladder rc3 (
    .a(a[2]),
    .b(b[2]),
    .cin(c2),
    .q(q[2]),
    .cout(c3)
  );
  
  fulladder rc4 (
    .a(a[3]),
    .b(b[3]),
    .cin(c3),
    .q(q[3]),
    .cout(cout)
  );
  
endmodule
  
module fulladder (
  input wire a,
  input wire b,
  input wire cin,
  output wire q,
  output wire cout
);
  
  wire s, c1, c2;
  
  halfadder sub1 (
    .a(a),
    .b(b),
    .q(s),
    .cout(c1)
  );
  
  halfadder sub2 (
    .a(s),
    .b(cin),
    .q(q),
    .cout(c2)
  );
  
  or u_or0(cout, c1, c2);
  
endmodule


module halfadder (
  input wire a,
  input wire b,
  output wire q,
  output wire cout
);
  
  assign {cout,q} = a + b;
  
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_rca16bit;
  
  reg [15:0] test_a;
  reg [15:0] test_b;
  reg test_cin;
  wire [15:0] test_q;
  wire test_cout;
  
  integer error_count = 0;
  
  rca16bit uut (
    .a(test_a),
    .b(test_b),
    .cin(test_cin),
    .q(test_q),
    .cout(test_cout)
  );
  
  reg [15:0] sum;
  reg carry;
  
  task check(input [15:0] ta, input [15:0] tb, input tcin, input [15:0] tq, input tca);
    begin
      
      $display("[TB_CHECK] Input: a=%0d, b=%0d, cin=%0d | Output: sum=%0d, carry=%0d", ta, tb, tcin, tq, tca);
      
      {carry, sum} = ta + tb + tcin;
      
      if(sum == tq && carry == tca) begin
        $display("[SUCCESS] Time: %0t | Matched expected: sum=%0d, carry=%0d", $time, sum, carry);
      end
      else begin
        $display("[ERROR] Time: %0t | Expected: sum=%0d, carry=%0d | Got: sum=%0d, carry=%0d", $time, sum, carry, tq, tca);
        error_count = error_count + 1;
      end
      
      end
  endtask
      
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_rca16bit);
    
    repeat (10) begin
      
      test_a = {$random} % 65536; 
      test_b = {$random} % 65536;
      test_cin = {$random} % 2;
      #10;
      check(test_a, test_b, test_cin, test_q, test_cout);
      
    end
    
    if(error_count == 0) begin
      $display("All tests passed successfully!");
    end
    else begin
      $display("Simulation failed! Encountered %0d errors", error_count);
    end
    
    
    $finish;
    
  end
  
endmodule
