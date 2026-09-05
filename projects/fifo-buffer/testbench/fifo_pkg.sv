`timescale 1ns/1ps

`ifndef FIFO_PACKAGE_SV
`define FIFO_PACKAGE_SV

package fifo_pkg;

localparam int DATA_WIDTH = 8;
localparam int MEMORY_DEPTH = 16;
localparam int PTR_WIDTH = $clog2(MEMORY_DEPTH);

`include "fifo_item.sv"
`include "fifo_generator.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_coverage.sv"
`include "fifo_scoreboard.sv"
`include "fifo_environment.sv"

endpackage : fifo_pkg

`endif