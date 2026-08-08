`timescale 1ns/1ps

`ifndef USR_PACKAGE_SV
`define USR_PACKAGE_SV

package usr_pkg;

localparam int WIDTH = 4;

`include "usr_item.sv"
`include "usr_generator.sv"
`include "usr_driver.sv"
`include "usr_monitor.sv"
`include "usr_coverage.sv"
`include "usr_scoreboard.sv"
`include "usr_environment.sv"

endpackage : usr_pkg

`endif