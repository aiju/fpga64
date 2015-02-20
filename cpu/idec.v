`include "cpu.vh"

module idec(
	input wire clk,

	input wire [31:0] rfinstr,
	output reg [DECMAX:0] rfdec
);
`include "cpuconst.vh"

	localparam LOADINSTR = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECLOAD;
	localparam STOREINSTR = ALUADDIMM<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSTORE;

	always @(*) begin
		rfdec = 1<<DECINVALID;
		casez(rfinstr)
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100000: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED; /* ADD */
		32'b001000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECSIGNED; /* ADDI */
		32'b001001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT; /* ADDIU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100001: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* ADDU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100100: rfdec = ALUAND<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* AND */
		32'b001100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUAND<<DECALU|1<<DECREGRS|1<<DECZIMM|1<<DECSETRT; /* ANDI */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101100: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED|1<<DECDWORD; /* DADD */
		32'b011000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECSIGNED|1<<DECDWORD; /* DADDI */
		32'b011001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECSIMM|1<<DECSETRT|1<<DECDWORD; /* DADDIU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101101: rfdec = ALUADD<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DADDU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011110: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD|1<<DECSIGNED; /* DDIV */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011111: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD; /* DDIVU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011010: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSIGNED; /* DIV */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011011: rfdec = ALUDIV<<DECALU|1<<DECREGRS|1<<DECREGRT; /* DIVU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011100: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD|1<<DECSIGNED; /* DMULT */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011101: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECDWORD; /* DMULTU */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111000: rfdec = ALUSLL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSLL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_010100: rfdec = ALUSLL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DSLLV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111100: rfdec = ALUSLL<<DECALU|1<<DECREGRT|3<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSLL32 */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111011: rfdec = ALUSRA<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSRA */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_010111: rfdec = ALUSRA<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DSRAV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111111: rfdec = ALUSRA<<DECALU|1<<DECREGRT|3<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSRA32 */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111010: rfdec = ALUSRL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSRL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_010110: rfdec = ALUSRL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DSRLV */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_111110: rfdec = ALUSRL<<DECALU|1<<DECREGRT|3<<DECSHIMM|1<<DECSETRD|1<<DECDWORD; /* DSRL32 */	
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101110: rfdec = ALUSUB<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECSIGNED|1<<DECDWORD; /* DSUB */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_101111: rfdec = ALUSUB<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD|1<<DECDWORD; /* DSUBU */
		32'b001111_00000_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALULUI<<DECALU|1<<DECSETRT|1<<DECZIMM; /* LUI */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011000: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSIGNED; /* MULT */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_011001: rfdec = ALUMUL<<DECALU|1<<DECREGRS|1<<DECREGRT; /* MULTU */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100111: rfdec = ALUNOR<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* NOR */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_100101: rfdec = ALUOR<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* OR */
		32'b001101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = ALUOR<<DECALU|1<<DECREGRS|1<<DECZIMM|1<<DECSETRT; /* ORI */
		32'b000000_00000_zzzzz_zzzzz_zzzzz_000000: rfdec = ALUSLL<<DECALU|1<<DECREGRT|1<<DECSHIMM|1<<DECSETRD; /* SLL */
		32'b000000_zzzzz_zzzzz_zzzzz_00000_000100: rfdec = ALUSLL<<DECALU|1<<DECREGRS|1<<DECREGRT|1<<DECSETRD; /* SLLV */
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
		32'b110101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR&~(1<<DECSETRT)|1<<DECSETFT|SZDWORD<<DECSZ; /* LDC1 */
		32'b011010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDLEFT<<DECSZ; /* LDL */
		32'b011011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDRIGHT<<DECSZ; /* LDR */
		32'b100001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZHALF<<DECSZ|1<<DECSIGNED; /* LH */
		32'b100101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZHALF<<DECSZ; /* LHU */
		32'b110000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZWORD<<DECSZ|1<<DECLLSC; /* LL */
		32'b110100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDWORD<<DECSZ|1<<DECLLSC; /* LLD */
		32'b100011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZWORD<<DECSZ|1<<DECSIGNED; /* LW */
		32'b110001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR&~(1<<DECSETRT)|1<<DECSETFT|SZWORD<<DECSZ; /* LWC1 */
		32'b100010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDLEFT<<DECSZ; /* LDL */
		32'b100110_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZDRIGHT<<DECSZ; /* LDR */
		32'b100111_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = LOADINSTR|SZWORD<<DECSZ; /* LWU */
		
		32'b101000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZBYTE<<DECSZ; /* SB */
		32'b111000_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZWORD<<DECSZ|1<<DECSETRT|1<<DECLLSC; /* SC */
		32'b111100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDWORD<<DECSZ|1<<DECSETRT|1<<DECLLSC; /* SCD */
		32'b111111_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDWORD<<DECSZ; /* SD */
		32'b111101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR&~(1<<DECREGR)|1<<DECREGFT|SZDWORD<<DECSZ; /* SDC1 */
		32'b101100_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDLEFT<<DECSZ; /* SDL */
		32'b101101_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZDRIGHT<<DECSZ; /* SDR */
		32'b101001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZHALF<<DECSZ; /* SH */
		32'b101011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZWORD<<DECSZ; /* SW */
		32'b111001_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR&~(1<<DECREGR)|1<<DECREGFT|SZWORD<<DECSZ; /* SWC1 */
		32'b101010_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZLEFT<<DECSZ; /* SWL */
		32'b101011_zzzzz_zzzzz_zzzzzzzz_zzzzzzzz: rfdec = STOREINSTR|SZRIGHT<<DECSZ; /* SWR */

		endcase
		
		if(rfdec[DECSETRD])
			rfdec[DECTARGR+5:DECTARGR] = {1'b0, rfinstr[15:11]};
		else if(rfdec[DECSETRT])
			rfdec[DECTARGR+5:DECTARGR] = {1'b0, rfinstr[20:16]};
	end

endmodule
