#import <dpsclient/psops.h>
#import <dpsclient/wraps.h>
#import <appkit/timer.h>
#import <appkit/Cell.h>
#import <appkit/Window.h>
#import <appkit/Application.h>

#import "NiftyMatrix.h"


@implementation NiftyMatrix

#define startTimer(timer) if (!timer) timer = NXBeginTimer(NULL, 0.1, 0.01);

#define stopTimer(timer) if (timer) { \
    NXEndTimer(timer); \
    timer = NULL; \
}

#define MOVE_MASK NX_MOUSEUPMASK|NX_MOUSEDRAGGEDMASK

- free
{
    [matrixCache free];
    [cellCache free];
    
    return [super free];
}

- mouseDown:(NXEvent *)theEvent
{
    NXPoint		mouseDownLocation, mouseUpLocation, mouseLocation;
    int			eventMask, row, column, newRow, activeCellPos;
    NXRect		visibleRect, cellCacheBounds, cellFrame;
    id			matrixCacheContentView, cellCacheContentView;
    float		dy;
    NXEvent		*event, peek;
    NXTrackingTimer	*timer = NULL;
    BOOL		scrolled = NO;
    
    if (!(theEvent->flags & NX_CONTROLMASK)) {
		return [super mouseDown:theEvent];
    }
    
    [self setupCacheWindows];
    
    eventMask = [window addToEventMask:NX_MOUSEDRAGGEDMASK];

    mouseDownLocation = theEvent->location;
    [self convertPoint:&mouseDownLocation fromView:nil];
    [self getRow:&row andCol:&column forPoint:&mouseDownLocation];
 	activeCellPos = row;
    activeCell = [self cellAt:row :column];
    [self selectCell:activeCell];
    [self getCellFrame:&cellFrame at:row :column];
    
    [self sendAction];
    
    [self lockFocus];
    [[self drawSelf:&cellFrame :1] unlockFocus];
    
    matrixCacheContentView = [matrixCache contentView];
    [matrixCacheContentView lockFocus];
    [self getVisibleRect:&visibleRect];
    [self convertRect:&visibleRect toView:nil];
    PScomposite(NX_X(&visibleRect), NX_Y(&visibleRect),
    		NX_WIDTH(&visibleRect), NX_HEIGHT(&visibleRect),
		[window gState], 0.0, NX_HEIGHT(&visibleRect), NX_COPY);
    [matrixCacheContentView unlockFocus];

    cellCacheContentView = [cellCache contentView];
    [cellCacheContentView lockFocus];
    [cellCacheContentView getBounds:&cellCacheBounds];
    [activeCell drawSelf:&cellCacheBounds inView:cellCacheContentView];
    [cellCacheContentView unlockFocus];

    dy = mouseDownLocation.y - cellFrame.origin.y;
    
    [self lockFocus];
    
    event = theEvent;
    while (event->type != NX_MOUSEUP) {
			
		[self getVisibleRect:&visibleRect];
		PScomposite(NX_X(&cellFrame), NX_HEIGHT(&visibleRect) -
				NX_Y(&cellFrame) + NX_Y(&visibleRect) -
				NX_HEIGHT(&cellFrame), NX_WIDTH(&cellFrame),
				NX_HEIGHT(&cellFrame), [matrixCache gState],
				NX_X(&cellFrame), NX_Y(&cellFrame) + NX_HEIGHT(&cellFrame),
				NX_COPY);
		
		mouseLocation = event->location;
		[self convertPoint:&mouseLocation fromView:nil];
		cellFrame.origin.y = mouseLocation.y - dy;
		
		if (NX_Y(&cellFrame) < NX_X(&bounds) ) {
			cellFrame.origin.y = NX_X(&bounds);
		} else if (NX_MAXY(&cellFrame) > NX_MAXY(&bounds)) {
			cellFrame.origin.y = NX_HEIGHT(&bounds) - NX_HEIGHT(&cellFrame);
		}
	
		if (!NXContainsRect(&visibleRect, &cellFrame) && mFlags.autoscroll) {	
			[window disableFlushWindow];
			[self scrollRectToVisible:&cellFrame];
			[window reenableFlushWindow];
			
			[matrixCacheContentView lockFocus];
			[self getVisibleRect:&visibleRect];
			[self convertRectFromSuperview:&visibleRect];
			[self convertRect:&visibleRect toView:nil];
			PScomposite(NX_X(&visibleRect), NX_Y(&visibleRect),
				NX_WIDTH(&visibleRect), NX_HEIGHT(&visibleRect),
				[window gState], 0.0, NX_HEIGHT(&visibleRect),
				NX_COPY);
			[matrixCacheContentView unlockFocus];
			
			scrolled = YES;
			startTimer(timer);
		} else {
			stopTimer(timer);
		}
			
		PScomposite(0.0, 0.0, NX_WIDTH(&cellFrame), NX_HEIGHT(&cellFrame),
				[cellCache gState], NX_X(&cellFrame),
				NX_Y(&cellFrame) + NX_HEIGHT(&cellFrame), NX_COPY);
		
		[window flushWindow];
		if (scrolled) {
			NXPing();
			scrolled = NO;
		}
		
		mouseLocation = event->location;
		
		if (![NXApp peekNextEvent:MOVE_MASK into:&peek]) {
			event = [NXApp getNextEvent:MOVE_MASK|NX_TIMERMASK];
		} else {
			event = [NXApp getNextEvent:MOVE_MASK];
		}
		
		if (event->type == NX_TIMER) {
			event->location = mouseLocation;
		}
    }
    
    stopTimer(timer);
    [self unlockFocus];
    
    mouseUpLocation = event->location;
    [self convertPoint:&mouseUpLocation fromView:nil];
    if (![self getRow:&newRow andCol:&column forPoint:&mouseUpLocation]) {
		[self getRow:&newRow andCol:&column forPoint:&(cellFrame.origin)];
    }
    
  /* we need to shuffle cells if the active cell's going to a new location */
    if (newRow != row) {
		[self setAutodisplay:NO];
		if (newRow > row) {
			if (selectedRow <= newRow) {
				selectedRow--;
			}
			while (row++ < newRow) {
				cell = [self cellAt:row :0];
				[self putCell:cell at:(row - 1) :0];
			}
			[self putCell:activeCell at:newRow :0];
		} else if (newRow < row) {
			if (selectedRow >= newRow) {
				selectedRow++;
			}
			while (row-- > newRow) {
				cell = [self cellAt:row :0];
				[self putCell:cell at:(row + 1) :0];
			}
			[self putCell:activeCell at:newRow :0];
		}
		if ([activeCell state]) {
			selectedRow = newRow;
		}
			
		if (mFlags.autoscroll) {
			[self scrollCellToVisible:newRow :0];
		}
		if ([delegate respondsTo:@selector(cellMovedFrom:to:)]) {
			[delegate cellMovedFrom:(unsigned)activeCellPos to:(unsigned)newRow];
		}
		activeCell = 0;
		[[self sizeToCells] setAutodisplay:YES];
    } else {
		activeCell = 0;
    }
    [[self superview] display];
    [window setEventMask:eventMask];

    return self;
}

