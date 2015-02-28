`include "cpu.vh"

module pipe(
	input wire clk,
	input wire phi1,
	input wire phi2,

	output reg [63:0] pc,
	input wire [31:0] icinstr,
	input wire [20:0] ictag,
	output reg icfill,
	input wire icerror,
	input wire icbusy,
	
	output reg [31:0] rfinstr,
	input wire [`DECMAX:0] rfdec,
	
	output reg [`DECMAX:0] exdec,
	output reg [31:0] exinstr,
	output reg [63:0] exlink,
	output reg [63:0] exr0,
	output reg [63:0] exr1,
	input wire [63:0] exalur,
	input wire exovfl,
	input wire exbcmp,
	input wire exfpe,
	
	output reg [63:0] dcva,
	output reg [31:0] dcpa,
	input wire [63:0] dcdata,
	input wire [21:0] dctag,
	output reg [63:0] dcwdata,
	output reg [2:0] dcsz,
	output reg dcread,
	output reg dcwrite,
	output reg dcfill,
	output reg dccache,
	input wire dcerror,
	input wire dcbusy,
	
	input wire [31:0] itlbpa,
	input wire itlbmiss,
	output reg itlbfill,
	input wire itlbbusy,
	
	output reg [63:0] jtlbva,
	input wire [31:0] jtlbpa,
	output reg jtlbreq,
	input wire jtlbmiss,
	input wire jtlberror,
	input wire jtlbdirty,
	input wire jtlbcache,
	
	input wire reset,
	input wire nmi,
	input wire irq,
	input wire irqen
);
`include "cpuconst.vh"
	
	reg stall, stall0, icmiss, exdade, dcmiss, dcovfl, icade, rfade, dcfpe, dcdade;
	reg rfkill, exkill, dckill, exc0, exc1;
	reg rfloadr0, rfloadr1, exloadr0, exloadr1, ldi, storestall, dcissued;
	reg [4:0] rfwhy, exwhy, dcwhy;
	
	reg [63:0] gp[0:31], fp[0:31];
	reg [63:0] rfr0, rfr1, dcalur, wbval, dcval, exbtarg, dcr1, wbr1;
	reg [`DECMAX:0] dcdec, wbdec;
	
	wire bemem=1, becpu=1, revend=0;
	
	wire [5:0] extargr = exdec[DECTARGR+5:DECTARGR];
	wire [5:0] dctargr = dcdec[DECTARGR+5:DECTARGR];
	wire [5:0] wbtargr = wbdec[DECTARGR+5:DECTARGR];
	
	always @(*) begin
		icmiss = !itlbmiss && (!ictag[20] || itlbpa[31:12] != ictag[19:0]);
		icade = pc[1:0] != 0;
	end
	
	always @(*) begin
		rfr0 = 0;
		rfr1 = 0;
		rfloadr0 = 0;
		rfloadr1 = 0;
		if(rfdec[DECREGRS])
			if(rfinstr[25:21] == 0)
				rfr0 = 0;
			else if(extargr == {1'b0, rfinstr[25:21]}) begin
				rfloadr0 = exdec[DECLOAD];
				rfr0 = exalur;
			end else if(dctargr == {1'b0, rfinstr[25:21]})
				rfr0 = dcval;
			else
				rfr0 = gp[rfinstr[25:21]];
		if(rfdec[DECREGRT])
			if(rfinstr[20:16] == 0)
				rfr1 = 0;
			else if(extargr == {1'b0, rfinstr[20:16]}) begin
				rfloadr1 = exdec[DECLOAD];
				rfr1 = exalur;
			end else if(dctargr == {1'b0, rfinstr[20:16]})
				rfr1 = dcval;
			else
				rfr1 = gp[rfinstr[20:16]];
		if(rfdec[DECREGFS])
			rfr0 = fp[rfinstr[15:11]];
		if(rfdec[DECREGFT])
			rfr1 = fp[rfinstr[20:16]];
		if(rfdec[DECZIMM])
			rfr1 = {48'd0, rfinstr[15:0]};
		if(rfdec[DECSIMM])
			rfr1 = {{48{rfinstr[15]}}, rfinstr[15:0]};
		if(rfdec[DECSHIMM])
			rfr0 = {59'd0, rfinstr[10:6]};
	end
	
	always @(*) begin
		dcva = 64'bx;
		dcpa = jtlbpa;
		dcsz = 3'bx;
		dcwdata = 64'bx;
		dcread = 0;
		dcwrite = 0;
		dccache = jtlbcache;
		exdade = 0;
		if(wbdec[DECSTORE]) begin
			dcva = wbval;
			dcwrite = !stall || storestall;
			dcwdata = wbr1;
			case(wbdec[DECSZ+3:DECSZ])
			SZBYTE: dcsz = 0;
			SZHALF: dcsz = 1;
			default: dcsz = 3;
			SZDWORD: dcsz = 7;
			endcase
		end else if(dcdec[DECLOAD]) begin
			dcva = dcalur;
			dcread = 1;
			jtlbreq = 1;
			case(dcdec[DECSZ+3:DECSZ])
			SZBYTE: begin
				dcsz = 0;
				dcval = {{56{dcdec[DECSIGNED] && dcdata[7]}}, dcdata[7:0]};
			end
			SZHALF: begin
				dcsz = 1;
				exdade = dcva[0];
				dcval = {{48{dcdec[DECSIGNED] && dcdata[15]}}, dcdata[15:0]};
			end
			SZWORD: begin
				dcsz = 3;
				exdade = dcva[1:0] != 0;
				dcval = {{32{dcdec[DECSIGNED] && dcdata[31]}}, dcdata[31:0]};
			end
			SZLEFT: begin
				dcsz = {1'b0, {2{becpu}} ^  dcalur[1:0]};
				if(!bemem)
					dcva[1:0] = 0;
			end
			SZRIGHT: begin
				dcsz = {1'b0, {2{~becpu}} ^ dcalur[1:0]};
				if(bemem)
					dcva[1:0] = 0;
			end
			SZDWORD: begin
				dcsz = 7;
				exdade = dcva[2:0] != 0;
				dcval = dcdata;
			end
			endcase
			dcmiss = !jtlbmiss && (jtlbcache ? !dctag[21] || dctag[19:0] != jtlbpa[31:12] : !dcissued);
		end else if(dcdec[DECSTORE]) begin
			dcva = dcalur;
			dcpa = jtlbpa;
			if(jtlbcache) begin
				dcmiss = !jtlbmiss && !dctag[21] || dctag[19:0] != jtlbpa[31:12] ;
				dcread = 1;
			end else begin
				dcmiss = !jtlbmiss && !dcissued;
				dcwrite = !jtlbmiss;
				dcwdata = dcr1;
			end
			jtlbreq = 1;
			dcval = dcalur;
			case(dcdec[DECSZ+3:DECSZ])
			SZBYTE: dcsz = 0;
			SZHALF: dcsz = 1;
			default: dcsz = 3;
			SZDWORD: dcsz = 7;
			endcase
		end else
			dcval = dcalur;
		jtlbva = dcva;
		if(itlbbusy) begin
			jtlbreq = 1;
			jtlbva = pc;
		end
	end
	
	always @(*) begin
		exbtarg = 64'bx;
		if(exdec[DECJUMP])
			exbtarg = {pc[63:28], exinstr[25:0], 2'b00};
		else if(exdec[DECJUMPREG])
			exbtarg = exr0;
		else if(exdec[DECBRANCH])
			exbtarg = pc + {{46{exinstr[15]}}, exinstr[15:0], 2'b00};
	end
	
	always @(posedge clk)
		if(phi2) begin
			exc0 <= wbdec[DECPANIC];
			exc1 <= exc0;
			if(!stall || icbusy) begin
				rfinstr <= rfkill || exkill || dckill ? 0 : icinstr;
				rfade <= icade;
			end

			if(!stall) begin
				exinstr <= rfinstr;
				exdec <= exdec[DECLIKELY] && !exbcmp || exkill || dckill ? 0 : rfdec;
				if(rfkill) begin
					exdec[DECPANIC] <= 1;
					exdec[DECWHY+4:DECWHY] <= rfwhy;
				end
				exr0 <= rfr0;
				exr1 <= rfr1;
				exloadr0 <= rfloadr0;
				exloadr1 <= rfloadr1;

				dcdec <= dckill ? 0 : exdec;
				if(exkill) begin
					dcdec[DECPANIC] <= 1;
					dcdec[DECWHY+4:DECWHY] <= exwhy;
				end
				dcalur <= exalur;
				dcovfl <= dckill ? 0 : exovfl;
				dcfpe <= dckill ? 0 : exfpe;
				dcdade <= dckill ? 0 : exdade;
				dcr1 <= exr1;
				dcissued <= 0;

				wbdec <= dcdec;
				if(dckill) begin
					wbdec[DECPANIC] <= 1;
					wbdec[DECWHY+4:DECWHY] <= dcwhy;
				end
				wbval <= dcval;
				wbr1 <= dcr1;
			end
			if(ldi) begin
				if(exloadr0)
					exr0 <= dcval;
				if(exloadr1)
					exr1 <= dcval;
				exloadr0 <= 0;
				exloadr1 <= 0;
			end
			if(storestall)
				wbdec[DECSTORE] <= 0;
			if(dcfill)
				dcissued <= 1;
			stall0 <= stall;
		end
	
	always @(posedge clk)
		if(phi1)
			if(!stall) begin
				pc <= exbcmp ? exbtarg : pc + 4;
				exlink <= pc + 4;
				if(wbtargr != 0)
					if(wbtargr[5])
						fp[wbtargr[4:0]] <= wbval;
					else
						gp[wbtargr[4:0]] <= wbval;
			end
	
	always @(*) begin
		stall = 0;
		dcfill = 0;
		itlbfill = 0;
		icfill = 0;
		rfkill = 0;
		exkill = 0;
		dckill = 0;
		ldi = 0;
		storestall = 0;
		dcwhy = 5'bx;
		exwhy = 5'bx;
		rfwhy = 5'bx;
		
		case(1'b1)
		exc0 || exc1: stall = 1;
		reset: begin dckill = 1; dcwhy = WHYRST; end
		nmi && !stall0: begin dckill = 1; dcwhy = WHYNMI; end
		dcovfl: begin dckill = 1; dcwhy = WHYOVFL; end
//		dctrap: begin dckill = 1; dcwhy = WHYTRAP; end
		dcfpe: begin dckill = 1; dcwhy = WHYFPE; end
		dcdade: begin dckill = 1; dcwhy = WHYDADE; end
		!itlbbusy && (jtlbmiss || jtlberror): begin dckill = 1; dcwhy = WHYDTLB; end
		wbdec[DECSTORE] && (dcdec[DECSTORE] || dcdec[DECLOAD]): begin stall = 1; storestall = 1; end
		irq && irqen && !stall0: begin dckill = 1; dcwhy = WHYINTR; end
		dcbusy: stall = 1;
		dcmiss: begin dcfill = 1; stall = 1; end
		dcerror && dcread: begin dckill = 1; dcwhy = WHYDBE; end
		
		exdec[DECINVALID]: begin exkill = 1; exwhy = WHYRSVD; end
		exdec[DECSYSCALL]: begin exkill = 1; exwhy = WHYSYSC; end
		exdec[DECBREAK]: begin exkill = 1; exwhy = WHYBRPT; end
		exloadr0 || exloadr1: begin stall = 1; ldi = 1; end
		
		rfade: begin rfkill = 1; rfwhy = WHYIADE; end
		itlbbusy && (jtlbmiss || jtlberror): begin rfkill = 1; rfwhy = WHYITLB; end
		itlbbusy: stall = 1;
		itlbmiss: begin itlbfill = 1; stall = 1; end
		icbusy: stall = 1;
		icmiss: begin icfill = 1; stall = 1; end
		icerror: begin rfkill = 1; rfwhy = WHYIBE; end
		endcase
	end
	
	integer i;
	initial begin
		pc = 0;
		exc0 = 0;
		exc1 = 0;
		rfinstr = 0;
		stall0 = 0;
		exdec = 0;
		dcdec = 0;
		wbdec = 0;
		dcmiss = 0;
		dcovfl = 0;
		for(i = 0; i < 32; i=i+1)
			gp[i] = 0;
	end

endmodule
