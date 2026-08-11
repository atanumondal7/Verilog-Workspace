`ifndef PRIOENC_ENVIRONMENT_SV
`define PRIOENC_ENVIRONMENT_SV

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
coverage_collector cov;

mailbox #(prioenc_item) gen2drv;
mailbox #(prioenc_item) mon2scb;
mailbox #(prioenc_item) mon2cov;

virtual prioenc_if vif;

function new(virtual prioenc_if vif);
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

int c1 = 0;
int c2 = 0;
int c3 = 0;
$display("[%0t] [ENVIRONMENT] Configuring environment variables...", $time);

fork
drv.run();
mon.run();
scb.run();
cov.run();
join_none

gen.run();
wait(scb.pass_count + scb.error_count == gen.loop_count);
#20;

for(int i=0;i<WIDTH;i++) begin
if(cov.check_1[i] > 0) begin c1++; end
end

if(cov.check_2[0] > 0) begin c2++; end
if(cov.check_2[1] > 0) begin c2++; end

if(c1 == WIDTH) begin c3++; end
if(c2 == 2) begin c3++; end
if(cov.max) begin c3++; end
if(cov.min) begin c3++; end

$display("===================================================");
$display("               COVERAGE SUMMARY                    ");
$display("===================================================");
$display(" Grant cover: %0d/%0d, %0.2f%%", c1, WIDTH, (c1*100)/WIDTH);
$display(" Valid cover: %0d/%0d, %0.2f%%", c2, 2, (c2*100)/2);
$display(" Hot Req: %0s", (cov.max)? "Covered" : "Not Covered");
$display(" Cold Req: %0s", (cov.min)? "Covered" : "Not Covered");
$display("===================================================");
$display(" Total Coverage: %0.2f%%", (c3*100)/4);
$display("===================================================");
$display("            FINAL VERIFICATION SUMMARY             ");
$display("===================================================");
$display(" Total Passed: %0d", scb.pass_count);
$display(" Total Failed: %0d", scb.error_count);
$display("===================================================");

if(scb.error_count==0) begin
$display(">>>> TEST PASSED <<<<");
end 
else begin
$display(">>>> TEST FAILED <<<<");
end

$finish;

endtask

endclass

`endif