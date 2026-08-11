`ifndef DECODER_GENERATOR_SV
`define DECODER_GENERATOR_SV

class generator;

dec_item item;
mailbox #(dec_item) gen2drv;
int loop_count = 1000;
int swerve = 1;

function new(mailbox #(dec_item) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run();
$display("[%0t] [GENERATOR] Starting stimulus generation...", $time);

repeat(loop_count-1) begin
item = new();

item.d = $urandom_range(OUT_WIDTH-1, 0);
if(swerve % (loop_count / 50) == 0) begin
item.en = 0;
end
else begin
item.en = 1;
end
++swerve;
gen2drv.put(item.copy());
end 

item = new();
item.d = 'x;
item.en = 1'bx;
gen2drv.put(item.copy());

$display("[GENERATOR] Finished generating %0d items.", loop_count);
endtask
endclass 

`endif