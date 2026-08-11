`ifndef DECODER_PACKAGE_SV
`define DECODER_PACKAGE_SV

package dec_pkg;

parameter int WIDTH = 3;
localparam int OUT_WIDTH = 2**WIDTH;

`include "dec_item.sv"
`include "dec_generator.sv"
`include "dec_driver.sv"
`include "dec_monitor.sv"
`include "dec_coverage.sv"
`include "dec_scoreboard.sv"
`include "dec_environment.sv"

endpackage : dec_pkg

`endif