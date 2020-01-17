#import <string.h>
#import <objc/List.h>
#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>
#import <appkit/Text.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#import "ErrorManager.h"
#import "StringManager.h"
#import "TheApp.h"
#import "KundenSelector.h"
#import "ZahlungBuchungsController.h"
#import "ZahlungItem.h"
#import "ZahlungsList.h"

#import "KundenKontoDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation KundenKontoDocument:MasterDocument
{
	id	browser;
	id	kundennameField;
	id	kontostandField;
	id	zahlungDeleteButton;
	id	neueZahlungButton;
	
	id	kundennr;
	id	kundenname;
	id	zahlungen;
	id	identity;
}

- itemClass { return [self class]; }

- initNib
{
	[super initNib];
	[browser setDelegate:self];
	[browser setTarget:self];
	[browser setAction:@selector(browserClicked:)];
	[browser setDoubleAction:@selector(browserDoubleClicked:)];
	[browser setCellClass:[ColumnBrowserCell class]];
	return self;
}

- createNewItem
{
	return [self doesNotRecognize:_cmd];
}

- createIdentityItem:identity
{
	return [self doesNotRecognize:_cmd];
}

- initForKundennr:aKundennr andKundenname:aKundenname
{
	kundennr = [aKundennr copy];
	kundenname = [aKundenname copy];
	zahlungen = [[ZahlungsList alloc] initForKunde:kundennr];
	identity = kundennr;
	return self;
}

/* ===== WINDOW I/O METHODS ============================================================== */

- makeActive:sender
{
	[super makeActive:sender];
	[self setWindowTitle];
	[self writeIntoWindow];
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(kundennameField);
	SETREADONLYFIELD(kontostandField);
	SETDISABLED(zahlungDeleteButton);
	SETDISABLED(neueZahlungButton);
	
	return self;
}

- writeIntoWindow
{
	[kundenname writeIntoCell:kundennameField];
	[self writeZahlungenIntoWindow];
	return self;
}

- writeZahlungenIntoWindow
{
	double aSum = [zahlungen summeDouble];
	[zahlungDeleteButton setEnabled:NO];
	[browser loadColumnZero];
	[kontostandField setDoubleValue:aSum];
	return self;
}

- readFromWindow
{
	return self;
}

- reloadZahlungen
{
	zahlungen = [zahlungen free];
	zahlungen = [[ZahlungsList alloc] initForKunde:kundennr];
	return self;
}	

- setWindowTitle
{
	id	aString = [String str:""];
	[aString concat:identity];
	[aString concatSTR:" Ð "];
	[aString concatSTR:[[NXApp stringMgr] windowTitleFor:[self name]]];
	[window setTitle:[aString str]];
	[aString free];
	
	return self;
}
/* ===== COPY/PASTE METHODS ============================================================== */
- (BOOL)acceptsItem:anItem { return	NO; }
- pasteItem:anItem { return nil; }
- pasteFile:anItem { return nil; }
/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[KundenSelector newInstance] find:sender];
	return self;
}

/* ===== NETWORK UPDATE METHODS ========================================================== */

- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,"Kundenkonto")) {
		if([kundennr compareSTR:identitySTR] == 0) {
			[self reloadZahlungen];
			[self writeZahlungenIntoWindow];
		}
		return self;
	} else {
		return [super changed:classname:identitySTR];
	}
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */

- checkMenus
{
	[super checkMenus];
	[[NXApp printButton] setEnabled:NO];
	return self;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	return [zahlungen count];
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	leer = [String str:""];
	id	zahlung = [zahlungen objectAt:row];
	[cell setColumnCount:5];
	[cell setDistance:8.0];
	[cell setLength:8 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:8 alignment:NX_RIGHTALIGNED andNumeric:YES ofColumn:1];
	[cell setLength:8 alignment:NX_RIGHTALIGNED andNumeric:YES ofColumn:2];
	[cell setLength:10 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:3];
	[cell setLength:50 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:4];
	[[zahlung datum] writeIntoCell:cell inColumn:0];
	if ([[zahlung betrag] double] < 0.0) {
		[[zahlung betrag] writeIntoCell:cell inColumn:1];
		[leer writeIntoCell:cell inColumn:2];
	} else {
		[[zahlung betrag] writeIntoCell:cell inColumn:2];
		[leer writeIntoCell:cell inColumn:1];
	}
	[[zahlung rechnr] writeIntoCell:cell inColumn:3];
	[[zahlung bemerkung] writeIntoCell:cell inColumn:4];
	[cell setTag:row];
	[cell setLoaded:YES];
	[leer free];
	return self;
}

- browserClicked:sender
{
	id	list = [[List alloc] init];
	[[browser matrixInColumn:0] sendAction:@selector(addObject:) to:list forAllCells:NO];
	[zahlungDeleteButton setEnabled:([list count] == 1)];
	[[list empty] free];
	return self;
}

- browserDoubleClicked:sender
{
	id	aCell = [[browser matrixInColumn:0] selectedCell];
	id	zahlung = [[zahlungen objectAt:[aCell tag]] copy];
	[[[ZahlungBuchungsController alloc] initItem:zahlung] makeActive:self];
	return self;
}

- zahlungDeleteButtonClicked:sender
{
	id	aCell = [[browser matrixInColumn:0] selectedCell];
	id	zahlung = [[zahlungen objectAt:[aCell tag]] copy];
	if([[NXApp errorMgr] showDialog:"DeletePayment" yesButton:"DoDelete" noButton:"CANCEL"] == EHYES_BUTTON) {
		if([zahlung delete]) {
			[NXApp sendChangedClass:"Kundenkonto" identity:[kundennr str]];
		}
	}
	return self;
}

- neueZahlungButtonClicked:sender
{
	id	bemerkung = [String str:[[NXApp stringMgr] stringFor:"Credit"]];
	id	zahlung = [[ZahlungItem alloc] initKundennr:kundennr bemerkung:bemerkung];
	[[[ZahlungBuchungsController alloc] initItem:zahlung] makeActive:self];
	[bemerkung free];
	return self;
}

@end
