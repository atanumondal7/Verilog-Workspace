`ifndef USR_GENERATOR_SV
`define USR_GENERATOR_SV

class generator;

mailbox #(usr_item) gen2drv;
int loop_count = 5000;
int swerve = 1;

function new(mailbox #(usr_item) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run();
usr_item item;

$display("[GENERATOR] Generating stimulus for DUT...");

repeat(loop_count) begin

item = new();

if(swerve%10 == 0) begin item.rst = 1; end
else begin item.rst = 0; end

item.mode = $urandom_range(3, 0);
item.s_in_l = $urandom_range(1, 0);
item.s_in_r = $urandom_range(1, 0);
item.p_in = $urandom_range((1 << WIDTH)-1, 0);

gen2drv.put(item.copy());

++swerve;

end
endtask
endclass

`endif