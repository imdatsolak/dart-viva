#import <appkit/graphics.h> 
#import <dpsclient/wraps.h>
#import "TimerView.h"

@implementation TimerView

- reset
{
	myDouble = 0.0;
	return self;
}

	
- drawSelf:(NXRect *)rects :(int ) count
{
	NXRect	myFrame;
	NXRect	viewFrame;
	NXCoord	step;
	int		i;
	
	[super drawSelf:rects :count];
	[super getFrame:&myFrame];
	[super getFrame:&viewFrame];
	myFrame.origin.y = myFrame.origin.x = 0;
	PSsetgray(NX_LTGRAY);
	NXDrawWhiteBezel(&myFrame, &myFrame);
	PSsetgray(NX_LTGRAY);
	myFrame.size.width = myFrame.size.width * ([self doubleValue]/100) -2;
	myFrame.size.height -= 4;
	myFrame.origin.y += 2;
	myFrame.origin.x += 2;
	NXRectFill(&myFrame);
	step = viewFrame.size.width / 20.0;
	
	PSsetlinewidth(1.0);
	for (i=1;i<=20;i++) {
		NXCoord xp = myFrame.origin.x + (step * i) -1;
		if (xp <= myFrame.size.width) {
			PSsetgray(NX_DKGRAY);
		} else {
			PSsetgray(NX_LTGRAY);
		}
		PSmoveto(xp, 3.0);
		if ((i % 5) != 0) {
			PSlineto(xp, 6.0);
		} else {
			PSlineto(xp, 9.0);
		}
		PSstroke();
	}
	
	return self;
}


- setDoubleValue:(double )aValue
{
	myDouble = aValue;
	[self display];
	return self;
}

- (double )doubleValue
{
	return myDouble;
}
@end
