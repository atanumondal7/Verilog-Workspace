`ifndef PRIOENC_ITEM_SV
`define PRIOENC_ITEM_SV

class prioenc_item;

bit [WIDTH-1:0] req;

bit [OUT_WIDTH-1:0] grant;
bit valid;

function void display(string tag = "ITEM");
$display("[%s] req=%b | grant=%0d | valid=%0b", tag, req, grant, valid);
endfunction

function prioenc_item copy();

prioenc_item cp = new();
cp.req = this.req;
cp.grant = this.grant;
cp.valid = this.valid;
return cp;

endfunction

endclass

`endif