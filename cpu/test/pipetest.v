`include "cpu.vh"

module pipetest();

`include "cpuconst.vh"
`include "asm.vh"

	/*AUTOWIRE*/
	// Beginning of automatic wires (for undeclared instantiated-module outputs)
	wire		alubusy;		// From alu0 of alu.v
	wire		alugo;			// From pipe0 of pipe.v
	wire		bemem;			// From pipe0 of pipe.v
	wire [31:0]	cp0cause;		// From cp0 of cp0.v
	wire		cp0coldreset;		// From pipe0 of pipe.v
	wire [31:0]	cp0config;		// From cp0 of cp0.v
	wire [63:0]	cp0entryhi;		// From cp0 of cp0.v
	wire [63:0]	cp0entryhi_;		// From jtlb0 of jtlb.v
	wire [63:0]	cp0entrylo0;		// From cp0 of cp0.v
	wire [63:0]	cp0entrylo0_;		// From jtlb0 of jtlb.v
	wire [63:0]	cp0entrylo1;		// From cp0 of cp0.v
	wire [63:0]	cp0entrylo1_;		// From jtlb0 of jtlb.v
	wire [63:0]	cp0epc;			// From cp0 of cp0.v
	wire		cp0eret;		// From pipe0 of pipe.v
	wire [63:0]	cp0errorepc;		// From cp0 of cp0.v
	wire [31:0]	cp0index;		// From cp0 of cp0.v
	wire [31:0]	cp0index_;		// From jtlb0 of jtlb.v
	wire		cp0jtlbshut;		// From jtlb0 of jtlb.v
	wire		cp0llset;		// From pipe0 of pipe.v
	wire [31:0]	cp0pagemask;		// From cp0 of cp0.v
	wire [31:0]	cp0pagemask_;		// From jtlb0 of jtlb.v
	wire [4:0]	cp0raddr;		// From pipe0 of pipe.v
	wire [4:0]	cp0random;		// From cp0 of cp0.v
	wire [63:0]	cp0rdata;		// From cp0 of cp0.v
	wire		cp0setbadva;		// From pipe0 of pipe.v
	wire		cp0setcontext;		// From pipe0 of pipe.v
	wire		cp0setentryhi;		// From jtlb0 of jtlb.v
	wire [65:0]	cp0setepc;		// From pipe0 of pipe.v
	wire [5:0]	cp0setexccode;		// From pipe0 of pipe.v
	wire		cp0setexl;		// From pipe0 of pipe.v
	wire		cp0softreset;		// From pipe0 of pipe.v
	wire [31:0]	cp0status;		// From cp0 of cp0.v
	wire [31:0]	cp0taglo;		// From cp0 of cp0.v
	wire		cp0taglodcset;		// From cache0 of cache.v
	wire [31:0]	cp0taglodcval;		// From cache0 of cache.v
	wire		cp0tagloicset;		// From cache0 of cache.v
	wire [31:0]	cp0tagloicval;		// From cache0 of cache.v
	wire [4:0]	cp0waddr;		// From pipe0 of pipe.v
	wire [63:0]	cp0wdata;		// From pipe0 of pipe.v
	wire		cp0write;		// From pipe0 of pipe.v
	wire		dcbusy;			// From cache0 of cache.v
	wire		dccache;		// From pipe0 of pipe.v
	wire [63:0]	dcdata;			// From cache0 of cache.v
	wire		dcdbe;			// From cache0 of cache.v
	wire		dcdoop;			// From pipe0 of pipe.v
	wire		dcfill;			// From pipe0 of pipe.v
	wire [2:0]	dcop;			// From pipe0 of pipe.v
	wire [31:0]	dcpa;			// From pipe0 of pipe.v
	wire		dcread;			// From pipe0 of pipe.v
	wire [2:0]	dcsz;			// From pipe0 of pipe.v
	wire [21:0]	dctag;			// From cache0 of cache.v
	wire [63:0]	dcva;			// From pipe0 of pipe.v
	wire [63:0]	dcwdata;		// From pipe0 of pipe.v
	wire		dcwrite;		// From pipe0 of pipe.v
	wire [63:0]	exalur;			// From alu0 of alu.v
	wire		exbcmp;			// From alu0 of alu.v
	wire [`DECMAX:0] exdec;			// From pipe0 of pipe.v
	wire [31:0]	exinstr;		// From pipe0 of pipe.v
	wire [63:0]	exlink;			// From pipe0 of pipe.v
	wire		exovfl;			// From alu0 of alu.v
	wire [63:0]	exr0;			// From pipe0 of pipe.v
	wire [63:0]	exr1;			// From pipe0 of pipe.v
	wire [31:0]	extaddr;		// From cache0 of cache.v
	wire		extreq;			// From cache0 of cache.v
	wire		extsrc;			// From cache0 of cache.v
	wire [4:0]	extsz;			// From cache0 of cache.v
	wire [63:0]	extwdata;		// From cache0 of cache.v
	wire		extwr;			// From cache0 of cache.v
	wire [63:0]	hi;			// From alu0 of alu.v
	wire		icbusy;			// From cache0 of cache.v
	wire		icdoop;			// From pipe0 of pipe.v
	wire		icfill;			// From pipe0 of pipe.v
	wire [31:0]	icinstr;		// From cache0 of cache.v
	wire [31:0]	icpa;			// From pipe0 of pipe.v
	wire [20:0]	ictag;			// From cache0 of cache.v
	wire [63:0]	icva;			// From pipe0 of pipe.v
	wire		itlbbusy;		// From itlb0 of itlb.v
	wire		itlbcache;		// From itlb0 of itlb.v
	wire		itlbfill;		// From pipe0 of pipe.v
	wire		itlbmiss;		// From itlb0 of itlb.v
	wire [31:0]	itlbpa;			// From itlb0 of itlb.v
	wire		jtlbade;		// From jtlb0 of jtlb.v
	wire		jtlbcache;		// From jtlb0 of jtlb.v
	wire		jtlbinval;		// From jtlb0 of jtlb.v
	wire		jtlbmiss;		// From jtlb0 of jtlb.v
	wire		jtlbmod;		// From jtlb0 of jtlb.v
	wire [31:0]	jtlbpa;			// From jtlb0 of jtlb.v
	wire		jtlbreq;		// From pipe0 of pipe.v
	wire [63:0]	jtlbva;			// From pipe0 of pipe.v
	wire		jtlbwr;			// From pipe0 of pipe.v
	wire [63:0]	lo;			// From alu0 of alu.v
	wire [1:0]	mode;			// From pipe0 of pipe.v
	wire		mode64;			// From pipe0 of pipe.v
	wire [63:0]	pc;			// From pipe0 of pipe.v
	wire [`DECMAX:0] rfdec;			// From idec0 of idec.v
	wire [31:0]	rfinstr;		// From pipe0 of pipe.v
	wire		stall;			// From pipe0 of pipe.v
	wire		tlbp;			// From pipe0 of pipe.v
	wire		tlbr;			// From pipe0 of pipe.v
	wire		tlbwi;			// From pipe0 of pipe.v
	wire		tlbwr;			// From pipe0 of pipe.v
	// End of automatics
	/*AUTOREGINPUT*/
	// Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
	reg		clk;			// To pipe0 of pipe.v, ...
	reg		exfpe;			// To pipe0 of pipe.v
	reg		exterror;		// To cache0 of cache.v
	reg [63:0]	extrdata;		// To cache0 of cache.v
	reg		extrdy;			// To cache0 of cache.v
	reg		extreply;		// To cache0 of cache.v
	reg		extreplyto;		// To cache0 of cache.v
	reg		icerror;		// To pipe0 of pipe.v
	reg		irq;			// To pipe0 of pipe.v
	reg		irqen;			// To pipe0 of pipe.v
	reg		itlbreq;		// To itlb0 of itlb.v
	reg		nmi;			// To pipe0 of pipe.v
	reg		phi1;			// To pipe0 of pipe.v, ...
	reg		phi2;			// To pipe0 of pipe.v, ...
	reg		reset;			// To pipe0 of pipe.v
	// End of automatics
	
	reg [63:0] mem[0:4095];
	integer i;
	initial begin

		for(i = 0; i < 4096; i=i+1)
			mem[i] = 0;
			
		$readmemh("cpu/test/c/boot.hex", mem);
	
	/*	`A(0) = `LUI(1,16'h8000);
		`A(4) = `ADDI(1,16'h10,1);
		`A(8) = `JR(1);
		`A(16) = `CACHE(1,16'h1000,0,4);
		`A(20) = `ADDI(0,1,2);
		`A(24) = `ADDI(0,2,2);
		`A(28) = `ADDI(0,3,2);
		`A(64) = 32'hDEADBEEF;
		`A(68) = 32'hCAFEBABE;
		`A(72) = 32'h12345678;
		`A(76) = 32'h9ABCDEF0;*/
	
		clk = 1;
		phi1 = 1;
		reset = 1;
		phi2 = 0;
		exfpe = 0;
		irq = 0;
		irqen = 0;
		#4 reset = 0;
	end
	always #0.5 clk = !clk;
	always @(posedge clk) begin
		phi1 <= !phi1;
		phi2 <= !phi2;
	end
	reg loadaddr, src;
	reg [11:0] addrreg;
	integer extstate, extstate_;
	localparam EXTIDLE = 0;
	localparam EXTIR0 = 1;
	localparam EXTIR1 = 2;
	localparam EXTIR2 = 3;
	localparam EXTIR3 = 4;
	localparam EXTDR0 = 5;
	localparam EXTDR1 = 6;
	localparam EXTUR = 7;
	initial extstate = EXTIDLE;

	always @(posedge clk)
		if(phi2) begin
			extstate <= extstate_;
			if(loadaddr) begin
				addrreg <= extaddr >> 3 & 4095;
				src <= extsrc;
			end
			if(extreq && extwr && extaddr < 32768)
				case(extsz)
				0: mem[extaddr/8][56 - extaddr[2:0] * 8 +: 8] <= extwdata[7:0];
				1: mem[extaddr/8][48 - extaddr[2:0] * 8 +: 16] <= extwdata[15:0];
				2: mem[extaddr/8][40 - extaddr[2:0] * 8 +: 24] <= extwdata[23:0];
				3: mem[extaddr/8][32 - extaddr[2:0] * 8 +: 32] <= extwdata[31:0];				
				4: mem[extaddr/8][24 - extaddr[2:0] * 8 +: 40] <= extwdata[39:0];
				5: mem[extaddr/8][16 - extaddr[2:0] * 8 +: 48] <= extwdata[47:0];
				6: mem[extaddr/8][8 - extaddr[2:0] * 8 +: 56] <= extwdata[55:0];
				7, 15: mem[extaddr/8] <= extwdata;
				endcase
			if(extreq && extwr && extaddr == 32'h10000000)
				$write("%c", extwdata);
		end
	
	always @(*) begin
		extrdy = 0;
		extreply = 0;
		extreplyto = src;
		extstate_ = extstate;
		extrdata = 64'dx;
		loadaddr = 0;
		case(extstate)
		EXTIDLE: begin
			extrdy = 1;
			if(extreq && !extwr)
				if(extsz == 31)
					extstate_ = EXTIR0;
				else if(extsz == 15)
					extstate_ = EXTDR0;
				else
					extstate_ = EXTUR;
			loadaddr = 1;
		end
		EXTIR0: begin
			extstate_ = EXTIR1;
			extrdata = mem[addrreg];
			extreply = 1;
		end
		EXTIR1: begin
			extstate_ = EXTIR2;
			extrdata = mem[addrreg+1];
			extreply = 1;
		end
		EXTIR2: begin
			extstate_ = EXTIR3;
			extrdata = mem[addrreg+2];
			extreply = 1;
		end
		EXTIR3: begin
			extstate_ = EXTIDLE;
			extrdata = mem[addrreg+3];
			extreply = 1;
		end
		EXTDR0: begin
			extstate_ = EXTDR1;
			extrdata = mem[addrreg];
			extreply = 1;
		end
		EXTDR1: begin
			extstate_ = EXTIDLE;
			extrdata = mem[addrreg^1];
			extreply = 1;
		end
		EXTUR: begin
			extstate_ = EXTIDLE;
			extrdata = mem[addrreg];
			extreply = 1;
		end
		endcase
	end
	
	pipe pipe0(/*AUTOINST*/
		   // Outputs
		   .stall		(stall),
		   .pc			(pc[63:0]),
		   .icva		(icva[63:0]),
		   .icpa		(icpa[31:0]),
		   .icfill		(icfill),
		   .icdoop		(icdoop),
		   .rfinstr		(rfinstr[31:0]),
		   .exdec		(exdec[`DECMAX:0]),
		   .exinstr		(exinstr[31:0]),
		   .exlink		(exlink[63:0]),
		   .exr0		(exr0[63:0]),
		   .exr1		(exr1[63:0]),
		   .alugo		(alugo),
		   .dcva		(dcva[63:0]),
		   .dcpa		(dcpa[31:0]),
		   .dcwdata		(dcwdata[63:0]),
		   .dcsz		(dcsz[2:0]),
		   .dcread		(dcread),
		   .dcwrite		(dcwrite),
		   .dcfill		(dcfill),
		   .dccache		(dccache),
		   .dcdoop		(dcdoop),
		   .dcop		(dcop[2:0]),
		   .itlbfill		(itlbfill),
		   .jtlbva		(jtlbva[63:0]),
		   .jtlbreq		(jtlbreq),
		   .jtlbwr		(jtlbwr),
		   .tlbp		(tlbp),
		   .tlbr		(tlbr),
		   .tlbwi		(tlbwi),
		   .tlbwr		(tlbwr),
		   .cp0raddr		(cp0raddr[4:0]),
		   .cp0waddr		(cp0waddr[4:0]),
		   .cp0wdata		(cp0wdata[63:0]),
		   .cp0write		(cp0write),
		   .bemem		(bemem),
		   .cp0setexl		(cp0setexl),
		   .cp0setexccode	(cp0setexccode[5:0]),
		   .cp0setepc		(cp0setepc[65:0]),
		   .cp0coldreset	(cp0coldreset),
		   .cp0softreset	(cp0softreset),
		   .cp0eret		(cp0eret),
		   .cp0setbadva		(cp0setbadva),
		   .cp0setcontext	(cp0setcontext),
		   .cp0llset		(cp0llset),
		   .mode		(mode[1:0]),
		   .mode64		(mode64),
		   // Inputs
		   .clk			(clk),
		   .phi1		(phi1),
		   .phi2		(phi2),
		   .icinstr		(icinstr[31:0]),
		   .ictag		(ictag[20:0]),
		   .icerror		(icerror),
		   .icbusy		(icbusy),
		   .rfdec		(rfdec[`DECMAX:0]),
		   .exalur		(exalur[63:0]),
		   .exovfl		(exovfl),
		   .exbcmp		(exbcmp),
		   .exfpe		(exfpe),
		   .alubusy		(alubusy),
		   .dcdata		(dcdata[63:0]),
		   .dctag		(dctag[21:0]),
		   .dcdbe		(dcdbe),
		   .dcbusy		(dcbusy),
		   .itlbpa		(itlbpa[31:0]),
		   .itlbmiss		(itlbmiss),
		   .itlbbusy		(itlbbusy),
		   .itlbcache		(itlbcache),
		   .jtlbpa		(jtlbpa[31:0]),
		   .jtlbmiss		(jtlbmiss),
		   .jtlbade		(jtlbade),
		   .jtlbinval		(jtlbinval),
		   .jtlbcache		(jtlbcache),
		   .jtlbmod		(jtlbmod),
		   .reset		(reset),
		   .nmi			(nmi),
		   .irq			(irq),
		   .irqen		(irqen),
		   .cp0rdata		(cp0rdata[63:0]),
		   .cp0config		(cp0config[31:0]),
		   .cp0status		(cp0status[31:0]),
		   .cp0epc		(cp0epc[63:0]),
		   .cp0errorepc		(cp0errorepc[63:0]));

	idec idec0(/*AUTOINST*/
		   // Outputs
		   .rfdec		(rfdec[`DECMAX:0]),
		   // Inputs
		   .clk			(clk),
		   .rfinstr		(rfinstr[31:0]));
	
	alu alu0(/*AUTOINST*/
		 // Outputs
		 .exalur		(exalur[63:0]),
		 .exovfl		(exovfl),
		 .exbcmp		(exbcmp),
		 .alubusy		(alubusy),
		 .lo			(lo[63:0]),
		 .hi			(hi[63:0]),
		 // Inputs
		 .clk			(clk),
		 .phi1			(phi1),
		 .phi2			(phi2),
		 .exdec			(exdec[`DECMAX:0]),
		 .exinstr		(exinstr[31:0]),
		 .exr0			(exr0[63:0]),
		 .exr1			(exr1[63:0]),
		 .exlink		(exlink[63:0]),
		 .alugo			(alugo));

	cache cache0(/*AUTOINST*/
		     // Outputs
		     .icinstr		(icinstr[31:0]),
		     .ictag		(ictag[20:0]),
		     .icbusy		(icbusy),
		     .dcdata		(dcdata[63:0]),
		     .dctag		(dctag[21:0]),
		     .dcbusy		(dcbusy),
		     .dcdbe		(dcdbe),
		     .cp0taglodcval	(cp0taglodcval[31:0]),
		     .cp0taglodcset	(cp0taglodcset),
		     .cp0tagloicval	(cp0tagloicval[31:0]),
		     .cp0tagloicset	(cp0tagloicset),
		     .extaddr		(extaddr[31:0]),
		     .extwdata		(extwdata[63:0]),
		     .extsz		(extsz[4:0]),
		     .extreq		(extreq),
		     .extwr		(extwr),
		     .extsrc		(extsrc),
		     // Inputs
		     .clk		(clk),
		     .phi1		(phi1),
		     .phi2		(phi2),
		     .bemem		(bemem),
		     .icva		(icva[63:0]),
		     .icpa		(icpa[31:0]),
		     .icfill		(icfill),
		     .itlbcache		(itlbcache),
		     .icdoop		(icdoop),
		     .dcva		(dcva[63:0]),
		     .dcpa		(dcpa[31:0]),
		     .dcwdata		(dcwdata[63:0]),
		     .dcsz		(dcsz[2:0]),
		     .dcread		(dcread),
		     .dcwrite		(dcwrite),
		     .dcfill		(dcfill),
		     .dccache		(dccache),
		     .dcdoop		(dcdoop),
		     .dcop		(dcop[2:0]),
		     .cp0taglo		(cp0taglo[31:0]),
		     .extrdy		(extrdy),
		     .extreply		(extreply),
		     .extreplyto	(extreplyto),
		     .extrdata		(extrdata[63:0]),
		     .exterror		(exterror));

	cp0 cp0(/*AUTOINST*/
		// Outputs
		.cp0rdata		(cp0rdata[63:0]),
		.cp0status		(cp0status[31:0]),
		.cp0config		(cp0config[31:0]),
		.cp0cause		(cp0cause[31:0]),
		.cp0epc			(cp0epc[63:0]),
		.cp0errorepc		(cp0errorepc[63:0]),
		.cp0taglo		(cp0taglo[31:0]),
		.cp0random		(cp0random[4:0]),
		.cp0index		(cp0index[31:0]),
		.cp0entryhi		(cp0entryhi[63:0]),
		.cp0entrylo0		(cp0entrylo0[63:0]),
		.cp0entrylo1		(cp0entrylo1[63:0]),
		.cp0pagemask		(cp0pagemask[31:0]),
		// Inputs
		.clk			(clk),
		.phi1			(phi1),
		.phi2			(phi2),
		.stall			(stall),
		.cp0raddr		(cp0raddr[4:0]),
		.cp0waddr		(cp0waddr[4:0]),
		.cp0wdata		(cp0wdata[63:0]),
		.cp0write		(cp0write),
		.cp0setexl		(cp0setexl),
		.cp0setexccode		(cp0setexccode[5:0]),
		.cp0setepc		(cp0setepc[65:0]),
		.cp0coldreset		(cp0coldreset),
		.cp0softreset		(cp0softreset),
		.cp0eret		(cp0eret),
		.cp0setbadva		(cp0setbadva),
		.cp0setcontext		(cp0setcontext),
		.cp0llset		(cp0llset),
		.jtlbva			(jtlbva[63:0]),
		.jtlbpa			(jtlbpa[31:0]),
		.cp0taglodcval		(cp0taglodcval[31:0]),
		.cp0taglodcset		(cp0taglodcset),
		.cp0tagloicval		(cp0tagloicval[31:0]),
		.cp0tagloicset		(cp0tagloicset),
		.cp0jtlbshut		(cp0jtlbshut),
		.cp0setentryhi		(cp0setentryhi),
		.cp0entryhi_		(cp0entryhi_[63:0]),
		.cp0entrylo0_		(cp0entrylo0_[63:0]),
		.cp0entrylo1_		(cp0entrylo1_[63:0]),
		.cp0pagemask_		(cp0pagemask_[31:0]),
		.cp0index_		(cp0index_[31:0]),
		.tlbp			(tlbp),
		.tlbr			(tlbr),
		.tlbwi			(tlbwi),
		.tlbwr			(tlbwr));

	jtlb jtlb0(/*AUTOINST*/
		   // Outputs
		   .jtlbpa		(jtlbpa[31:0]),
		   .jtlbcache		(jtlbcache),
		   .jtlbmiss		(jtlbmiss),
		   .jtlbade		(jtlbade),
		   .jtlbinval		(jtlbinval),
		   .jtlbmod		(jtlbmod),
		   .cp0jtlbshut		(cp0jtlbshut),
		   .cp0setentryhi	(cp0setentryhi),
		   .cp0entryhi_		(cp0entryhi_[63:0]),
		   .cp0entrylo0_	(cp0entrylo0_[63:0]),
		   .cp0entrylo1_	(cp0entrylo1_[63:0]),
		   .cp0pagemask_	(cp0pagemask_[31:0]),
		   .cp0index_		(cp0index_[31:0]),
		   // Inputs
		   .clk			(clk),
		   .phi1		(phi1),
		   .phi2		(phi2),
		   .jtlbva		(jtlbva[63:0]),
		   .jtlbreq		(jtlbreq),
		   .jtlbwr		(jtlbwr),
		   .tlbr		(tlbr),
		   .tlbwi		(tlbwi),
		   .tlbwr		(tlbwr),
		   .tlbp		(tlbp),
		   .cp0status		(cp0status[31:0]),
		   .cp0entryhi		(cp0entryhi[63:0]),
		   .cp0entrylo0		(cp0entrylo0[63:0]),
		   .cp0entrylo1		(cp0entrylo1[63:0]),
		   .cp0pagemask		(cp0pagemask[31:0]),
		   .cp0index		(cp0index[31:0]),
		   .cp0random		(cp0random[4:0]),
		   .mode		(mode[1:0]),
		   .mode64		(mode64));

	itlb itlb0(/*AUTOINST*/
		   // Outputs
		   .itlbpa		(itlbpa[31:0]),
		   .itlbmiss		(itlbmiss),
		   .itlbbusy		(itlbbusy),
		   .itlbcache		(itlbcache),
		   // Inputs
		   .clk			(clk),
		   .phi1		(phi1),
		   .phi2		(phi2),
		   .pc			(pc[63:0]),
		   .itlbreq		(itlbreq),
		   .itlbfill		(itlbfill),
		   .jtlbpa		(jtlbpa[31:0]),
		   .jtlbmiss		(jtlbmiss),
		   .jtlbade		(jtlbade),
		   .jtlbinval		(jtlbinval),
		   .jtlbcache		(jtlbcache));
endmodule

// Local Variables:
// verilog-library-directories:("." "..")
// End:
