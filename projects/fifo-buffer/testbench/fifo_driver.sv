`ifndef FIFO_DRIVER_SV
`define FIFO_DRIVER_SV

class driver;

virtual fifo_if vif;
mailbox #(fifo_item) gen2drv;

function new(virtual fifo_if vif, mailbox #(fifo_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

task run();
fifo_item item;

$display("[DRIVER] Driving stimuli to DUT...");

forever begin
gen2drv.get(item);

vif.cb.rst <= item.rst;
vif.cb.wr_en <= item.wr_en;
vif.cb.rd_en <= item.rd_en;
vif.cb.din <= item.din;
@(vif.cb);

end
endtask
endclass

`endif