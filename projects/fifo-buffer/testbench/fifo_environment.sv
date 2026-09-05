`ifndef FIFO_ENVIRONMENT_SV
`define FIFO_ENVIRONMENT_SV

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
coverage cov;

mailbox #(fifo_item) gen2drv;
mailbox #(fifo_item) mon2scb;
mailbox #(fifo_item) mon2cov;

virtual fifo_if vif;

function new(virtual fifo_if vif);
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
int ccount = 0;
int tcount = 9;

$display("[ENVIRONMENT] Configuring environment variables...");

fork
drv.run();
mon.run();
cov.run();
scb.run();
join_none

gen.run();
wait(scb.pass_count + scb.fail_count == gen.loop_count);
#20;

ccount = cov.crst + cov.c_wr_en + cov.c_rd_en + cov.c_din + cov.c_dout + cov.c_empty + cov.c_full + cov.c_overflow_err + cov.c_underflow_err;

$display("===================================================");
$display("               COVERAGE SUMMARY                    ");
$display("===================================================");
$display(" Reset Cover: %0s", (cov.crst)? "Covered" : "Not Covered");
$display(" Write Enable Cover: %0s", (cov.c_wr_en)? "Covered" : "Not Covered");
$display(" Read Enable Cover: %0s", (cov.c_rd_en)? "Covered" : "Not Covered");
$display(" Data Input Cover: %0s", (cov.c_din)? "Covered" : "Not Covered");
$display(" Data Output Cover: %0s", (cov.c_dout)? "Covered" : "Not Covered");
$display(" Empty Cover: %0s", (cov.c_empty)? "Covered" : "Not Covered");
$display(" Full Cover: %0s", (cov.c_full)? "Covered" : "Not Covered");
$display(" Overflow Error Cover: %0s", (cov.c_overflow_err)? "Covered" : "Not Covered");
$display(" Underflow Error Cover: %0s", (cov.c_underflow_err)? "Covered" : "Not Covered");
$display("===================================================");
$display(" Total Coverage: %0.2f%%", (real'(ccount)*100)/tcount);
$display("===================================================");
$display("            FINAL VERIFICATION SUMMARY             ");
$display("===================================================");
$display(" Total Passed: %0d", scb.pass_count);
$display(" Total Failed: %0d", scb.fail_count);
$display("===================================================");

if(scb.fail_count==0) begin
$display(">>>> SIMULATION PASSED <<<<");
end 
else begin
$display(">>>> SIMULATION FAILED <<<<");
end

$finish;

endtask

endclass

`endif