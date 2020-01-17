#import <appkit/TextField.h>

#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "BankItem.h"
#import "BankItemList.h"
#import "BankenSelector.h"

#import "BankenDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation BankenDocument:MasterDocument
{
	id	blzField;
	id	kurzBezeichnungField;
	id	bezeichnungField;
}


- itemClass
{ return [BankItem class]; }

- createNewItem
{
	item = [[BankItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[BankItem alloc] initIdentity:identity];
	return self;
}

/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	[[blzField setEditable:NO] setBackgroundGray:NX_LTGRAY];
	if (![self isReadOnly]) {
		[kurzBezeichnungField selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(blzField);
	SETREADONLYFIELD(kurzBezeichnungField);
	SETREADONLYFIELD(bezeichnungField);

	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,blz,blzField);
	WRITEINTOCELL(item,kurzBezeichnung,kurzBezeichnungField);
	WRITEINTOCELL(item,bezeichnung,bezeichnungField);
	return self;
}

- readFromWindow
{
	READFROMCELL(item,blz,blzField);
	READFROMCELL(item,kurzBezeichnung,kurzBezeichnungField);
	READFROMCELL(item,bezeichnung,bezeichnungField);
	
	return self;
}

/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{
	return [anItem isKindOf:[BankItemList class]] && [anItem isSingle];
}

- pasteItem:anItem
{
	if([anItem isKindOf:[BankItemList class]]) {
		return self;
	} else {
		return nil;
	}
}

- pasteBank:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];

	if(newItem) {
		[self readFromWindow];
		[newItem setBlz:[item blz]];
		[item free];
		item = newItem;
		[newItem setIsNew:iamNew];
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
	[[BankenSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */

@end
