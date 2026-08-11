`ifndef DECODER_ENVIRONMENT_SV
`define DECODER_ENVIRONMENT_SV

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
coverage cov;

mailbox #(dec_item) gen2drv;
mailbox #(dec_item) mon2scb;
mailbox #(dec_item) mon2cov;

virtual dec_if vif;

function new(virtual dec_if vif);
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

int tcover = 0;
int d_cover = 0;
int a_cover = 0;
$display("[%0t] [ENVIRONMENT] Configuring environment variables...", $time);

fork
drv.run();
mon.run();
scb.run();
cov.run();
join_none

gen.run();
wait(scb.pass_count + scb.fail_count == gen.loop_count);
#20;

tcover = OUT_WIDTH + 2;

for(int i=0;i<OUT_WIDTH;i++) begin
if(cov.c1[i] > 0) begin d_cover++; end
end

a_cover = d_cover + cov.en_cover + cov.ren_c; 

$display("===================================================");
$display("               COVERAGE SUMMARY                    ");
$display("===================================================");
$display(" Enable Cover: %0s", (cov.en_cover)? "Covered" : "Not Covered");
$display(" Disable Cover: %0s", (cov.ren_c)? "Covered" : "Not Covered");
$display(" Input Cover with Enable: %0d/%0d, %0.2f%%", d_cover, OUT_WIDTH, real'( (d_cover * 100) / OUT_WIDTH ));
;
$display("===================================================");
$display(" Total Coverage: %0.2f%%", real'((a_cover*100)/tcover));
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