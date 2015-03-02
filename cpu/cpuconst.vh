localparam
DECINVALID = 0,
DECREGRS = 1,
DECREGRT = 2,
DECREGFS = 3,
DECREGFT = 4,
DECZIMM = 5,
DECSIMM = 6,
DECALU = 7, /* 5 bit */
DECSETRD = 12,
DECSETRT = 13,
DECMEMRD = 14,
DECMEMWR = 15,
DECSIGNED = 16,
DECSHIMM = 17, /* 2 bit with DECSHIMM32 */
DECSHIMM32 = 18,
DECTARGR = 19, /* 6 bit */
DECLOAD = 25,
DECSZ = 26, /* 4 bit, DECDWORD highest bit */
DECDWORD = 29,
DECLLSC = 30,
DECSTORE = 31,
DECCOND = 32, /* 3 bit */
DECBRANCH = 35,
DECLIKELY = 36,
DECLINK = 37,
DECJUMP = 38,
DECJUMPREG = 39,
DECPANIC = 40,
DECWHY = 41, /* 5 bit */
DECSYSCALL = 46,
DECBREAK = 47,
DECSETFD = 48,
DECSETFT = 49,
DECCACHE = 50,
DECDCACHE = 51,
DECCACHEOP = 52, /* 3 bit */

ALUNOP = 0,
ALUADD = 1,
ALUSUB = 2,
ALUAND = 3,
ALUOR = 4,
ALUNOR = 5,
ALUXOR = 6,
ALUSLL = 7,
ALUSRL = 8,
ALUSRA = 9,
ALUMUL = 10,
ALUDIV = 11,
ALULUI = 12,
ALUADDIMM = 13,
ALUSLT = 14,

CONDEQ = 0,
CONDNE = 1,
CONDGE = 2,
CONDGT = 3,
CONDLE = 4,
CONDLT = 5,

SZWORD = 0,
SZBYTE = 1,
SZHALF = 2,
SZLEFT = 3,
SZRIGHT = 4,
SZDWORD = 8,
SZDLEFT = 11,
SZDRIGHT = 12,

WHYRSVD = 0,
WHYIADE = 1,
WHYITLB = 2,
WHYIBE = 3,
WHYSYSC = 4,
WHYBRPT = 5,
WHYCPU = 6,
WHYRST = 7,
WHYNMI = 8,
WHYOVFL = 9,
WHYTRAP = 10,
WHYFPE = 11,
WHYDADE = 12,
WHYDTLB = 13,
WHYWAT = 14,
WHYINTR = 15,
WHYDBE = 16
;
