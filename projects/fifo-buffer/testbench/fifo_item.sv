`ifndef FIFO_ITEM_SV
`define FIFO_ITEM_SV

class fifo_item;

logic rst;
logic wr_en;
logic rd_en;
logic [DATA_WIDTH-1:0] din;
logic [DATA_WIDTH-1:0] dout;
logic empty;
logic full;
logic overflow_err;
logic underflow_err;

function void display(string tag);
$display("[%s] rst=%0b  wr_en=%b  rd_en=%0b  din=%0d -> dout=%0d  empty=%0b  full=%0b  overflow_err=%0b  underflow_err=%0b",tag, rst, wr_en, rd_en, din, dout, empty, full, overflow_err, underflow_err);
endfunction

function fifo_item copy();
fifo_item cp = new();
cp.rst = this.rst;
cp.wr_en = this.wr_en;
cp.rd_en = this.rd_en;
cp.din = this.din;
cp.dout = this.dout;
cp.empty = this.empty;
cp.full = this.full;
cp.overflow_err = this.overflow_err;
cp.underflow_err = this.underflow_err;
return cp;
endfunction

endclass

`endif