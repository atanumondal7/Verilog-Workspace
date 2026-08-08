`ifndef ALU_PKG_SV
`define ALU_PKG_SV

package alu_pkg;

localparam int WIDTH = 4;

`include "alu_item.sv"
`include "alu_generator.sv"
`include "alu_driver.sv"
`include "alu_monitor.sv"
`include "alu_coverage.sv"
`include "alu_scoreboard.sv"
`include "alu_environment.sv"

endpackage : alu_pkg;