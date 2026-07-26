`ifndef ALU_GENERATOR_SV
`define ALU_GENERATOR_SV

import alu_pkg::*;

class generator;

mailbox #(alu_item) gen2drv;
int loop_count = 1000;

function new(mailbox #(alu_item) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run();
alu_item item;

$display("[%0t] [GENERATOR] Generating stimulus...", $time);

repeat (loop_count) begin

item = new();

if(!item.randomize()) begin
$error("Randomization Failed!");
end 

gen2drv.put(item.copy());
end
endtask
endclass

`endif