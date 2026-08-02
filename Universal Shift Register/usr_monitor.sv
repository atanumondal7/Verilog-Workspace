`ifndef USR_MONITOR_SV
`define USR_MONITOR_SV

class monitor;

virtual usr_if vif;
mailbox #(usr_item) mon2scb;
mailbox #(usr_item) mon2cov;

function new(virtual usr_if vif, mailbox #(usr_item) mon2scb, mailbox #(usr_item) mon2cov);
this.vif = vif;
this.mon2scb = mon2scb;
this.mon2cov = mon2cov;
endfunction

task run();
usr_item item;
logic prev_rst;
logic [1:0] prev_mode;
logic prev_s_in_l;
logic prev_s_in_r;
logic [WIDTH-1:0] prev_p_in;

$display("[MONITOR] Monitoring DUT output signals...");

// ------------------------------------------------------------------------
// Skew Alignment Priming:
// Edge 1: Driver puts stimulus onto the bus after edge.
// Edge 2: DUT processes stimulus and updates p_out.
// We sample initial inputs here to align with p_out on Edge 3.
// ------------------------------------------------------------------------
@(vif.cb);
@(vif.cb);
prev_rst = vif.rst;
prev_mode = vif.mode;
prev_s_in_l = vif.s_in_l;
prev_s_in_r = vif.s_in_r;
prev_p_in = vif.p_in;

forever begin
@(vif.cb);

item = new();
item.rst = prev_rst;
item.mode = prev_mode;
item.s_in_l = prev_s_in_l;
item.s_in_r = prev_s_in_r;
item.p_in = prev_p_in;
item.p_out = vif.cb.p_out;

mon2scb.put(item.copy());
mon2cov.put(item.copy());

prev_rst = vif.rst;
prev_mode = vif.mode;
prev_s_in_l = vif.s_in_l;
prev_s_in_r = vif.s_in_r;
prev_p_in = vif.p_in;

end
endtask
endclass

`endif