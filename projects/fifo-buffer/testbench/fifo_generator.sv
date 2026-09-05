`ifndef FIFO_GENERATOR_SV
`define FIFO_GENERATOR_SV

class generator;

mailbox #(fifo_item) gen2drv;
int loop_count = 1000;
int swerve = 1;
int rd = 0;
int csr = 1;

function new(mailbox #(fifo_item) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run();
fifo_item item;

$display("[GENERATOR] Generating stimulus for DUT...");

item = new();
item.rst = 1;
item.wr_en = 0;
item.rd_en = 0;
item.din = 0;
gen2drv.put(item.copy());

item = new();
item.rst = 1;
item.wr_en = 0;
item.rd_en = 0;
item.din = 0;
gen2drv.put(item.copy());

item = new();
item.rst = 0;
item.wr_en = 0;
item.rd_en = 1;
item.din = 0;
gen2drv.put(item.copy());

repeat(loop_count-3) begin

item = new();

item.wr_en = 1;
if(rd >= 20 && csr == 1) begin item.rd_en = 1; end
else begin item.rd_en = 0; end
item.din = $urandom_range((1 << DATA_WIDTH)-1, 0);

if(swerve%20 == 0) begin item.rst = 1; csr = 0; end
else begin item.rst = 0; csr = 1; end

gen2drv.put(item.copy());

++rd;
++swerve;

end
endtask
endclass

`endif