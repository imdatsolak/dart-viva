/* dartPSwraps.c generated from dartPSwraps.psw
   by unix pswrap V1.009  Wed Apr 19 17:50:24 PDT 1989
 */

#include <dpsclient/dpsfriends.h>
#include <string.h>

#line 1 "dartPSwraps.psw"
#line 10 "dartPSwraps.c"
void setrotatedfont(char *fontname, float fontsize)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char sizeFlag;
    unsigned short topLevelCount;
    unsigned long nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjReal obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjGeneric obj13;
    DPSBinObjGeneric obj14;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 0, 9, 128,
    {DPS_LITERAL|DPS_INT, 0, 0, -60},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 136},	/* rotate */
    {DPS_LITERAL|DPS_NAME, 0, 0, 120},	/* param fontname */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 67},	/* findfont */
    {DPS_LITERAL|DPS_ARRAY, 0, 6, 72},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 103},	/* makefont */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: fontsize */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 140},	/* scalefont */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 149},	/* setfont */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  register int _dps_offset = 120;
  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[2].length = strlen(fontname);
  _dpsP[6].val.realVal = fontsize;
  _dpsP[2].val.stringVal = _dps_offset;
  _dps_offset += (_dpsP[2].length + 3) & ~3;

  _dpsF.nBytes = _dps_offset+8;
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,128);
  DPSWriteStringChars(_dpsCurCtxt, (char *)fontname, _dpsP[2].length);
  DPSWriteStringChars(_dpsCurCtxt, (char *)_dpsCurCtxt, ~(_dpsP[2].length + 3) & 3);
}
#line 4 "dartPSwraps.psw"

#line 71 "dartPSwraps.c"
void unrotatefont( void )
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    } _dpsQ;
  static const _dpsQ _dpsF = {
    DPS_DEF_TOKENTYPE, 2, 20,
    {DPS_LITERAL|DPS_INT, 0, 0, 60},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 136},	/* rotate */
    }; /* _dpsQ */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,20);
}
#line 8 "dartPSwraps.psw"

#line 92 "dartPSwraps.c"
void setflippedfont(char *fontname, float fontsize)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char sizeFlag;
    unsigned short topLevelCount;
    unsigned long nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjReal obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 0, 7, 112,
    {DPS_LITERAL|DPS_NAME, 0, 0, 104},	/* param fontname */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 67},	/* findfont */
    {DPS_LITERAL|DPS_ARRAY, 0, 6, 56},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 103},	/* makefont */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: fontsize */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 140},	/* scalefont */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 149},	/* setfont */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  register int _dps_offset = 104;
  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[0].length = strlen(fontname);
  _dpsP[4].val.realVal = fontsize;
  _dpsP[0].val.stringVal = _dps_offset;
  _dps_offset += (_dpsP[0].length + 3) & ~3;

  _dpsF.nBytes = _dps_offset+8;
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,112);
  DPSWriteStringChars(_dpsCurCtxt, (char *)fontname, _dpsP[0].length);
  DPSWriteStringChars(_dpsCurCtxt, (char *)_dpsCurCtxt, ~(_dpsP[0].length + 3) & 3);
}
#line 13 "dartPSwraps.psw"

