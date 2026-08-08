design.sv:

`timescale 1ns/1ps

module accumulator (
  input wire [3:0] d,
  input wire clk,
  input wire rst,
  output wire [3:0] q,
  output wire carry
);
  
  wire [3:0] q_store;
  
  reg_4bit sub_next (
    .d(q_store),
    .clk(clk),
    .rst(rst),
    .q(q)
  );
  
  ripple_carry_adder sub_add (
    .a(q),
    .b(d),
    .y(q_store),
    .cout(carry)
      );
      
  

  
endmodule
      

module reg_4bit (
  input reg [3:0] d,
  input reg clk,
  input reg rst,
  output reg [3:0] q
);
  
  always @(posedge clk or posedge rst) begin
    
    if (rst == 1'b1) begin
      q <= 4'b0000;
    end
    
    else begin
      q <= d;
    end
    
  end
  
endmodule

module ripple_carry_adder (
  input wire [3:0] a,
  input wire [3:0] b,
  output wire[3:0] y,
  output wire cout
);
  
  wire cout1;
  wire cout2;
  wire cout3;
  
  fulladder add_zero (
    .a(a[0]),
    .b(b[0]),
    .cin(1'b0),
    .y(y[0]),
    .cout(cout1)
  );
  
  fulladder add_one (
    .a(a[1]),
    .b(b[1]),
    .cin(cout1),
    .y(y[1]),
    .cout(cout2)
  );
  
  fulladder add_two (
    .a(a[2]),
    .b(b[2]),
    .cin(cout2),
    .y(y[2]),
    .cout(cout3)
  );
  
  fulladder add_three (
    .a(a[3]),
    .b(b[3]),
    .cin(cout3),
    .y(y[3]),
    .cout(cout)
  );
  
endmodule

module fulladder (
  input wire a,
  input wire b,
  input wire cin,
  output wire y,
  output wire cout
);
  
  wire sum1;
  wire cout1;
  wire cout2;
  
  halfadder sub_one (
    .a(a),
    .b(b),
    .y(sum1),
    .cout(cout1)
  );
  
  halfadder sub_two (
    .a(sum1),
    .b(cin),
    .y(y),
    .cout(cout2)
  );
  
  or u_or0(cout, cout1, cout2);
  
endmodule
  

module halfadder (
  input wire a,
  input wire b,
  output wire y,
  output wire cout
);
  
  xor u_xor0(y, a, b);
  
  and u_and0(cout, a, b);
  
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_accumulator;
  
  reg [3:0] test_d;
  reg test_clk;
  reg test_rst;
  wire [3:0] test_q;
  wire test_carry;
  
  accumulator uut (
    .d(test_d),
    .clk(test_clk),
    .rst(test_rst),
    .q(test_q),
    .carry(test_carry)
  );
  
  initial begin
    test_clk = 0;
  end
  
  always begin
    #10 test_clk = ~test_clk;
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_accumulator);
    
    test_rst = 1'b1; 
    test_d = 4'b0000; 
    
    @(negedge test_clk);
    test_rst = 1'b0;
    
    
    test_d = 4'b0001; @(negedge test_clk);
    test_d = 4'b0010; @(negedge test_clk);
    test_d = 4'b0011; @(negedge test_clk);
    test_d = 4'b0100; @(negedge test_clk);
    test_d = 4'b0101; @(negedge test_clk);
    test_d = 4'b0110; @(negedge test_clk);
    test_d = 4'b0111; @(negedge test_clk);
    test_d = 4'b1000; @(negedge test_clk);
    test_d = 4'b1001; @(negedge test_clk);
    test_d = 4'b1010; @(negedge test_clk);
    test_d = 4'b1011; @(negedge test_clk);
    test_d = 4'b1100; @(negedge test_clk);
    test_d = 4'b1101; @(negedge test_clk);
    test_d = 4'b1110; @(negedge test_clk);
    test_d = 4'b1111; @(negedge test_clk);
    
    $finish;
    
  end
  
endmodule



EDA Playground link - https://www.edaplayground.com/x/fw3n
