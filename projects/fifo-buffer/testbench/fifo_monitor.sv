`ifndef FIFO_MONITOR_SV
`define FIFO_MONITOR_SV

class monitor;

virtual fifo_if vif;
mailbox #(fifo_item) mon2scb;
mailbox #(fifo_item) mon2cov;

function new(virtual fifo_if vif, mailbox #(fifo_item) mon2scb, mailbox #(fifo_item) mon2cov);
this.vif = vif;
this.mon2scb = mon2scb;
this.mon2cov = mon2cov;
endfunction

task run();
fifo_item item;
logic prev_rst;
logic prev_wr_en;
logic prev_rd_en;
logic [DATA_WIDTH-1:0] prev_din;

$display("[MONITOR] Monitoring DUT output signals...");

@(vif.cb);
@(vif.cb);
prev_rst = vif.rst;
prev_wr_en = vif.wr_en;
prev_rd_en = vif.rd_en;
prev_din = vif.din;

forever begin
@(vif.cb);

item = new();
item.rst = prev_rst;
item.wr_en = prev_wr_en;
item.rd_en = prev_rd_en;
item.din = prev_din;
item.dout = vif.cb.dout;
item.empty = vif.cb.empty;
item.full = vif.cb.full;
item.overflow_err = vif.cb.overflow_err;
item.underflow_err = vif.cb.underflow_err;

mon2scb.put(item.copy());
mon2cov.put(item.copy());

prev_rst = vif.rst;
prev_wr_en = vif.wr_en;
prev_rd_en = vif.rd_en;
prev_din = vif.din;

end
endtask
endclass

`endif