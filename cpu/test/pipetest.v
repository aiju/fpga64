`include "cpu.vh"

module pipetest();

`include "cpuconst.vh"

	/*AUTOWIRE*/
	// Beginning of automatic wires (for undeclared instantiated-module outputs)
	wire		cp0taglodcset;		// From cache0 of cache.v
	wire [31:0]	cp0taglodcval;		// From cache0 of cache.v
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
	wire		icbusy;			// From cache0 of cache.v
	wire		icfill;			// From pipe0 of pipe.v
	wire [31:0]	icinstr;		// From cache0 of cache.v
	wire [20:0]	ictag;			// From cache0 of cache.v
	wire		itlbfill;		// From pipe0 of pipe.v
	wire		jtlbreq;		// From pipe0 of pipe.v
	wire [63:0]	jtlbva;			// From pipe0 of pipe.v
	wire [63:0]	pc;			// From pipe0 of pipe.v
	wire [`DECMAX:0] rfdec;			// From idec0 of idec.v
	wire [31:0]	rfinstr;		// From pipe0 of pipe.v
	// End of automatics
	/*AUTOREGINPUT*/
	// Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
	reg		clk;			// To pipe0 of pipe.v, ...
	reg [31:0]	cp0taglo;		// To cache0 of cache.v
	reg		exfpe;			// To pipe0 of pipe.v
	reg		exterror;		// To cache0 of cache.v
	reg [63:0]	extrdata;		// To cache0 of cache.v
	reg		extrdy;			// To cache0 of cache.v
	reg		extreply;		// To cache0 of cache.v
	reg		extreplyto;		// To cache0 of cache.v
	reg		icerror;		// To pipe0 of pipe.v
	reg		icreq;			// To cache0 of cache.v
	reg		irq;			// To pipe0 of pipe.v
	reg		irqen;			// To pipe0 of pipe.v
	reg		itlbbusy;		// To pipe0 of pipe.v
	reg		itlbmiss;		// To pipe0 of pipe.v
	reg [31:0]	itlbpa;			// To pipe0 of pipe.v, ...
	reg		jtlbcache;		// To pipe0 of pipe.v
	reg		jtlbdirty;		// To pipe0 of pipe.v
	reg		jtlberror;		// To pipe0 of pipe.v
	reg		jtlbmiss;		// To pipe0 of pipe.v
	reg [31:0]	jtlbpa;			// To pipe0 of pipe.v
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
		mem[0] = 64'h200801008D090004;
		mem[1] = 64'h21290001ad090004;
		mem[2] = 64'h8d0a000400000000;
		mem[32] = 64'hDEADBEEFCAFEBABE;
	
		clk = 1;
		phi1 = 1;
		phi2 = 0;
		exfpe = 0;
		irq = 0;
		irqen = 0;
		itlbbusy = 0;
		itlbmiss = 0;
		jtlbcache = 1;
		jtlbdirty = 0;
		jtlberror = 0;
		jtlbmiss = 0;
	end
	//always @(*) jtlbcache = !jtlbva[8];
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
	initial extstate = EXTIDLE;

	always @(posedge clk)
		if(phi2) begin
			extstate <= extstate_;
			if(loadaddr) begin
				addrreg <= extaddr >> 3;
				src <= extsrc;
			end
		end
		
	always @(*) begin
		jtlbpa = jtlbva;
		itlbpa = pc;
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
				else
					extstate_ = EXTDR0;
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
		endcase
	end
	
	pipe pipe0(/*AUTOINST*/
		   // Outputs
		   .pc			(pc[63:0]),
		   .icfill		(icfill),
		   .rfinstr		(rfinstr[31:0]),
		   .exdec		(exdec[`DECMAX:0]),
		   .exinstr		(exinstr[31:0]),
		   .exlink		(exlink[63:0]),
		   .exr0		(exr0[63:0]),
		   .exr1		(exr1[63:0]),
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
		   .dcdata		(dcdata[63:0]),
		   .dctag		(dctag[21:0]),
		   .dcdbe		(dcdbe),
		   .dcbusy		(dcbusy),
		   .itlbpa		(itlbpa[31:0]),
		   .itlbmiss		(itlbmiss),
		   .itlbbusy		(itlbbusy),
		   .jtlbpa		(jtlbpa[31:0]),
		   .jtlbmiss		(jtlbmiss),
		   .jtlberror		(jtlberror),
		   .jtlbdirty		(jtlbdirty),
		   .jtlbcache		(jtlbcache),
		   .reset		(reset),
		   .nmi			(nmi),
		   .irq			(irq),
		   .irqen		(irqen));

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
		 // Inputs
		 .clk			(clk),
		 .exdec			(exdec[`DECMAX:0]),
		 .exinstr		(exinstr[31:0]),
		 .exr0			(exr0[63:0]),
		 .exr1			(exr1[63:0]),
		 .exlink		(exlink[63:0]));

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
		     .pc		(pc[63:0]),
		     .icreq		(icreq),
		     .itlbpa		(itlbpa[31:0]),
		     .icfill		(icfill),
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
endmodule

// Local Variables:
// verilog-library-directories:("." "..")
// End:
