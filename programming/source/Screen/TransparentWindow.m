#import <math.h>
#import <dpsclient/wraps.h>
#import <appkit/publicWraps.h>
#import <appkit/NXImage.h>
#import <appkit/Window.h>
#import <appkit/View.h>
#import <appkit/Application.h>

#import <dart/Animator.h>
#import <dart/dartPSwraps.h>

#import "TransparentWindow.h"

#define NOWINDOW 0

@implementation TransparentWindow

- initForImage:anImage at:(NXPoint *)windowOrigin forView:anObject
{
    NXRect	windowFrame;
    NXPoint	origin = {0.0, 0.0};
    
    [anImage getSize:&windowSize];
    windowFrame.origin.x = windowFrame.origin.y = 0.0;
    windowFrame.size = windowSize;
    image = [[Window alloc] initContent:&windowFrame
			    style:NX_PLAINSTYLE
			    backing:NX_RETAINED
			    buttonMask:0
			    defer:NO];

    [[image contentView] lockFocus];
    [anImage composite:NX_COPY toPoint:&origin];
    [[image contentView] unlockFocus];
    source = anObject;
    animator = [[Animator alloc] initChronon:(1.0 / 80)
				 adaptation:0.0
				 target:self
				 action:@selector(animateBack:)
				 autoStart:NO
				 eventMask:0];
				 
    return self;
}

- free
{
    [image free];
    [animator free];
    return [super free];
}

- image
{
    return image;
}

-(BOOL) dragFromMouseDown:(NXPoint *)startingPoint mouseOffset:(NXPoint *)offset
{
    unsigned int    windowNum;
    BOOL	    	accepted = NO;
    float	    	deltaX, deltaY, distance;
	BOOL			droppedButNotAccepted=NO;
    int				mouseUp = 0, windowUnderImage, windowUnderMouseChanged = 0, 
					previousWindowUnderMouseChanged = 0;
    
	PSsetwaitcursorenabled(NO);
    imageGstate = [image gState];
    currentPoint = stoppingPoint = *startingPoint;

    initDrag(currentPoint.x, currentPoint.y, offset->x, offset->y,  windowSize.width, windowSize.height, 
			 &iWindow, &bgWindow,  &niWindow, &igstate, &bggstate, &nigstate, &gWindow, &ggstate);

    while (!mouseUp) {
		dragWindow(iWindow, niWindow, gWindow, windowUnderMouseChanged, previousWindowUnderMouseChanged, igstate,
					bggstate, nigstate, imageGstate, ggstate, currentPoint.x, currentPoint.y, offset->x, offset->y, 
					windowSize.width, windowSize.height, &mouseUp, &windowUnderImage, &(currentPoint.x), 
					&(currentPoint.y));
	
		[self checkForAcceptWindow:windowUnderImage atPoint:&currentPoint :&windowUnderMouseChanged
					:&previousWindowUnderMouseChanged];
    }

	if (windowUnderMouseChanged) {
		NXConvertGlobalToWinNum(windowUnderMouseChanged, &windowNum);
		[[NXApp findWindow:windowNum] flushWindow];
	}

	if (previousWindowUnderMouse) {
		if (previousWindowUnderMouseChanged) {
			[previousWindowUnderMouse flushWindow];
		}
		if ([[previousWindowUnderMouse delegate] respondsTo:@selector(acceptedButNotDropped)]) {
			accepted = droppedButNotAccepted = YES;
		} else {
			accepted = [[previousWindowUnderMouse delegate] windowDropped:&currentPoint fromSource:source];
		}
	}
    
    if (!accepted) {
		deltaX = currentPoint.x - startingPoint->x;
		deltaY = currentPoint.y - startingPoint->y;
		if (deltaX && deltaY) {
			distance = sqrt(deltaX  * deltaX + deltaY * deltaY);
			frames = ceil(40.0 * distance / 5000.0);
			if (frames == 1) {
				frames = ceil(40.0 * distance / 1400.0);
			}
			increment.x = deltaX / frames;
			increment.y = deltaY / frames;
			mouseOffset = *offset;
			[animator startEntry];
			return NO;
		}
    }
    
    PS_cleanup(iWindow, bgWindow, niWindow, gWindow, igstate, bggstate, nigstate, ggstate);
	PSsetwaitcursorenabled(YES);
    [self free];
	
	return droppedButNotAccepted;
}

- checkForAcceptWindow:(int)windowNumUnderMouse atPoint:(NXPoint *)point :(int *)windowUnderMouseChanged :(int *)previousWindowUnderMouseChanged
{
    unsigned   int	windowNum;
    id			windowUnderMouse = NOWINDOW;
    
    *windowUnderMouseChanged = 0;
    *previousWindowUnderMouseChanged = 0;
      
    if (windowNumUnderMouse) {
		NXConvertGlobalToWinNum(windowNumUnderMouse, &windowNum);
		windowUnderMouse = [NXApp findWindow:windowNum];
		if (![[windowUnderMouse delegate] respondsTo:@selector(windowEntered:fromSource:)]) {
			windowUnderMouse = NOWINDOW;
			windowNumUnderMouse = 0;
		}
    }
    
    if ((windowUnderMouse != previousWindowUnderMouse) && (previousWindowUnderMouse != NOWINDOW)) {
		if ([[previousWindowUnderMouse delegate] windowExited:source]) {
			*previousWindowUnderMouseChanged = previousWindowNumUnderMouse;
		}
    }
    
    if (windowUnderMouse != NOWINDOW)  {
		if ([[windowUnderMouse delegate] windowEntered:point fromSource:source]) {
			*windowUnderMouseChanged = windowNumUnderMouse;
		}
    }
    previousWindowUnderMouse = windowUnderMouse;
    previousWindowNumUnderMouse = windowNumUnderMouse;
    
    return self;
}

- animateBack:sender
{
    currentPoint.x -= increment.x;
    currentPoint.y -= increment.y;
    
    if ((increment.x > 0 && (currentPoint.x < stoppingPoint.x + 3.0)) ||
		(increment.x < 0 && (currentPoint.x > stoppingPoint.x - 3.0))) {
			currentPoint.x = stoppingPoint.x;
    }
    if ((increment.y > 0 && (currentPoint.y < stoppingPoint.y + 3.0)) ||
      	(increment.y < 0 && (currentPoint.y > stoppingPoint.y + 3.0))) {
			currentPoint.y = stoppingPoint.y;
    }
    miniDragWindow(iWindow, niWindow, gWindow, igstate, bggstate, nigstate,
    		imageGstate, ggstate, currentPoint.x, currentPoint.y,
			mouseOffset.x, mouseOffset.y, windowSize.width, windowSize.height);
    
    if (--frames) {
		return self;
    }
    [animator stopEntry];
    PS_cleanup(iWindow, bgWindow, niWindow, gWindow, igstate, bggstate, nigstate, ggstate);
	PSsetwaitcursorenabled(YES);
	
    return [self free];
}

@end