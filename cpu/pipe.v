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
	output wire dcwrite,
	output reg dcfill,
	output reg dccache,
	input wire dcdbe,
	input wire dcbusy,
	output reg dcdoop,
	output wire [2:0] dcop,
	
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
	input wire irqen,
	
	output reg [4:0] cp0raddr,
	input wire [63:0] cp0rdata,
	output reg [4:0] cp0waddr,
	output reg [63:0] cp0wdata,
	output reg cp0write,
	
	input wire [31:0] cp0status,
	input wire [63:0] cp0epc,
	input wire [63:0] cp0errorepc,
	output reg cp0setexl,
	output reg [5:0] cp0setexccode,
	output reg [65:0] cp0setepc,
	output reg cp0coldreset,
	output reg cp0softreset,
	output reg cp0eret
	
);
`include "cpuconst.vh"
	
	reg stall, stall0, icmiss, rfmiss, dcmiss, dcovfl, icade, rfade, dcfpe, dcdade, dcdbe0;
	reg rfkill, exkill, dckill, exc0, exc1;
	reg rfloadr0, rfloadr1, exloadr0, exloadr1, ldi, storestall, dcissued, dcdone, wbcache, rfbd, exbd, dcbd, wbbd;
	reg busystall;
	reg [4:0] rfwhy, exwhy, dcwhy;
	reg [2:0] wbsz;
	
	reg [31:0] wbpa;
	reg [63:0] gp[0:31], fp[0:31];
	reg [63:0] rfr0, rfr1, dcalur, wbval, dcval, exbtarg, dcr1, dcwdata0, wbwdata, dcval0, excpc, rfpc, expc, dcpc, wbpc;
	reg [`DECMAX:0] dcdec, wbdec;
	
	wire bemem=1, becpu=1, revend = cp0status[RE];
	
	wire [1:0] mode = cp0status[EXL] || cp0status[ERL] ? 0 : cp0status[KSU+1:KSU];
	wire mode64 = mode == 0 ? cp0status[KX] : mode == 1 ? cp0status[SX] : cp0status[UX];
	
	wire [5:0] extargr = exdec[DECTARGR+5:DECTARGR];
	wire [5:0] dctargr = dcdec[DECTARGR+5:DECTARGR];
	wire [5:0] wbtargr = wbdec[DECTARGR+5:DECTARGR];
	assign dcop = dcdec[DECCACHEOP+2:DECCACHEOP];
	
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
	
	assign dcwrite = wbdec[DECSTORE] && (!stall || storestall || busystall);
	always @(*) begin
		dcva = 64'bx;
		dcpa = jtlbpa;
		dcsz = 3'bx;
		dcwdata = 64'bx;
		dcwdata0 = 64'bx;
		dcread = 0;
		dcdoop = 0;
		dccache = jtlbcache;
		dcdade = 0;
		dcmiss = 0;
		if(wbdec[DECSTORE]) begin
			dcva = wbval;
			dcpa = wbpa;
			dccache = wbcache;
			dcwdata = wbwdata;
			dcsz = wbsz;
		end else if(dcdec[DECLOAD]) begin
			dcva = dcalur;
			dcread = 1;
			jtlbreq = 1;
			case(dcdec[DECSZ+3:DECSZ])
			SZBYTE: begin
				dcsz = 0;
				dcval = {{56{dcdec[DECSIGNED] && dcdata[7]}}, dcdata[7:0]};
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
			end
			SZHALF: begin
				dcsz = 1;
				dcdade = dcva[0];
				dcval = {{48{dcdec[DECSIGNED] && dcdata[15]}}, dcdata[15:0]};
				dcva[2:1] = dcva[2:1] ^ {2{revend}};
			end
			SZWORD: begin
				dcsz = 3;
				dcdade = dcva[1:0] != 0;
				dcval = {{32{dcdec[DECSIGNED] && dcdata[31]}}, dcdata[31:0]};
				dcva[2] = dcva[2] ^ revend;
			end
			SZDWORD: begin
				dcsz = 7;
				dcdade = dcva[2:0] != 0;
				dcval = dcdata;
			end
			SZLEFT: begin
				dcsz = {1'b0, {2{becpu}} ^  dcalur[1:0]};
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(!bemem)
					dcva[1:0] = 0;
				dcval = dcr1;
				case(dcsz)
				0: dcval[31:24] = dcdata[7:0];
				1: dcval[31:16] = dcdata[15:0];
				2: dcval[31:8] = dcdata[23:0];
				3: dcval[31:0] = dcdata[31:0];
				endcase
				dcval[63:32] = {32{dcval[31]}};
			end
			SZRIGHT: begin
				dcsz = {1'b0, {2{~becpu}} ^ dcalur[1:0]};
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(bemem)
					dcva[1:0] = 0;
				dcval = dcr1;
				case(dcsz)
				0: dcval[7:0] = dcdata[7:0];
				1: dcval[15:0] = dcdata[15:0];
				2: dcval[23:0] = dcdata[23:0];
				3: dcval = {{32{dcdata[31]}}, dcdata[31:0]};
				endcase
			end
			SZDLEFT: begin
				dcsz = {3{becpu}} ^  dcalur[2:0];
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(!bemem)
					dcva[2:0] = 0;
				dcval = dcr1;
				case(dcsz)
				0: dcval[63:56] = dcdata[7:0];
				1: dcval[63:48] = dcdata[15:0];
				2: dcval[63:40] = dcdata[23:0];
				3: dcval[63:32] = dcdata[31:0];
				4: dcval[63:24] = dcdata[39:0];
				5: dcval[63:16] = dcdata[47:0];
				6: dcval[63:8] = dcdata[55:0];
				7: dcval = dcdata;
				endcase
			end
			SZDRIGHT: begin
				dcsz = {3{~becpu}} ^ dcalur[2:0];
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(bemem)
					dcva[2:0] = 0;
				dcval = dcr1;
				case(dcsz)
				0: dcval[7:0] = dcdata[7:0];
				1: dcval[15:0] = dcdata[15:0];
				2: dcval[23:0] = dcdata[23:0];
				3: dcval[31:0] = dcdata[31:0];
				4: dcval[39:0] = dcdata[39:0];
				5: dcval[47:0] = dcdata[47:0];
				6: dcval[55:0] = dcdata[55:0];
				7: dcval[63:0] = dcdata[63:0];
				endcase
			end
			endcase
			dcmiss = !dcissued && (!jtlbcache || !dctag[21] || dctag[19:0] != jtlbpa[31:12]);
		end else if(dcdec[DECSTORE]) begin
			dcva = dcalur;
			dcpa = jtlbpa;
			dcmiss = jtlbcache && (!dctag[21] || dctag[19:0] != jtlbpa[31:12]);
			dcread = 1;
			jtlbreq = 1;
			dcval = dcalur;
			dcwdata0 = dcr1;
			case(dcdec[DECSZ+3:DECSZ])
			SZBYTE: begin
				dcsz = 0;
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
			end
			SZHALF: begin
				dcsz = 1;
				dcva[2:1] = dcva[2:1] ^ {2{revend}};
			end
			SZWORD: begin
				dcsz = 3;
				dcva[2] = dcva[2] ^ revend;
			end
			SZDWORD: dcsz = 7;
			SZLEFT: begin
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(!bemem)
					dcva[1:0] = 0;
				dcsz = {1'b0, dcalur[1:0] ^ {2{becpu}}};
				dcwdata0 = dcwdata0 >> 24 - 8 * dcsz;
			end
			SZRIGHT: begin
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(bemem)
					dcva[1:0] = 0;
				dcsz = {1'b0, dcalur[1:0] ^ {2{becpu}}};
			end
			SZDLEFT: begin
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(!bemem)
					dcva[2:0] = 0;
				dcsz = dcalur[2:0] ^ {3{becpu}};
				dcwdata0 = dcwdata0 >> 63 - 8 * dcsz;
			end
			SZDRIGHT: begin
				dcva[2:0] = dcva[2:0] ^ {3{revend}};
				if(bemem)
					dcva[1:0] = 0;
				dcsz = dcalur[2:0] ^ {3{becpu}};
			end
			endcase
		end else if(dcdec[DECCACHE] && dcdec[DECDCACHE]) begin
			dcva = dcalur;
			dcpa = jtlbpa;
			case(dcop)
			0:
				dcmiss = dctag[21];
			3:
				dcmiss = 1;
			4, 5, 6:
				dcmiss = dctag[21] && dctag[19:0] == jtlbpa[31:12];
			endcase
			dcdoop = 1;
			dcread = 1;
			jtlbreq = 1;
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
		cp0eret = 0;
		if(exdec[DECJUMP])
			exbtarg = {pc[63:28], exinstr[25:0], 2'b00};
		else if(exdec[DECJUMPREG])
			exbtarg = exr0;
		else if(exdec[DECERET]) begin
			exbtarg = cp0status[ERL] ? cp0errorepc : cp0epc;
			cp0eret = 1;
		end	
		else if(exdec[DECBRANCH])
			exbtarg = pc + {{46{exinstr[15]}}, exinstr[15:0], 2'b00};
	end
	
	always @(posedge clk)
		if(phi2) begin
			exc0 <= wbdec[DECPANIC];
			if(!stall || icbusy) begin
				rfinstr <= rfkill || exkill || dckill ? 0 : icinstr;
				rfade <= icade;
				rfmiss <= icmiss;
			end
			if((dcfill || dcread) && !dcbusy)
				dcissued <= 1;
			if(dcissued && !dcbusy) begin
				dcval0 <= dcval;
				dcdbe0 <= dcdbe;
				dcdone <= 1;
			end
			if(!stall) begin
				rfpc <= pc;
				rfbd <= rfdec[DECBRANCH];
			
				exinstr <= rfinstr;
				exdec <= exdec[DECLIKELY] && !exbcmp || exdec[DECERET] || exkill || dckill ? 0 : rfdec;
				if(rfkill) begin
					exdec <= 0;
					exdec[DECPANIC] <= 1;
					exdec[DECWHY+4:DECWHY] <= rfwhy;
				end
				exr0 <= rfr0;
				exr1 <= rfr1;
				exloadr0 <= rfloadr0;
				exloadr1 <= rfloadr1;
				expc <= rfpc;
				exbd <= rfbd;

				dcdec <= dckill ? 0 : exdec;
				if(exkill) begin
					dcdec <= 0;
					dcdec[DECPANIC] <= 1;
					dcdec[DECWHY+4:DECWHY] <= exwhy;
				end
				dcalur <= exalur;
				dcovfl <= dckill ? 0 : exovfl;
				dcfpe <= dckill ? 0 : exfpe;
				dcr1 <= exloadr1 && exdec[DECLOAD] ? dcval : exr1;
				dcissued <= 0;
				dcdone <= 0;
				dcpc <= expc;
				dcbd <= exbd;

				wbdec <= dcdec;
				if(dckill) begin
					wbdec <= 0;
					wbdec[DECPANIC] <= 1;
					wbdec[DECWHY+4:DECWHY] <= dcwhy;
				end
				wbval <= dcdone ? dcval0 : dcval;
				wbwdata <= dcwdata0;
				wbpa <= jtlbpa;
				wbcache <= jtlbcache;
				wbsz <= dcsz;
				wbpc <= dcpc;
				wbbd <= dcbd;
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
			stall0 <= stall;
		end
	
	always @(posedge clk)
		if(phi1) begin
			exc1 <= exc0;
			if(!stall) begin
				pc <= exbcmp ? exbtarg : pc + 4;
				exlink <= pc + 4;
				if(wbtargr != 0)
					if(wbtargr[5])
						fp[wbtargr[4:0]] <= wbval;
					else
						gp[wbtargr[4:0]] <= wbval;
			end
			if(exc1)
				pc <= excpc;
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
		busystall = 0;
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
		dcdade: begin dckill = 1; dcwhy = wbdec[DECSTORE] ? WHYADES : WHYADEL; end
		!itlbbusy && (jtlbmiss || jtlberror): begin dckill = 1; dcwhy = dcdec[DECSTORE] ? WHYTLBS : WHYTLBL; end
		irq && irqen && !stall0: begin dckill = 1; dcwhy = WHYINTR; end
		dcbusy && wbdec[DECSTORE]: begin stall = 1; busystall = 1; end
		wbdec[DECSTORE] && (dcdec[DECSTORE] || dcdec[DECLOAD]): begin stall = 1; storestall = 1; end
		dcbusy && (dcread || dcfill) && !dcdone: stall = 1;
		dcmiss: begin dcfill = 1; stall = 1; end
		dcdone ? dcdbe0 : dcdbe: begin dckill = 1; dcwhy = WHYDBE; end
		
		exdec[DECINVALID]: begin exkill = 1; exwhy = WHYRSVD; end
		exdec[DECSYSCALL]: begin exkill = 1; exwhy = WHYSYSC; end
		exdec[DECBREAK]: begin exkill = 1; exwhy = WHYBRPT; end
		exloadr0 || exloadr1 && !exdec[DECLOAD]: begin stall = 1; ldi = 1; end
		
		rfade: begin rfkill = 1; rfwhy = WHYIADE; end
		itlbbusy && (jtlbmiss || jtlberror): begin rfkill = 1; rfwhy = WHYITLB; end
		itlbbusy: stall = 1;
		itlbmiss: begin itlbfill = 1; stall = 1; end
		icbusy: stall = 1;
		rfmiss: begin icfill = 1; stall = 1; end
		icerror: begin rfkill = 1; rfwhy = WHYIBE; end
		endcase
	end
	
	wire [4:0] excwhy = wbdec[DECWHY+4:DECWHY];
	reg exl0;
	
	always @(posedge clk)
		if(phi2 && cp0setexl)
			exl0 <= cp0status[EXL];
	
	always @(*) begin
		excpc[63:32] = -1;
		if(excwhy == WHYRST || excwhy == WHYNMI)
			excpc[31:0] = 32'hBFC00000;
		else if(cp0status[BEV])
			excpc[31:0] = 32'hBFC00200;
		else
			excpc[31:0] = 32'h80000000;
		if(excwhy == WHYRST || excwhy == WHYNMI)
			excpc[8:0] = 0;
		else if((excwhy == WHYTLBS || excwhy == WHYTLBL || excwhy == WHYITLB) && !exl0)
			excpc[8:0] = mode64 ? 9'h80 : 0;
		else
			excpc[8:0] = 9'h180;
	end
	
	always @(*) begin
		cp0setexl = 0;
		cp0setexccode = 0;
		cp0coldreset = 0;
		cp0softreset = 0;
		cp0setepc = {1'b0, wbbd, wbbd ? wbpc - 4 : wbpc};
		if(wbdec[DECPANIC] && !cp0status[EXL] && excwhy != WHYRST && excwhy != WHYNMI)
			cp0setepc[65] = 1;
		if(exc0) begin
			cp0setexl = 1;
			case(excwhy)
			WHYRST: cp0coldreset = 1;
			WHYNMI: cp0softreset = 1;
			WHYIADE: cp0setexccode = {1'b1, WHYADEL};
			WHYITLB: cp0setexccode = {1'b1, WHYTLBL};
			default: cp0setexccode = {1'b1, excwhy};
			endcase
		end
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
