`ifndef PRIOENC_COVERAGE_SV
`define PRIOENC_COVERAGE_SV

class coverage_collector;

prioenc_item item;
mailbox #(prioenc_item) mon2cov;
int check_1[WIDTH];
int check_2[2] = '{0, 0};
int max = 0;
int min = 0;

function new(mailbox #(prioenc_item) mon2cov);
this.mon2cov = mon2cov;
endfunction

task run();

for(int i=0;i<WIDTH;i++) begin
check_1[i] = 0;
end

$display("[%0t] [COVERAGE] Coverage collector started ...", $time);

forever begin

mon2cov.get(item);

check_1[item.grant]++;
check_2[item.valid]++;

if(item.req == '1) begin max = 1; end
if(item.req == '0) begin min = 1; end
end
endtask
endclass

`endif