#line 149 "dartPSwraps.c"
void initDrag(float mouseDownX, float mouseDownY, float offsetX, float offsetY, float imageW, float imageH, int *iWindow, int *bgWindow, int *niWindow, int *igstate, int *bggstate, int *nigstate, int *gWindow, int *ggstate)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjReal obj1;
    DPSBinObjReal obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjReal obj6;
    DPSBinObjReal obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjReal obj11;
    DPSBinObjReal obj12;
    DPSBinObjReal obj13;
    DPSBinObjReal obj14;
    DPSBinObjGeneric obj15;
    DPSBinObjGeneric obj16;
    DPSBinObjGeneric obj17;
    DPSBinObjGeneric obj18;
    DPSBinObjGeneric obj19;
    DPSBinObjGeneric obj20;
    DPSBinObjGeneric obj21;
    DPSBinObjGeneric obj22;
    DPSBinObjGeneric obj23;
    DPSBinObjReal obj24;
    DPSBinObjReal obj25;
    DPSBinObjReal obj26;
    DPSBinObjReal obj27;
    DPSBinObjGeneric obj28;
    DPSBinObjGeneric obj29;
    DPSBinObjGeneric obj30;
    DPSBinObjGeneric obj31;
    DPSBinObjGeneric obj32;
    DPSBinObjGeneric obj33;
    DPSBinObjGeneric obj34;
    DPSBinObjGeneric obj35;
    DPSBinObjGeneric obj36;
    DPSBinObjGeneric obj37;
    DPSBinObjGeneric obj38;
    DPSBinObjReal obj39;
    DPSBinObjReal obj40;
    DPSBinObjGeneric obj41;
    DPSBinObjGeneric obj42;
    DPSBinObjGeneric obj43;
    DPSBinObjGeneric obj44;
    DPSBinObjGeneric obj45;
    DPSBinObjGeneric obj46;
    DPSBinObjGeneric obj47;
    DPSBinObjGeneric obj48;
    DPSBinObjGeneric obj49;
    DPSBinObjGeneric obj50;
    DPSBinObjGeneric obj51;
    DPSBinObjGeneric obj52;
    DPSBinObjGeneric obj53;
    DPSBinObjGeneric obj54;
    DPSBinObjGeneric obj55;
    DPSBinObjGeneric obj56;
    DPSBinObjGeneric obj57;
    DPSBinObjReal obj58;
    DPSBinObjReal obj59;
    DPSBinObjReal obj60;
    DPSBinObjReal obj61;
    DPSBinObjGeneric obj62;
    DPSBinObjReal obj63;
    DPSBinObjReal obj64;
    DPSBinObjGeneric obj65;
    DPSBinObjGeneric obj66;
    DPSBinObjGeneric obj67;
    DPSBinObjGeneric obj68;
    DPSBinObjGeneric obj69;
    DPSBinObjGeneric obj70;
    DPSBinObjGeneric obj71;
    DPSBinObjGeneric obj72;
    DPSBinObjGeneric obj73;
    DPSBinObjReal obj74;
    DPSBinObjReal obj75;
    DPSBinObjGeneric obj76;
    DPSBinObjGeneric obj77;
    DPSBinObjGeneric obj78;
    DPSBinObjGeneric obj79;
    DPSBinObjGeneric obj80;
    DPSBinObjGeneric obj81;
    DPSBinObjGeneric obj82;
    DPSBinObjGeneric obj83;
    DPSBinObjReal obj84;
    DPSBinObjReal obj85;
    DPSBinObjReal obj86;
    DPSBinObjReal obj87;
    DPSBinObjGeneric obj88;
    DPSBinObjReal obj89;
    DPSBinObjReal obj90;
    DPSBinObjGeneric obj91;
    DPSBinObjGeneric obj92;
    DPSBinObjGeneric obj93;
    DPSBinObjGeneric obj94;
    DPSBinObjGeneric obj95;
    DPSBinObjGeneric obj96;
    DPSBinObjGeneric obj97;
    DPSBinObjGeneric obj98;
    DPSBinObjGeneric obj99;
    DPSBinObjGeneric obj100;
    DPSBinObjGeneric obj101;
    DPSBinObjGeneric obj102;
    DPSBinObjGeneric obj103;
    DPSBinObjGeneric obj104;
    DPSBinObjGeneric obj105;
    DPSBinObjGeneric obj106;
    DPSBinObjGeneric obj107;
    DPSBinObjGeneric obj108;
    DPSBinObjGeneric obj109;
    DPSBinObjGeneric obj110;
    DPSBinObjGeneric obj111;
    DPSBinObjGeneric obj112;
    DPSBinObjGeneric obj113;
    DPSBinObjGeneric obj114;
    DPSBinObjGeneric obj115;
    DPSBinObjGeneric obj116;
    DPSBinObjGeneric obj117;
    DPSBinObjGeneric obj118;
    DPSBinObjGeneric obj119;
    DPSBinObjGeneric obj120;
    DPSBinObjGeneric obj121;
    DPSBinObjGeneric obj122;
    DPSBinObjGeneric obj123;
    DPSBinObjGeneric obj124;
    DPSBinObjGeneric obj125;
    DPSBinObjGeneric obj126;
    DPSBinObjGeneric obj127;
    DPSBinObjGeneric obj128;
    DPSBinObjGeneric obj129;
    DPSBinObjGeneric obj130;
    DPSBinObjGeneric obj131;
    DPSBinObjGeneric obj132;
    DPSBinObjGeneric obj133;
    DPSBinObjGeneric obj134;
    DPSBinObjGeneric obj135;
    DPSBinObjGeneric obj136;
    DPSBinObjGeneric obj137;
    DPSBinObjGeneric obj138;
    DPSBinObjGeneric obj139;
    DPSBinObjGeneric obj140;
    DPSBinObjGeneric obj141;
    DPSBinObjGeneric obj142;
    DPSBinObjGeneric obj143;
    DPSBinObjGeneric obj144;
    DPSBinObjGeneric obj145;
    DPSBinObjGeneric obj146;
    DPSBinObjGeneric obj147;
    DPSBinObjGeneric obj148;
    DPSBinObjGeneric obj149;
    DPSBinObjGeneric obj150;
    DPSBinObjGeneric obj151;
    DPSBinObjGeneric obj152;
    DPSBinObjGeneric obj153;
    DPSBinObjGeneric obj154;
    DPSBinObjGeneric obj155;
    DPSBinObjGeneric obj156;
    DPSBinObjGeneric obj157;
    DPSBinObjGeneric obj158;
    DPSBinObjGeneric obj159;
    DPSBinObjGeneric obj160;
    DPSBinObjGeneric obj161;
    DPSBinObjGeneric obj162;
    DPSBinObjGeneric obj163;
    DPSBinObjGeneric obj164;
    DPSBinObjGeneric obj165;
    DPSBinObjGeneric obj166;
    DPSBinObjGeneric obj167;
    DPSBinObjGeneric obj168;
    DPSBinObjGeneric obj169;
    DPSBinObjGeneric obj170;
    DPSBinObjGeneric obj171;
    DPSBinObjGeneric obj172;
    DPSBinObjGeneric obj173;
    DPSBinObjGeneric obj174;
    DPSBinObjGeneric obj175;
    DPSBinObjGeneric obj176;
    DPSBinObjGeneric obj177;
    DPSBinObjGeneric obj178;
    DPSBinObjGeneric obj179;
    DPSBinObjGeneric obj180;
    DPSBinObjGeneric obj181;
    DPSBinObjGeneric obj182;
    DPSBinObjGeneric obj183;
    DPSBinObjGeneric obj184;
    DPSBinObjGeneric obj185;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 157, 1492,
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: mouseDownX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: offsetX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: mouseDownY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: offsetY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* newImageWindow */
    {DPS_LITERAL|DPS_REAL, 0, 0, 50.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Retained */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* window */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* newImageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 79},	/* gstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* backgroundWindow */
    {DPS_LITERAL|DPS_REAL, 0, 0, 100.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Retained */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* window */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* backgroundWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* backgroundGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 79},	/* gstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Nonretained */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* window */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_BOOL, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setautofill */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Above */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* grabGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 79},	/* gstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* backgroundGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabGstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Out */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Retained */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* window */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* imageGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 79},	/* gstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* backgroundGs */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Above */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Above */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* findwindow */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentwindowlevel */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* windowLevel */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowLevel */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setwindowlevel */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowLevel */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* backgroundWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setwindowlevel */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowLevel */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* setwindowlevel */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageWindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* backgroundWindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* newImageWindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 2},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* mydefineuserobject */
    {DPS_EXEC|DPS_ARRAY, 0, 15, 1256},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageGstate */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* mydefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* backgroundGs */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* mydefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 4},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* newImageGs */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* mydefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 5},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabGstate */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* mydefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 7},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* grabWindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 6},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 8},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 70},	/* flush */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* uoindex */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 374},	/* UserObjects */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 98},	/* length */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* uoindex */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_ARRAY, 0, 9, 1376},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 72},	/* for */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* uoindex */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 372},	/* defineuserobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* uoindex */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 56},	/* dup */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 374},	/* UserObjects */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 75},	/* get */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 113},	/* null */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 61},	/* eq */
    {DPS_EXEC|DPS_ARRAY, 0, 4, 1456},
    {DPS_EXEC|DPS_ARRAY, 0, 1, 1448},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* uoindex */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 64},	/* exit */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[81] = {-1};
  DPSResultsRec _dpsR[8];
  static const DPSResultsRec _dpsRstat[] = {
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    { dps_tInt, -1 },
    };
    _dpsR[0] = _dpsRstat[0];
    _dpsR[0].value = (char *)iWindow;
    _dpsR[1] = _dpsRstat[1];
    _dpsR[1].value = (char *)bgWindow;
    _dpsR[2] = _dpsRstat[2];
    _dpsR[2].value = (char *)niWindow;
    _dpsR[3] = _dpsRstat[3];
    _dpsR[3].value = (char *)igstate;
    _dpsR[4] = _dpsRstat[4];
    _dpsR[4].value = (char *)bggstate;
    _dpsR[5] = _dpsRstat[5];
    _dpsR[5].value = (char *)nigstate;
    _dpsR[6] = _dpsRstat[6];
    _dpsR[6].value = (char *)gWindow;
    _dpsR[7] = _dpsRstat[7];
    _dpsR[7].value = (char *)ggstate;

  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"currentX",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"currentY",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"newImageWindow",
	(char *) 0 ,
	(char *) 0 ,
	"Retained",
	(char *) 0 ,
	(char *) 0 ,
	"window",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"windowdeviceround",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"newImageGs",
	(char *) 0 ,
	"backgroundWindow",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"backgroundGs",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"grabWindow",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"Nonretained",
	"setautofill",
	"Above",
	(char *) 0 ,
	(char *) 0 ,
	"orderwindow",
	(char *) 0 ,
	(char *) 0 ,
	"grabGstate",
	(char *) 0 ,
	(char *) 0 ,
	"Copy",
	(char *) 0 ,
	"composite",
	(char *) 0 ,
	"Out",
	"imageWindow",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"imageGstate",
	(char *) 0 ,
	"findwindow",
	"currentwindowlevel",
	"windowLevel",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"setwindowlevel",
	(char *) 0 ,
	(char *) 0 ,
	"mydefineuserobject",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"uoindex",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 };
    long int *_dps_nameVals[81];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];
    _dps_nameVals[2] = &_dpsCodes[2];
    _dps_nameVals[3] = &_dpsCodes[3];
    _dps_nameVals[4] = &_dpsCodes[4];
    _dps_nameVals[5] = &_dpsCodes[5];
    _dps_nameVals[6] = &_dpsCodes[6];
    _dps_nameVals[7] = &_dpsCodes[7];
    _dps_nameVals[8] = &_dpsCodes[8];
    _dps_nameVals[9] = &_dpsCodes[9];
    _dps_nameVals[10] = &_dpsCodes[10];
    _dps_nameVals[11] = &_dpsCodes[11];
    _dps_nameVals[12] = &_dpsCodes[12];
    _dps_nameVals[13] = &_dpsCodes[13];
    _dps_nameVals[14] = &_dpsCodes[14];
    _dps_nameVals[15] = &_dpsCodes[15];
    _dps_nameVals[16] = &_dpsCodes[16];
    _dps_nameVals[17] = &_dpsCodes[17];
    _dps_nameVals[18] = &_dpsCodes[18];
    _dps_nameVals[19] = &_dpsCodes[19];
    _dps_nameVals[20] = &_dpsCodes[20];
    _dps_nameVals[21] = &_dpsCodes[21];
    _dps_nameVals[22] = &_dpsCodes[22];
    _dps_nameVals[23] = &_dpsCodes[23];
    _dps_nameVals[24] = &_dpsCodes[24];
    _dps_nameVals[25] = &_dpsCodes[25];
    _dps_nameVals[26] = &_dpsCodes[26];
    _dps_nameVals[27] = &_dpsCodes[27];
    _dps_nameVals[28] = &_dpsCodes[28];
    _dps_nameVals[29] = &_dpsCodes[29];
    _dps_nameVals[30] = &_dpsCodes[30];
    _dps_nameVals[31] = &_dpsCodes[31];
    _dps_nameVals[32] = &_dpsCodes[32];
    _dps_nameVals[33] = &_dpsCodes[33];
    _dps_nameVals[34] = &_dpsCodes[34];
    _dps_nameVals[35] = &_dpsCodes[35];
    _dps_nameVals[36] = &_dpsCodes[36];
    _dps_nameVals[37] = &_dpsCodes[37];
    _dps_nameVals[38] = &_dpsCodes[38];
    _dps_nameVals[39] = &_dpsCodes[39];
    _dps_nameVals[40] = &_dpsCodes[40];
    _dps_nameVals[41] = &_dpsCodes[41];
    _dps_nameVals[42] = &_dpsCodes[42];
    _dps_nameVals[43] = &_dpsCodes[43];
    _dps_nameVals[44] = &_dpsCodes[44];
    _dps_nameVals[45] = &_dpsCodes[45];
    _dps_nameVals[46] = &_dpsCodes[46];
    _dps_nameVals[47] = &_dpsCodes[47];
    _dps_nameVals[48] = &_dpsCodes[48];
    _dps_nameVals[49] = &_dpsCodes[49];
    _dps_nameVals[50] = &_dpsCodes[50];
    _dps_nameVals[51] = &_dpsCodes[51];
    _dps_nameVals[52] = &_dpsCodes[52];
    _dps_nameVals[53] = &_dpsCodes[53];
    _dps_nameVals[54] = &_dpsCodes[54];
    _dps_nameVals[55] = &_dpsCodes[55];
    _dps_nameVals[56] = &_dpsCodes[56];
    _dps_nameVals[57] = &_dpsCodes[57];
    _dps_nameVals[58] = &_dpsCodes[58];
    _dps_nameVals[59] = &_dpsCodes[59];
    _dps_nameVals[60] = &_dpsCodes[60];
    _dps_nameVals[61] = &_dpsCodes[61];
    _dps_nameVals[62] = &_dpsCodes[62];
    _dps_nameVals[63] = &_dpsCodes[63];
    _dps_nameVals[64] = &_dpsCodes[64];
    _dps_nameVals[65] = &_dpsCodes[65];
    _dps_nameVals[66] = &_dpsCodes[66];
    _dps_nameVals[67] = &_dpsCodes[67];
    _dps_nameVals[68] = &_dpsCodes[68];
    _dps_nameVals[69] = &_dpsCodes[69];
    _dps_nameVals[70] = &_dpsCodes[70];
    _dps_nameVals[71] = &_dpsCodes[71];
    _dps_nameVals[72] = &_dpsCodes[72];
    _dps_nameVals[73] = &_dpsCodes[73];
    _dps_nameVals[74] = &_dpsCodes[74];
    _dps_nameVals[75] = &_dpsCodes[75];
    _dps_nameVals[76] = &_dpsCodes[76];
    _dps_nameVals[77] = &_dpsCodes[77];
    _dps_nameVals[78] = &_dpsCodes[78];
    _dps_nameVals[79] = &_dpsCodes[79];
    _dps_nameVals[80] = &_dpsCodes[80];

    DPSMapNames(_dpsCurCtxt, 81, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[1].val.realVal = mouseDownX;
  _dpsP[6].val.realVal = mouseDownY;
  _dpsP[2].val.realVal = offsetX;
  _dpsP[7].val.realVal = offsetY;
  _dpsP[13].val.realVal =
  _dpsP[26].val.realVal =
  _dpsP[39].val.realVal =
  _dpsP[60].val.realVal =
  _dpsP[74].val.realVal =
  _dpsP[86].val.realVal = imageW;
  _dpsP[14].val.realVal =
  _dpsP[27].val.realVal =
  _dpsP[40].val.realVal =
  _dpsP[61].val.realVal =
  _dpsP[75].val.realVal =
  _dpsP[87].val.realVal = imageH;
  _dpsP[0].val.nameVal = _dpsCodes[0];
  _dpsP[94].val.nameVal = _dpsCodes[1];
  _dpsP[72].val.nameVal = _dpsCodes[2];
  _dpsP[37].val.nameVal = _dpsCodes[3];
  _dpsP[5].val.nameVal = _dpsCodes[4];
  _dpsP[95].val.nameVal = _dpsCodes[5];
  _dpsP[73].val.nameVal = _dpsCodes[6];
  _dpsP[38].val.nameVal = _dpsCodes[7];
  _dpsP[10].val.nameVal = _dpsCodes[8];
  _dpsP[127].val.nameVal = _dpsCodes[9];
  _dpsP[18].val.nameVal = _dpsCodes[10];
  _dpsP[15].val.nameVal = _dpsCodes[11];
  _dpsP[76].val.nameVal = _dpsCodes[12];
  _dpsP[28].val.nameVal = _dpsCodes[13];
  _dpsP[16].val.nameVal = _dpsCodes[14];
  _dpsP[77].val.nameVal = _dpsCodes[15];
  _dpsP[42].val.nameVal = _dpsCodes[16];
  _dpsP[29].val.nameVal = _dpsCodes[17];
  _dpsP[19].val.nameVal = _dpsCodes[18];
  _dpsP[80].val.nameVal = _dpsCodes[19];
  _dpsP[52].val.nameVal = _dpsCodes[20];
  _dpsP[32].val.nameVal = _dpsCodes[21];
  _dpsP[20].val.nameVal = _dpsCodes[22];
  _dpsP[142].val.nameVal = _dpsCodes[23];
  _dpsP[23].val.nameVal = _dpsCodes[24];
  _dpsP[124].val.nameVal = _dpsCodes[25];
  _dpsP[116].val.nameVal = _dpsCodes[26];
  _dpsP[31].val.nameVal = _dpsCodes[27];
  _dpsP[33].val.nameVal = _dpsCodes[28];
  _dpsP[138].val.nameVal = _dpsCodes[29];
  _dpsP[88].val.nameVal = _dpsCodes[30];
  _dpsP[56].val.nameVal = _dpsCodes[31];
  _dpsP[36].val.nameVal = _dpsCodes[32];
  _dpsP[150].val.nameVal = _dpsCodes[33];
  _dpsP[119].val.nameVal = _dpsCodes[34];
  _dpsP[69].val.nameVal = _dpsCodes[35];
  _dpsP[51].val.nameVal = _dpsCodes[36];
  _dpsP[49].val.nameVal = _dpsCodes[37];
  _dpsP[45].val.nameVal = _dpsCodes[38];
  _dpsP[41].val.nameVal = _dpsCodes[39];
  _dpsP[46].val.nameVal = _dpsCodes[40];
  _dpsP[47].val.nameVal = _dpsCodes[41];
  _dpsP[96].val.nameVal = _dpsCodes[42];
  _dpsP[93].val.nameVal = _dpsCodes[43];
  _dpsP[50].val.nameVal = _dpsCodes[44];
  _dpsP[114].val.nameVal = _dpsCodes[45];
  _dpsP[70].val.nameVal = _dpsCodes[46];
  _dpsP[53].val.nameVal = _dpsCodes[47];
  _dpsP[146].val.nameVal = _dpsCodes[48];
  _dpsP[62].val.nameVal = _dpsCodes[49];
  _dpsP[65].val.nameVal = _dpsCodes[50];
  _dpsP[91].val.nameVal = _dpsCodes[51];
  _dpsP[66].val.nameVal = _dpsCodes[52];
  _dpsP[92].val.nameVal = _dpsCodes[53];
  _dpsP[67].val.nameVal = _dpsCodes[54];
  _dpsP[71].val.nameVal = _dpsCodes[55];
  _dpsP[121].val.nameVal = _dpsCodes[56];
  _dpsP[113].val.nameVal = _dpsCodes[57];
  _dpsP[111].val.nameVal = _dpsCodes[58];
  _dpsP[79].val.nameVal = _dpsCodes[59];
  _dpsP[81].val.nameVal = _dpsCodes[60];
  _dpsP[134].val.nameVal = _dpsCodes[61];
  _dpsP[98].val.nameVal = _dpsCodes[62];
  _dpsP[106].val.nameVal = _dpsCodes[63];
  _dpsP[107].val.nameVal = _dpsCodes[64];
  _dpsP[118].val.nameVal = _dpsCodes[65];
  _dpsP[115].val.nameVal = _dpsCodes[66];
  _dpsP[110].val.nameVal = _dpsCodes[67];
  _dpsP[112].val.nameVal = _dpsCodes[68];
  _dpsP[120].val.nameVal = _dpsCodes[69];
  _dpsP[117].val.nameVal = _dpsCodes[70];
  _dpsP[130].val.nameVal = _dpsCodes[71];
  _dpsP[147].val.nameVal = _dpsCodes[72];
  _dpsP[143].val.nameVal = _dpsCodes[73];
  _dpsP[139].val.nameVal = _dpsCodes[74];
  _dpsP[135].val.nameVal = _dpsCodes[75];
  _dpsP[157].val.nameVal = _dpsCodes[76];
  _dpsP[182].val.nameVal = _dpsCodes[77];
  _dpsP[171].val.nameVal = _dpsCodes[78];
  _dpsP[168].val.nameVal = _dpsCodes[79];
  _dpsP[161].val.nameVal = _dpsCodes[80];
  DPSSetResultTable(_dpsCurCtxt, _dpsR, 8);
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,1492);
  DPSAwaitReturnValues(_dpsCurCtxt);
}
#line 92 "dartPSwraps.psw"

