`include "cpu.vh"

module alu(
	input wire clk,
	input wire phi1,
	input wire phi2,
	input wire [`DECMAX:0] exdec,
	input wire [31:0] exinstr,
	input wire [63:0] exr0,
	input wire [63:0] exr1,
	input wire [63:0] exlink,
	output reg [63:0] exalur,
	output reg exovfl,
	output reg exbcmp,
	input wire alugo,
	output reg alubusy,
	output wire [63:0] lo,
	output wire [63:0] hi
);
`include "cpuconst.vh"

	reg [63:0] v;
	wire [5:0] n = {exdec[DECSHIMM32], exr0[4:0]};
	wire signed [31:0] s32 = exr1[31:0];
	wire signed [63:0] s64 = exr1;
	wire signed [63:0] s640 = exr0;

	always @(*) begin
		exovfl = 0;
		exalur = 64'bx;
		case(exdec[DECALU+4:DECALU])
		ALUNOP: exalur = exr0;
		ALUADD: begin
			exalur = exr0 + exr1;
			v = ~(exr0 ^ exr1) & (exr0 ^ exalur);
			exovfl = exdec[DECSIGNED] && (exdec[DECDWORD] ? v[63] : v[31]);
		end
		ALUSUB: begin
			exalur = exr0 - exr1;
			v = (exr0 ^ exr1) & (exr0 ^ exalur);
			exovfl = exdec[DECSIGNED] && (exdec[DECDWORD] ? v[63] : v[31]);
		end
		ALUAND: exalur = exr0 & exr1;
		ALUOR: exalur = exr0 | exr1;
		ALUNOR: exalur = ~(exr0 | exr1);
		ALUXOR: exalur = exr0 ^ exr1;
		ALUSLL: begin
			exalur = exr1 << n;
			if(!exdec[DECDWORD])
				exalur[63:32] = {32{exalur[31]}};
		end
		ALUSRL: begin
			if(exdec[DECDWORD])
				exalur = exr1 >> n;
			else
				exalur = {32'd0, exr1[31:0] >> n};
			if(!exdec[DECDWORD])
				exalur[63:32] = {32{exalur[31]}};
		end
		ALUSRA:
			if(exdec[DECDWORD])
				exalur = s64 >>> n;
			else
				exalur = {{32{s32[31]}}, s32 >>> n};
		ALULUI: exalur = {{32{exr1[15]}}, exr1[15:0], 16'd0};
		ALUADDIMM: exalur = {{48{exinstr[15]}}, exinstr[15:0]} + exr0;
		ALUSLT:
			if(exdec[DECSIGNED])
				exalur = {63'd0, s640 < s64};
			else
				exalur = {63'd0, exr0 < exr1};
		ALUMFLO:
			exalur = lo;
		ALUMFHI:
			exalur = hi;
		endcase
		if(exdec[DECLINK])
			exalur = exlink;
	end
	
	always @(*) begin
		case(exdec[DECCOND+2:DECCOND])
		CONDAL: exbcmp = 1;
		CONDEQ: exbcmp = exr0 == exr1;
		CONDNE: exbcmp = exr0 != exr1;
		CONDGE: exbcmp = !exr0[63];
		CONDGT: exbcmp = !exr0[63] && exr0 != 0;
		CONDLT: exbcmp = exr0[63];
		CONDLE: exbcmp = exr0[63] || exr0 == 0;
		default: exbcmp = 1'bx;
		endcase
		if(!exdec[DECBRANCH])
			exbcmp = 0;
	end

	reg signed [17:0] mula, mulb, mulc, muld;
	reg [7:0] src, src0;
	wire sx0 = exdec[DECSIGNED] && src[6] && (src[7] || !exdec[DECDWORD]);
	wire sx1 = exdec[DECSIGNED] && src[4] && (src[5] || !exdec[DECDWORD]);
	wire sx2 = exdec[DECSIGNED] && src[3:2] == 3;
	wire sx3 = exdec[DECSIGNED] && src[1:0] == 3;
	always @(*) begin
		mula[15:0] = exr0[src[7:6] * 16 +: 16];
		mulb[15:0] = exr1[src[5:4] * 16 +: 16];
		mulc[15:0] = exr0[src[3:2] * 16 +: 16];
		muld[15:0] = exr1[src[1:0] * 16 +: 16];
		mula[17:16] = {2{sx0 && mula[15]}};
		mulb[17:16] = {2{sx1 && mulb[15]}};
		mulc[17:16] = {2{sx2 && mulc[15]}};
		muld[17:16] = {2{sx3 && muld[15]}};
	end
	wire signed [35:0] mulr = mula * mulb;
	wire signed [35:0] muls = mulc * muld;

	reg [3:0] dst;
	reg lohifix, lohiclr;
	reg [127:0] hilo, hilo_;
	
	assign lo = hilo[63:0];
	assign hi = hilo[127:64];

	always @(*) begin
		hilo_ = lohiclr ? 0 : hilo;
		if(lohifix)
			hilo_ = {{32{hilo[63]}}, hilo[63:32], {32{hilo[31]}}, hilo[31:0]};
		else begin
			hilo_ = hilo_ + ({{96{(sx0 || sx1) && mulr[31]}}, mulr[31:0]} << {{1'b0, src[7:6]} + {1'b0, src[5:4]}, 4'd0});
			if(exdec[DECDWORD])
				hilo_ = hilo_ + ({{96{(sx2 || sx3) && muls[31]}}, muls[31:0]} << {{1'b0, src[3:2]} + {1'b0, src[1:0]}, 4'd0});
		end
	end
	
	reg [3:0] state, state_;
	localparam IDLE = 0;
	localparam MUL0 = 1;
	localparam MUL1 = 2;
	localparam MUL2 = 3;
	localparam MUL3 = 4;
	localparam DM0 = 5;
	localparam DM1 = 6;
	localparam DM2 = 7;
	localparam DM3 = 8;
	localparam DM4 = 9;
	localparam DM5 = 10;
	localparam DM6 = 11;
	wire sx = exdec[DECSIGNED];
	
	always @(posedge clk)
		if(phi2) begin
			state <= state_;
			hilo <= hilo_;
			src0 <= src;
		end
	
	always @(*) begin
		state_ = state;
		alubusy = 1;
		src = 0;
		dst = 0;
		lohifix = 0;
		lohiclr = 0;
		case(state)
		IDLE: begin
			alubusy = 0;
			if(alugo && exdec[DECALU+4:DECALU] == ALUMUL) begin
				lohiclr = 1;
				if(exdec[DECDWORD]) begin
					src = 8'b00000001;
					state_ = DM0;
				end else begin
					src = 8'b00000000;
					state_ = MUL0;
				end
			end
		end
		MUL0: begin
			src = 8'b00010000;
			state_ = MUL1;
		end
		MUL1: begin
			src = 8'b01000000;
			state_ = MUL2;
		end
		MUL2: begin
			src = 8'b01010000;
			state_ = MUL3;
		end
		MUL3: begin
			lohifix = 1;
			state_ = IDLE;
		end
		DM0, DM1, DM2, DM3, DM4, DM5: begin
			src = src0 + 8'b00100010;
			state_ = state + 1;
		end
		DM6: begin
			src = src0 + 8'b00100010;
			state_ = IDLE;
		end
		endcase
	end
	
	initial state = IDLE;

endmodule