- drawSelf:(NXRect *)rects :(int)count
{
    int		row, col;
    NXRect	cellBorder;
    int		sides[] = {NX_XMIN, NX_YMIN, NX_XMAX, NX_YMAX, NX_XMIN,
    			   NX_YMIN};
    float	grays[] = {NX_DKGRAY, NX_DKGRAY, NX_WHITE, NX_WHITE, NX_BLACK,
			   NX_BLACK};
			   
    [super drawSelf:rects :count];
    
    if (activeCell) {
		[self getRow:&row andCol:&col ofCell:activeCell];
		[self getCellFrame:&cellBorder at:row :col];
		if (NXIntersectsRect(&cellBorder, &(rects[0]))) {
			NXDrawTiledRects(&cellBorder, (NXRect *)0, sides, grays, 6);
			PSsetgray(0.17);
			NXRectFill(&cellBorder);
		}
    }
    
    return self;
}

- setupCacheWindows
{
    NXRect	visibleRect;

    [self getVisibleRect:&visibleRect];
    matrixCache = [self sizeCacheWindow:matrixCache to:&(visibleRect.size)];
    cellCache = [self sizeCacheWindow:cellCache to:&cellSize];
    return self;
}

- sizeCacheWindow:cacheWindow to:(NXSize *)windowSize
{
    NXRect	cacheFrame;
    
    if (!cacheWindow) {
		cacheFrame.origin.x = cacheFrame.origin.y = 0.0;
		cacheFrame.size = *windowSize;
		cacheWindow = [[[Window alloc] initContent:&cacheFrame
							style:NX_PLAINSTYLE
							backing:NX_RETAINED
							buttonMask:0
							defer:NO] reenableDisplay];
		[[cacheWindow contentView] setFlipped:YES];
    } else {
		[cacheWindow getFrame:&cacheFrame];
		if (cacheFrame.size.width != windowSize->width ||
				cacheFrame.size.height != windowSize->height) {
			[cacheWindow sizeWindow:windowSize->width
							:windowSize->height];
		}
    }
    
    return cacheWindow;
}

- setDelegate:anObject
{
	delegate = anObject;
	return self;
}

- delegate { return delegate; }


@end