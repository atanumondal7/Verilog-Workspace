`ifndef PRIOENC_MONITOR_SV
`define PRIOENC_MONITOR_SV

class monitor;

virtual prioenc_if vif;
mailbox #(prioenc_item) mon2scb;
mailbox #(prioenc_item) mon2cov;

function new(virtual prioenc_if vif, mailbox #(prioenc_item) mon2scb, mailbox #(prioenc_item) mon2cov);
this.vif = vif;
this.mon2scb = mon2scb;
this.mon2cov = mon2cov;
endfunction

task run();
prioenc_item item;

$display("[%0t] [MONITOR] Monitoring DUT signals...", $time);

forever begin
@(vif.cb);
@(vif.cb);

item = new();
item.req = vif.req;
item.grant = vif.cb.grant;
item.valid = vif.cb.valid;

mon2scb.put(item.copy());
mon2cov.put(item.copy());
end

endtask
endclass

`endif