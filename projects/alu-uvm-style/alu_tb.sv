`timescale 1ns/1ps

import alu_pkg::*;

module alu_tb;

logic clk = 0;
always #10 clk = ~clk;

alu_if vif(clk);

alu #(.WIDTH(WIDTH)) dut (
.a(vif.a),
.b(vif.b),
.opcode(vif.opcode),
.y(vif.y),
.neg_flag(vif.neg_flag),
.zero_flag(vif.zero_flag),
.carry_out(vif.carry_out)
);

environment env;

initial begin

$dumpfile("ALU wave viewer.vcd");
$dumpvars(0, alu_tb);

env = new(vif);

env.test();

end

endmodule