#import <stdlib.h>
#import <string.h>
#import <math.h>
#import <dpsclient/wraps.h>
#import <appkit/NXImage.h>
#import <appkit/Cell.h>
#import <appkit/TextField.h>
#import <appkit/Font.h>
#import <appkit/Text.h>
#import <appkit/Application.h>

#import <dart/dartPSwraps.h>
#import <dart/TransparentWindow.h>
#import <dart/String.h>
#import <dart/Integer.h>

#import "PaletteView.h"

#pragma .h #import <appkit/Control.h>

@implementation PaletteView:Control
{
	id	   	icon;
	id		myOwner;
	id		target;
	id		doubleTarget;
	id		content;
	id		supportFont;
	id		titleField;
	SEL		action;
	SEL		doubleAction;
	NXRect  hotRect;
	NXEvent	*anEvent;
	BOOL	dissolve;
	BOOL	selected;
	BOOL	isTitled;
	BOOL	editable;
}

static 	id hilite = nil;
static	NXSize   hiliteSize;


- initFrame:(NXRect *)frameRect
{
	[super initFrame:frameRect];
	isTitled = NO;
	selected = NO;
	editable = NO;
	titleField = nil;
	return self;
}


- setOwner:owner
{
	myOwner = owner;
	return self;
}

- owner
{
	return myOwner;
}


- (BOOL)acceptsFirstMouse
{
    return YES;
}

- setImageObject:anImageObject
{
    icon = anImageObject;

 	if( icon) {
		[icon getSize:&(hotRect.size)];
		hotRect.origin.x = floor((NX_WIDTH(&bounds) - NX_WIDTH(&hotRect)) / 2.0);
		hotRect.origin.y = floor((NX_HEIGHT(&bounds) - NX_HEIGHT(&hotRect)) / 2.0);
    }
	[self display];	

	return self;
}


- imageObject
{
	return icon;
}


- mouseDown:(NXEvent *)theEvent
{
	id		imageWindow;
	NXRect	windowRect;
	NXPoint	hitPoint, offset, mouseLocation;
	BOOL	droppedButNotAccepted = NO;
		
	if (!content) 
		return self;
		
	if (theEvent->data.mouse.click == 2) {
		BOOL	wasSel = selected;
		[[self setGhost:YES] display];
		if ([doubleTarget respondsTo:doubleAction]) {
			[doubleTarget perform:doubleAction with:self];
		}
		[[self setGhost:NO] setSelected:wasSel];
	} else {
		id	aFirstResp = [[self window] firstResponder];
		if (aFirstResp != nil) {
			[aFirstResp resignFirstResponder];
		}
		if ([target respondsTo:action]) {
			[target perform:action with:self];
		}
		if (theEvent->flags & NX_CONTROLMASK) {
			NXRect 	aFrame;
			NXSize	imageSize;
			id		ret = nil;
			[icon getSize:&imageSize];
			
			aFrame.origin.x = floor((NX_WIDTH(&bounds) - imageSize.width) / 2.0);
			aFrame.origin.y = floor((NX_HEIGHT(&bounds)	- imageSize.height) / 2.0);
			ret = [self dragFile:"/Net/dart/Users/imdat/Tiffs+Eps/Unterschrift92.tiff"
						fromRect:&aFrame
						slideBack:YES
						event:theEvent];
		} else {
			anEvent = theEvent;
			hitPoint = theEvent->location;
			[self convertPoint:&hitPoint fromView:nil];
			if( !NXPointInRect(&hitPoint, &hotRect)) {
				return self;
			}
		
			[self display];
			windowRect = hotRect;
			[self convertRect:&windowRect toView:nil];
			[window convertBaseToScreen:&windowRect.origin];
			
			offset.x = hitPoint.x - NX_X(&hotRect);
			offset.y = hitPoint.y - NX_Y(&hotRect);
			
			mouseLocation = theEvent->location;
			[window convertBaseToScreen:&mouseLocation];
			
			imageWindow = [[TransparentWindow alloc] initForImage:icon
														at:&(windowRect.origin)
														forView:self];
			droppedButNotAccepted = [imageWindow dragFromMouseDown:&mouseLocation mouseOffset:&offset];
			if ((droppedButNotAccepted) && ([[self owner] respondsTo:@selector(copySpecial:)])) {
				[[self owner] copySpecial:self];
			}
		}
	}
	return self;
}


