`timescale 1ns/1ps

`ifndef PRIOENC_IF_SV
`define PRIOENC_IF_SV

import prioenc_pkg::*;

interface prioenc_if(input logic clk);

logic [WIDTH-1:0] req;
logic [OUT_WIDTH-1:0] grant;
logic valid;

clocking cb @(posedge clk);

default input #1 output #1;
output req;
input grant;
input valid;

endclocking

endinterface

`endif