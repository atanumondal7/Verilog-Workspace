`ifndef ALU_SCOREBOARD_SV
`define ALU_SCOREBOARD_SV

import alu_pkg::*;

class scoreboard;

mailbox #(alu_item) mon2scb;
int pass_count = 0;
int fail_count = 0;

function new(mailbox #(alu_item) mon2scb);
this.mon2scb = mon2scb;
endfunction

task run();
alu_item item;

$display("[%0t] [SCOREBOARD] Starting up scoreboard...", $time);

forever begin

mon2scb.get(item);

logic [WIDTH-1:0] exp_y = '0;
logic exp_neg_flag = 0;
logic exp_zero_flag = 0;
logic exp_carry_out = 0;

case(item.opcode);

2'b00: begin
{exp_carry_out, exp_y} = item.a + item.b;
end

2'b01: begin
if(item.a>=item.b) begin
exp_y = item.a - item.b;
end
else begin
exp_y = item.a - item.b;
exp_neg_flag = 1'b1;
end
end

2'b10: begin
exp_y = item.a & item.b;
end

2'b11: begin
exp_y = item.a | item.b;
end

default: exp_y = '0;

endcase

if(exp_y == '0) begin
exp_zero_flag = 1'b1;
end

item.display("ITEM");

if(exp_y === item.y && exp_neg_flag === item.neg_flag && exp_zero_flag === item.zero_flag && exp_carry_out === item.carry_out) begin
$display("[SCOREBOARD] |SUCCESS| a=%0d, b=%0d, opcode=%0d -> y=%0d, neg_flag=%0d, zero_flag=%0d, carry_out=%0d", item.a, item.b, item.opcode, item.y, item.neg_flag, item.zero_flag, item.carry_out);
pass_count++;
end
else begin
$display("[SCOREBOARD] |ERROR| a=%0d, b=%0d, opcode=%0d -> Expected: y=%0d, neg_flag=%0d, zero_flag=%0d, carry_out=%0d | Got: y=%0d, neg_flag=%0d, zero_flag=%0d, carry_out=%0d", item.a, item.b, item.opcode, exp_y, exp_neg_flag, exp_zero_flag, exp_carry_out, item.y, item.neg_flag, item.zero_flag, item.carry_out);
fail_count++;
end

end 
endtask
endclass

`endif