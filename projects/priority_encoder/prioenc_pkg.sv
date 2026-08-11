`ifndef PRIOENC_PACKAGE_SV
`define PRIOENC_PACKAGE_SV

package prioenc_pkg;

localparam int WIDTH = 8;
localparam int OUT_WIDTH = $clog2(WIDTH);

`include "prioenc_item.sv"
`include "prioenc_generator.sv"
`include "prioenc_driver.sv"
`include "prioenc_monitor.sv"
`include "prioenc_coverage.sv"
`include "prioenc_scoreboard.sv"
`include "prioenc_environment.sv"

endpackage : prioenc_pkg

`endif