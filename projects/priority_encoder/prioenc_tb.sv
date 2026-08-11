`timescale 1ns/1ps

import prioenc_pkg::*;

module prioenc_tb;

logic clk = 0;
always #10 clk=~clk;

prioenc_if vif(clk);

prioenc #(.WIDTH(WIDTH)) dut (
.req(vif.req),
.grant(vif.grant),
.valid(vif.valid)
);

environment env;

initial begin

$dumpfile("Waves.vcd");
$dumpvars(0, prioenc_tb);

vif.req = '0;

env = new(vif);

env.test();

end

endmodule