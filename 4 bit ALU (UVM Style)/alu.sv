`timescale 1ns/1ps

import alu_pkg::*;

module alu #(parameter int WIDTH = 4) (
input logic [WIDTH-1:0] a,
input logic [WIDTH-1:0] b,
input logic [1:0] opcode,
output logic [WIDTH-1:0] y,
output logic neg_flag,
output logic zero_flag,
output logic carry_out
);

always_comb begin

y = '0;
neg_flag = 1'b0;
zero_flag = 1'b0;
carry_out = 1'b0;

case(opcode);

2'b00: begin
{carry_out, y} = a + b;
end

2'b01: begin
if(a>=b) begin
y = a-b;
end
else begin
y = a-b;
neg_flag = 1'b1;
end
end

2'b10: begin
y = a & b;
end

2'b11: begin
y = a | b;
end

default: y = '0;

endcase

if(y == '0) begin
zero_flag = 1'b1;
end 

end

endmodule