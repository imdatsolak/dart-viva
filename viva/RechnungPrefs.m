#import <stdio.h>

#import <appkit/NXCursor.h>
#import <appkit/View.h>
#import <appkit/Window.h>

#import "dart/fieldvaluekit.h"
#import "dart/PaletteView.h"

#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "LayoutItemList.h"

#import "RechnungPrefs.h"

#pragma .h #import "MasterDocumentPrefs.h"

@implementation RechnungPrefs:MasterDocumentPrefs
{
	id	mahn1Icon;
	id	mahn2Icon;
	id	mahn3Icon;
	
	id	mahn1;
	id	mahn2;
	id	mahn3;
}

- init
{
	mahn1 = [String str:""];
	mahn2 = [String str:""];
	mahn3 = [String str:""];
	[super init];
	return self;
}

- free
{
	[mahn1 free];
	[mahn2 free];
	[mahn3 free];
	return [super free];
}
	
- reloadPrefs:sender
{
	id	value = [[NXApp defaultsDB] valueForKey:"LayoutForM1"];
	if (value != nil) [mahn1 str:[value str]];

	value = [[NXApp defaultsDB] valueForKey:"LayoutForM2"];
	if (value != nil) [mahn2 str:[value str]];

	value = [[NXApp defaultsDB] valueForKey:"LayoutForM3"];
	if (value != nil) [mahn3 str:[value str]];
	[[[mahn1Icon setDoubleTarget:self] setDoubleAction:@selector(openItem:)] setTitled:YES];
	[[[mahn2Icon setDoubleTarget:self] setDoubleAction:@selector(openItem:)] setTitled:YES];
	[[[mahn3Icon setDoubleTarget:self] setDoubleAction:@selector(openItem:)] setTitled:YES];
	return [super reloadPrefs:sender];
}

- redisplay:sender
{
	if ([mahn1 length] > 0) {
		id	content = [[[LayoutItemList alloc] initCount:0] addIdentity:mahn1];
		[mahn1Icon setContent:content];
		[content free];
	}

	if ([mahn2 length] > 0) {
		id	content = [[[LayoutItemList alloc] initCount:0] addIdentity:mahn2];
		[mahn2Icon setContent:content];
		[content free];
	}

	if ([mahn3 length] > 0) {
		id	content = [[[LayoutItemList alloc] initCount:0] addIdentity:mahn3];
		[mahn3Icon setContent:content];
		[content free];
	}
	return [super redisplay:sender];
}

- savePrefs:sender
{
	if ([[[mahn1Icon content] identity] str] != NULL)
		[mahn1 str:[[[mahn1Icon content] identity] str]];
	[[NXApp defaultsDB] setValue:mahn1 forKey:"LayoutForM1"];
	
	if ([[[mahn2Icon content] identity] str] != NULL)
		[mahn2 str:[[[mahn2Icon content] identity] str]];
	[[NXApp defaultsDB] setValue:mahn2 forKey:"LayoutForM2"];
	
	if ([[[mahn3Icon content] identity] str] != NULL)
		[mahn3 str:[[[mahn3Icon content] identity] str]];
	[[NXApp defaultsDB] setValue:mahn3 forKey:"LayoutForM3"];
	
	return [super savePrefs:sender];
}

- (const char *)myLayoutKey { return "LayoutForRE"; }

- pasteItem:anItem
{
	[NXApp beep:"CommandShitV not possible"];
	return self;
}

- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	id		entryItem, viewToDropOn, content;
	BOOL 	accepted = NO;
	
	if (([source window] != prefsWindow)) {
		if (((entryItem = [source content]) != nil ) && ([self acceptsItem:[source content]])) {
			NXPoint	aPoint = *mouseLocation;
			[prefsWindow convertScreenToBase:&aPoint];
			viewToDropOn = [[prefsWindow contentView] hitTest:&aPoint];
			if ([viewToDropOn isKindOf:[PaletteView class]]) {
				content = [[[LayoutItemList alloc] initCount:0] addIdentityOf:entryItem];
				[viewToDropOn setContent:content];
				[prefsWindow makeKeyAndOrderFront:self];
				[prefsWindow setDocEdited:YES];
				[content free];
				accepted = YES;
			} else {
				accepted = NO;
			}
		}
	}
	[NXArrow set];
	return accepted;
}

- (const char *)nrBreiteKey { return "RechnungItemNrBreite"; }
- (const char *)nrBeginKey { return "RechnungItemNrBegin"; }
- (const char *)prePostfixSelectKey { return "RechnungItemNrPrePostfixSelect";}
- (const char *)prePostfixKindKey { return "RechnungItemNrPrefixKind"; }
- (const char *)withDashKey { return "RechnungItemNrWithDash"; }
- (const char *)maxNrTableName { return "maxrechnung"; }

@end
