design.sv:

`timescale 1ns/1ps

module alu (
  input logic [3:0] a,
  input logic [3:0] b,
  input logic [1:0] opcode,
  output logic [3:0] result,
  output logic carry_out,
  output logic neg_flag,
  output logic zero_flag
);
  
  always_comb begin
    result = 4'b0000;
    carry_out = 1'b0;
    neg_flag = 1'b0;
    zero_flag = 1'b0;
    
    case (opcode)
      
      2'b00: begin
        {carry_out, result} = a + b;        
      end
      
      2'b01: begin
        if(a < b) begin
          result = b - a;
          neg_flag = 1'b1;
        end
        
        else begin
          result = a - b;
        end
       
      end
      
      2'b10: begin
        result = a & b;        
      end
      
      2'b11: begin
        result = a | b;
      end
      
      default: result = 4'b0000;
      
    endcase
    
    if(result == 4'b0000) begin
      zero_flag = 1'b1;
    end
     
  end
      
 endmodule




testbench.sv: 

`timescale 1ns/1ps

class randomizer;
  
  rand bit [3:0] a;
  rand bit [3:0] b;
  rand bit [1:0] opcode;
  
  constraint distr {
    opcode dist{2'b00 := 35, 2'b01 := 35, 2'b10 := 15, 2'b11 := 15};
  }
  
  covergroup alu_cg;
    
    cp_opcode: coverpoint opcode {
      bins add_op = {2'b00};
      bins sub_op = {2'b01};
      bins and_op = {2'b10};
      bins or_op = {2'b11};
    }
    
    cp_a: coverpoint a {
      bins max = {4'd15};
      bins min = {4'd0};
      bins others = {[4'd1:4'd14]};
    }
    
    cp_b: coverpoint b {
      bins max = {4'd15};
      bins min = {4'd0};
      bins others = {[4'd1:4'd14]};
    }
    
    X_opcode_a: cross cp_opcode, cp_a {
      
      ignore_bins ignore_logical_zero = binsof(cp_opcode) intersect {2'b10, 2'b11} && binsof(cp_a.min);
      
    }
    
    X_opcode_b: cross cp_opcode, cp_b {
      
      ignore_bins ignore_logical_zero = binsof(cp_opcode) intersect {2'b10, 2'b11} && binsof(cp_b.min);
      
    }
    
    X_a_b: cross cp_a, cp_b, cp_opcode {
      
      ignore_bins ignore_others = binsof(cp_a) intersect {[4'd0:4'd14]} || binsof(cp_b) intersect {[4'd0:4'd14]} || binsof(cp_opcode) intersect {2'b01, 2'b10, 2'b11};
      
    }
    
  endgroup
   	
  function new();
    alu_cg = new();
  endfunction
  
  function void display(string name, bit [3:0] result, bit carry_out, bit neg_flag, bit zero_flag);
    $display("[%s] Input: a=%0d, b=%0d, opcode=%0d || Output: result=%s%0d, carry_out=%0d, neg_flag=%0d, zero_flag = %0d", name, a, b, opcode, (neg_flag ? "-" : ""), result, carry_out, neg_flag, zero_flag);
  endfunction
  
endclass

interface alu_if;
  
  logic [3:0] a;
  logic [3:0] b;
  logic [1:0] opcode;
  logic [3:0] result;
  logic carry_out;
  logic neg_flag;
  logic zero_flag;
  
endinterface

module tb_alu;
  
  alu_if ver();
  
  integer error_count = 0;
  
  alu uut (
    .a(ver.a),
    .b(ver.b),
    .opcode(ver.opcode),
    .result(ver.result),
    .carry_out(ver.carry_out),
    .neg_flag(ver.neg_flag),
    .zero_flag(ver.zero_flag)
  );
  
  task reset_seq();
    begin
      
    ver.a = 4'b0000;
    ver.b = 4'b0000;
    ver.opcode = 2'b00;
      
      #10;
      
    end 
  endtask
  
  logic [3:0] exp_result;
  logic exp_carry_out;
  logic exp_neg_flag;
  logic exp_zero_flag;
  
  task operation(logic [3:0] ta, logic [3:0] tb, logic [1:0] top);
    begin
      
      exp_result = 4'b0000;
      exp_carry_out = 1'b0;
      exp_neg_flag = 1'b0;
      exp_zero_flag = 1'b0;
      
      case (top)
        
        2'b00: begin
          {exp_carry_out, exp_result} = ta + tb;        
      end
      
      2'b01: begin
        if(ta < tb) begin
          exp_result = tb - ta;
          exp_neg_flag = 1'b1;
        end
        
        else begin
          exp_result = ta - tb;
        end
      end
      
      2'b10: begin
        exp_result = ta & tb;        
      end
      
      2'b11: begin
        exp_result = ta | tb;        
      end
      
      default: exp_result = 4'b0000;
        
     endcase
      
      if(exp_result == 4'b0000) begin
        exp_zero_flag = 1'b1;
      end
        
        
      if(ver.result == exp_result && ver.carry_out == exp_carry_out && ver.neg_flag == exp_neg_flag && ver.zero_flag == exp_zero_flag) begin
        $display("[SUCCESS] Time: %0t | Matched expected: result:%s%0d, carry_out=%0d, neg_flag=%0d, zero_flag=%0d", $time, (exp_neg_flag ? "-" : ""), exp_result, exp_carry_out, exp_neg_flag, exp_zero_flag);
      end
      else begin
        $display("[ERROR] Time: %0t | Expected: result:%s%0d, carry_out=%0d, neg_flag=%0d, zero_flag=%0d | Got: result:%s%0d, carry_out=%0d, neg_flag=%0d, zero_flag=%0d", $time, (exp_neg_flag ? "-" : ""), exp_result, exp_carry_out, exp_neg_flag, exp_zero_flag, (ver.neg_flag ? "-" : ""), ver.result, ver.carry_out, ver.neg_flag, ver.zero_flag);
          error_count = error_count + 1;
      end
        
      #10;
      
    end
    
  endtask
  
  randomizer check;
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_alu);
    
    check = new();
    
    reset_seq();
    
    repeat(1500) begin
      
      if(!check.randomize()) begin
        $error("Randomization failed!");
      end
      
      ver.a = check.a;
      ver.b = check.b;
      ver.opcode = check.opcode;
      
      check.alu_cg.sample();
      
      #10;
      
      check.display("TB_LOOP", ver.result, ver.carry_out, ver.neg_flag, ver.zero_flag);
      
      operation(ver.a, ver.b, ver.opcode);
      
    end
    
    $display("Final Function Coverage: %0.2f%%", check.alu_cg.get_inst_coverage());
    
    if(error_count == 0) begin
      $display("All tests passed successfully!");
    end
    else begin
      $display("Simulation failed! Encountered %0d errors.", error_count);
    end
    
    $finish;
    
  end
  
  endmodule



EDA Playground link - https://www.edaplayground.com/x/vknL
