#import <dpsclient/event.h>
#import <objc/Object.h>

@interface TransparentWindow:Object
{
    id		image;
	id		source;
	id		previousWindowUnderMouse;
	id		animator;
	int		iWindow;
	int		bgWindow;
	int		niWindow;
	int		gWindow;
	int		igstate;
	int		bggstate;
	int		nigstate;
	int		imageGstate;
	int		ggstate;
	int		previousWindowNumUnderMouse;
	int		frames;
    NXSize	windowSize;
	NXPoint	increment;
	NXPoint	currentPoint;
	NXPoint	stoppingPoint;
	NXPoint	mouseOffset;
}

- initForImage:anImage at:(NXPoint *)windowOrigin forView:anObject;
- free;
- image;
-(BOOL) dragFromMouseDown:(NXPoint *)startingPoint mouseOffset:(NXPoint *)offset;
- checkForAcceptWindow:(int)windowNumUnderMouse atPoint:(NXPoint *)point :(int *)windowUnderMouseChanged :(int *)previousWindowUnderMouseChanged;
- animateBack:sender;

@end

@interface Object(TransparentWindowsDelegate)
- acceptedButNotDropped;
- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource;
- (BOOL)windowExited:dragSource;
- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source;
@end

