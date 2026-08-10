design.sv:

`timescale 1ns/1ps

module counter4bit (
  input wire clk,
  input wire rst,
  output reg [3:0] count
);
  
  always @(posedge clk or posedge rst) begin
    
    if(rst == 1'b1) begin
      	count <= 4'b0000;
    end
    
    else begin
      count <= count + 4'b0001;
    end
   
  end
  
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_counter4bit;
  
  reg test_clk;
  reg test_rst;
  wire [3:0] test_count;
  
  counter4bit uut (
    .clk(test_clk),
    .rst(test_rst),
    .count(test_count)
  );
  
  initial begin
    test_clk = 0;
  end
  
  always begin
    #10 test_clk = ~test_clk;
  end
  
  initial begin
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_counter4bit);
    
    test_rst = 1'b1; #5;
    test_rst = 1'b0; #5;
    
    #200;
    
    $finish;
    
  end
  
  endmodule



EDA Playground file link - https://www.edaplayground.com/x/vtQM