#line 841 "dartPSwraps.c"
void dragWindow(int imageWindow, int newImageWindow, int grabWindow, int winUnderMouse, int prevWinUnderMouse, int imageGstate, int oldBgGs, int newImageGs, int bitmapGstate, int grabGstate, float mouseDownX, float mouseDownY, float offsetX, float offsetY, float imageW, float imageH, int *mouseup, int *underwindow, float *newMouseX, float *newMouseY)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjGeneric obj13;
    DPSBinObjGeneric obj14;
    DPSBinObjGeneric obj15;
    DPSBinObjReal obj16;
    DPSBinObjGeneric obj17;
    DPSBinObjGeneric obj18;
    DPSBinObjReal obj19;
    DPSBinObjGeneric obj20;
    DPSBinObjGeneric obj21;
    DPSBinObjGeneric obj22;
    DPSBinObjGeneric obj23;
    DPSBinObjGeneric obj24;
    DPSBinObjGeneric obj25;
    DPSBinObjGeneric obj26;
    DPSBinObjGeneric obj27;
    DPSBinObjGeneric obj28;
    DPSBinObjGeneric obj29;
    DPSBinObjGeneric obj30;
    DPSBinObjGeneric obj31;
    DPSBinObjGeneric obj32;
    DPSBinObjGeneric obj33;
    DPSBinObjGeneric obj34;
    DPSBinObjGeneric obj35;
    DPSBinObjGeneric obj36;
    DPSBinObjGeneric obj37;
    DPSBinObjGeneric obj38;
    DPSBinObjGeneric obj39;
    DPSBinObjGeneric obj40;
    DPSBinObjGeneric obj41;
    DPSBinObjGeneric obj42;
    DPSBinObjGeneric obj43;
    DPSBinObjGeneric obj44;
    DPSBinObjGeneric obj45;
    DPSBinObjGeneric obj46;
    DPSBinObjGeneric obj47;
    DPSBinObjGeneric obj48;
    DPSBinObjGeneric obj49;
    DPSBinObjGeneric obj50;
    DPSBinObjGeneric obj51;
    DPSBinObjGeneric obj52;
    DPSBinObjGeneric obj53;
    DPSBinObjGeneric obj54;
    DPSBinObjGeneric obj55;
    DPSBinObjGeneric obj56;
    DPSBinObjGeneric obj57;
    DPSBinObjGeneric obj58;
    DPSBinObjGeneric obj59;
    DPSBinObjGeneric obj60;
    DPSBinObjGeneric obj61;
    DPSBinObjGeneric obj62;
    DPSBinObjGeneric obj63;
    DPSBinObjGeneric obj64;
    DPSBinObjGeneric obj65;
    DPSBinObjGeneric obj66;
    DPSBinObjGeneric obj67;
    DPSBinObjGeneric obj68;
    DPSBinObjGeneric obj69;
    DPSBinObjGeneric obj70;
    DPSBinObjGeneric obj71;
    DPSBinObjGeneric obj72;
    DPSBinObjGeneric obj73;
    DPSBinObjGeneric obj74;
    DPSBinObjGeneric obj75;
    DPSBinObjGeneric obj76;
    DPSBinObjGeneric obj77;
    DPSBinObjGeneric obj78;
    DPSBinObjGeneric obj79;
    DPSBinObjGeneric obj80;
    DPSBinObjGeneric obj81;
    DPSBinObjGeneric obj82;
    DPSBinObjGeneric obj83;
    DPSBinObjGeneric obj84;
    DPSBinObjGeneric obj85;
    DPSBinObjGeneric obj86;
    DPSBinObjGeneric obj87;
    DPSBinObjGeneric obj88;
    DPSBinObjGeneric obj89;
    DPSBinObjGeneric obj90;
    DPSBinObjGeneric obj91;
    DPSBinObjGeneric obj92;
    DPSBinObjGeneric obj93;
    DPSBinObjGeneric obj94;
    DPSBinObjGeneric obj95;
    DPSBinObjGeneric obj96;
    DPSBinObjGeneric obj97;
    DPSBinObjGeneric obj98;
    DPSBinObjGeneric obj99;
    DPSBinObjGeneric obj100;
    DPSBinObjGeneric obj101;
    DPSBinObjGeneric obj102;
    DPSBinObjGeneric obj103;
    DPSBinObjGeneric obj104;
    DPSBinObjGeneric obj105;
    DPSBinObjGeneric obj106;
    DPSBinObjGeneric obj107;
    DPSBinObjGeneric obj108;
    DPSBinObjGeneric obj109;
    DPSBinObjGeneric obj110;
    DPSBinObjGeneric obj111;
    DPSBinObjReal obj112;
    DPSBinObjGeneric obj113;
    DPSBinObjGeneric obj114;
    DPSBinObjGeneric obj115;
    DPSBinObjGeneric obj116;
    DPSBinObjReal obj117;
    DPSBinObjGeneric obj118;
    DPSBinObjGeneric obj119;
    DPSBinObjGeneric obj120;
    DPSBinObjGeneric obj121;
    DPSBinObjGeneric obj122;
    DPSBinObjGeneric obj123;
    DPSBinObjGeneric obj124;
    DPSBinObjGeneric obj125;
    DPSBinObjGeneric obj126;
    DPSBinObjGeneric obj127;
    DPSBinObjGeneric obj128;
    DPSBinObjGeneric obj129;
    DPSBinObjGeneric obj130;
    DPSBinObjGeneric obj131;
    DPSBinObjGeneric obj132;
    DPSBinObjGeneric obj133;
    DPSBinObjGeneric obj134;
    DPSBinObjGeneric obj135;
    DPSBinObjGeneric obj136;
    DPSBinObjGeneric obj137;
    DPSBinObjGeneric obj138;
    DPSBinObjGeneric obj139;
    DPSBinObjGeneric obj140;
    DPSBinObjGeneric obj141;
    DPSBinObjReal obj142;
    DPSBinObjReal obj143;
    DPSBinObjReal obj144;
    DPSBinObjReal obj145;
    DPSBinObjGeneric obj146;
    DPSBinObjGeneric obj147;
    DPSBinObjGeneric obj148;
    DPSBinObjGeneric obj149;
    DPSBinObjGeneric obj150;
    DPSBinObjGeneric obj151;
    DPSBinObjGeneric obj152;
    DPSBinObjGeneric obj153;
    DPSBinObjGeneric obj154;
    DPSBinObjReal obj155;
    DPSBinObjReal obj156;
    DPSBinObjReal obj157;
    DPSBinObjReal obj158;
    DPSBinObjGeneric obj159;
    DPSBinObjGeneric obj160;
    DPSBinObjGeneric obj161;
    DPSBinObjGeneric obj162;
    DPSBinObjGeneric obj163;
    DPSBinObjGeneric obj164;
    DPSBinObjGeneric obj165;
    DPSBinObjGeneric obj166;
    DPSBinObjGeneric obj167;
    DPSBinObjGeneric obj168;
    DPSBinObjGeneric obj169;
    DPSBinObjGeneric obj170;
    DPSBinObjGeneric obj171;
    DPSBinObjGeneric obj172;
    DPSBinObjGeneric obj173;
    DPSBinObjGeneric obj174;
    DPSBinObjGeneric obj175;
    DPSBinObjGeneric obj176;
    DPSBinObjGeneric obj177;
    DPSBinObjGeneric obj178;
    DPSBinObjGeneric obj179;
    DPSBinObjGeneric obj180;
    DPSBinObjGeneric obj181;
    DPSBinObjGeneric obj182;
    DPSBinObjGeneric obj183;
    DPSBinObjReal obj184;
    DPSBinObjReal obj185;
    DPSBinObjReal obj186;
    DPSBinObjReal obj187;
    DPSBinObjGeneric obj188;
    DPSBinObjGeneric obj189;
    DPSBinObjReal obj190;
    DPSBinObjReal obj191;
    DPSBinObjGeneric obj192;
    DPSBinObjGeneric obj193;
    DPSBinObjGeneric obj194;
    DPSBinObjGeneric obj195;
    DPSBinObjGeneric obj196;
    DPSBinObjGeneric obj197;
    DPSBinObjGeneric obj198;
    DPSBinObjGeneric obj199;
    DPSBinObjGeneric obj200;
    DPSBinObjReal obj201;
    DPSBinObjReal obj202;
    DPSBinObjReal obj203;
    DPSBinObjReal obj204;
    DPSBinObjGeneric obj205;
    DPSBinObjGeneric obj206;
    DPSBinObjReal obj207;
    DPSBinObjReal obj208;
    DPSBinObjGeneric obj209;
    DPSBinObjGeneric obj210;
    DPSBinObjGeneric obj211;
    DPSBinObjGeneric obj212;
    DPSBinObjGeneric obj213;
    DPSBinObjGeneric obj214;
    DPSBinObjGeneric obj215;
    DPSBinObjGeneric obj216;
    DPSBinObjGeneric obj217;
    DPSBinObjGeneric obj218;
    DPSBinObjGeneric obj219;
    DPSBinObjGeneric obj220;
    DPSBinObjGeneric obj221;
    DPSBinObjGeneric obj222;
    DPSBinObjGeneric obj223;
    DPSBinObjGeneric obj224;
    DPSBinObjGeneric obj225;
    DPSBinObjGeneric obj226;
    DPSBinObjGeneric obj227;
    DPSBinObjGeneric obj228;
    DPSBinObjGeneric obj229;
    DPSBinObjGeneric obj230;
    DPSBinObjGeneric obj231;
    DPSBinObjGeneric obj232;
    DPSBinObjGeneric obj233;
    DPSBinObjGeneric obj234;
    DPSBinObjGeneric obj235;
    DPSBinObjReal obj236;
    DPSBinObjReal obj237;
    DPSBinObjReal obj238;
    DPSBinObjReal obj239;
    DPSBinObjGeneric obj240;
    DPSBinObjGeneric obj241;
    DPSBinObjGeneric obj242;
    DPSBinObjGeneric obj243;
    DPSBinObjGeneric obj244;
    DPSBinObjGeneric obj245;
    DPSBinObjReal obj246;
    DPSBinObjReal obj247;
    DPSBinObjReal obj248;
    DPSBinObjReal obj249;
    DPSBinObjGeneric obj250;
    DPSBinObjGeneric obj251;
    DPSBinObjGeneric obj252;
    DPSBinObjGeneric obj253;
    DPSBinObjGeneric obj254;
    DPSBinObjGeneric obj255;
    DPSBinObjGeneric obj256;
    DPSBinObjGeneric obj257;
    DPSBinObjGeneric obj258;
    DPSBinObjGeneric obj259;
    DPSBinObjGeneric obj260;
    DPSBinObjGeneric obj261;
    DPSBinObjGeneric obj262;
    DPSBinObjReal obj263;
    DPSBinObjGeneric obj264;
    DPSBinObjReal obj265;
    DPSBinObjReal obj266;
    DPSBinObjReal obj267;
    DPSBinObjReal obj268;
    DPSBinObjGeneric obj269;
    DPSBinObjGeneric obj270;
    DPSBinObjGeneric obj271;
    DPSBinObjGeneric obj272;
    DPSBinObjGeneric obj273;
    DPSBinObjGeneric obj274;
    DPSBinObjGeneric obj275;
    DPSBinObjGeneric obj276;
    DPSBinObjGeneric obj277;
    DPSBinObjGeneric obj278;
    DPSBinObjGeneric obj279;
    DPSBinObjGeneric obj280;
    DPSBinObjGeneric obj281;
    DPSBinObjGeneric obj282;
    DPSBinObjGeneric obj283;
    DPSBinObjGeneric obj284;
    DPSBinObjGeneric obj285;
    DPSBinObjGeneric obj286;
    DPSBinObjGeneric obj287;
    DPSBinObjGeneric obj288;
    DPSBinObjGeneric obj289;
    DPSBinObjGeneric obj290;
    DPSBinObjGeneric obj291;
    DPSBinObjGeneric obj292;
    DPSBinObjGeneric obj293;
    DPSBinObjGeneric obj294;
    DPSBinObjGeneric obj295;
    DPSBinObjGeneric obj296;
    DPSBinObjGeneric obj297;
    DPSBinObjGeneric obj298;
    DPSBinObjGeneric obj299;
    DPSBinObjGeneric obj300;
    DPSBinObjGeneric obj301;
    DPSBinObjGeneric obj302;
    DPSBinObjGeneric obj303;
    DPSBinObjGeneric obj304;
    DPSBinObjGeneric obj305;
    DPSBinObjGeneric obj306;
    DPSBinObjGeneric obj307;
    DPSBinObjGeneric obj308;
    DPSBinObjGeneric obj309;
    DPSBinObjGeneric obj310;
    DPSBinObjGeneric obj311;
    DPSBinObjGeneric obj312;
    DPSBinObjGeneric obj313;
    DPSBinObjReal obj314;
    DPSBinObjReal obj315;
    DPSBinObjGeneric obj316;
    DPSBinObjGeneric obj317;
    DPSBinObjReal obj318;
    DPSBinObjReal obj319;
    DPSBinObjGeneric obj320;
    DPSBinObjGeneric obj321;
    DPSBinObjGeneric obj322;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 49, 2588,
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* winchanged */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: winUnderMouse */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: prevWinUnderMouse */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 114},	/* or */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* windowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: winUnderMouse */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* prevwindowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: prevWinUnderMouse */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* lastX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: mouseDownX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* lastY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: mouseDownY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_ARRAY, 0, 20, 496},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 14},	/* bind */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 101},	/* loop */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Below */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* findwindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 4},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 135},	/* roll */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* windowbelow */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_ARRAY, 0, 7, 392},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_LITERAL|DPS_INT, 0, 0, 2},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_LITERAL|DPS_INT, 0, 0, 3},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 4},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 70},	/* flush */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowbelow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentowner */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 278},	/* currentcontext */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 61},	/* eq */
    {DPS_EXEC|DPS_ARRAY, 0, 3, 472},
    {DPS_EXEC|DPS_ARRAY, 0, 3, 448},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowbelow */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentmouse */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* lastX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 61},	/* eq */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* lastY */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 61},	/* eq */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 4},	/* and */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 112},	/* not */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* winchanged */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 114},	/* or */
    {DPS_EXEC|DPS_ARRAY, 0, 110, 880},
    {DPS_EXEC|DPS_ARRAY, 0, 4, 656},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* buttondown */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 112},	/* not */
    {DPS_EXEC|DPS_ARRAY, 0, 14, 688},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_EXEC|DPS_ARRAY, 0, 5, 840},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* prevwindowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_EXEC|DPS_ARRAY, 0, 5, 800},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_LITERAL|DPS_BOOL, 0, 0, 1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 64},	/* exit */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* prevwindowUM */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* flushgraphics */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowUM */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* flushgraphics */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: offsetX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: offsetY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* movewindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Above */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* movewindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* winchanged */
    {DPS_EXEC|DPS_ARRAY, 0, 37, 2080},
    {DPS_EXEC|DPS_ARRAY, 0, 24, 1888},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 85},	/* ifelse */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: oldBgGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: bitmapGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Sover */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* lastX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* lastY */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_EXEC|DPS_ARRAY, 0, 8, 1824},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* prevwindowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 109},	/* ne */
    {DPS_EXEC|DPS_ARRAY, 0, 8, 1760},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* movewindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Out */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* buttondown */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 112},	/* not */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 119},	/* printobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 64},	/* exit */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* prevwindowUM */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* flushgraphics */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* prevwindowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowUM */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* flushgraphics */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* windowUM */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: oldBgGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* lastX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* lastY */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* currentY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* saveobj */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 138},	/* save */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_REAL, 0, 0, .333},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 150},	/* setgray */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 128},	/* rectfill */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* countscreenlist */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 9},	/* array */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* screenlist */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* warray */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* countscreenlist */
    {DPS_LITERAL|DPS_INT, 0, 0, 1},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_LITERAL|DPS_INT, 0, 0, -1},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_EXEC|DPS_ARRAY, 0, 25, 2376},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 72},	/* for */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 30},	/* currentdict */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* awindow */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 180},	/* undef */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 30},	/* currentdict */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* warray */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 180},	/* undef */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* saveobj */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 132},	/* restore */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* winchanged */
    {DPS_LITERAL|DPS_BOOL, 0, 0, 0},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* warray */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 75},	/* get */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* awindow */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 62},	/* exch */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* awindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWindow */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 61},	/* eq */
    {DPS_EXEC|DPS_ARRAY, 0, 1, 2576},
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 84},	/* if */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* awindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* windowdeviceround */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* screentobase */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 79},	/* gstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 64},	/* exit */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[100] = {-1};
  DPSResultsRec _dpsR[4];
  static const DPSResultsRec _dpsRstat[] = {
    { dps_tBoolean, -1 },
    { dps_tInt, -1 },
    { dps_tFloat, -1 },
    { dps_tFloat, -1 },
    };
    _dpsR[0] = _dpsRstat[0];
    _dpsR[0].value = (char *)mouseup;
    _dpsR[1] = _dpsRstat[1];
    _dpsR[1].value = (char *)underwindow;
    _dpsR[2] = _dpsRstat[2];
    _dpsR[2].value = (char *)newMouseX;
    _dpsR[3] = _dpsRstat[3];
    _dpsR[3].value = (char *)newMouseY;

  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"winchanged",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"windowUM",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"prevwindowUM",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"lastX",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"lastY",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"currentX",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"currentY",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"Below",
	"findwindow",
	"windowbelow",
	(char *) 0 ,
	(char *) 0 ,
	"currentowner",
	"currentmouse",
	"buttondown",
	(char *) 0 ,
	"windowdeviceround",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"flushgraphics",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"imageX",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"imageY",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"movewindow",
	(char *) 0 ,
	(char *) 0 ,
	"Above",
	"orderwindow",
	(char *) 0 ,
	"Copy",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"composite",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"Sover",
	"Out",
	"saveobj",
	(char *) 0 ,
	"countscreenlist",
	(char *) 0 ,
	"screenlist",
	"warray",
	(char *) 0 ,
	(char *) 0 ,
	"awindow",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"screentobase"};
    long int *_dps_nameVals[100];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];
    _dps_nameVals[2] = &_dpsCodes[2];
    _dps_nameVals[3] = &_dpsCodes[3];
    _dps_nameVals[4] = &_dpsCodes[4];
    _dps_nameVals[5] = &_dpsCodes[5];
    _dps_nameVals[6] = &_dpsCodes[6];
    _dps_nameVals[7] = &_dpsCodes[7];
    _dps_nameVals[8] = &_dpsCodes[8];
    _dps_nameVals[9] = &_dpsCodes[9];
    _dps_nameVals[10] = &_dpsCodes[10];
    _dps_nameVals[11] = &_dpsCodes[11];
    _dps_nameVals[12] = &_dpsCodes[12];
    _dps_nameVals[13] = &_dpsCodes[13];
    _dps_nameVals[14] = &_dpsCodes[14];
    _dps_nameVals[15] = &_dpsCodes[15];
    _dps_nameVals[16] = &_dpsCodes[16];
    _dps_nameVals[17] = &_dpsCodes[17];
    _dps_nameVals[18] = &_dpsCodes[18];
    _dps_nameVals[19] = &_dpsCodes[19];
    _dps_nameVals[20] = &_dpsCodes[20];
    _dps_nameVals[21] = &_dpsCodes[21];
    _dps_nameVals[22] = &_dpsCodes[22];
    _dps_nameVals[23] = &_dpsCodes[23];
    _dps_nameVals[24] = &_dpsCodes[24];
    _dps_nameVals[25] = &_dpsCodes[25];
    _dps_nameVals[26] = &_dpsCodes[26];
    _dps_nameVals[27] = &_dpsCodes[27];
    _dps_nameVals[28] = &_dpsCodes[28];
    _dps_nameVals[29] = &_dpsCodes[29];
    _dps_nameVals[30] = &_dpsCodes[30];
    _dps_nameVals[31] = &_dpsCodes[31];
    _dps_nameVals[32] = &_dpsCodes[32];
    _dps_nameVals[33] = &_dpsCodes[33];
    _dps_nameVals[34] = &_dpsCodes[34];
    _dps_nameVals[35] = &_dpsCodes[35];
    _dps_nameVals[36] = &_dpsCodes[36];
    _dps_nameVals[37] = &_dpsCodes[37];
    _dps_nameVals[38] = &_dpsCodes[38];
    _dps_nameVals[39] = &_dpsCodes[39];
    _dps_nameVals[40] = &_dpsCodes[40];
    _dps_nameVals[41] = &_dpsCodes[41];
    _dps_nameVals[42] = &_dpsCodes[42];
    _dps_nameVals[43] = &_dpsCodes[43];
    _dps_nameVals[44] = &_dpsCodes[44];
    _dps_nameVals[45] = &_dpsCodes[45];
    _dps_nameVals[46] = &_dpsCodes[46];
    _dps_nameVals[47] = &_dpsCodes[47];
    _dps_nameVals[48] = &_dpsCodes[48];
    _dps_nameVals[49] = &_dpsCodes[49];
    _dps_nameVals[50] = &_dpsCodes[50];
    _dps_nameVals[51] = &_dpsCodes[51];
    _dps_nameVals[52] = &_dpsCodes[52];
    _dps_nameVals[53] = &_dpsCodes[53];
    _dps_nameVals[54] = &_dpsCodes[54];
    _dps_nameVals[55] = &_dpsCodes[55];
    _dps_nameVals[56] = &_dpsCodes[56];
    _dps_nameVals[57] = &_dpsCodes[57];
    _dps_nameVals[58] = &_dpsCodes[58];
    _dps_nameVals[59] = &_dpsCodes[59];
    _dps_nameVals[60] = &_dpsCodes[60];
    _dps_nameVals[61] = &_dpsCodes[61];
    _dps_nameVals[62] = &_dpsCodes[62];
    _dps_nameVals[63] = &_dpsCodes[63];
    _dps_nameVals[64] = &_dpsCodes[64];
    _dps_nameVals[65] = &_dpsCodes[65];
    _dps_nameVals[66] = &_dpsCodes[66];
    _dps_nameVals[67] = &_dpsCodes[67];
    _dps_nameVals[68] = &_dpsCodes[68];
    _dps_nameVals[69] = &_dpsCodes[69];
    _dps_nameVals[70] = &_dpsCodes[70];
    _dps_nameVals[71] = &_dpsCodes[71];
    _dps_nameVals[72] = &_dpsCodes[72];
    _dps_nameVals[73] = &_dpsCodes[73];
    _dps_nameVals[74] = &_dpsCodes[74];
    _dps_nameVals[75] = &_dpsCodes[75];
    _dps_nameVals[76] = &_dpsCodes[76];
    _dps_nameVals[77] = &_dpsCodes[77];
    _dps_nameVals[78] = &_dpsCodes[78];
    _dps_nameVals[79] = &_dpsCodes[79];
    _dps_nameVals[80] = &_dpsCodes[80];
    _dps_nameVals[81] = &_dpsCodes[81];
    _dps_nameVals[82] = &_dpsCodes[82];
    _dps_nameVals[83] = &_dpsCodes[83];
    _dps_nameVals[84] = &_dpsCodes[84];
    _dps_nameVals[85] = &_dpsCodes[85];
    _dps_nameVals[86] = &_dpsCodes[86];
    _dps_nameVals[87] = &_dpsCodes[87];
    _dps_nameVals[88] = &_dpsCodes[88];
    _dps_nameVals[89] = &_dpsCodes[89];
    _dps_nameVals[90] = &_dpsCodes[90];
    _dps_nameVals[91] = &_dpsCodes[91];
    _dps_nameVals[92] = &_dpsCodes[92];
    _dps_nameVals[93] = &_dpsCodes[93];
    _dps_nameVals[94] = &_dpsCodes[94];
    _dps_nameVals[95] = &_dpsCodes[95];
    _dps_nameVals[96] = &_dpsCodes[96];
    _dps_nameVals[97] = &_dpsCodes[97];
    _dps_nameVals[98] = &_dpsCodes[98];
    _dps_nameVals[99] = &_dpsCodes[99];

    DPSMapNames(_dpsCurCtxt, 100, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[125].val.integerVal =
  _dpsP[304].val.integerVal =
  _dpsP[196].val.integerVal =
  _dpsP[27].val.integerVal = imageWindow;
  _dpsP[130].val.integerVal = newImageWindow;
  _dpsP[122].val.integerVal =
  _dpsP[126].val.integerVal =
  _dpsP[213].val.integerVal = grabWindow;
  _dpsP[1].val.integerVal =
  _dpsP[10].val.integerVal = winUnderMouse;
  _dpsP[4].val.integerVal =
  _dpsP[13].val.integerVal = prevWinUnderMouse;
  _dpsP[198].val.integerVal = imageGstate;
  _dpsP[250].val.integerVal =
  _dpsP[139].val.integerVal = oldBgGs;
  _dpsP[132].val.integerVal =
  _dpsP[146].val.integerVal =
  _dpsP[152].val.integerVal =
  _dpsP[188].val.integerVal =
  _dpsP[205].val.integerVal = newImageGs;
  _dpsP[159].val.integerVal = bitmapGstate;
  _dpsP[240].val.integerVal =
  _dpsP[181].val.integerVal = grabGstate;
  _dpsP[16].val.realVal = mouseDownX;
  _dpsP[19].val.realVal = mouseDownY;
  _dpsP[112].val.realVal = offsetX;
  _dpsP[117].val.realVal = offsetY;
  _dpsP[267].val.realVal =
  _dpsP[314].val.realVal =
  _dpsP[238].val.realVal =
  _dpsP[248].val.realVal =
  _dpsP[144].val.realVal =
  _dpsP[157].val.realVal =
  _dpsP[186].val.realVal =
  _dpsP[203].val.realVal = imageW;
  _dpsP[268].val.realVal =
  _dpsP[315].val.realVal =
  _dpsP[239].val.realVal =
  _dpsP[249].val.realVal =
  _dpsP[145].val.realVal =
  _dpsP[158].val.realVal =
  _dpsP[187].val.realVal =
  _dpsP[204].val.realVal = imageH;
  _dpsP[0].val.nameVal = _dpsCodes[0];
  _dpsP[294].val.nameVal = _dpsCodes[1];
  _dpsP[135].val.nameVal = _dpsCodes[2];
  _dpsP[77].val.nameVal = _dpsCodes[3];
  _dpsP[9].val.nameVal = _dpsCodes[4];
  _dpsP[233].val.nameVal = _dpsCodes[5];
  _dpsP[229].val.nameVal = _dpsCodes[6];
  _dpsP[171].val.nameVal = _dpsCodes[7];
  _dpsP[106].val.nameVal = _dpsCodes[8];
  _dpsP[86].val.nameVal = _dpsCodes[9];
  _dpsP[12].val.nameVal = _dpsCodes[10];
  _dpsP[225].val.nameVal = _dpsCodes[11];
  _dpsP[221].val.nameVal = _dpsCodes[12];
  _dpsP[176].val.nameVal = _dpsCodes[13];
  _dpsP[101].val.nameVal = _dpsCodes[14];
  _dpsP[91].val.nameVal = _dpsCodes[15];
  _dpsP[15].val.nameVal = _dpsCodes[16];
  _dpsP[252].val.nameVal = _dpsCodes[17];
  _dpsP[165].val.nameVal = _dpsCodes[18];
  _dpsP[69].val.nameVal = _dpsCodes[19];
  _dpsP[18].val.nameVal = _dpsCodes[20];
  _dpsP[255].val.nameVal = _dpsCodes[21];
  _dpsP[168].val.nameVal = _dpsCodes[22];
  _dpsP[72].val.nameVal = _dpsCodes[23];
  _dpsP[24].val.nameVal = _dpsCodes[24];
  _dpsP[253].val.nameVal = _dpsCodes[25];
  _dpsP[166].val.nameVal = _dpsCodes[26];
  _dpsP[111].val.nameVal = _dpsCodes[27];
  _dpsP[70].val.nameVal = _dpsCodes[28];
  _dpsP[62].val.nameVal = _dpsCodes[29];
  _dpsP[39].val.nameVal = _dpsCodes[30];
  _dpsP[25].val.nameVal = _dpsCodes[31];
  _dpsP[256].val.nameVal = _dpsCodes[32];
  _dpsP[169].val.nameVal = _dpsCodes[33];
  _dpsP[116].val.nameVal = _dpsCodes[34];
  _dpsP[73].val.nameVal = _dpsCodes[35];
  _dpsP[65].val.nameVal = _dpsCodes[36];
  _dpsP[42].val.nameVal = _dpsCodes[37];
  _dpsP[26].val.nameVal = _dpsCodes[38];
  _dpsP[28].val.nameVal = _dpsCodes[39];
  _dpsP[32].val.nameVal = _dpsCodes[40];
  _dpsP[59].val.nameVal = _dpsCodes[41];
  _dpsP[49].val.nameVal = _dpsCodes[42];
  _dpsP[50].val.nameVal = _dpsCodes[43];
  _dpsP[64].val.nameVal = _dpsCodes[44];
  _dpsP[82].val.nameVal = _dpsCodes[45];
  _dpsP[215].val.nameVal = _dpsCodes[46];
  _dpsP[102].val.nameVal = _dpsCodes[47];
  _dpsP[312].val.nameVal = _dpsCodes[48];
  _dpsP[230].val.nameVal = _dpsCodes[49];
  _dpsP[222].val.nameVal = _dpsCodes[50];
  _dpsP[107].val.nameVal = _dpsCodes[51];
  _dpsP[103].val.nameVal = _dpsCodes[52];
  _dpsP[231].val.nameVal = _dpsCodes[53];
  _dpsP[223].val.nameVal = _dpsCodes[54];
  _dpsP[108].val.nameVal = _dpsCodes[55];
  _dpsP[110].val.nameVal = _dpsCodes[56];
  _dpsP[308].val.nameVal = _dpsCodes[57];
  _dpsP[194].val.nameVal = _dpsCodes[58];
  _dpsP[128].val.nameVal = _dpsCodes[59];
  _dpsP[120].val.nameVal = _dpsCodes[60];
  _dpsP[115].val.nameVal = _dpsCodes[61];
  _dpsP[309].val.nameVal = _dpsCodes[62];
  _dpsP[195].val.nameVal = _dpsCodes[63];
  _dpsP[129].val.nameVal = _dpsCodes[64];
  _dpsP[121].val.nameVal = _dpsCodes[65];
  _dpsP[123].val.nameVal = _dpsCodes[66];
  _dpsP[197].val.nameVal = _dpsCodes[67];
  _dpsP[131].val.nameVal = _dpsCodes[68];
  _dpsP[124].val.nameVal = _dpsCodes[69];
  _dpsP[127].val.nameVal = _dpsCodes[70];
  _dpsP[214].val.nameVal = _dpsCodes[71];
  _dpsP[150].val.nameVal = _dpsCodes[72];
  _dpsP[320].val.nameVal = _dpsCodes[73];
  _dpsP[258].val.nameVal = _dpsCodes[74];
  _dpsP[244].val.nameVal = _dpsCodes[75];
  _dpsP[209].val.nameVal = _dpsCodes[76];
  _dpsP[192].val.nameVal = _dpsCodes[77];
  _dpsP[151].val.nameVal = _dpsCodes[78];
  _dpsP[321].val.nameVal = _dpsCodes[79];
  _dpsP[259].val.nameVal = _dpsCodes[80];
  _dpsP[245].val.nameVal = _dpsCodes[81];
  _dpsP[210].val.nameVal = _dpsCodes[82];
  _dpsP[193].val.nameVal = _dpsCodes[83];
  _dpsP[164].val.nameVal = _dpsCodes[84];
  _dpsP[163].val.nameVal = _dpsCodes[85];
  _dpsP[211].val.nameVal = _dpsCodes[86];
  _dpsP[260].val.nameVal = _dpsCodes[87];
  _dpsP[292].val.nameVal = _dpsCodes[88];
  _dpsP[271].val.nameVal = _dpsCodes[89];
  _dpsP[279].val.nameVal = _dpsCodes[90];
  _dpsP[274].val.nameVal = _dpsCodes[91];
  _dpsP[275].val.nameVal = _dpsCodes[92];
  _dpsP[297].val.nameVal = _dpsCodes[93];
  _dpsP[290].val.nameVal = _dpsCodes[94];
  _dpsP[287].val.nameVal = _dpsCodes[95];
  _dpsP[311].val.nameVal = _dpsCodes[96];
  _dpsP[303].val.nameVal = _dpsCodes[97];
  _dpsP[300].val.nameVal = _dpsCodes[98];
  _dpsP[313].val.nameVal = _dpsCodes[99];
  DPSSetResultTable(_dpsCurCtxt, _dpsR, 4);
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,2588);
  DPSAwaitReturnValues(_dpsCurCtxt);
}
#line 245 "dartPSwraps.psw"

