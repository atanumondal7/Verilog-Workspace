design.sv:

`timescale 1ns/1ps

module tls (
  input wire clk,
  input wire rst,
  output reg red,
  output reg yellow,
  output reg green,
  output reg [3:0] count
);
  
  always @(posedge clk or posedge rst) begin
    
    if(rst == 1'b1) begin
      	
      	count <= 4'b0000;
      	red <= 1'b1;
        yellow <= 1'b0;
        green <= 1'b0;
      
    end
    
    else begin
    
      count <= count + 4'b0001;

        if (count == 4'b0101) begin

          red <= 1'b0;
          green <= 1'b1;

      end

        if (count == 4'b1010) begin

          green <= 1'b0;
          yellow <= 1'b1;

      end

        if (count == 4'b1100) begin

          yellow <= 1'b0;
          red <= 1'b1;

      end
      
    end
  end
    
  
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_tls;
  
  reg test_clk;
  reg test_rst;
  wire test_red;
  wire test_yellow;
  wire test_green;
  wire [3:0] test_count;
  
  tls uut (
    .clk(test_clk),
    .rst(test_rst),
    .red(test_red),
    .yellow(test_yellow),
    .green(test_green),
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
    $dumpvars(0, tb_tls);
    
    test_rst = 1'b1; #5; 
    test_rst = 1'b0; #5;
    
    #2400;
    
    $finish;
    
  end
  
endmodule



EDA Playground file link - https://www.edaplayground.com/x/HywE
