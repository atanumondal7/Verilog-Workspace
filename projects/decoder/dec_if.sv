`timescale 1ns/1ps

`ifndef DECODER_IF_SV
`define DECODER_IF_SV

import dec_pkg::*;

interface dec_if(input logic clk);

logic [WIDTH-1:0] d;
logic en;
logic [OUT_WIDTH-1:0] y;

clocking cb @(posedge clk);

default input #1 output #1;
output d;
output en;
input y;

endclocking

endinterface

`endif