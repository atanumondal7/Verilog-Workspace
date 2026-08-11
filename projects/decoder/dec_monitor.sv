`ifndef DECODER_MONITOR_SV
`define DECODER_MONITOR_SV

class monitor;

virtual dec_if vif;
mailbox #(dec_item) mon2scb;
mailbox #(dec_item) mon2cov;

function new(virtual dec_if vif, mailbox #(dec_item) mon2scb, mailbox #(dec_item) mon2cov);
this.vif = vif;
this.mon2scb = mon2scb;
this.mon2cov = mon2cov;
endfunction

task run();
dec_item item;

$display("[%0t] [MONITOR] Monitoring DUT signals...", $time);

forever begin
@(vif.cb);
@(vif.cb);

item = new();
item.d = vif.d;
item.en = vif.en;
item.y = vif.cb.y;

mon2scb.put(item.copy());
mon2cov.put(item.copy());
end

endtask
endclass

`endif