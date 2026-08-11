`ifndef DECODER_DRIVER_SV
`define DECODER_DRIVER_SV

class driver;

virtual dec_if vif;
mailbox	#(dec_item) gen2drv;

function new(virtual dec_if vif, mailbox #(dec_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

task run();
dec_item item;

$display("[%0t] [DRIVER] Driving stimulus to DUT...", $time);

forever begin
gen2drv.get(item);

vif.cb.d <= item.d;
vif.cb.en <= item.en;

@(vif.cb);
@(vif.cb);
end
endtask

endclass

`endif