`include "cpu.vh"

module alu(
	input wire clk,
	input wire [`DECMAX:0] exdec,
	input wire [31:0] exinstr,
	input wire [63:0] exr0,
	input wire [63:0] exr1,
	input wire [63:0] exlink,
	output reg [63:0] exalur,
	output reg exovfl,
	output reg exbcmp
);
`include "cpuconst.vh"

	reg [63:0] v;
	wire [5:0] n = {exdec[DECSHIMM32], exr0[4:0]};
	wire signed [31:0] s32 = exr1[31:0];
	wire signed [63:0] s64 = exr1;
	wire signed [64:0] s640 = exr0;

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
		ALULUI: exalur = {{32{exr0[15]}}, exr0[15:0], 16'd0};
		ALUADDIMM: exalur = {{48{exinstr[15]}}, exinstr[15:0]} + exr0;
		ALUSLT:
			if(exdec[DECSIGNED])
				exalur = s640 < s64;
			else
				exalur = exr0 < exr1;
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

endmodule
