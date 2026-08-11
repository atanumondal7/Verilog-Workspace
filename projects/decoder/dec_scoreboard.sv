`ifndef DECODER_SCOREBOARD_SV
`define DECODER_SCOREBOARD_SV

class scoreboard;

mailbox #(dec_item) mon2scb;
int fail_count = 0;
int pass_count = 0;

function new(mailbox #(dec_item) mon2scb);
this.mon2scb = mon2scb;
endfunction

task run();
dec_item item;

logic [OUT_WIDTH-1:0] exp_y;

$display("[%0t] [SCOREBOARD] Verifying DUT signals...", $time);

forever begin
mon2scb.get(item);

exp_y = '0;

exp_y = item.en ? (OUT_WIDTH'(1) << item.d) : '0; 

if(item.y === exp_y) begin
$display("[SCOREBOARD MATCH] d=%0d  en=%0b -> y=%b", item.d, item.en, item.y);
pass_count++;
end
else begin
$error("[SCOREBOARD ERROR] d=%0d  en=%0b | Expected: y=%b | Got: y=%b", item.d, item.en, exp_y, item.y);
fail_count++;
end
end
endtask
endclass

`endif