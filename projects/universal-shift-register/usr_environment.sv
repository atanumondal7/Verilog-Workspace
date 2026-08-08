`ifndef USR_ENVIRONMENT_SV
`define USR_ENVIRONMENT_SV

class environment;

generator gen;
driver drv;
monitor mon;
scoreboard scb;
coverage cov;

mailbox #(usr_item) gen2drv;
mailbox #(usr_item) mon2scb;
mailbox #(usr_item) mon2cov;

virtual usr_if vif;

function new(virtual usr_if vif);
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
int c4 = 0;
int c5 = 0;
int c6 = 0;
int tcount = 0;

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

for(int i=0;i<4;i++) begin
if(cov.cmode[i] > 0) begin c1++; end
end

for(int i=0;i<(1 << WIDTH);i++) begin
if(cov.c_p_in[i] > 0) begin c2++; end
end

for(int i=0;i<(1 << WIDTH);i++) begin
if(cov.c_p_out[i] > 0) begin c4++; end
end

for(int i=0;i<cov.ccount;i++) begin
c5 = c5 + cov.c[i];
end

if(cov.crst) begin c3++; end
if(cov.c_s_in_l) begin c3++; end
if(cov.c_s_in_r) begin c3++; end
c6 = c1 + c2 + c3 + c4 + c5;
tcount = 7 + cov.ccount + 2*(2**WIDTH);

$display("===================================================");
$display("               COVERAGE SUMMARY                    ");
$display("===================================================");
$display(" Reset Cover: %0s", (cov.crst)? "Covered" : "Not Covered");
$display(" Mode Cover: %0d/%0d, %0.2f%%", c1, 4, (real'(c1)*100)/4);
$display(" S_In Left Cover: %0s", (cov.c_s_in_l)? "Covered" : "Not Covered");
$display(" S_In Right Cover: %0s", (cov.c_s_in_r)? "Covered" : "Not Covered");
$display(" P_In Cover: %0d/%0d, %0.2f%%", c2, (1 << WIDTH), (real'(c2)*100)/(1 << WIDTH));
$display(" P_Out Cover: %0d/%0d, %0.2f%%", c4, (1 << WIDTH), (real'(c4)*100)/(1 << WIDTH));
$display(" Other(s) Cover: %0d/%0d, %0.2f%%", c5, cov.ccount, (real'(c5)*100)/cov.ccount);
$display("===================================================");
$display(" Total Coverage: %0.2f%%", (real'(c6)*100)/tcount);
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