`ifndef USR_ITEM_SV
`define USR_ITEM_SV

class usr_item;

bit rst;
bit [1:0] mode;
bit s_in_l;
bit s_in_r;
bit [WIDTH-1:0] p_in;
bit [WIDTH-1:0] p_out;

function void display(string tag);
$display("[%s] rst=%0b  mode=%b  s_in_l=%0b  s_in_r=%0b  p_in=%b -> p_out=%b", tag, rst, mode, s_in_l, s_in_r, p_in, p_out);
endfunction

function usr_item copy();
usr_item cp = new();
cp.rst = this.rst;
cp.mode = this.mode;
cp.s_in_l = this.s_in_l;
cp.s_in_r = this.s_in_r;
cp.p_in = this.p_in;
cp.p_out = this.p_out;
return cp;
endfunction

endclass

`endif