#line 1879 "dartPSwraps.c"
void miniDragWindow(int imageWindow, int newImageWindow, int grabWindow, int imageGstate, int oldBgGs, int newImageGs, int bitmapGstate, int grabGstate, float currentX, float currentY, float offsetX, float offsetY, float imageW, float imageH)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjReal obj1;
    DPSBinObjReal obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjReal obj6;
    DPSBinObjReal obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjGeneric obj13;
    DPSBinObjGeneric obj14;
    DPSBinObjGeneric obj15;
    DPSBinObjGeneric obj16;
    DPSBinObjGeneric obj17;
    DPSBinObjGeneric obj18;
    DPSBinObjGeneric obj19;
    DPSBinObjGeneric obj20;
    DPSBinObjGeneric obj21;
    DPSBinObjGeneric obj22;
    DPSBinObjGeneric obj23;
    DPSBinObjGeneric obj24;
    DPSBinObjReal obj25;
    DPSBinObjReal obj26;
    DPSBinObjReal obj27;
    DPSBinObjReal obj28;
    DPSBinObjGeneric obj29;
    DPSBinObjGeneric obj30;
    DPSBinObjReal obj31;
    DPSBinObjReal obj32;
    DPSBinObjGeneric obj33;
    DPSBinObjGeneric obj34;
    DPSBinObjReal obj35;
    DPSBinObjReal obj36;
    DPSBinObjReal obj37;
    DPSBinObjReal obj38;
    DPSBinObjGeneric obj39;
    DPSBinObjGeneric obj40;
    DPSBinObjGeneric obj41;
    DPSBinObjReal obj42;
    DPSBinObjGeneric obj43;
    DPSBinObjGeneric obj44;
    DPSBinObjReal obj45;
    DPSBinObjGeneric obj46;
    DPSBinObjGeneric obj47;
    DPSBinObjGeneric obj48;
    DPSBinObjGeneric obj49;
    DPSBinObjGeneric obj50;
    DPSBinObjGeneric obj51;
    DPSBinObjReal obj52;
    DPSBinObjReal obj53;
    DPSBinObjReal obj54;
    DPSBinObjReal obj55;
    DPSBinObjGeneric obj56;
    DPSBinObjGeneric obj57;
    DPSBinObjReal obj58;
    DPSBinObjReal obj59;
    DPSBinObjGeneric obj60;
    DPSBinObjGeneric obj61;
    DPSBinObjGeneric obj62;
    DPSBinObjGeneric obj63;
    DPSBinObjGeneric obj64;
    DPSBinObjReal obj65;
    DPSBinObjReal obj66;
    DPSBinObjReal obj67;
    DPSBinObjReal obj68;
    DPSBinObjGeneric obj69;
    DPSBinObjGeneric obj70;
    DPSBinObjReal obj71;
    DPSBinObjReal obj72;
    DPSBinObjGeneric obj73;
    DPSBinObjGeneric obj74;
    DPSBinObjGeneric obj75;
    DPSBinObjGeneric obj76;
    DPSBinObjGeneric obj77;
    DPSBinObjReal obj78;
    DPSBinObjReal obj79;
    DPSBinObjReal obj80;
    DPSBinObjReal obj81;
    DPSBinObjGeneric obj82;
    DPSBinObjGeneric obj83;
    DPSBinObjReal obj84;
    DPSBinObjReal obj85;
    DPSBinObjGeneric obj86;
    DPSBinObjGeneric obj87;
    DPSBinObjGeneric obj88;
    DPSBinObjGeneric obj89;
    DPSBinObjGeneric obj90;
    DPSBinObjGeneric obj91;
    DPSBinObjGeneric obj92;
    DPSBinObjGeneric obj93;
    DPSBinObjGeneric obj94;
    DPSBinObjReal obj95;
    DPSBinObjReal obj96;
    DPSBinObjReal obj97;
    DPSBinObjReal obj98;
    DPSBinObjGeneric obj99;
    DPSBinObjGeneric obj100;
    DPSBinObjReal obj101;
    DPSBinObjReal obj102;
    DPSBinObjGeneric obj103;
    DPSBinObjGeneric obj104;
    DPSBinObjGeneric obj105;
    DPSBinObjGeneric obj106;
    DPSBinObjGeneric obj107;
    DPSBinObjGeneric obj108;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 109, 876,
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: currentX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: offsetX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_LITERAL|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: currentY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: offsetY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 51},	/* def */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* movewindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Above */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* movewindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: oldBgGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* lastX */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: currentX */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* lastY */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: currentY */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 169},	/* sub */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: oldBgGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: bitmapGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Sover */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageX */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* imageY */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* movewindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageGstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 151},	/* setgstate */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageW */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0},	/* param: imageH */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageGs */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_LITERAL|DPS_REAL, 0, 0, 0.0},
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Copy */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* composite */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* Out */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWindow */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* orderwindow */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[29] = {-1};
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"imageX",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"imageY",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"movewindow",
	(char *) 0 ,
	(char *) 0 ,
	"Above",
	"orderwindow",
	(char *) 0 ,
	"Copy",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"composite",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 ,
	"lastX",
	"lastY",
	"Sover",
	"Out"};
    long int *_dps_nameVals[29];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];
    _dps_nameVals[2] = &_dpsCodes[2];
    _dps_nameVals[3] = &_dpsCodes[3];
    _dps_nameVals[4] = &_dpsCodes[4];
    _dps_nameVals[5] = &_dpsCodes[5];
    _dps_nameVals[6] = &_dpsCodes[6];
    _dps_nameVals[7] = &_dpsCodes[7];
    _dps_nameVals[8] = &_dpsCodes[8];
    _dps_nameVals[9] = &_dpsCodes[9];
    _dps_nameVals[10] = &_dpsCodes[10];
    _dps_nameVals[11] = &_dpsCodes[11];
    _dps_nameVals[12] = &_dpsCodes[12];
    _dps_nameVals[13] = &_dpsCodes[13];
    _dps_nameVals[14] = &_dpsCodes[14];
    _dps_nameVals[15] = &_dpsCodes[15];
    _dps_nameVals[16] = &_dpsCodes[16];
    _dps_nameVals[17] = &_dpsCodes[17];
    _dps_nameVals[18] = &_dpsCodes[18];
    _dps_nameVals[19] = &_dpsCodes[19];
    _dps_nameVals[20] = &_dpsCodes[20];
    _dps_nameVals[21] = &_dpsCodes[21];
    _dps_nameVals[22] = &_dpsCodes[22];
    _dps_nameVals[23] = &_dpsCodes[23];
    _dps_nameVals[24] = &_dpsCodes[24];
    _dps_nameVals[25] = &_dpsCodes[25];
    _dps_nameVals[26] = &_dpsCodes[26];
    _dps_nameVals[27] = &_dpsCodes[27];
    _dps_nameVals[28] = &_dpsCodes[28];

    DPSMapNames(_dpsCurCtxt, 29, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[15].val.integerVal =
  _dpsP[90].val.integerVal = imageWindow;
  _dpsP[20].val.integerVal = newImageWindow;
  _dpsP[12].val.integerVal =
  _dpsP[16].val.integerVal =
  _dpsP[107].val.integerVal = grabWindow;
  _dpsP[92].val.integerVal = imageGstate;
  _dpsP[39].val.integerVal =
  _dpsP[49].val.integerVal = oldBgGs;
  _dpsP[22].val.integerVal =
  _dpsP[56].val.integerVal =
  _dpsP[62].val.integerVal =
  _dpsP[82].val.integerVal =
  _dpsP[99].val.integerVal = newImageGs;
  _dpsP[69].val.integerVal = bitmapGstate;
  _dpsP[29].val.integerVal =
  _dpsP[75].val.integerVal = grabGstate;
  _dpsP[1].val.realVal =
  _dpsP[42].val.realVal = currentX;
  _dpsP[6].val.realVal =
  _dpsP[45].val.realVal = currentY;
  _dpsP[2].val.realVal = offsetX;
  _dpsP[7].val.realVal = offsetY;
  _dpsP[27].val.realVal =
  _dpsP[37].val.realVal =
  _dpsP[54].val.realVal =
  _dpsP[67].val.realVal =
  _dpsP[80].val.realVal =
  _dpsP[97].val.realVal = imageW;
  _dpsP[28].val.realVal =
  _dpsP[38].val.realVal =
  _dpsP[55].val.realVal =
  _dpsP[68].val.realVal =
  _dpsP[81].val.realVal =
  _dpsP[98].val.realVal = imageH;
  _dpsP[0].val.nameVal = _dpsCodes[0];
  _dpsP[88].val.nameVal = _dpsCodes[1];
  _dpsP[18].val.nameVal = _dpsCodes[2];
  _dpsP[10].val.nameVal = _dpsCodes[3];
  _dpsP[5].val.nameVal = _dpsCodes[4];
  _dpsP[89].val.nameVal = _dpsCodes[5];
  _dpsP[19].val.nameVal = _dpsCodes[6];
  _dpsP[11].val.nameVal = _dpsCodes[7];
  _dpsP[13].val.nameVal = _dpsCodes[8];
  _dpsP[91].val.nameVal = _dpsCodes[9];
  _dpsP[21].val.nameVal = _dpsCodes[10];
  _dpsP[14].val.nameVal = _dpsCodes[11];
  _dpsP[17].val.nameVal = _dpsCodes[12];
  _dpsP[108].val.nameVal = _dpsCodes[13];
  _dpsP[33].val.nameVal = _dpsCodes[14];
  _dpsP[103].val.nameVal = _dpsCodes[15];
  _dpsP[86].val.nameVal = _dpsCodes[16];
  _dpsP[60].val.nameVal = _dpsCodes[17];
  _dpsP[47].val.nameVal = _dpsCodes[18];
  _dpsP[34].val.nameVal = _dpsCodes[19];
  _dpsP[104].val.nameVal = _dpsCodes[20];
  _dpsP[87].val.nameVal = _dpsCodes[21];
  _dpsP[74].val.nameVal = _dpsCodes[22];
  _dpsP[61].val.nameVal = _dpsCodes[23];
  _dpsP[48].val.nameVal = _dpsCodes[24];
  _dpsP[41].val.nameVal = _dpsCodes[25];
  _dpsP[44].val.nameVal = _dpsCodes[26];
  _dpsP[73].val.nameVal = _dpsCodes[27];
  _dpsP[105].val.nameVal = _dpsCodes[28];
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,876);
}
#line 298 "dartPSwraps.psw"

