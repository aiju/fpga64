`include "cpu.vh"

module itlb(
	input wire clk,
	input wire phi1,
	input wire phi2,
	
	input wire [63:0] pc,
	output wire [31:0] itlbpa,
	input wire itlbreq,
	output wire itlbmiss,
	input wire itlbfill,
	output wire itlbbusy,
	output wire itlbcache,
	
	input wire [31:0] jtlbpa,
	input wire jtlbmiss,
	input wire jtlbade,
	input wire jtlbinval,
	input wire jtlbcache
);

	reg [1:0] valid;
	reg [51:0] va[0:1];
	reg [19:0] pa[0:1];
	reg [1:0] cached;
	wire [1:0] hit;
	reg lru, fill0, fill1;
	
	assign hit[0] = valid[0] && pc[63:12] == va[0];
	assign hit[1] = valid[1] && pc[63:12] == va[1];
	assign itlbpa = {hit[0] ? pa[0] : pa[1], pc[11:0]};
	assign itlbmiss = !hit[0] && !hit[1];
	assign itlbcache = hit[0] ? cached[0] : cached[1];
	always @(posedge clk) begin
		if(phi1)
			fill1 <= fill0;
		if(phi2) begin
			if(itlbreq) begin
				if(hit[0])
					lru <= 1;
				if(hit[1])
					lru <= 0;
			end
			fill0 <= itlbfill;
			if(fill0 && !(jtlbmiss || jtlbade || jtlbinval)) begin
				valid[lru] <= 1;
				va[lru] <= pc[63:12];
				pa[lru] <= jtlbpa[31:12];
				cached[lru] <= jtlbcache;
			end
		end
	end
	assign itlbbusy = fill0 || fill1;
	
	initial begin
		valid[0] = 0;
		valid[1] = 0;
		lru = 0;
	end

endmodule
