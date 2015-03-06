`include "cpu.vh"

module cp0(
	input wire clk,
	input wire phi1,
	input wire phi2,
	
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
	
	output reg [31:0] cp0taglo,
	input wire [31:0] cp0taglodcval,
	input wire cp0taglodcset,

	output reg [4:0] cp0random,
	output reg [4:0] cp0wired
);

`include "cpuconst.vh"

	reg [31:0] cp0count, cp0compare;
	reg countdiv;
	
	always @(*)
		case(cp0raddr)
		9: cp0rdata = {32'b0, cp0count};
		11: cp0rdata = {32'b0, cp0compare};
		12: cp0rdata = {32'b0, cp0status};
		13: cp0rdata = {32'b0, cp0cause};
		14: cp0rdata = cp0epc;
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
			if(cp0setexccode[5])
				cp0cause[6:2] <= cp0setexccode[4:0];
			if(cp0setepc[65]) begin
				cp0epc <= cp0setepc[63:0];
				cp0cause[BD] <= cp0setepc[64];
			end
			if(cp0taglodcset)
				cp0taglo <= cp0taglodcval;
			if(cp0eret)
				if(cp0status[ERL])
					cp0status[ERL] <= 0;
				else
					cp0status[EXL] <= 0;
			if(cp0write)
				case(cp0waddr)
				9: cp0count <= cp0wdata[31:0];
				11: begin
					cp0compare <= cp0wdata[31:0];
					cp0cause[IP+7] <= 0;
				end
				12: cp0status <= cp0wdata[31:0];
				13: cp0cause[9:8] <= cp0wdata[9:8];
				14: cp0epc <= cp0wdata;
				16: cp0config <= cp0wdata[31:0] & 32'h0f00800f | 32'h00066460;
				28: cp0taglo <= cp0wdata[31:0] & 32'h0fffffc0;
				30: cp0errorepc <= cp0wdata;
				endcase
		end
	
	initial begin
		cp0status <= 0;
		cp0config <= 0;
	end

endmodule