#line 2250 "dartPSwraps.c"
void PS_cleanup(int imageWin, int bgWin, int newImageWin, int grabWin, int igstate, int bggstate, int nigstate, int ggstate)
{
  typedef struct {
    unsigned char tokenType;
    unsigned char topLevelCount;
    unsigned short nBytes;

    DPSBinObjGeneric obj0;
    DPSBinObjGeneric obj1;
    DPSBinObjGeneric obj2;
    DPSBinObjGeneric obj3;
    DPSBinObjGeneric obj4;
    DPSBinObjGeneric obj5;
    DPSBinObjGeneric obj6;
    DPSBinObjGeneric obj7;
    DPSBinObjGeneric obj8;
    DPSBinObjGeneric obj9;
    DPSBinObjGeneric obj10;
    DPSBinObjGeneric obj11;
    DPSBinObjGeneric obj12;
    DPSBinObjGeneric obj13;
    DPSBinObjGeneric obj14;
    DPSBinObjGeneric obj15;
    DPSBinObjGeneric obj16;
    DPSBinObjGeneric obj17;
    DPSBinObjGeneric obj18;
    DPSBinObjGeneric obj19;
    DPSBinObjGeneric obj20;
    DPSBinObjGeneric obj21;
    DPSBinObjGeneric obj22;
    DPSBinObjGeneric obj23;
    DPSBinObjGeneric obj24;
    DPSBinObjGeneric obj25;
    DPSBinObjGeneric obj26;
    DPSBinObjGeneric obj27;
    DPSBinObjGeneric obj28;
    DPSBinObjGeneric obj29;
    DPSBinObjGeneric obj30;
    DPSBinObjGeneric obj31;
    DPSBinObjGeneric obj32;
    DPSBinObjGeneric obj33;
    DPSBinObjGeneric obj34;
    } _dpsQ;
  static const _dpsQ _dpsStat = {
    DPS_DEF_TOKENTYPE, 35, 284,
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 78},	/* gsave */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 322},	/* nulldevice */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: igstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 34},	/* currentgstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: bggstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 34},	/* currentgstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: nigstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 34},	/* currentgstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: ggstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 212},	/* execuserobject */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 34},	/* currentgstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 117},	/* pop */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 77},	/* grestore */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: igstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 373},	/* undefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: bggstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 373},	/* undefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: nigstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 373},	/* undefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: ggstate */
    {DPS_EXEC|DPS_NAME, 0, DPSSYSNAME, 373},	/* undefineuserobject */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: imageWin */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* termwindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: bgWin */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* termwindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: newImageWin */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* termwindow */
    {DPS_LITERAL|DPS_INT, 0, 0, 0},	/* param: grabWin */
    {DPS_EXEC|DPS_NAME, 0, 0, 0},	/* termwindow */
    }; /* _dpsQ */
  _dpsQ _dpsF;	/* local copy  */
  register DPSContext _dpsCurCtxt = DPSPrivCurrentContext();
  register DPSBinObjRec *_dpsP = (DPSBinObjRec *)&_dpsF.obj0;
  static long int _dpsCodes[4] = {-1};
  {
if (_dpsCodes[0] < 0) {
    static const char * const _dps_names[] = {
	"termwindow",
	(char *) 0 ,
	(char *) 0 ,
	(char *) 0 };
    long int *_dps_nameVals[4];
    _dps_nameVals[0] = &_dpsCodes[0];
    _dps_nameVals[1] = &_dpsCodes[1];
    _dps_nameVals[2] = &_dpsCodes[2];
    _dps_nameVals[3] = &_dpsCodes[3];

    DPSMapNames(_dpsCurCtxt, 4, _dps_names, _dps_nameVals);
    }
  }

  _dpsF = _dpsStat;	/* assign automatic variable */

  _dpsP[27].val.integerVal = imageWin;
  _dpsP[29].val.integerVal = bgWin;
  _dpsP[31].val.integerVal = newImageWin;
  _dpsP[33].val.integerVal = grabWin;
  _dpsP[2].val.integerVal =
  _dpsP[19].val.integerVal = igstate;
  _dpsP[6].val.integerVal =
  _dpsP[21].val.integerVal = bggstate;
  _dpsP[10].val.integerVal =
  _dpsP[23].val.integerVal = nigstate;
  _dpsP[14].val.integerVal =
  _dpsP[25].val.integerVal = ggstate;
  _dpsP[28].val.nameVal = _dpsCodes[0];
  _dpsP[34].val.nameVal = _dpsCodes[1];
  _dpsP[32].val.nameVal = _dpsCodes[2];
  _dpsP[30].val.nameVal = _dpsCodes[3];
  DPSBinObjSeqWrite(_dpsCurCtxt,(char *) &_dpsF,284);
}
#line 322 "dartPSwraps.psw"


