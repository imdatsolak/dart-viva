#import <objc/List.h>
#import <appkit/NXCursor.h>
#import <appkit/Window.h>
#import <appkit/Speaker.h>
#import <appkit/NXImage.h>
#import <appkit/Listener.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/PaletteView.h"

#import "FileItem.h"
#import "ImageManager.h"
#import "TheApp.h"

#import "MasterObject.h"
	
#pragma .h #import <dpsclient/event.h>
#pragma .h #import <objc/Object.h>

@implementation MasterObject:Object
{
	id	window;
	id	cursor;
	id	iconButton;
	id	myMiniWindow;
	id	oldImage;		/* this is a local private variable */
	id	droppedPathList;
}

static id	instanceList = nil;

+ instanceList
{
	if(instanceList == nil) instanceList = [[List alloc] initCount:0];
	return instanceList;
}

+ (BOOL)canHaveMultipleInstances
{
	return YES;
}

/*+ cursor
{
	static id copyCursor = nil;
	if(copyCursor == nil) {
		copyCursor = [[NXCursor alloc] initFromImage:[[NXApp imageMgr] iconFor:"CopyCursor"]];
	}
	return copyCursor;
}
*/
+ newInstance
{	
	if(![self canHaveMultipleInstances]) {
		id	list = [self instanceList];
		int	i, count = [list count];
		for(i=0; i<count; i++) {
			if([[list objectAt:i] isMemberOf:[self class]]) {
				return [list objectAt:i];
			}
		}
	}
	return [self createNewInstance];
}


+ createNewInstance
{
	return [[self alloc] init];
}

+ registerInstance:anInstance
{
	[[self instanceList] addObject:anInstance];
	return self;
}


+ unRegisterInstance:anInstance
{
	[[self instanceList] removeObject:anInstance];
	return self;
}


- init
{
	[super init];
	if(![[self class] canHaveMultipleInstances]) {
		[[self class] registerInstance:self];
	}
	cursor = [[NXCursor alloc] initFromImage:[[NXApp imageMgr] iconFor:"CopyCursor"]];
	myMiniWindow = nil;
	droppedPathList = [String str:""];
	return self;
}

- free
{
	if (myMiniWindow) {
		[myMiniWindow orderOut:self];
	}
	if(![[self class] canHaveMultipleInstances]) {
		[[self class] unRegisterInstance:self];
	}
	droppedPathList = [droppedPathList free];
	return [super free];
}


- makeActive:sender
{
	[window makeKeyAndOrderFront:sender];
	[NXApp checkMenus];
	return self;
}

- checkMenus
{ return self; }


- close:sender  
{
	if ([window isDocEdited]) {
		[window makeKeyAndOrderFront:sender];
	}
	return [window performClose:sender];
}


- window  
{ return window; }



- pasteItem:item
{
	return [self subclassResponsibility:_cmd];
}


- (BOOL)acceptsItem:item
{
	return NO;
}


- windowWillMiniaturize:sender toMiniwindow:miniwindow
{
	myMiniWindow = miniwindow;
	return self;
}

- windowDidDeminiaturize:sender
{
	myMiniWindow = nil;
	return self;
}


- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource
{
	BOOL	isWritable;
	if ([self respondsTo:@selector(isReadOnly)]) {
		isWritable = ![self isReadOnly];
	} else {
		isWritable = NO;
	}
	if ((dragSource != iconButton) && ([dragSource window] != [self window]) &&
		 (isWritable && [self acceptsItem:[dragSource content]])) {
		[cursor set];
		return YES;
	}
	return NO;
}


- (BOOL)windowExited:dragSource
{
	[NXArrow set];
	return NO;
}


- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	id		entryItem;
	BOOL 	accepted = NO;
	BOOL	isWritable;
	if ([self respondsTo:@selector(isReadOnly)]) {
		isWritable = ![self isReadOnly];
	} else {
		isWritable = NO;
	}
	if ((source != iconButton) && ([source window] != [self window])){
		if (((entryItem = [source content]) != nil ) && (isWritable && [self acceptsItem:[source content]])) {
			id	copiedItem = [entryItem copy];
			[self perform:@selector(pasteAndFreeCopiedDelayItem:) with:copiedItem afterDelay:1 cancelPrevious:NO];
			[window makeKeyAndOrderFront:self];
//			[self pasteItem:entryItem];
			accepted = YES;
		}
	}
	[NXArrow set];
	return accepted;
}

- pasteAndFreeCopiedDelayItem:anItem
{
	[self pasteItem:anItem];
	anItem = [anItem free];
	return self;
}

/* =================================== DocumentHandler Menu Handling Methods =============== */
- (BOOL)isEditedAndSaveable
{
	return [window isDocEdited];
}

- (BOOL)isSelectedAndOpenable
{
	return ([iconButton content] != nil);
}

- (BOOL)isSelectedAndDestroyable
{
	return ([iconButton content] != nil);
}

- (int)iconEntered:(int)windowNum at:(double)x :(double)y iconWindow:(int)iconWindowNum iconX:(double)iconX iconY:(double)iconY iconWidth:(double)iconWidth iconHeight:(double)iconHeight pathList:(char *)pathList
{
	id	fakeItem = [[FileItem alloc] initFilename:nil];
	BOOL	isWritable;
	if ([self respondsTo:@selector(isReadOnly)]) {
		isWritable = ![self isReadOnly];
	} else {
		isWritable = NO;
	}
	[droppedPathList str:pathList];
	if (isWritable && [self acceptsItem:fakeItem]) {	
		[fakeItem free];
	    return 0;
	} else {
		[fakeItem free];
		return 1;
	}
}

- (int)iconExitedAt:(double)x :(double)y
{ return 0; }
   
- (int)iconReleasedAt:(double)x :(double)y ok:(int *)flag
{
	[self perform:@selector(getFileInfo:) with:self afterDelay:1 cancelPrevious:NO];
	*flag = 1;
    return 0;
}
    
- getFileInfo:sender
{	
	id			tmpStr = [droppedPathList copy];
	id			newFilename = [tmpStr copyStrtok:"\t"];
	while (newFilename != nil) {
		id	newFileItem;
		DEBUG2("Current File to drop: [%s]\n",[newFilename str]);
		newFileItem = [[FileItem alloc] initFilename:newFilename];
		[self pasteItem:newFileItem];
		[newFileItem free];
		[newFilename free];
		newFilename = [tmpStr copyStrtok:"\t"];
	}
	
	[tmpStr free];
	
	return self;
}

@end

@interface Object(MySubclasses)
- (BOOL)isReadOnly;
@end

