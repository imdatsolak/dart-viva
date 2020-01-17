#import <appkit/TextField.h>

#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "UserManager.h"
#import "IconListView.h"
#import "FileItem.h"
#import "BenutzerItem.h"
#import "BenutzerItemList.h"
#import "BenutzerSelector.h"

#import "BenutzerDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation BenutzerDocument:MasterDocument
{
	id	bnameField;
	id	vollernameField;
	id	provisionField;
	id	zugriffPopup;
	id	provisionBKField;
}

+ enableButton:aButton
{
	[aButton setEnabled:[[NXApp userMgr] isSuperuser]];
	return self;
}


- itemClass
{ return [BenutzerItem class]; }

- createNewItem
{
	item = [[BenutzerItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[BenutzerItem alloc] initIdentity:identity];
	return self;
}

- initNib
{
	[super initNib];
	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];
	return self;
}
/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	SETREADONLYFIELD(bnameField);

	if (![self isReadOnly]) {
		[vollernameField selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(bnameField);
	SETREADONLYFIELD(vollernameField);
	SETREADONLYFIELD(provisionField);
	SETDISABLED(zugriffPopup);
	SETDISABLED(provisionBKField);
	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,bname,bnameField);
	WRITEINTOCELL(item,vollername,vollernameField);
	WRITEINTOCELL(item,provision,provisionField);
	WRITEINTOCELL(item,zugriff,zugriffPopup);
	[iconListView reload];
	return self;
}

- readFromWindow
{
	READFROMCELL(item,vollername,vollernameField);
	READFROMCELL(item,provision,provisionField);
	READFROMCELL(item,zugriff,zugriffPopup);
	
	return self;
}

- (BOOL)save
{
	if ([super save]) {
		[item grant];
		return YES;
	} else {
		return NO;
	}
}
/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{
	return [anItem isKindOf:[BenutzerItemList class]] && [anItem isSingle]
			 ||	([anItem isKindOf:[FileItem class]]);
}

- pasteItem:anItem
{
	if([anItem isKindOf:[BenutzerItemList class]]) {
		return self;
	} else if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else {
		return nil;
	}
}

- pasteBenutzer:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];

	if(newItem) {
		[self readFromWindow];
		[newItem setUid:[item uid]];
		[newItem setBname:[item bname]];
		[item free];
		item = newItem;
		[newItem setIsNew:NO];
		[self updateWindow];
		[window setDocEdited:YES];
	} else {
		[NXApp beep:"EmptyItem"];
	}
	
	return self;
}

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[BenutzerSelector newInstance] find:sender];
	return self;
}
@end
