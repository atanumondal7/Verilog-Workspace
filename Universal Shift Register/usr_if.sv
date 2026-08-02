`timescale 1ns/1ps

`ifndef USR_INTERFACE_SV
`define USR_INTERFACE_SV

import usr_pkg::*;

interface usr_if (input logic clk);

logic rst;
logic [1:0] mode;
logic s_in_l;
logic s_in_r;
logic [WIDTH-1:0] p_in;
logic [WIDTH-1:0] p_out;

clocking cb @(posedge clk);
default input #1 output #1;
output rst;
output mode;
output s_in_l;
output s_in_r;
output p_in;
input p_out;
endclocking

endinterface

`endif