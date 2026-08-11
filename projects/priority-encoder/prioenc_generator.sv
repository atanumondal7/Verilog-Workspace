`ifndef PRIOENC_GENERATOR_SV
`define PRIOENC_GENERATOR_SV

class generator;

prioenc_item item;
mailbox #(prioenc_item) gen2drv;
int loop_count = 5000;

function new(mailbox #(prioenc_item) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run();
$display("[%0t] [GENERATOR] Starting stimulus generation...", $time);

item = new();
item.req = '0;
gen2drv.put(item.copy());

repeat(loop_count-1) begin
item = new();
while(item.req == '0) begin
item.req = $urandom_range((2**WIDTH)-1,0);
end
gen2drv.put(item.copy());
end 

$display("[GENERATOR] Finished generating %0d items.", loop_count);
endtask
endclass 

`endif