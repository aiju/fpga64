`include "cpu.vh"

module cache(
	input wire clk,
	input wire phi1,
	input wire phi2,
	
	input wire [63:0] pc,
	output reg [31:0] instr,
	output reg [20:0] itag,
	input wire icreq,
	input wire [31:0] itlbpa,
	input wire icfill,
	
	input wire [63:0] dcva,
	input wire [31:0] dcpa,
	output wire [63:0] dcdata,
	output wire [21:0] dctag,
	input wire [63:0] dcwdata,
	input wire [2:0] dcsz,
	input wire dcread,
	input wire dcwrite,
	input wire dcfill,
	
	input wire [31:0] extdata,
	output wire extreq,
	output wire extwr,
	output wire [2:0] extsz,
	input wire extack,
);

	reg [255:0] icdata[0:511];
	reg [20:0] ictag[0:511];

endmodule
