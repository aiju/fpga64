`include "cpu.vh"

module bus(
	input wire clk,
	input wire phi1,
	input wire phi2,
	input wire bustick,
	
	input wire [31:0] extaddr,
	input wire [63:0] extwdata,
	input wire [4:0] extsz,
	input wire extreq,
	input wire extwr,
	input wire extsrc,
	output wire extrdy,
	output wire extreply,
	output wire extreplyto,
	output wire [63:0] extrdata,
	output wire exterror,
	
	output reg [31:0] sysadout,
	output reg [4:0] syscmdout,
	input wire [31:0] sysadin,
	input wire [4:0] syscmdin,
	input wire ereq,
	output reg preq,
	input wire evalid,
	output reg pvalid,
	output reg pmaster,
	input wire eok
);

	reg [3:0] bufwr;
	reg [4:0] bufsz[0:3];
	reg [31:0] bufaddr[0:3];
	reg [63:0] bufdata[0:3];
	reg [2:0] bufpos;
	reg consume;
	assign extrdy = !bufpos[2];
	
	wire [2:0] wrpos = consume ? bufpos - 1 : bufpos;
	
	integer i;
	always @(posedge clk) begin
		if(consume && bustick) begin
			for(i = 0; i < bufpos - 1; i++) begin
				bufwr[i] <= bufwr[i+1];
				bufsz[i] <= bufsz[i+1];
				bufaddr[i] <= bufaddr[i+1];
				bufdata[i] <= bufdata[i+1];
			end
		end
		if(extreq && phi2) begin
			bufwr[wrpos] <= extwr;
			bufwr[wrpos] <= extsz;
			bufaddr[wrpos] <= extaddr;
			bufdata[wrpos] <= extwdata; 
		end
		if(consume && bustick && (!extreq || !phi2))
			bufpos <= bufpos - 1;
		if(extreq && phi2 && (!consume || !bustick))
			bufpos <= bufpos + 1;
	end
	
	reg ereq0, evalid0, eok0, preq_, pvalid_, pmaster_;
	reg [31:0] sysadin0, sysadout_;
	reg [4:0] syscmdin0, syscmdout_;
	reg [2:0] state, state_;
	reg [2:0] pos, pos_;
	reg pending, pending_;
	localparam IDLE = 0;
	localparam WRDAT = 1;
	
	always @(posedge clk)
		if(bustick) begin
			ereq0 <= ereq;
			evalid0 <= evalid;
			eok0 <= eok;
			sysadin0 <= sysadin;
			syscmdin0 <= syscmdin;
			
			syscmdout <= syscmdout_;
			sysadout <= sysadout_;
			preq <= preq_;
			pvalid <= pvalid_;
			pmaster <= pmaster_;
			
			state <= state_;
			pos <= pos_;
			pending <= pending_;
		end
	
	always @(*) begin
		pmaster_ = 1;
		pvalid_ = 0;
		preq_ = 0;
		consume = 0;
		sysadout_ = 32'bx;
		syscmdout_ = 5'bx;
		state_ = state;
		pos_ = pos;
		pending_ = pending;
		case(state)
		IDLE: begin
			pos_ = 0;
			if(bufpos != 0) begin
				sysadout_ = bufaddr[0];
				pvalid_ = 1;
				syscmdout_[4] = 0;
				syscmdout_[3] = bufwr[0];
				case(bufsz[0])
				0, 1, 2, 3: syscmdout_[2:0] = bufsz[0][2:0];
				4, 5, 6: syscmdout_[2:0] = 3'd3;
				7: syscmdout_[2:0] = 3'b100;
				15: syscmdout_[2:0] = 3'b101;
				31: syscmdout_[2:0] = 3'b110;
				endcase
				if(eok0)
					state_ = bufwr[0] ? WRDAT : RDWAIT;
			end
		end
		WRDAT: begin
			sysadout_ = bemem ^ pos[0] ? bufdata[0][63:32] : bufdata[0][31:0];
			syscmdout_ = {1'b1, pos == bufsz[0][4:2] || !eok0 && pos == 0, 3'd0};
			pvalid_ = 1;
			if(syscmdout_[3])
				state_ = IDLE;
			if((pos == bufsz[0][4:2] || pos[1]) && (eok0 || pos != 0))
				consume = 1;
		end
		RDWAIT: begin
			pmaster_ = 0;
			if(!eok0 && !ereq)
				state_ = IDLE;
			else begin
				pending_ = eok0;
				state_ = SLAVE;
			end
		end
		SLAVE: begin
			pmaster_ = 0;
			if(!pending && !ereq)
				state_ = IDLE;
			
		end
		endcase
	end
	
	initial
		bufpos = 0;

endmodule
