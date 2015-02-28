`include "cpu.vh"

module cache(
	input wire clk,
	input wire phi1,
	input wire phi2,
	
	input wire [63:0] pc,
	output reg [31:0] icinstr,
	output reg [20:0] ictag,
	input wire icreq,
	input wire [31:0] itlbpa,
	input wire icfill,
	output reg icbusy,
	
	input wire [63:0] dcva,
	input wire [31:0] dcpa,
	output reg [63:0] dcdata,
	output reg [21:0] dctag,
	input wire [63:0] dcwdata,
	input wire [2:0] dcsz,
	input wire dcread,
	input wire dcwrite,
	input wire dcfill,
	input wire dccache,
	input wire dcdoop,
	input wire [2:0] dcop,
	output reg dcbusy,
	
	output reg [31:0] extaddr,
	output reg [63:0] extwdata,
	output reg [4:0] extsz,
	output reg extreq,
	output reg extwr,
	output reg extsrc,
	input wire extrdy,
	input wire extreply,
	input wire extreplyto,
	input wire [63:0] extrdata
);

`include "cpuconst.vh"

	reg [31:0] dcextaddr, icextaddr;
	reg [4:0] dcextsz, icextsz;
	reg dcextreq, icextreq, dcextrdy, icextrdy;
	reg dcextwr;

	reg [63:0] ddata[0:1023], idata[0:2047];
	reg [21:0] dtag[0:511];
	reg [20:0] itag[0:511];
	reg dcload, dchalf, icload;
	reg [1:0] icctr;
	reg clricctr, incicctr;
	
	reg [3:0] dcstate, dcstate_;
	localparam DCIDLE = 0;
	localparam DCREAD = 1;
	localparam DCWRITE = 2;
	localparam DCWRITE2 = 3;
	localparam DCRECV = 4;
	localparam DCRECV2 = 5;
	localparam DCREADU = 6;
	localparam DCRECVU = 7;
	localparam DCWRITEU = 8;
	
	reg [2:0] icstate, icstate_;
	localparam ICIDLE = 0;
	localparam ICREAD = 1;
	localparam ICRECV = 2;
	
	integer i;
	initial begin
		for(i = 0; i < 512; i = i + 1) begin
			dtag[i] = 0;
			itag[i] = 0;
		end
		dcstate = DCIDLE;
		icstate = ICIDLE;
	end
	
	always @(*) begin
		case(dcstate)
		DCRECVU:
			dcdata = extrdata >> ((7 - dcsz - dcva[2:0]) * 8);
		DCWRITE, DCWRITE2:
			dcdata = ddata[{dcva[12:4], dcstate == DCWRITE2}];
		default:
			dcdata = ddata[dcva[12:3]] >> ((7 - dcsz - dcva[2:0]) * 8);
		endcase
		dctag = dtag[dcva[12:4]];
		icinstr = pc[2] ? idata[pc[13:3]][31:0] : idata[pc[13:3]][63:32];
		ictag = itag[pc[13:5]];
	end
	
	reg [5:0] pos;
	always @(posedge clk) begin
		if(phi2) begin
			if(dcload) begin
				ddata[{dcva[12:4], dchalf}] <= extrdata;
				dtag[dcva[12:4]] <= {2'b10, dcpa[31:12]};
			end
			if(dcwrite && dccache) begin
				pos = {dcva[2:0], 3'b000};
				case(dcsz)
				0: ddata[dcva[12:3]][56 - pos +: 8] <= dcwdata[7:0];
				1: ddata[dcva[12:3]][48 - pos +: 16] <= dcwdata[15:0];
				2: ddata[dcva[12:3]][40 - pos +: 24] <= dcwdata[23:0];
				3: ddata[dcva[12:3]][32 - pos +: 32] <= dcwdata[31:0];
				4: ddata[dcva[12:3]][24 - pos +: 40] <= dcwdata[39:0];
				5: ddata[dcva[12:3]][16 - pos +: 48] <= dcwdata[47:0];
				6: ddata[dcva[12:3]][8 - pos +: 56] <= dcwdata[55:0];
				7: ddata[dcva[12:3]] <= dcwdata;
				endcase
				dtag[dcva[12:4]][20] <= 1;
			end
			if(icload) begin
				idata[{pc[13:5], icctr}] <= extrdata;
				itag[pc[13:5]] <= {1'b1, dcpa[31:12]};
			end
			if(clricctr)
				icctr <= 0;
			if(incicctr)
				icctr <= icctr + 1;
			dcstate <= dcstate_;
			icstate <= icstate_;
		end
	end

	
	always @(*) begin
		dcextrdy = extrdy;
		icextrdy = extrdy && !dcextreq;
		extsrc = dcextreq;
		extaddr = extsrc ? dcextaddr : icextaddr;
		extsz = extsrc ? dcextsz : icextsz;
		extwr = extsrc && dcextwr;
		extreq = extsrc ? dcextreq : icextreq;
	end
	
	always @(*) begin
		dcstate_ = dcstate;
		dcextaddr = 32'bx;
		extwdata = 64'bx;
		dcextwr = 0;
		dcextreq = 0;
		dcextsz = 0;
		dcload = 0;
		dcbusy = 1;
		dchalf = 1'bx;
		case(dcstate)
		DCIDLE: begin
			dcbusy = 0;
			if(dcfill)
				if(dccache)
					dcstate_ = DCREAD;
				else if(dcwrite)
					dcstate_ = DCWRITEU;
				else
					dcstate_ = DCREADU;
		end
		DCREAD: begin
			dcextaddr = dcpa & ~7;
			dcextsz = 15;
			dcextreq = 1;
			if(dcextrdy)
				if(dctag[21:20] == 2'b11)
					dcstate_ = DCWRITE;
				else
					dcstate_ = DCRECV;
		end
		DCWRITE: begin
			dcextaddr = {dctag[19:0], dcva[11:4], 4'd0};
			dcextsz = 15;
			dcextreq = 1;
			extwdata = dcdata;
			if(dcextrdy)
				dcstate_ = DCWRITE2;
		end
		DCWRITE2: begin
			extwdata = dcdata;
			dcextreq = 1;
			dcstate_ = DCRECV;
		end
		DCRECV:
			if(extreply && extreplyto) begin
				dcload = 1;
				dchalf = dcva[3];
				dcstate_ = DCRECV2;
			end
		DCRECV2:
			if(extreply && extreplyto) begin
				dcload = 1;
				dchalf = !dcva[3];
				dcstate_ = DCIDLE;
			end
		DCREADU: begin
			dcextaddr = dcpa;
			dcextsz = dcsz;
			dcextreq = 1;
			if(dcextrdy)
				dcstate_ = DCRECVU;
		end
		DCRECVU:
			if(extreply && extreplyto) begin
				dcbusy = 0;
				dcstate_ = DCIDLE;
			end
		DCWRITEU: begin
			dcextaddr = dcpa;
			dcextsz = dcsz;
			dcextreq = 1;
			extwdata = dcwdata;
			if(dcextrdy) begin
				dcbusy = 0;
				dcstate_ = DCIDLE;
			end
		end
		endcase
	end
	
	always @(*) begin
		icstate_ = icstate;
		icextaddr = 32'bx;
		icextreq = 0;
		icextsz = 31;
		clricctr = 0;
		incicctr = 0;
		icload = 0;
		icbusy = 1;
		case(icstate)
		ICIDLE: begin
			icbusy = 0;
			if(icfill)
				icstate_ = ICREAD;
		end
		ICREAD: begin
			icextaddr = itlbpa;
			icextreq = 1;
			if(icextrdy) begin
				icstate_ = ICRECV;
				clricctr = 1;
			end
		end
		ICRECV:
			if(extreply && !extreplyto) begin
				icload = 1;
				incicctr = 1;
				if(icctr == 3)
					icstate_ = ICIDLE;
			end
		endcase
	end

endmodule
