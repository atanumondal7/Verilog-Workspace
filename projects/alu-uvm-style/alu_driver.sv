`ifndef ALU_DRIVER_SV
`define ALU_DRIVER_SV

import alu_pkg::*;

class driver;

virtual alu_if vif;
mailbox #(alu_item) gen2drv;

function new(virtual alu_if vif, mailbox #(alu_item) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;
endfunction

task run();
alu_item item;
$display("[%0t] [DRIVER] Driving stimulus to DUT...", $time);

forever begin
gen2drv.get(item);

vif.cb.a <= item.a;
vif.cb.b <= item.b;
vif.cb.opcode <= item.opcode;
@(vif.cb);
end

endtask
endclass

`endif