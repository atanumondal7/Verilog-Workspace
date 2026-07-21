design.sv:

`timescale 1ns/1ps

module counter_sv (
  input logic clk,
  input logic rst,
  input logic load,
  input logic [3:0] data_in,
  output logic [3:0] q
);
  
  always_ff @(posedge clk or posedge rst) begin
    
    if(rst) begin
      q <= 4'd0;
    end
    
    else if (load) begin
      q <= data_in;
    end
    
    else begin
      q <= q + 4'd1;
    end
  
  end
  
endmodule



testbench.sv:

`timescale 1ns/1ps

class randomizer;
  
  rand bit [3:0] data_in;
  rand bit load;
  rand bit rst;
  
  constraint distr_load {
    load dist{1'b1 := 80, 1'b0 := 20};
  }
  
  constraint distr_rst {
    rst dist{1'b1 := 10, 1'b0 := 90};
  }
  
  covergroup counter_cg;
    
    cp_data_in: coverpoint data_in {
      bins min = {4'd0};
      bins max = {4'd15};
      bins others = {[4'd1:4'd14]};
    }
    
    cp_load: coverpoint load {
      bins high = {1'b1};
      bins low = {1'b0};
    }
    
    cp_rst: coverpoint rst {
      bins high = {1'b1};
      bins low = {1'b0};
    }
    
    X_data_in_load: cross cp_data_in, cp_load;
    
    X_data_in_rst: cross cp_data_in, cp_rst {
      ignore_bins ignore_low = binsof(cp_rst.low);
    }
    
    x_all: cross cp_data_in, cp_load, cp_rst {
      ignore_bins ignore = binsof(cp_rst.low) && binsof(cp_load.low);
    }
    
  endgroup
  
  function new();
    counter_cg = new();
  endfunction
  
  function void display(string text, logic [3:0] q);
    $display("[%s] Input: rst=%0d, load=%0d, data_in=%0d | Output: q=%0d", text, rst, load, data_in, q);
  endfunction
  
endclass

interface counter_if(input logic clk);
  
  logic rst;
  logic load;
  logic [3:0] data_in;
  logic [3:0] q;
  
  clocking cb @(posedge clk);
    
    default input #1 output #1;
    output rst;
    output load;
    output data_in;
    input q;
    
  endclocking
  
endinterface

module tb_counter_sv;
  
  logic clk = 0;
  always #5 clk = ~clk;
  
  counter_if ver(clk);
  
  integer error_count = 0;
  
  counter_sv uut (
    .clk(ver.clk),
    .rst(ver.rst),
    .load(ver.load),
    .data_in(ver.data_in),
    .q(ver.q)
  );
  
  logic [3:0] qn = 4'd0;
  
  task check(logic trst, logic tload, logic [3:0] tdata_in, logic [3:0] tq);
    begin
      
      if(trst) begin
        qn = 4'd0;
      end
      else if(tload) begin
        qn = tdata_in;
      end
      else begin
        qn = qn + 1'b1;
      end
      
      if(qn == tq) begin
        $display("[SUCCESS] Time: %0t | Matched expected: %0d", $time, qn);
      end
      else begin
        $display("[ERROR] Time: %0t | Expected: %0d | Got: %0d", $time, qn, tq);
        error_count = error_count + 1;
      end
      
    end
  endtask
  
  randomizer checking;
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_counter_sv);
    
    checking = new();
    
    ver.rst = 1'b1;
    ver.load = 1'b0;
    ver.data_in = 4'd0;
    #15;
    ver.rst = 1'b0;
    
    @(ver.cb);
    
    repeat(250) begin
      
      if(!checking.randomize()) begin
        $display("Randomization failed!");
      end
      
      ver.cb.rst <= checking.rst;
      ver.cb.load <= checking.load;
      ver.cb.data_in <= checking.data_in;
      
      @(ver.cb);
      
      checking.counter_cg.sample();
      checking.display("TB_CYCLE", ver.cb.q);
      check(checking.rst, checking.load, checking.data_in, ver.cb.q);
      
    end
    
    $display("Final function coverage: %0.2f", checking.counter_cg.get_inst_coverage());
    
    if(error_count == 0) begin
      $display("All tests passed successfully!");
    end
    
    else begin
      $display("simulation failed! Encountered %0d errors.", error_count);
    end
    
    $finish;
    
  end
  
endmodule
