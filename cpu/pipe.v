`include "cpu.vh"

module pipe(
	input wire clk,
	input wire phi1,
	input wire phi2,

	output wire [63:0] pc,
	input wire [31:0] icinstr,
	input wire [20:0] itag,
	output wire icreq,
	output wire icfill,
	
	output reg [31:0] rfinstr,
	input wire [`DECMAX:0] rfdec,
	
	input wire [63:0] exalur,
	input wire exovfl,
	
	output wire [63:0] dcva,
	input wire [63:0] dcdata,
	input wire [21:0] dctag,
	output wire [63:0] dcwdata,
	output wire [2:0] dcsz,
	output wire dcread,
	output wire dcwrite,
	output wire dcfill,
	
	input wire [31:0] itlbpa,
	output wire itlbreq,
	input wire itlbmiss,
	
	output reg [63:0] jtlbva,
	intput wire [31:0] jtlbpa,
	output wire jtlbreq,
	input wire jtlbhit,
	input wire jtlbdirty,
	input wire jtlbcache,
);
`include "cpuconst.vh"
	
	reg stall, icmiss, exdade, dcmiss;
	
	reg [63:0] gp[0:31], fp[0:31];
	reg [63:0] rfr0, rfr1, exr0, exr1, dcalur, wbval, dcval;
	reg [DECMAX:0] exdec, dcdec, wbdec;
	
	wire bemem, becpu, revend;
	
	wire [5:0] extargr = exdec[DECTARGR+5:DECTARGR];
	wire [5:0] dctargr = dcdec[DECTARGR+5:DECTARGR];
	wire [5:0] wbtargr = wbdec[DECTARGR+5:DECTARGR];
	
	always @(*) begin
		icreq = phi2 && !stall;
		itlbreq = phi2 && !stall;
		icmiss = phi1 && (!itag[20] || itlbpa[31:12] != itag[19:0]);
	end
	
	always @(*) begin
		rfr0 = 0;
		rfr1 = 0;
		if(rfdec[DECREGRS])
			if(rfinstr[25:21] == 0)
				rfr0 = 0;
			else if(extargr != {1'b0, rfinstr[25:21]})
				rfr0 = exalur;
			else if(dctargr != {1'b0, rfinstr[25:21]})
				rfr0 = dcval;
			else
				rfr0 = gp[rfinstr[25:21]];
		if(rfdec[DECREGRT])
			if(rfinstr[20:16] == 0)
				rfr1 = 0;
			else if(extargr == {1'b0, rfinstr[20:16]})
				rfr1 = exalur;
			else if(dctargr == {1'b0, rfinstr[20:16]})
				rfr1 = dcval;
			else
				rfr1 = gp[rfinstr[20:16]];
		if(rfdec[DECREGFS)
			rfr0 = fp[rfinstr[15:11]];
		if(rfdec[DECREGFT])
			rfr1 = fp[rfinstr[20:16]];
		if(rfdec[DECZIMM])
			rfr1 = {48'd0, rfinstr[15:0]};
		if(rfdec[DECSIMM])
			rfr1 = {48{rfinstr[15]}, rfinstr[15:0]};
		if(rfdec[DECSHIMM])
			rfr0 = {59'd0, rfinstr[10:6]};
	end
	
	always @(*) begin
		dcva = 0;
		dcwdata = 0;
		jtlbva = dcva;
		dcread = 0;
		dcwrite = 0;
		exdade = 0;
		if(dcdec[DECLOAD]) begin
			dcva = dcalur;
			dcload = !stall;
			jtlbreq = !stall;
			case(dcdec[DECSZ+3:DECSZ])
			SZBYTE: begin
				dcsz = 0;
				dcval = {56{dcdec[DECSIGNED] && dcdata[7]}, dcdata[7:0]};
			end
			SZHALF: begin
				dcsz = 1;
				exdade = dcva[0];
				dcval = {48{dcdec[DECSIGNED] && dcdata[15]}, dcdata[15:0]};
			end
			default: begin
				dcsz = 3;
				exdade = dcva[1:0] != 0;
				dcval = {32{dcdec[DECSIGNED] && dcdata[31]}, dcdata[31:0]};
			end
			SZLEFT: begin
				dcsz = {1'b0, {2{becpu}} ^  dcalur[1:0];
				if(!bemem)
					dcva[1:0] = 0;
			end
			SZRIGHT: begin
				dcsz = {1'b0, {2{~becpu}} ^ dcalur[1:0];
				if(bemem)
					dcva[1:0] = 0;
			end
			SZDWORD: begin
				dcsz = 7;
				exdade = dcva[2:0] != 0;
				dcval = dcdata;
			end
			endcase
			dcmiss = !stall && jtlbhit && (!jtlbcache || !dctag[21] || dctag[19:0] != jtlbpa);
		end else
			dcval = dcalur;
	end
	
	always @(posedge clk)
		if(phi2) begin
			if(!stall) begin
				rfinstr <= icinstr;

				exdec <= rfdec;
				exr0 <= rfr0;
				exr1 <= rfr1;

				dcdec <= exdec;
				dcalur <= exalur;

				wbdec <= dcdec;
				wbval <= dcval;
			end
		end
	
	always @(posedge clk)
		if(phi1)
			if(!stall)
				if(wbtargr != 0)
					if(!wbtargr[5])
						gp[wbtargr] <= wbval;
	
	always @(*) begin
		stall = 0;
		dcfill = 0;
		case(1'b1)
		dcmiss: begin
			dcfill = 1;
			stall = 1;
		end
		endcase
	end

endmodule
