`timescale 1ns/1ps

import fifo_pkg::*;

module fifo_tb;

logic clk = 0;
always #10 clk = ~clk;

fifo_if vif(clk);

environment env;

fifo #(.DATA_WIDTH(DATA_WIDTH), .MEMORY_DEPTH(MEMORY_DEPTH)) dut (
.clk(clk),
.rst(vif.rst),
.wr_en(vif.wr_en),
.rd_en(vif.rd_en),
.din(vif.din),
.dout(vif.dout),
.full(vif.full),
.empty(vif.empty),
.overflow_err(vif.overflow_err),
.underflow_err(vif.underflow_err)
);

initial begin

$dumpfile("Waves.vcd");
$dumpvars(0, fifo_tb);

vif.rst = '0;
vif.wr_en = '0;
vif.rd_en = '0;
vif.din = '0;

env = new(vif);

env.test();

end
endmodule