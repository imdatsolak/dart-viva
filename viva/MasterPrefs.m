#import <appkit/View.h>
#import <appkit/NXCursor.h>
#import <appkit/Window.h>

#import "dart/fieldvaluekit.h"
#import "dart/Localizer.h"
#import "dart/PaletteView.h"

#import "ImageManager.h"
#import "TheApp.h"

#import "MasterPrefs.h"

#pragma .h #import <objc/Object.h>
#pragma .h #import <dpsclient/event.h>

@implementation MasterPrefs:Object
{
	id		preferencesView;
	id		myWindow;
	id		prefsWindow;
	id		iconButton;
	id		cursor;
	BOOL	needsSaving;
}

+ icon
{
	return [[NXApp imageMgr] iconFor:[[self class] name]];
}

- init
{
	[super init];
	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	cursor = [[NXCursor alloc] initFromImage:[[NXApp imageMgr] iconFor:"CopyCursor"]];
	return self;

}

- free
{
	return [super free];
}

- freeItems
{
	return self;
}

- putYourViewInto:aWindow
{
	[aWindow disableFlushWindow];
	[preferencesView removeFromSuperview];
	[[aWindow contentView] addSubview:preferencesView];
	[self redisplay:self];
	[aWindow reenableFlushWindow];
	prefsWindow = aWindow;
	return self;
}

- redisplay:sender
{ 
	return self;
}

- removeYourViewFrom:aWindow
{
	[preferencesView removeFromSuperview];
	[[myWindow contentView] addSubview:preferencesView];
	return self;
}

- reloadPrefs:sender
{
	needsSaving = NO;
	return self;
}

- savePrefs:sender
{
	needsSaving = NO;
	return self;
}

- (BOOL)acceptsItem:anItem
{ 
	return	NO; 
}

- pasteItem:anItem
{
	return nil;
}

- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource
{
	if ((dragSource != iconButton) && ([dragSource window] != prefsWindow) &&
		 ([self acceptsItem:[dragSource content]])) {
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
	
	if ((source != iconButton) && ([source window] != prefsWindow)){
		if (((entryItem = [source content]) != nil ) && ([self acceptsItem:[source content]])) {
			id	copiedItem = [entryItem copy];
			accepted = YES;
			[self perform:@selector(pasteAndFreeCopiedDelayItem:) with:copiedItem afterDelay:1 cancelPrevious:NO];
			[prefsWindow makeKeyAndOrderFront:self];
		}
	}
	[NXArrow set];
	return accepted;
}

- pasteAndFreeCopiedDelayItem:anItem
{
	[self pasteItem:anItem];
	anItem = [anItem free];
	needsSaving = YES;
	[prefsWindow setDocEdited:YES];
	return self;
}

- controlDidChange:sender
{
	needsSaving = YES;
	[prefsWindow setDocEdited:YES];
	return self;
}

- textDidChange:sender
{
	needsSaving = YES;
	[prefsWindow setDocEdited:YES];
	return self;
}
@end
