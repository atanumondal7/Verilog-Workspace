`ifndef FIFO_SCOREBOARD_SV
`define FIFO_SCOREBOARD_SV

class scoreboard;

mailbox #(fifo_item) mon2scb;
int pass_count = 0;
int fail_count = 0;

function new(mailbox #(fifo_item) mon2scb);
this.mon2scb = mon2scb;
endfunction

task run();
fifo_item item;
logic [DATA_WIDTH-1:0] exp_dout = '0;
logic exp_empty;
logic exp_full;
logic exp_overflow_err;
logic exp_underflow_err;

logic [DATA_WIDTH-1:0] memory [0:MEMORY_DEPTH-1];
logic [PTR_WIDTH:0] w_ptr = '0;
logic [PTR_WIDTH:0] r_ptr = '0;

$display("[SCOREBOARD] Calculating simulation results...");

forever begin
mon2scb.get(item);

if(item.rst) begin
w_ptr = '0;
r_ptr = '0;
exp_dout = '0;
exp_underflow_err = '0;
exp_overflow_err = '0;
end

else begin

exp_overflow_err = '0;
exp_underflow_err = '0;

if(item.wr_en && exp_full) begin
exp_overflow_err = 1;
end

else if(item.wr_en && !exp_full) begin
memory[w_ptr[PTR_WIDTH-1:0]] = item.din;
w_ptr = w_ptr + 1'b1;
end

if(item.rd_en && exp_empty) begin
exp_underflow_err = 1;
end

else if(item.rd_en && !exp_empty) begin
exp_dout = memory[r_ptr[PTR_WIDTH-1:0]];
r_ptr = r_ptr + 1'b1;
end
end

exp_empty = (w_ptr == r_ptr);
exp_full = (w_ptr[PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0] && w_ptr[PTR_WIDTH] != r_ptr[PTR_WIDTH]);

item.display("ITEM");

if(exp_dout === item.dout && exp_empty === item.empty && exp_full === item.full && exp_overflow_err === item.overflow_err && exp_underflow_err === item.underflow_err) begin
$display("[SCOREBOARD MATCH] rst=%0b, wr_en=%0b, rd_en=%0b, din=%0d -> dout=%0d, empty=%0b, full=%0b, overflow_err=%0b, underflow_err=%0b", item.rst, item.wr_en, item.rd_en, item.din, item.dout, item.empty, item.full, item.overflow_err, item.underflow_err);
pass_count++;
end
else begin
$display("[SCOREBOARD ERROR] rst=%0b, wr_en=%0b, rd_en=%0b, din=%0d -> Exp: dout=%0d, empty=%0b, full=%0b, overflow_err=%0b, underflow_err=%0b | Got: dout=%0d, empty=%0b, full=%0b, overflow_err=%0b, underflow_err=%0b", item.rst, item.wr_en, item.rd_en, item.din, exp_dout, exp_empty, exp_full, exp_overflow_err, exp_underflow_err, item.dout, item.empty, item.full, item.overflow_err, item.underflow_err);
fail_count++;
end
end
endtask
endclass

`endif