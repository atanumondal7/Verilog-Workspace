`ifndef USR_DRIVER_SV
`define USR_DRIVER_SV

class driver;

virtual usr_if vif;
mailbox #(usr_item) gen2drv;

function new(virtual usr_if vif, mailbox #(usr_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

task run();
usr_item item;

$display("[DRIVER] Driving stimuli to DUT...");

forever begin
gen2drv.get(item);

vif.cb.rst <= item.rst;
vif.cb.mode <= item.mode;
vif.cb.s_in_l <= item.s_in_l;
vif.cb.s_in_r <= item.s_in_r;
vif.cb.p_in <= item.p_in;
@(vif.cb);

end
endtask
endclass

`endif