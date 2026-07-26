`ifndef ALU_INTERFACE_SV
`define ALU_INTERFACE_SV

import alu_pkg::*;

interface alu_if (input logic clk);

logic [WIDTH-1:0] a;
logic [WIDTH-1:0] b;
logic [1:0] opcode;
logic [WIDTH-1:0] y;
logic neg_flag;
logic zero_flag;
logic carry_out;

clocking cb @(posedge clk);
default input #1 output #1;
output a;
output b;
output opcode;
input y;
input neg_flag;
input zero_flag;
input carry_out;
endclocking

endinterface

`endif