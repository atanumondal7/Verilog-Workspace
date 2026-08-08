`ifndef ALU_COVERAGE_SV
`define ALU_COVERAGE_SV

import alu_pkg::*;

class coverage_collector;

alu_item item;
mailbox #(alu_item) mon2cov;

covergroup alu_cg;
option.per_instance = 1;

cp_a: coverpoint item.a {
bins max = {'1};
bins min = {'0};
bins others = default;
}

cp_b: coverpoint item.b {
bins max = {'1};
bins min = {'0};
bins others = default;
}

cp_opcode: coverpoint item.opcode {
bins all[] = {0, 1, 2, 3};
}

cp_y: coverpoint item.y {
bins max = {'1};
bins min = {'0};
bins others = default;
}

cp_neg_flag: coverpoint item.neg_flag {
bins active = {1};
}

cp_zero_flag: coverpoint item.zero_flag {
bins active = {1};
}

cp_carry_out: coverpoint item.carry_out {
bins active = {1};
}

X_cout_zero: cross cp_zero_flag, cp_carry_out;

X_y_cout: cross cp_y, cp_carry_out {
ignore_bins ignore = binsof(cp_y.others);
}
X_a_b_opcode: cross cp_a, cp_b, cp_opcode {
ignore_bins ignore = binsof(cp_opcode) intersect{2'b10, 2'b11} && binsof(cp_a.others) && binsof(cp_b.others);
}

endgroup

function new(mailbox #(alu_item) mon2cov);
this.mon2cov = mon2cov;
alu_cg = new();
endfunction

task run();

$display("[%0t] [COVERAGE] Collecting coverage data...", $time);

forever begin
mon2cov.get(item);
alu_cg.sample();
end
endtask
endclass

`endif