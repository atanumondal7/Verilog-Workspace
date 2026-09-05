`timescale 1ns/1ps

module fifo #(parameter DATA_WIDTH = 8, parameter MEMORY_DEPTH = 16) (
input logic clk,
input logic rst,
input logic wr_en,
input logic rd_en,
input logic [DATA_WIDTH-1:0] din,
output logic [DATA_WIDTH-1:0] dout,
output logic empty,
output logic full,
output logic overflow_err,
output logic underflow_err
);

localparam PTR_WIDTH = $clog2(MEMORY_DEPTH);

logic [DATA_WIDTH-1:0] memory [0:MEMORY_DEPTH-1];
logic [PTR_WIDTH:0] w_ptr = '0;
logic [PTR_WIDTH:0] r_ptr = '0;

always_ff @(posedge clk) begin

if(rst) begin
w_ptr <= '0;
r_ptr <= '0;
dout <= '0;
overflow_err <= '0;
underflow_err <= '0;
end

else begin

overflow_err <= '0;
underflow_err <= '0;

if(wr_en && full) begin
overflow_err <= 1;
end

else if(wr_en && !full) begin
memory[w_ptr[PTR_WIDTH-1:0]] <= din;
w_ptr <= w_ptr + 1'b1;
end

if(rd_en && empty) begin
underflow_err <= 1;
end

else if(rd_en && !empty) begin
dout <= memory[r_ptr[PTR_WIDTH-1:0]];
r_ptr <= r_ptr + 1'b1;
end

end

end

assign empty = (w_ptr == r_ptr);

assign full = (w_ptr[PTR_WIDTH-1:0] == r_ptr[PTR_WIDTH-1:0] && w_ptr[PTR_WIDTH] != r_ptr[PTR_WIDTH]);

endmodule