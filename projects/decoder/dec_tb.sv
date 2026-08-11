`timescale 1ns/1ps

import dec_pkg::*;

module dec_tb;

logic clk = 0;
always #10 clk=~clk;

dec_if vif(clk);

dec #(.WIDTH(WIDTH)) dut (
.d(vif.d),
.en(vif.en),
.y(vif.y)
);

environment env;

initial begin

$dumpfile("Waves.vcd");
$dumpvars(0, dec_tb);

vif.d = '0;
vif.en = 0;

env = new(vif);

env.test();

end

endmodule