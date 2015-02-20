`include "cpu.vh"

module itlb(
	input wire clk,
	
	input wire [63:0] pc,
	output wire [31:0] itlbpa,
	input wire itlbreq,
	output wire itlbmiss,
	
	input wire [31:0] jtlbpa,
	input wire jtlbhit
);

endmodule
