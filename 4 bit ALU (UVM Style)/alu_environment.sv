`ifndef ALU_ENVIRONMENT_SV
`define ALU_ENVIRONMENT_SV

import alu_pkg::*;

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
coverage_collector cov;

mailbox #(alu_item) gen2drv;
mailbox #(alu_item) mon2scb;
mailbox #(alu_item) mon2cov;

virtual alu_if vif;

function new(virtual alu_if vif);
this.vif = vif;

gen2drv = new();
mon2scb = new();
mon2cov = new();

gen = new(gen2drv);
drv = new(vif, gen2drv);
mon = new(vif, mon2scb, mon2cov);
cov = new(mon2cov);
scb = new(mon2scb);
endfunction

task test();

$display("[%0t] [ENVIRONMENT] Configuring environment variables...", $time);

fork
drv.run();
mon.run();
cov.run();
scb.run();
join_none

gen.run();
#100;

$display("\nFunctional Coverage: %0.2f%%", cov.alu_cg.get_inst_coverage());
$display("\n=====================================================");
$display("\n=====================================================");
$display("              FINAL VERIFICATION SUMMARY               ");
$display("\n=====================================================");
$display(" Total Passed: %0d", scb.pass_count);
$display(" Total Failed: %0d", scb.fail_count);
$display("\n=====================================================");
$display("\n=====================================================");

if(scb.fail_count == 0) begin
$display(">>>> SIMULATION PASSED <<<<");
end
else begin
$display(">>>> SIMULATION FAILED <<<<");
end

$finish;

endtask
endclass

`endif