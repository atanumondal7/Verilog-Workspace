`ifndef PRIOENC_SCOREBOARD_SV
`define PRIOENC_SCOREBOARD_SV

class scoreboard;

mailbox #(prioenc_item) mon2scb;
int error_count = 0;
int pass_count = 0;

function new(mailbox #(prioenc_item) mon2scb);
this.mon2scb = mon2scb;
endfunction

task run();
prioenc_item item;

logic [OUT_WIDTH-1:0] exp_grant;
logic exp_valid;

$display("[%0t] [SCOREBOARD] Verifying DUT signals...", $time);

forever begin
mon2scb.get(item);

exp_grant = '0;
exp_valid = |item.req;

for(int i=0;i<WIDTH;i++) begin
if(item.req[i]) begin
exp_grant = OUT_WIDTH'(i);
end
end

if(item.grant === exp_grant && item.valid === exp_valid) begin
$display("[SCOREBOARD MATCH] req=%b -> grant=%0d  valid=%0b", item.req, item.grant, item.valid);
pass_count++;
end
else begin
$error("[SCOREBOARD ERROR] req=%b | Expected: grant=%0d, valid=%0b | Got: grant=%0d, valid=%0b", item.req, exp_grant, exp_valid, item.grant, item.valid);
error_count++;
end
end
endtask
endclass

`endif