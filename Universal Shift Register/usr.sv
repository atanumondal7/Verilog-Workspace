`timescale 1ns/1ps

module usr #(parameter WIDTH = 4) (
input logic clk,
input logic rst,
input logic [1:0] mode,
input logic s_in_l,
input logic s_in_r,
input logic [WIDTH-1:0] p_in,
output logic [WIDTH-1:0] p_out = '0 
);

always_ff @(posedge clk) begin

if(rst) begin
p_out <= '0;
end

else begin

case (mode)

2'b00: p_out <= p_out;
2'b01: p_out <= {s_in_l, p_out[WIDTH-1:1]};
2'b10: p_out <= {p_out[WIDTH-2:0], s_in_r};
2'b11: p_out <= p_in;

default: p_out <= p_out;

endcase
end
end

endmodule