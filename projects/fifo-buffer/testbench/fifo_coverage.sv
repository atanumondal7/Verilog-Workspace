`ifndef FIFO_COVERAGE_SV
`define FIFO_COVERAGE_SV

class coverage;

mailbox #(fifo_item) mon2cov;

function new(mailbox #(fifo_item) mon2cov);
this.mon2cov = mon2cov;
endfunction

int crst = 0;
int c_wr_en = 0;
int c_rd_en = 0;
int c_din = 0;
int c_dout = 0;
int c_empty = 0;
int c_full = 0;
int c_overflow_err = 0;
int c_underflow_err = 0;

task run();
fifo_item item;

$display("[COVERAGE] Collecting coverage data...");

forever begin
mon2cov.get(item);

if(item.rst) begin crst = 1; end
if(item.wr_en) begin c_wr_en = 1; end
if(item.rd_en) begin c_rd_en = 1; end
if(|item.din) begin c_din = 1; end
if(!item.dout) begin c_dout = 1; end
if(item.empty) begin c_empty = 1; end
if(item.full) begin c_full = 1; end
if(item.overflow_err) begin c_overflow_err = 1; end
if(item.underflow_err) begin c_underflow_err = 1; end

end
endtask
endclass

`endif