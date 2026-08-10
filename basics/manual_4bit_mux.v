design.sv:

`timescale 1ns/1ps

module mux4bitmanual (
  input wire i0,
  input wire i1,
  input wire i2,
  input wire i3,
  input wire [1:0] sel,
  output wire y
);
  
  wire w_top_to_final;
  wire w_bot_to_final;
  
  mux2to1 sub_mux_top (
    .a(i0),
    .b(i1),
    .sel(sel[0]),
    .y(w_top_to_final)
  );
  
  mux2to1 sub_mux_bottom (
    .a(i2),
    .b(i3),
    .sel(sel[0]),
    .y(w_bot_to_final)
  );
  
  mux2to1 sub_mux_final (
    .a(w_top_to_final),
    .b(w_bot_to_final),
    .sel(sel[1]),
    .y(y)
  );
  
endmodule

module mux2to1 (
  input wire a,
  input wire b,
  input wire sel,
  output wire y
);
  
  wire sel_bar;
  wire and0_out;
  wire and1_out;
  
  not u_not0(sel_bar, sel);
  
  and u_and0(and0_out, a, sel_bar);
  
  and u_and1(and1_out, b, sel);
  
  or u_or0(y, and0_out, and1_out);
 
endmodule



testbench.sv:

`timescale 1ns/1ps

module tb_mux4bitmanual;
  
  reg test_i0;
  reg test_i1;
  reg test_i2;
  reg test_i3;
  reg [1:0] test_sel;
  wire test_y;
  
  mux4bitmanual uut (
    .i0(test_i0),
    .i1(test_i1),
    .i2(test_i2),
    .i3(test_i3),
    .sel(test_sel),
    .y(test_y)
  );
  
  initial begin 
    
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_mux4bitmanual);
    
    test_i0 = 1; test_i1 = 0; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b00; #10;
    
    test_i0 = 0; test_i1 = 1; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b00; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 1; test_i3 = 0; 
    test_sel = 2'b00; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 0; test_i3 = 1; 
    test_sel = 2'b00; #10;
    
    
    
    test_i0 = 1; test_i1 = 0; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b01; #10;
    
    test_i0 = 0; test_i1 = 1; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b01; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 1; test_i3 = 0; 
    test_sel = 2'b01; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 0; test_i3 = 1; 
    test_sel = 2'b01; #10;
    
    
    
    test_i0 = 1; test_i1 = 0; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b10; #10;
    
    test_i0 = 0; test_i1 = 1; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b10; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 1; test_i3 = 0; 
    test_sel = 2'b10; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 0; test_i3 = 1; 
    test_sel = 2'b10; #10;
    
    
    
    test_i0 = 1; test_i1 = 0; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b11; #10;
    
    test_i0 = 0; test_i1 = 1; test_i2 = 0; test_i3 = 0; 
    test_sel = 2'b11; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 1; test_i3 = 0; 
    test_sel = 2'b11; #10;
    
    test_i0 = 0; test_i1 = 0; test_i2 = 0; test_i3 = 1; 
    test_sel = 2'b11; #10;
    
    
    $finish;
    
  end
  
endmodule



EDA Playground file link - https://www.edaplayground.com/x/fT4r
