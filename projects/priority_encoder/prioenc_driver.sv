`ifndef PRIOENC_DRIVER_SV
`define PRIOENC_DRIVER_SV

class driver;

virtual prioenc_if vif;
mailbox	#(prioenc_item) gen2drv;

function new(virtual prioenc_if vif, mailbox #(prioenc_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

task run();
prioenc_item item;

$display("[%0t] [DRIVER] Driving stimulus to DUT...", $time);

forever begin
gen2drv.get(item);

vif.cb.req <= item.req;
@(vif.cb);
@(vif.cb);
end
endtask

endclass

`endif