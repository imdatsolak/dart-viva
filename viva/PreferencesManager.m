#import <stdlib.h>
#import <string.h>

#import <objc/objc-runtime.h>
#import <objc/List.h>
#import <objc/typedstream.h>
#import <streams/streams.h>
#import <appkit/ScrollView.h>
#import <appkit/Button.h>

#import "TheApp.h"

#import "PreferencesManager.h"

#pragma .h #import "MasterDocument.h"

@implementation PreferencesManager:MasterDocument
{
	id	selectedButton;
	id	currentOpenPrefs;
	id	currentPreferences;
	id	scrollView;
}


+ (BOOL)canHaveMultipleInstances
{
	return NO;
}

- itemClass
{ return [self class]; }

- init
{
	[super init];
	currentOpenPrefs = [[List alloc] initCount:0];
	selectedButton = [[[scrollView docView] subviews] objectAt:0];
	[selectedButton performClick:self];
	return self;
}

- free
{
	[[currentOpenPrefs freeObjects] free];
	[NXApp unregisterDocument:self];
	return [super free];
}

- addPreferencesClass:theClass
{
	NXRect	aFrame, lastButtonFrame;
	int		count;
	id		newButton, lastButton;
		
	count = [[[scrollView docView] subviews] count];
	lastButton = [[[scrollView docView] subviews] objectAt:count-1];
	[lastButton getFrame:&lastButtonFrame];
	
	aFrame.origin.x = 0.0;
	aFrame.origin.y = lastButtonFrame.origin.y + lastButtonFrame.size.width;
	aFrame.size.width = lastButtonFrame.size.width;
	aFrame.size.height = lastButtonFrame.size.height;

	newButton = [lastButton copy];
	[newButton setFrame:&aFrame];
	NXNameObject([theClass name], newButton, self);
	[newButton setImage:(id)[theClass icon]];
	[newButton setTarget:self];
	[newButton setAction:@selector(changePrefButtonClicked:)];
	[[scrollView docView] addSubview:newButton];
	[[scrollView docView] sizeTo:aFrame.origin.x+aFrame.size.width :aFrame.size.height];
	return self;
}
	
- changePrefButtonClicked:sender
{
	id		classToMakeInstanceOf;
	id		newPreferences = nil;
	char	*str = malloc(strlen(NXGetObjectName(sender))+8);
	int		i, count;
	BOOL	found=NO;
	
	[selectedButton setState:0];
	[selectedButton display];

	strcpy(str,NXGetObjectName(sender));
	classToMakeInstanceOf = objc_getClass(str);
	free(str);
	
	count = [currentOpenPrefs count];
	for (i=0;(i<count) && !found;i++) {
		newPreferences = [currentOpenPrefs objectAt:i];
		found = [newPreferences isKindOf:classToMakeInstanceOf];
	}
	if (!found) {
		newPreferences = [[classToMakeInstanceOf alloc] init];
	}
	if (newPreferences) {
		if (newPreferences != currentPreferences) {
			[currentPreferences removeYourViewFrom:window];
			[newPreferences putYourViewInto:window];
			if (!found) {
				[currentOpenPrefs addObject:newPreferences];
			}
			currentPreferences = newPreferences;
		}
		selectedButton = sender;
		[sender setState:1];
	} else {
		[[selectedButton setState:1] display];
		[NXApp beep:"WrongPreferences"];
	}

	[window display];
    return self;
}


- (BOOL)save
{
	[currentOpenPrefs makeObjectsPerform:@selector(savePrefs:) with:self];
	[window setDocEdited:NO];
	return YES;
}

- (BOOL)revertToSaved
{ 
	[currentOpenPrefs makeObjectsPerform:@selector(reloadPrefs:) with:self];
	[currentPreferences redisplay:self];
	[window setDocEdited:NO];
	return YES; 
}

- checkMenus
{
	[[NXApp saveButton] setEnabled:YES];
	[[NXApp revertButton] setEnabled:[window isDocEdited]];
	return self;
}

- (BOOL)acceptsItem:anItem
{ 
	return	[currentPreferences acceptsItem:anItem]; 
}

- windowDidBecomeKey:sender
{
	[super windowDidBecomeKey:sender];
	[[NXApp destroyButton] setEnabled:NO];
	[[NXApp findButton] setEnabled:NO];
	[[NXApp newButton] setEnabled:NO];
	return self;
}

- pasteItem:anItem
{
	return [currentPreferences pasteItem:anItem];
}
- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource
{
	return [currentPreferences windowEntered:mouseLocation fromSource:dragSource];
}


- (BOOL)windowExited:dragSource
{
	return [currentPreferences windowExited:dragSource];
}


- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	return [currentPreferences windowDropped:mouseLocation fromSource:source];
}

@end

@interface Object(SubPreferences)
- reloadSelf:sender;
- putYourViewInto:aWindow;
- redisplay:sender;
- removeYourViewFrom:aWindow;
- savePrefs:sender;
@end

#if 0
BEGIN TABLE DEFS
create table preferences
(
	userid	int,
	key	varchar(96),
	range	int,
	valuetype	char(1),
	value	text
)

create unique clustered index preferencesindex on preferences(userid,key,range)
go
insert into preferences values(0,"defaultMwSt",1,"d","14.0")
go
END TABLE DEFS
#endif