- drawSelf:(NXRect *)rects :(int)count		/*n*/
{
	NXPoint	point, pt2;
	NXSize	imageSize;
	id		textCell;

	PSsetgray(NX_LTGRAY);
	NXRectFill(rects);

	if (!icon) {
		return self;
	}
	if (!supportFont) {
		supportFont = [[Font newFont:"Helvetica" size:9.0] set];
	}
	[icon getSize:&imageSize];
	
	point.x = floor((NX_WIDTH(&bounds) - imageSize.width) / 2.0);
	point.y = floor((NX_HEIGHT(&bounds)	- imageSize.height) / 2.0);
	
    if (selected) {
		if( nil == hilite ) {
            hilite = [[NXApp imageMgr] iconFor:"ToolHilite"];
            [hilite getSize:&hiliteSize];
		}
        pt2.x = floor((NX_WIDTH(&bounds) - hiliteSize.width) / 2.0);
        pt2.y = floor((NX_HEIGHT(&bounds) - hiliteSize.height) / 2.0);
        [hilite composite:NX_COPY toPoint:&pt2];
        [icon composite:NX_SOVER toPoint:&point];
    } else {
		if (dissolve)  {
			[icon composite:NX_SOVER toPoint:&point];
			PSsetalpha(0.5);
			PSsetgray(NX_LTGRAY);
			PScompositerect(point.x, point.y, imageSize.width, imageSize.height, NX_SOVER);
		} else {
			[icon composite:NX_SOVER toPoint:&hotRect.origin];
		}
	}
	if ((nil != content) && 
		(([content respondsTo:@selector(description)]) && (nil != [content description])) && isTitled) {
		char 	*buffer;
		NXRect	myFrame;
		id		ident;
		
		ident = [[content description] copy];
		if (ident) {
			[self getFrame:&myFrame];
			if (![ident isKindOf:[String class]]) {
				id oldId = ident;
				ident = [ident copyAsString];
				[oldId free];
			}
			buffer = malloc([ident length]+100);
			
			setflippedfont((char *)[supportFont name],[supportFont pointSize]);
			PSsetgray(NX_BLACK);
			if ([content respondsTo:@selector(count)] && ([content count]!=1)) {
				sprintf(buffer,"%d %s",[content count], [ident str]);
			} else {
				strcpy(buffer, [ident str]);
			}

			if (titleField == nil) {
				NXRect	aFrame;
				aFrame.origin.x = 3;
				aFrame.origin.y = 0;
				aFrame.size.width = myFrame.size.width-6;
				aFrame.size.height = 12.0;
				titleField = [[TextField alloc] initFrame:&aFrame];
				textCell = [titleField cell];
				[[[titleField setFont:supportFont] setBezeled:NO] setBordered:NO];
				[textCell setScrollable:NO];
				[titleField setTextDelegate:self];
				[textCell setTextGray:NX_BLACK];
				[textCell setAlignment:NX_CENTERED];
				[self addSubview:titleField];
			} else {
				textCell = [titleField cell];
			}
			[textCell setStringValue:buffer];
			[textCell setEditable:[self isEditable]];
			[textCell setBackgroundGray:[self isEditable]? NX_WHITE:NX_LTGRAY];
			[titleField display];
			free(buffer);
			[ident free];
		}
	}
	return self;
}


- setEditable:(BOOL)flag
{
	editable = flag;
	return self;
}

- (BOOL)isEditable
{
	return editable;
}
	
- setTitled:(BOOL)flag
{
	isTitled = flag;
	return self;
}

- (BOOL)isTitled
{
	return isTitled;
}

- setGhost:(BOOL )flag
{
	dissolve = flag;
	selected = selected && !dissolve;
	return self;
}

- (BOOL)ghost
{
	return dissolve;
}


- setSelected:(BOOL)flag
{
	selected = flag;
	[self display];
	return self;
}

- (BOOL) selected
{
	return selected;
}


- setTarget:anObject
{
	target = anObject;
	return self;
}


- setAction:(SEL )aSelector
{
	action = aSelector;
	return self;
}


- target
{
	return target;
}


- (SEL )action
{
	return action;
}

#if 0
/* masks for the bits in the flags field */
    /* Device-independent bits */
#define	NX_ALPHASHIFTMASK	(1 << 16)	/* if alpha lock is on */
#define	NX_SHIFTMASK		(1 << 17)	/* if shift key is down */
#define NX_CONTROLMASK		(1 << 18)	/* if control key is down */
#define NX_ALTERNATEMASK	(1 << 19)	/* if alt key is down */
#define NX_COMMANDMASK		(1 << 20)	/* if command key is down */
#define NX_NUMERICPADMASK	(1 << 21)	/* if key on numeric pad */
    /* Device-dependent bits */
#define NX_NEXTCTRLKEYMASK	(1 << 0)	/* control key */
#define NX_NEXTLSHIFTKEYMASK	(1 << 1)	/* left side shift key */
#define NX_NEXTRSHIFTKEYMASK	(1 << 2)	/* right side shift key */
#define NX_NEXTLCMDKEYMASK	(1 << 3)	/* left side command key */
#define NX_NEXTRCMDKEYMASK	(1 << 4)	/* right side command key */
#define NX_NEXTLALTKEYMASK	(1 << 5)	/* left side alt key */
#define NX_NEXTRALTKEYMASK	(1 << 6)	/* right side alt key */
#endif

- (long )getMask
{
	if (anEvent) 
		return anEvent->flags;
	else
		return 0;
}


- setContent:anObject
{
	if (content) {
		[content free];
		content = nil;
	}
	content = [anObject copy];
	if (content == nil) {
		[self setImageObject:nil];
	} else {
		[self setImageObject:[content imageObject]];
	}
	return self;
}


- content
{
	return content;
}


- setDoubleTarget:anObject
{
	doubleTarget = anObject;
	return self;
}

- setDoubleAction:(SEL )anAction
{
	doubleAction = anAction;
	return self;
}

- doubleTarget
{
	return doubleTarget;
}

- (SEL)doubleAction
{
	return doubleAction;
}

- free
{
	[content free];
	[titleField removeFromSuperview];
	[titleField free];
	return [super free];
}

- textDidEnd:textObject endChar:(unsigned short)whyEnd
{
	if ([myOwner respondsTo:@selector(titleChanged:to:)]) {
		[myOwner titleChanged:self to:[titleField stringValue]];
	}
	return self;
}

@end

@interface Object(PaletteViewOwner)
- titleChanged:sender to:(const char *)newTitle;
- copySpecial:sender;
@end

@interface Object(PaletteViewContent)
- imageObject;
- description;
@end

@interface Object(ImageMgr)
- iconFor:(const char *)iconName;
@end

@interface Object(TheApplication)
- imageMgr;
@end

