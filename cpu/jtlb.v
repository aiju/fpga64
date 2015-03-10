`include "cpu.vh"

module jtlb(
	input wire clk,
	input wire phi1,
	input wire phi2,
	
	input wire [63:0] jtlbva,
	input wire jtlbreq,
	input wire jtlbwr,
	
	output reg [31:0] jtlbpa,
	output reg jtlbcache,
	output reg jtlbmiss,
	output reg jtlbade,
	output reg jtlbinval,
	output reg jtlbmod,
	
	input wire tlbr,
	input wire tlbwi,
	input wire tlbwr,
	input wire tlbp,
	
	input wire [31:0] cp0status,
	input wire [63:0] cp0entryhi,
	input wire [63:0] cp0entrylo0,
	input wire [63:0] cp0entrylo1,
	input wire [31:0] cp0pagemask,
	input wire [31:0] cp0index,
	input wire [4:0] cp0random,
	output reg cp0jtlbshut,
	output wire cp0setentryhi,
	
	output wire [63:0] cp0entryhi_,
	output wire [63:0] cp0entrylo0_,
	output wire [63:0] cp0entrylo1_,
	output wire [31:0] cp0pagemask_,
	output wire [31:0] cp0index_,
	
	input wire [1:0] mode,
	input wire mode64
);

`include "cpuconst.vh"

	localparam MASK = 205;
	localparam REG = 190;
	localparam VPN = 141;
	localparam GLOBAL = 140;
	localparam ASID = 128;
	localparam PFN = 6;
	localparam CACHE = 3;
	localparam DIRTY = 2;
	localparam VALID = 1;

	reg [255:0] tlbent[0:31];
	reg [31:0] tlbhit;
	reg [255:0] hitent;
	reg [4:0] hit;
	reg mapped, unmapped, cached, compat;

	wire [7:0] asid = cp0entryhi[7:0];
	wire [63:0] va = tlbp ? cp0entryhi : jtlbva;
	
	integer i;
	always @(*)
		for(i = 0; i < 32; i = i + 1)
			tlbhit[i] = ((tlbent[i][VPN+26:VPN] ^ va[39:13]) & {{8{mode64}}, 7'h3f, ~tlbent[i][MASK+11:MASK]}) == 0 &&
				(!mode64 || jtlbva[63:62] == tlbent[i][REG+1:REG]) &&
				(tlbent[i][GLOBAL] || tlbent[i][ASID+7:ASID] == asid);
	always @(*) begin
		hit = 5'bx;
		for(i = 31; i >= 0; i = i - 1)
			if(tlbhit[i])
				hit = i[4:0];
		if(tlbr)
			i = cp0index & 32'h1f;
		hitent = tlbent[i];
	end
	assign cp0index_ = {tlbhit == 0, 26'd0, hit};
	assign cp0pagemask_ = hitent[223:192];
	assign cp0entryhi_ = hitent[191:128];
	assign cp0entrylo1_ = hitent[127:64];
	assign cp0entrylo0_ = hitent[63:0];
	assign cp0setentryhi = tlbr || jtlbmiss || jtlbinval || jtlbmod;
	
	wire [12:0] mask = {hitent[MASK+11:MASK], 1'b0};
	wire [19:0] pfnmask = {8'h0, hitent[MASK+11:MASK]};
	wire half = (mask & ~(mask - 1) & jtlbva[24:12]) != 0;
	wire [63:0] entry = half ? hitent[127:64] : hitent[63:0];
	
	always @(*)
		if(jtlbreq) begin
			mapped = 0;
			unmapped = 0;
			cached = 0;
			compat = 1;
			case({mode, mode64})
			3'b100: mapped = jtlbva[63:31] == 0;
			3'b101: mapped = jtlbva[63:39] == 0;
			3'b010: mapped = jtlbva[63:31] == 0 || jtlbva[63:29] == 35'h7fffffffe;
			3'b011: mapped = jtlbva[63:39] == 0 || jtlbva[63:40] == 24'h400000 || jtlbva[63:29] == 35'h7fffffffe;
			3'b000: begin
				mapped = jtlbva[63:31] == 0 || ~jtlbva[63:30] == 0;
				unmapped = !mapped;
				cached = !jtlbva[29];
			end
			3'b001:
				casez(jtlbva)
				64'h00000000_zzzzzzzz, 64'h40000000_zzzzzzzz, 64'hc0000000_zzzzzzzz, {32'hffffffff, 4'b11zz, 28'bz}:
					mapped = 1;
				{1'b1, 63'bz}: begin
					unmapped = 1;
					compat = 0;
					cached = jtlbva[61:59] != 2;
				end
				{32'hffffffff, 4'b10zz, 28'bz}: begin
					unmapped = 1;
					cached = !jtlbva[29];
				end
				endcase
			default: jtlbade = 1;
			endcase
		end
	
	always @(*) begin
		jtlbcache = 0;
		jtlbmiss = 0;
		jtlbade = 0;
		jtlbmod = 0;
		jtlbinval = 0;
		cp0jtlbshut = 0;
		jtlbpa = 32'hx;
		if(jtlbreq) begin
			if(unmapped) begin
				jtlbpa = jtlbva[31:0];
				if(compat)
					jtlbpa[31:29] = 0;
				jtlbcache = cached;
			end else if(mapped)
				if(tlbhit == 0 || cp0status[TS])
					jtlbmiss = 1;
				else if((tlbhit & tlbhit - 1) != 0) begin
					jtlbmiss = 1;
					cp0jtlbshut = 1;
				end else begin
					jtlbpa = {entry[PFN+19:PFN] & ~pfnmask | jtlbva[31:12] & pfnmask, jtlbva[11:0]};
					jtlbinval = !entry[VALID];
					jtlbmod = !entry[DIRTY] && jtlbwr;
					jtlbcache = entry[CACHE+2:CACHE] != 2;
				end
			else
				jtlbade = 1;
		end
	end
	
	wire [4:0] wrtarg = tlbwr ? cp0random : cp0index[4:0];
	
	always @(posedge clk)
		if(phi2)
			if(tlbwr || tlbwi)
				tlbent[wrtarg] <= {39'd0, cp0pagemask[24:13], 13'd0,
					cp0entryhi[63:62], 22'd0, cp0entryhi[39:13], cp0entrylo0[0] && cp0entrylo1[0], 4'd0, cp0entryhi[7:0],
					38'd0, cp0entrylo1[25:1], 39'd0, cp0entrylo0[25:0]};

	initial
		for(i = 0; i < 32; i = i + 1)
			tlbent[i] = 0;
			

endmodule
