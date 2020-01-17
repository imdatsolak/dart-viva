#import <appkit/TextField.h>
#import <appkit/Window.h>

#import "dart/Localizer.h"
#import "dart/fieldvaluekit.h"

#import "ErrorManager.h"
#import "MasterDocument.h"
#import "StringManager.h"
#import "TheApp.h"
#import "RechnungItemList.h"
#import "ZahlungItem.h"

#import "ZahlungBuchungsController.h"

#pragma .h #import "MasterObject.h"

@implementation ZahlungBuchungsController:MasterObject
{
	id	kundennrField;
	id	rechnrField;
	id	datumField;
	id	betragField;
	id	bemerkungField;
	
	id	okButton;
	id	cancelButton;
	
	id	item;
}

- (BOOL)isReadOnly { return NO; }
- init
{
	[super init];
	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	[window setDelegate:self];
	[[NXApp registerDocument:self] setActiveDocument:self];
	return self;
}

- initItem:anItem
{
	id	aTitle;
	[self init];
	item = anItem;
	aTitle = [String str:[[anItem kundennr] str]];
	[aTitle concatSTR:" Ð "];
	[aTitle concatSTR:[[NXApp stringMgr] windowTitleFor:[self name]]];
	[window setTitle:[aTitle str]];
	[self writeIntoWindow];
	[betragField selectText:self];
	[aTitle free];
	return self;
}

- free
{
	[window orderOut:self];
	[NXApp unregisterDocument:self];
	return [super free];
}


/* ===== WINDOW I/O METHODS ============================================================== */
- writeIntoWindow
{
	WRITEINTOCELL(item,kundennr,kundennrField);
	WRITEINTOCELL(item,rechnr,rechnrField);
	WRITEINTOCELL(item,datum,datumField);
	WRITEINTOCELL(item,betrag,betragField);
	WRITEINTOCELL(item,bemerkung,bemerkungField);
	return self;
}

- readFromWindow
{
	READFROMCELL(item,kundennr,kundennrField);
	READFROMCELL(item,rechnr,rechnrField);
	READFROMCELL(item,datum,datumField);
	READFROMCELL(item,betrag,betragField);
	READFROMCELL(item,bemerkung,bemerkungField);
	return self;
}

/* ===== WINDOW DELEGATE METHODS ============================================================== */

- windowWillClose:sender
{
	if (![[NXApp errorMgr] discardChanges:window]) {
		return nil;
	}
	[window setDelegate:nil];
	[self free];
	return (id )YES;
}

/* ===== DOCUMENT SPECIFIC METHODS ============================================================ */

- okButtonClicked:sender
{
	[self readFromWindow];
	[item save];
	[window setDelegate:nil];
	[NXApp sendChangedClass:"Kundenkonto" identity:[[item kundennr] str]];
	return [self free];
}

- cancelButtonClicked:sender
{
	[window setDelegate:nil];
	return [self free];
}

- (BOOL)acceptsItem:anItem
{
	return [anItem isKindOf:[RechnungItemList class]] && [anItem isSingle];
}

- pasteItem:anItem
{
	if ([anItem isKindOf:[RechnungItemList class]] && [anItem isSingle]) {
		[self readFromWindow];
		[item setRechnr:[anItem objectAt:0]];
		[self writeIntoWindow];
		return self;
	} else {
		return nil;
	}
}
	

@end
