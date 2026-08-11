`ifndef DECODER_COVERAGE_SV
`define DECODER_COVERAGE_SV

class coverage;

dec_item item;
mailbox #(dec_item) mon2cov;
int c1[OUT_WIDTH];
int en_cover;
int ren_c;

function new(mailbox #(dec_item) mon2cov);
this.mon2cov = mon2cov;
endfunction

task run();

for(int i=0;i<OUT_WIDTH;i++) begin
c1[i] = 0;
end

$display("[%0t] [COVERAGE] Coverage collector started ...", $time);

forever begin
mon2cov.get(item);

if(!item.en && |item.d) begin ren_c = 1; end
if(item.en) begin c1[item.d]++; en_cover = 1; end

end
endtask
endclass

`endif