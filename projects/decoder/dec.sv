`timescale 1ns/1ps

module dec #(parameter int WIDTH = 3, localparam int OUT_WIDTH = 2**WIDTH) (
input logic [(WIDTH-1):0] d,
input logic en,
output logic [OUT_WIDTH-1:0] y
);

always_comb begin

y = en ? (OUT_WIDTH'(1) << d) : '0;

end

endmodule