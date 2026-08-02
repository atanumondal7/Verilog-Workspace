`timescale 1ns/1ps

import usr_pkg::*;

module usr_tb;

logic clk = 0;
always #10 clk = ~clk;

usr_if vif(clk);

environment env;

usr #(.WIDTH(WIDTH)) dut (
.clk(clk),
.rst(vif.rst),
.mode(vif.mode),
.s_in_l(vif.s_in_l),
.s_in_r(vif.s_in_r),
.p_in(vif.p_in),
.p_out(vif.p_out)
);

initial begin

$dumpfile("Waves.vcd");
$dumpvars(0, usr_tb);

vif.rst = '0;
vif.mode = '0;
vif.s_in_l = '0;
vif.s_in_r = '0;
vif.p_in = '0;

env = new(vif);

env.test();

end
endmodule