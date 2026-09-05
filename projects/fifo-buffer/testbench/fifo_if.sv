`timescale 1ns/1ps

`ifndef FIFO_INTERFACE_SV
`define FIFO_INTERFACE_SV

import fifo_pkg::*;

interface fifo_if (input logic clk);

logic rst;
logic wr_en;
logic rd_en;
logic [DATA_WIDTH-1:0] din;
logic [DATA_WIDTH-1:0] dout;
logic empty;
logic full;
logic overflow_err;
logic underflow_err;

clocking cb @(posedge clk);
default input #1 output #1;
output rst;
output wr_en;
output rd_en;
output din;
input dout;
input empty;
input full;
input overflow_err;
input underflow_err;
endclocking

endinterface

`endif