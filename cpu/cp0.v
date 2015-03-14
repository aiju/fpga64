`include "cpu.vh"

module cp0(
	input wire clk,
	input wire phi1,
	input wire phi2,
	input wire stall,
	
	input wire [4:0] cp0raddr,
	output reg [63:0] cp0rdata,
	input wire [4:0] cp0waddr,
	input wire [63:0] cp0wdata,
	input wire cp0write,

	output reg [31:0] cp0status,
	output reg [31:0] cp0config,
	output reg [31:0] cp0cause,
	output reg [63:0] cp0epc,
	output reg [63:0] cp0errorepc,
	input wire cp0setexl,
	input wire [5:0] cp0setexccode,
	input wire [65:0] cp0setepc,
	input wire cp0coldreset,
	input wire cp0softreset,
	input wire cp0eret,
	input wire cp0setbadva,
	input wire cp0setcontext,
	input wire cp0llset,
	input wire [63:0] jtlbva,
	input wire [31:0] jtlbpa,
	
	output reg [31:0] cp0taglo,
	input wire [31:0] cp0taglodcval,
	input wire cp0taglodcset,
	input wire [31:0] cp0tagloicval,
	input wire cp0tagloicset,

	output reg [4:0] cp0random,
	output reg [31:0] cp0index,
	
	output reg [63:0] cp0entryhi,
	output reg [63:0] cp0entrylo0,
	output reg [63:0] cp0entrylo1,
	output reg [31:0] cp0pagemask,
	input wire cp0jtlbshut,
	input wire cp0setentryhi,
	
	input wire [63:0] cp0entryhi_,
	input wire [63:0] cp0entrylo0_,
	input wire [63:0] cp0entrylo1_,
	input wire [31:0] cp0pagemask_,
	input wire [31:0] cp0index_,
	
	input wire tlbp,
	input wire tlbr,
	input wire tlbwi,
	input wire tlbwr
);

`include "cpuconst.vh"

	reg [31:0] cp0count, cp0compare;
	reg [63:0] badva;
	reg countdiv;
	reg cp0random5;
	reg [5:0] cp0wired;
	reg [31:0] cp0lladdr;
	reg [63:0] cp0context, cp0xcontext;
	
	always @(*)
		case(cp0raddr)
		0: cp0rdata = {32'd0, cp0index};
		1: cp0rdata = {58'd0, cp0random5, cp0random};
		2: cp0rdata = cp0entrylo0;
		3: cp0rdata = cp0entrylo1;
		4: cp0rdata = cp0context;
		5: cp0rdata = {32'd0, cp0pagemask};
		6: cp0rdata = {58'd0, cp0wired};
		8: cp0rdata = badva;
		9: cp0rdata = {32'b0, cp0count};
		10: cp0rdata = cp0entryhi;
		11: cp0rdata = {32'b0, cp0compare};
		12: cp0rdata = {32'b0, cp0status};
		13: cp0rdata = {32'b0, cp0cause};
		14: cp0rdata = cp0epc;
		15: cp0rdata = {48'd0, 16'h0B00};
		17: cp0rdata = {32'd0, cp0lladdr};
		28: cp0rdata = {32'b0, cp0taglo};
		30: cp0rdata = cp0errorepc;
		default: cp0rdata = 0;
		endcase

	always @(posedge clk)
		if(phi2) begin
		
			countdiv <= !countdiv;
			if(countdiv)
				cp0count <= cp0count + 1;
			if(cp0count == cp0compare)
				cp0cause[IP+7] <= 1;
			
			if(cp0setexl)
				cp0status[EXL] <= 1;
			if(cp0coldreset || cp0softreset) begin
				cp0status[RP] <= 0;
				cp0status[BEV] <= 1;
				cp0status[TS] <= 0;
				cp0status[SR] <= cp0softreset;
				cp0status[ERL] <= 1;
				cp0errorepc <= cp0setepc[63:0];
			end
			if(cp0coldreset) begin
				cp0config[BE] <= 1;
				cp0random <= 31;
				cp0wired <= 0;
				cp0config[EP+3:EP] <= 0;
			end
			if(cp0jtlbshut)
				cp0status[TS] <= 1;
			if(cp0setexccode[5])
				cp0cause[6:2] <= cp0setexccode[4:0];
			if(cp0setepc[65]) begin
				cp0epc <= cp0setepc[63:0];
				cp0cause[BD] <= cp0setepc[64];
			end
			if(cp0taglodcset)
				cp0taglo <= cp0taglodcval;
			if(cp0tagloicset)
				cp0taglo <= cp0tagloicval;
			if(cp0eret)
				if(cp0status[ERL])
					cp0status[ERL] <= 0;
				else
					cp0status[EXL] <= 0;
			if(tlbp)
				cp0index <= cp0index_;
			if(tlbr) begin
				cp0entrylo0 <= cp0entrylo0_;
				cp0entrylo1 <= cp0entrylo1_;
				cp0pagemask <= cp0pagemask_;
			end
			if(cp0setentryhi)
				cp0entryhi <= cp0entryhi_;
			if(!stall)
				if(cp0random == cp0wired[4:0])
					cp0random <= 31;
				else
					cp0random <= cp0random - 1;
			if(cp0setbadva)
				badva <= jtlbva;
			if(cp0setcontext) begin
				cp0context[22:4] <= jtlbva[31:13];
				cp0xcontext[32:31] <= jtlbva[63:62];
				cp0xcontext[30:4] <= jtlbva[39:13];
			end
			if(cp0llset && !stall)
				cp0lladdr <= jtlbpa;
			if(cp0write)
				case(cp0waddr)
				0: cp0index <= cp0wdata[31:0] & 32'h8000003f;
				1: begin
					cp0random5 <= cp0wdata[5];
					cp0random <= cp0wdata[4:0];
				end
				2: cp0entrylo0 <= cp0wdata & 64'h3fffffff;
				3: cp0entrylo1 <= cp0wdata & 64'h3fffffff;
				4: cp0context <= cp0wdata & ~64'h4;
				5: cp0pagemask <= cp0wdata[31:0] & 32'h01ffe000;
				6: begin
					cp0wired <= cp0wdata[5:0];
					cp0random <= 31;
				end
				9: cp0count <= cp0wdata[31:0];
				10: cp0entryhi <= cp0wdata & 64'hc00000ffffffe000;
				11: begin
					cp0compare <= cp0wdata[31:0];
					cp0cause[IP+7] <= 0;
				end
				12: cp0status <= cp0wdata[31:0];
				13: cp0cause[9:8] <= cp0wdata[9:8];
				14: cp0epc <= cp0wdata;
				16: cp0config <= cp0wdata[31:0] & 32'h0f00800f | 32'h00066460;
				17: cp0lladdr <= cp0wdata[31:0];
				20: cp0xcontext <= cp0wdata & ~64'hf;
				28: cp0taglo <= cp0wdata[31:0] & 32'h0fffffc0;
				30: cp0errorepc <= cp0wdata;
				endcase
		end
	
	initial begin
		cp0status = 0;
		cp0config = 0;
		cp0entryhi = 0;
	end

endmodule
