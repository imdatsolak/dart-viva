#import <libc.h>
#import <appkit/graphics.h> 
#import <dpsclient/wraps.h>
#import <appkit/NXImage.h>
#import <appkit/Button.h>
#import <dpsclient/dpsclient.h>
#import "TheApp.h"
#import "ImageManager.h"

#import "AbspannView.h"

#pragma .h #import <appkit/View.h>

@implementation AbspannView:View
{
    id		icon1;
	NXRect 	myFrame;
	NXRect 	finalFrame;
	NXPoint	aPoint;
	NXSize 	imageFrame;
	id		button;
	DPSTimedEntry anEntry;
	double	backGray;
	id		buttonToCopyBack;
	double	step;
}

void scrollFunc(DPSTimedEntry teNumber, double now, char *userData)
{
	id	theObj = (id)userData;
	[theObj scrollOnce];
}
- initFrame:(const NXRect *)frameRect
{
	[super initFrame:frameRect];
	backGray = NX_LTGRAY;
	return self;
}

- do:sender copyBack:aButton
{
	float 	delta;
	step = 1;
	buttonToCopyBack = aButton;
	backGray = NX_LTGRAY;
	if (icon1==nil) {
		icon1 = [[NXApp imageMgr] iconFor:"vivax"];
	}
    [icon1 getSize:&imageFrame];
	[self getFrame:&myFrame];
	aPoint.y = -imageFrame.height+174.0;
	aPoint.x = ((myFrame.size.width-imageFrame.width)/2);
	finalFrame.size.width = imageFrame.width;
	finalFrame.origin.x = aPoint.x;
	button = sender;
	[button setEnabled:NO];
	delta = 0.0;
	while (delta <= 1.0) {
		[self lockFocus];
		[icon1 dissolve:delta toPoint:&aPoint];
		delta += 0.04;
		[self unlockFocus];
	}
	anEntry= DPSAddTimedEntry(step*0.01,(DPSTimedEntryProc)&scrollFunc, self, NX_MODALRESPTHRESHOLD);
    return self;
}


- scrollOnce
{
	if (aPoint.y>myFrame.size.height) {
		NXPoint thePoint;
		float	delta;
		id		anImage;
		DPSRemoveTimedEntry(anEntry);
		backGray = NX_LTGRAY;
		thePoint.y = 0;
		thePoint.x = 0;
		delta = 0.0;
		anImage = [buttonToCopyBack image];
		while (delta <= 1.0) {
			[buttonToCopyBack lockFocus];
			[anImage dissolve:delta toPoint:&thePoint];
			delta += 0.025;
			[buttonToCopyBack unlockFocus];
		}
		[button setEnabled:YES];
		[[buttonToCopyBack window] display];
		return self;
	} else {
		finalFrame.origin.y = aPoint.y;
		[self lockFocus];
		[icon1 composite:NX_COPY toPoint:&aPoint];
		PSsetgray(backGray);
		finalFrame.size.height = 0.5 * step;
		NXRectFill(&finalFrame);
		[self unlockFocus];
		aPoint.y = aPoint.y + (0.5 * step);
	}
	return self;
}


- drawSelf:(const NXRect *)r :(int)c
{
	[super drawSelf:r :c];
	PSsetgray(backGray);
	NXRectFill(r);
	return self;
}
@end
