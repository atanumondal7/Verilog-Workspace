`ifndef ALU_ITEM_SV
`define ALU_ITEM_SV

import alu_pkg::*;

class alu_item;

rand bit [WIDTH-1:0] a;
rand bit [WIDTH-1:0] b;
rand bit [1:0] opcode;

bit [WIDTH-1:0] y;
bit neg_flag;
bit zero_flag;
bit carry_out;

constraint distr {
opcode dist{2'b00 := 40, 2'b01 := 30, 2'b10 := 15, 2'b11 := 15};
}

function void display(string tag);
$display("[%s] Inputs: a=%0d, b=%0d, opcode=%0d | Outputs: y=%0d, neg_flag=%0b, zero_flag=%0b, carry_out=%0b", tag, a, b, opcode, y, neg_flag, zero_flag, carry_out);
endfunction

function alu_item copy();
alu_item cp = new();
cp.a = this.a;
cp.b = this.b;
cp.opcode = this.opcode;
cp.y = this.y;
cp.neg_flag = this.neg_flag;
cp.zero_flag = this.zero_flag;
cp.carry_out = this.carry_out;
return cp;
endfunction

endclass
`endif