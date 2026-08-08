`ifndef USR_COVERAGE_SV
`define USR_COVERAGE_SV

class coverage;

mailbox #(usr_item) mon2cov;

function new(mailbox #(usr_item) mon2cov);
this.mon2cov = mon2cov;
endfunction

int crst = 0;
int cmode[3:0];
int c_s_in_l = 0;
int c_s_in_r = 0;
int c_p_in[(1 << WIDTH)-1:0];
int c_p_out[(1 << WIDTH)-1:0];
localparam int ccount = 46;
int c[ccount];

task run();
usr_item item;

for(int i=0;i<4;i++) begin cmode[i] = 0; end 
for(int i=0;i<(1 << WIDTH);i++) begin c_p_in[i] = 0; end
for(int i=0;i<(1 << WIDTH);i++) begin c_p_out[i] = 0; end
for(int i=0;i<ccount;i++) begin c[i] = 0; end

$display("[COVERAGE] Collecting coverage data...");

forever begin
mon2cov.get(item);

if(item.rst) begin crst = 1; end
for(int i=0;i<4;i++) begin cmode[i]++; end
if(item.s_in_l) begin c_s_in_l = 1; end
if(item.s_in_r) begin c_s_in_r = 1; end
c_p_in[item.p_in]++;
c_p_out[item.p_out]++;
if (item.rst == 1'b1 && item.mode == 2'b00) begin c[0]  = 1; end
if (item.rst == 1'b1 && item.mode == 2'b01) begin c[1]  = 1; end
if (item.rst == 1'b1 && item.mode == 2'b10) begin c[2]  = 1; end
if (item.rst == 1'b1 && item.mode == 2'b11) begin c[3]  = 1; end
if (item.rst == 1'b0 && item.mode == 2'b00 && item.p_in == 4'b1111) begin c[4] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b00 && item.p_in == 4'b0000) begin c[5] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b00 && item.s_in_r == 1'b1 && item.s_in_l == 1'b1) begin c[6] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_r == 1'b0) begin c[7] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_r == 1'b1) begin c[8] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_r == 1'b1 && item.s_in_l == 1'b1) begin c[9] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b10 && item.s_in_l == 1'b0) begin c[10] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b10 && item.s_in_l == 1'b1) begin c[11] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b10 && item.s_in_l == 1'b1 && item.s_in_r == 1'b1) begin c[12] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1111) begin c[13] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0000) begin c[14] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1010) begin c[15] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0101) begin c[16] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0001) begin c[17] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1000) begin c[18] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0110) begin c[19] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1001) begin c[20] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0011) begin c[21] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1100) begin c[22] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0111) begin c[23] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1110) begin c[24] = 1; end 
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0010) begin c[25] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b0100) begin c[26] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1011) begin c[27] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.p_in == 4'b1101) begin c[28] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_r == 1'b0 && item.s_in_l == 1'b0) begin c[29] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.s_in_l == 1'b1 && item.s_in_r == 1'b1 && item.p_in == 4'b1111) begin c[30] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.s_in_l == 1'b0 && item.s_in_r == 1'b0 && item.p_in == 4'b0000) begin c[31] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_l == 1'b1 && item.s_in_r == 1'b1 && item.p_in == 4'b1010) begin c[32] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b10 && item.s_in_l == 1'b0 && item.s_in_r == 1'b0 && item.p_in == 4'b0101) begin c[33] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b00 && item.s_in_l == 1'b1 && item.s_in_r == 1'b0 && item.p_in == 4'b1001) begin c[34] = 1; end
if (item.rst == 1'b1 && item.mode == 2'b11 && item.s_in_l == 1'b1 && item.s_in_r == 1'b1 && item.p_in == 4'b0110) begin c[35] = 1; end
if (item.rst == 1'b1 && item.mode == 2'b11 && item.s_in_l == 1'b1 && item.s_in_r == 1'b0 && item.p_in == 4'b0101) begin c[36] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_l == 1'b1 && item.s_in_r == 1'b0 && item.p_in == 4'b0001) begin c[37] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b10 && item.s_in_l == 1'b0 && item.s_in_r == 1'b1 && item.p_in == 4'b1110) begin c[38] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b00 && item.s_in_l == 1'b0 && item.s_in_r == 1'b1 && item.p_in == 4'b1010) begin c[39] = 1; end
if (item.rst == 1'b1 && item.mode == 2'b01 && item.s_in_l == 1'b0 && item.s_in_r == 1'b1 && item.p_in == 4'b1100) begin c[40] = 1; end
if (item.rst == 1'b1 && item.mode == 2'b10 && item.s_in_l == 1'b1 && item.s_in_r == 1'b0 && item.p_in == 4'b1111) begin c[41] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b11 && item.s_in_l == 1'b1 && item.s_in_r == 1'b0 && item.p_in == 4'b1010) begin c[42] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b01 && item.s_in_l == 1'b0 && item.s_in_r == 1'b1 && item.p_in == 4'b1111) begin c[43] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b10 && item.s_in_l == 1'b1 && item.s_in_r == 1'b0 && item.p_in == 4'b0000) begin c[44] = 1; end
if (item.rst == 1'b0 && item.mode == 2'b00 && item.s_in_l == 1'b1 && item.s_in_r == 1'b1 && item.p_in == 4'b0100) begin c[45] = 1; end

end
endtask
endclass

`endif