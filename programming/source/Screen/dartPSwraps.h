/* dartPSwraps.h generated from dartPSwraps.psw
   by unix pswrap V1.009  Wed Apr 19 17:50:24 PDT 1989
 */

#ifndef DARTPSWRAPS_H
#define DARTPSWRAPS_H

extern void setrotatedfont(char *fontname, float fontsize);

extern void unrotatefont( void );

extern void setflippedfont(char *fontname, float fontsize);

extern void initDrag(float mouseDownX, float mouseDownY, float offsetX, float offsetY, float imageW, float imageH, int *iWindow, int *bgWindow, int *niWindow, int *igstate, int *bggstate, int *nigstate, int *gWindow, int *ggstate);

extern void dragWindow(int imageWindow, int newImageWindow, int grabWindow, int winUnderMouse, int prevWinUnderMouse, int imageGstate, int oldBgGs, int newImageGs, int bitmapGstate, int grabGstate, float mouseDownX, float mouseDownY, float offsetX, float offsetY, float imageW, float imageH, int *mouseup, int *underwindow, float *newMouseX, float *newMouseY);

extern void miniDragWindow(int imageWindow, int newImageWindow, int grabWindow, int imageGstate, int oldBgGs, int newImageGs, int bitmapGstate, int grabGstate, float currentX, float currentY, float offsetX, float offsetY, float imageW, float imageH);

extern void PS_cleanup(int imageWin, int bgWin, int newImageWin, int grabWin, int igstate, int bggstate, int nigstate, int ggstate);

#endif DARTPSWRAPS_H
