
#import <appkit/NXCursor.h>
#import <appkit/View.h>
#import <appkit/Window.h>

#import "dart/fieldvaluekit.h"
#import "dart/PaletteView.h"

#import "CustomPopupButton.h"
#import "DefaultsDatabase.h"
#import "LayoutItemList.h"
#import "TheApp.h"

#import "LieferscheinPrefs.h"

#pragma .h #import "MasterDocumentPrefs.h"

@implementation LieferscheinPrefs:MasterDocumentPrefs
{
	id	defaultLagerPopup;
	id	packzettelIcon;

	id	defaultLager;
	id	packzettel;
}
- init
{
	defaultLager = [String str:""];
	packzettel = [String str:""];
	[super init];
	return self;
}

- free
{
	[defaultLager free];
	[packzettel free];
	return [super free];
}

- reloadPrefs:sender
{
	id	value = [[NXApp defaultsDB] valueForKey:"defaultLagerZumAusbuchen"];
	if (value != nil) { 
		[defaultLager str:[value str]];
	}

	value = [[NXApp defaultsDB] valueForKey:"LayoutForPZ"];
	if (value != nil) [packzettel str:[value str]];

	[[[packzettelIcon setDoubleTarget:self] setDoubleAction:@selector(openItem:)] setTitled:YES];
	return [super reloadPrefs:sender];
}

- redisplay:sender
{
	if ([packzettel length] > 0) {
		id	content = [[[LayoutItemList alloc] initCount:0] addIdentity:packzettel];
		[packzettelIcon setContent:content];
		[content free];
	}

	[defaultLagerPopup setTitle:[defaultLager str]];
	return [super redisplay:sender];
}

- savePrefs:sender
{
	if (needsSaving) {
		if ([[[packzettelIcon content] identity] str] != NULL)
			[packzettel str:[[[packzettelIcon content] identity] str]];
		[[NXApp defaultsDB] setValue:packzettel forKey:"LayoutForPZ"];
	
		[defaultLager str:[defaultLagerPopup title]];
		[[NXApp defaultsDB] setValue:defaultLager forKey:"defaultLagerZumAusbuchen"];
		return [super savePrefs:sender];
	} else {
		return self;
	}
}

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


- (const char *)myLayoutKey { return "LayoutForLF"; }
- (const char *)nrBreiteKey { return "LieferscheinItemNrBreite"; }
- (const char *)nrBeginKey { return "LieferscheinItemNrBegin"; }
- (const char *)prePostfixSelectKey { return "LieferscheinItemNrPrePostfixSelect";}
- (const char *)prePostfixKindKey { return "LieferscheinItemNrPrefixKind"; }
- (const char *)withDashKey { return "LieferscheinItemNrWithDash"; }
- (const char *)maxNrTableName { return "maxlieferschein"; }
@end
