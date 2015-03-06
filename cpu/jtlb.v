`include "cpu.vh"

module jtlb(
	input wire clk,
	
	input wire [63:0] jtlbva,
	input wire jtlbreq,
	output wire jtlbmiss,
	
	output wire [31:0] jtlbpa,
	output wire jtlbhit,
	output wire jtlbdirty,
	output wire jtlbcache
);

`include "cpuconst.vh"

	localparam MASK = 205;
	localparam REG = 190;
	localparam VPN = 141;
	localparam GLOBAL = 140;
	localparam ASID = 128;

	reg [255:0] tlbent[0:31];
	
	integer i;
	always @(*)
		for(i = 0; i < 32; i = i + 1) begin
			if(jtlbreq && 

endmodule
