`include "cpu.vh"

module jtlb(
	input wire clk,
	
	input wire [63:0] jtlbva,
	input wire jtlbreq,
	
	output wire [63:0] jtlbpa,
	output wire jtlbhit,
	output wire jtlbdirty,
	output wire jtlbcache
);

endmodule
