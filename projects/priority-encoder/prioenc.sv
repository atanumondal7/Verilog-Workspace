`timescale 1ns/1ps

module prioenc #( parameter int WIDTH = 8, localparam int OUT_WIDTH = $clog2(WIDTH) ) (
input logic [WIDTH-1:0] req,
output logic [OUT_WIDTH-1:0] grant,
output logic valid
);

assign valid = |req;

always_comb begin
grant = '0;
for(int i=0;i<WIDTH;i++) begin
if(req[i]) begin
grant = OUT_WIDTH'(i);
end
end
end
endmodule