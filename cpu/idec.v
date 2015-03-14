`include "cpu.vh"

module idec(
	input wire clk,

	input wire [31:0] rfinstr,
	output reg [`DECMAX:0] rfdec
);
`include "cpuconst.vh"

	localparam [`DECMAX:0] LOADINSTR = ALUADDIMM<<DECALU|1<<DECREGRS|1<<DECSETRT|1<<DECLOAD;
	localparam [`DECMAX:0] STOREINSTR = ALUADDIMM<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSTORE;

	always @(*) begin
		rfdec = 1<<DECINVALID;
		casez(rfinstr)
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100000: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED; /* ADD */
		32'b001000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECSIGNED; /* ADDI */
		32'b001001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT; /* ADDIU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100001: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* ADDU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100100: rfdec = ALUAND<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* AND */
		32'b001100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUAND<<DECALU|1<<DECREGRS|1<<DECZIMM|1<<DECSETRT; /* ANDI */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101100: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED|1<<DECDWORD|1<<DEC64; /* DADD */
		32'b011000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECSIGNED|1<<DECDWORD|1<<DEC64; /* DADDI */
		32'b011001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECDWORD|1<<DEC64; /* DADDIU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101101: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DADDU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011110: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD|1<<DECSIGNED|1<<DEC64; /* DDIV */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011111: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD|1<<DEC64; /* DDIVU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011010: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSIGNED; /* DIV */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011011: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT; /* DIVU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011100: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD|1<<DECSIGNED|1<<DEC64; /* DMULT */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011101: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD|1<<DEC64; /* DMULTU */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111000: rfdec = ALUSLL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DSLL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_010100: rfdec = ALUSLL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DSLLV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111100: rfdec = ALUSLL<<DECALU|1<<DECREGRT|3<<DECSHIMM|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DSLL32 */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111011: rfdec = ALUSRA<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DSRA */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_010111: rfdec = ALUSRA<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DSRAV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111111: rfdec = ALUSRA<<DECALU|1<<DECREGRT|3<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSRA32 */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111010: rfdec = ALUSRL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSRL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_010110: rfdec = ALUSRL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DSRLV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111110: rfdec = ALUSRL<<DECALU|1<<DECREGRT|3<<DECSHIMM|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DSRL32 */	
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101110: rfdec = ALUSUB<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED|1<<DECDWORD|1<<DEC64; /* DSUB */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101111: rfdec = ALUSUB<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD|1<<DEC64; /* DSUBU */
		32'b001111_00000_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALULUI<<DECALU|1<<DECSETRT|1<<DECZIMM; /* LUI */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011000: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSIGNED; /* MULT */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011001: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT; /* MULTU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100111: rfdec = ALUNOR<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* NOR */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100101: rfdec = ALUOR<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* OR */
		32'b001101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUOR<<DECALU|1<<DECREGRS|1<<DECZIMM|1<<DECSETRT; /* ORI */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_000000: rfdec = ALUSLL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD; /* SLL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_000100: rfdec = ALUSLL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* SLLV */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101010: rfdec = ALUSLT<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED; /* SLT */
		32'b001010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUSLT<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECSIGNED; /* SLTI */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101010: rfdec = ALUSLT<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* SLTU */
		32'b001011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUSLT<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT; /* SLTIU */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_000011: rfdec = ALUSRA<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD; /* SRA */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_000111: rfdec = ALUSRA<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* SRAV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_000010: rfdec = ALUSRL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD; /* SRL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_000110: rfdec = ALUSRL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* SRLV */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100010: rfdec = ALUSUB<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED; /* SUB */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100011: rfdec = ALUSUB<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* SUBU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100110: rfdec = ALUXOR<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* XOR */
		32'b001110_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUXOR<<DECALU|1<<DECREGRS|1<<DECZIMM|1<<DECSETRT; /* XORI */
		
		32'b100000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZBYTE<<DECSZ|1<<DECSIGNED; /* LB */
		32'b100100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZBYTE<<DECSZ; /* LBU */
		32'b110111_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDWORD<<DECSZ; /* LD */
		32'b110101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR&~(1<<DECSETRT)|1<<DECSETFT|SZDWORD<<DECSZ|1<<DECCOP|1<<DEC64; /* LDC1 */
		32'b011010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|1<<DECREGRT|SZDLEFT<<DECSZ|1<<DEC64; /* LDL */
		32'b011011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|1<<DECREGRT|SZDRIGHT<<DECSZ|1<<DEC64; /* LDR */
		32'b100001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZHALF<<DECSZ|1<<DECSIGNED; /* LH */
		32'b100101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZHALF<<DECSZ; /* LHU */
		32'b110000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZWORD<<DECSZ|1<<DECLLSC; /* LL */
		32'b110100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDWORD<<DECSZ|1<<DECLLSC|1<<DEC64; /* LLD */
		32'b100011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZWORD<<DECSZ|1<<DECSIGNED; /* LW */
		32'b110001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR&~(1<<DECSETRT)|1<<DECSETFT|SZWORD<<DECSZ|1<<DECCOP; /* LWC1 */
		32'b100010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|1<<DECREGRT|SZLEFT<<DECSZ; /* LWL */
		32'b100110_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|1<<DECREGRT|SZRIGHT<<DECSZ; /* LWR */
		32'b100111_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZWORD<<DECSZ|1<<DEC64; /* LWU */
		
		32'b101000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZBYTE<<DECSZ; /* SB */
		32'b111000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZWORD<<DECSZ|1<<DECSETRT|1<<DECLLSC; /* SC */
		32'b111100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDWORD<<DECSZ|1<<DECSETRT|1<<DECLLSC|1<<DEC64; /* SCD */
		32'b111111_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDWORD<<DECSZ|1<<DEC64; /* SD */
		32'b111101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR&~(1<<DECREGRT)|1<<DECREGFT|SZDWORD<<DECSZ|1<<DECCOP|1<<DEC64; /* SDC1 */
		32'b101100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDLEFT<<DECSZ|1<<DEC64; /* SDL */
		32'b101101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDRIGHT<<DECSZ|1<<DEC64; /* SDR */
		32'b101001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZHALF<<DECSZ; /* SH */
		32'b101011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZWORD<<DECSZ; /* SW */
		32'b111001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR&~(1<<DECREGRT)|1<<DECREGFT|SZWORD<<DECSZ|1<<DECCOP; /* SWC1 */
		32'b101010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZLEFT<<DECSZ; /* SWL */
		32'b101110_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZRIGHT<<DECSZ; /* SWR */

		32'b000100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|1<<DECREGRT|CONDEQ<<DECCOND; /* BEQ */
		32'b010100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|1<<DECREGRT|CONDEQ<<DECCOND|1<<DECLIKELY; /* BEQ */
		32'b000001_zzzzz_00001_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDGE<<DECCOND; /* BGEZ */
		32'b000001_zzzzz_10001_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDGE<<DECCOND|1<<DECLINK; /* BGEZAL */
		32'b000001_zzzzz_10011_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDGE<<DECCOND|1<<DECLINK|1<<DECLIKELY; /* BGEZALL */
		32'b000001_zzzzz_00011_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDGE<<DECCOND|1<<DECLIKELY; /* BGEZL */
		32'b000111_zzzzz_00000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDGT<<DECCOND; /* BGTZ */
		32'b010111_zzzzz_00000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDGT<<DECCOND|1<<DECLIKELY; /* BGTZL */
		32'b000110_zzzzz_00000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDLE<<DECCOND; /* BLEZ */
		32'b010110_zzzzz_00000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDLE<<DECCOND|1<<DECLIKELY; /* BLEZL */
		32'b000001_zzzzz_00000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDLT<<DECCOND; /* BLTZ */
		32'b000001_zzzzz_10000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDLT<<DECCOND|1<<DECLINK; /* BLTZAL */
		32'b000001_zzzzz_10010_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDLT<<DECCOND|1<<DECLINK|1<<DECLIKELY; /* BLTZALL */
		32'b000001_zzzzz_00010_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|CONDLT<<DECCOND|1<<DECLIKELY; /* BLTZL */
		32'b000101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|1<<DECREGRT|CONDNE<<DECCOND; /* BNE */
		32'b010101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECREGRS|1<<DECREGRT|CONDNE<<DECCOND|1<<DECLIKELY; /* BNEL */
		32'b000010_zz_zzzzzzzz_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECJUMP; /* J */
		32'b000011_zz_zzzzzzzz_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECBRANCH|1<<DECJUMP|1<<DECLINK; /* JAL */
		32'b000000_zzzzz_00000_zzzzz_00000_001001: rfdec = 1<<DECBRANCH|1<<DECJUMPREG|1<<DECREGRS|1<<DECSETRD|1<<DECLINK; /* JALR */
		32'b000000_zzzzz_00000_00000_00000_001000: rfdec = 1<<DECBRANCH|1<<DECJUMPREG|1<<DECREGRS; /* JR */
		
		32'b000000_zzzzzzzzzz_zzzzzzzzzz_001100: rfdec = 1<<DECSYSCALL; /* SYSCALL */
		32'b000000_zzzzzzzzzz_zzzzzzzzzz_001101: rfdec = 1<<DECBREAK; /* BREAK */
		32'b101111_zzzzz_zzz0z_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECCACHE|ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|rfinstr[16]<<DECDCACHE|rfinstr[20:18]<<DECCACHEOP|1<<DECCOP; /* CACHE */
		32'b010000_1000000000_0000000000_011000: rfdec = 1<<DECBRANCH|1<<DECERET; /* ERET */
		32'b010000_1000000000_0000000000_000001: rfdec = 1<<DECTLBR|1<<DECCOP; /* TLBR */
		32'b010000_1000000000_0000000000_000010: rfdec = 1<<DECTLBWI|1<<DECCOP; /* TLBWI */
		32'b010000_1000000000_0000000000_000110: rfdec = 1<<DECTLBWR|1<<DECCOP; /* TLBWR */
		32'b010000_1000000000_0000000000_001000: rfdec = 1<<DECTLBP|1<<DECCOP; /* TLBP */
		
		32'b000000_0000000000_zzzzz_00000_010010: rfdec = ALUMFLO<<DECALU|1<<DECSETRD; /* MFLO */
		32'b000000_0000000000_zzzzz_00000_010000: rfdec = ALUMFHI<<DECALU|1<<DECSETRD; /* MFHI */
		32'b000000_zzzzz_000000000000000_010001: rfdec = ALUMTLO<<DECALU|1<<DECREGRS; /* MTLO */
		32'b000000_zzzzz_000000000000000_010011: rfdec = ALUMTHI<<DECALU|1<<DECREGRS; /* MTHI */
		
		32'b000000_zzzzz_zzzzz_zzzzzzzzzz_110100: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECREGRT|CONDEQ<<DECCOND; /* TEQ */
		32'b000001_zzzzz_01100_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECSIMM|CONDEQ<<DECCOND; /* TEQI */
		32'b000000_zzzzz_zzzzz_zzzzzzzzzz_110000: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECREGRT|CONDGET<<DECCOND; /* TGE */
		32'b000001_zzzzz_01000_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECSIMM|CONDGET<<DECCOND; /* TGEI */
		32'b000000_zzzzz_zzzzz_zzzzzzzzzz_110001: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECREGRT|CONDGEUT<<DECCOND; /* TGEU */
		32'b000001_zzzzz_01001_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECSIMM|CONDGEUT<<DECCOND; /* TGEIU */
		32'b000000_zzzzz_zzzzz_zzzzzzzzzz_110110: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECREGRT|CONDNE<<DECCOND; /* TNE */
		32'b000001_zzzzz_01110_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECSIMM|CONDNE<<DECCOND; /* TNEI */
		32'b000000_zzzzz_zzzzz_zzzzzzzzzz_110010: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECREGRT|CONDLTT<<DECCOND; /* TLT */
		32'b000001_zzzzz_01010_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECSIMM|CONDLTT<<DECCOND; /* TLTI */
		32'b000000_zzzzz_zzzzz_zzzzzzzzzz_110011: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECREGRT|CONDLTUT<<DECCOND; /* TLTU */
		32'b000001_zzzzz_01011_zzzzzzzz_zzzzzzzz: rfdec = 1<<DECTRAP|1<<DECREGRS|1<<DECSIMM|CONDLTUT<<DECCOND; /* TLTIU */
		
		32'b010000_00100_zzzzz_zzzzz_00000000000: rfdec = 1<<DECMTC0|1<<DECREGRT|1<<DECCOP; /* MTC0 */
		32'b010000_00101_zzzzz_zzzzz_00000000000: rfdec = 1<<DECMTC0|1<<DECREGRT|1<<DECCOP|1<<DECDWORD|1<<DEC64; /* DMTC0 */
		32'b010000_00000_zzzzz_zzzzz_00000000000: rfdec = 1<<DECMFC0|1<<DECSETRT|1<<DECCOP; /* MFC0 */
		32'b010000_00001_zzzzz_zzzzz_00000000000: rfdec = 1<<DECMFC0|1<<DECSETRT|1<<DECCOP|1<<DECDWORD|1<<DEC64; /* DMFC0 */
		endcase
		
		if(rfdec[DECSETRD])
			rfdec[DECTARGR+5:DECTARGR] = {1'b0, rfinstr[15:11]};
		else if(rfdec[DECSETRT])
			rfdec[DECTARGR+5:DECTARGR] = {1'b0, rfinstr[20:16]};
		else if(rfdec[DECLINK])
			rfdec[DECTARGR+5:DECTARGR] = 31;
		
		if(rfdec[DECALU+4:DECALU] == ALUMUL || rfdec[DECALU+4:DECALU] == ALUDIV)
			rfdec[DECLONGALU] = 1;
	end

endmodule
