`ifndef DECODER_ITEM_SV
`define DECODER_ITEM_SV

class dec_item;

logic [WIDTH-1:0] d;
logic en;

logic [OUT_WIDTH-1:0] y;

function void display(string tag = "ITEM");
$display("[%s] d=%0d | en=%0b | y=%b", tag, d, en, y);
endfunction

function dec_item copy();

dec_item cp = new();
cp.d = this.d;
cp.en = this.en;
cp.y = this.y;
return cp;

endfunction

endclass

`endif