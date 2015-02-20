`include "cpu.vh"

module jtlb(
	input wire clk,
	
	input wire [63:0] jtlbva,
	input wire jtlbreq,
	
	output wire [63:0] jtlbpa,
	output wire jtlbhit,
	output wire jtlbdirty,
	output wire jtlbcache,
	
	input wire [4:0] cp0addr,
	output wire [31:0] cp0data,
	input wire [31:0] cp0wdata,
	input wire cp0req
);

endmodule
