`ifndef ALU_MONITOR_SV
`define ALU_MONITOR_SV

import alu_pkg::*;

class monitor;

virtual alu_if vif;
mailbox #(alu_item) mon2scb;
mailbox #(alu_item) mon2cov;

function new(virtual alu_if vif, mailbox #(alu_item) mon2scb, mailbox #(alu_item) mon2cov);
this.vif = vif;
this.mon2scb = mon2scb;
this.mon2cov = mon2cov;
endfunction

task run();
alu_item item;

$display("[%0t] [MONITOR] Monitoring DUT output signals...", $time);

forever begin
@(vif.cb);

item = new();
item.a = vif.cb.a;
item.b = vif.cb.b;
item.opcode = vif.cb.opcode;
item.y = vif.cb.y;
item.neg_flag = vif.cb.neg_flag;
item.zero_flag = vif.cb.zero_flag;
item.carry_out = vif.cb.carry_out;

mon2scb.put(item.copy());
mon2cov.put(item.copy());

end 
endtask
endclass

`endif