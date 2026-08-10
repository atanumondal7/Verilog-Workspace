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
