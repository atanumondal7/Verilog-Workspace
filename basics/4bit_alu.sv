design.sv:

`timescale 1ns/1ps

module alu (
  input wire [3:0] a,
  input wire [3:0] b,
  input wire [1:0] opcode,
  output reg [3:0] result,
  output reg carry_out,
  output reg neg_flag,
  output reg zero_flag
);
  
  always @(*) begin
    result = 4'b0000;
    carry_out = 1'b0;
    neg_flag = 1'b0;
    zero_flag = 1'b0;
    
    case (opcode)
      
      2'b00: begin
        {carry_out, result} = a + b;
        
        if (result == 4'b0000) begin
          zero_flag = 1'b1;
        end
        
        else begin
          zero_flag = 1'b0;
        end
        
      end
      
      2'b01: begin
        if (a >= b) begin
        	result = a - b;
          
          if (result == 4'b0000) begin
          zero_flag = 1'b1;
        end
          
          else begin
          zero_flag = 1'b0;
        end
          
        end
        
        else begin
          neg_flag = 1'b1;
          result = 4'b0000;
        end
      end
      
      2'b10: begin
        result = a & b;
        
        if (result == 4'b0000) begin
          zero_flag = 1'b1;
        end
        
        else begin
          zero_flag = 1'b0;
        end
        
      end
      
      2'b11: begin
        result = a | b;
        
        if (result == 4'b0000) begin
          zero_flag = 1'b1;
        end
        
        else begin
          zero_flag = 1'b0;
        end
        
      end
      
      default: result = 4'b0000;
      
    endcase
     
  end
      
 endmodule




testbench.sv:

`timescale 1ns/1ps

module tb_alu;
  
  reg [3:0] test_a;
  reg [3:0] test_b;
  reg [1:0] test_opcode;
  wire [3:0] test_result;
  wire test_carry_out;
  wire test_neg_flag;
  wire test_zero_flag;
  
  alu uut (
    .a(test_a),
    .b(test_b),
    .opcode(test_opcode),
    .result(test_result),
    .carry_out(test_carry_out),
    .neg_flag(test_neg_flag),
    .zero_flag(test_zero_flag)
  );
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_alu);
    
    test_a = 4'b0111; test_b = 4'b0011; test_opcode = 2'b00; #10;
    test_a = 4'b1011; test_b = 4'b1001; test_opcode = 2'b00; #10;
    test_a = 4'b0111; test_b = 4'b0011; test_opcode = 2'b01; #10;
    test_a = 4'b0111; test_b = 4'b0011; test_opcode = 2'b10; #10;
    test_a = 4'b0111; test_b = 4'b0011; test_opcode = 2'b11; #10;
    test_a = 4'b0011; test_b = 4'b0111; test_opcode = 2'b01; #10;
    test_a = 4'b0011; test_b = 4'b0011; test_opcode = 2'b01; #10;
    
    $finish;
    
  end
  
  endmodule



  EDA Playground file link - https://www.edaplayground.com/x/F3nv
