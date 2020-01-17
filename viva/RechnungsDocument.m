#import <string.h>
#import <objc/List.h>
#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>
#import <appkit/Text.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#import "ErrorManager.h"
#import "FileItem.h"
#import "IconListView.h"
#import "LayoutManager.h"
#import "MahnungRTFItem.h"
#import "PrintoutDocument.h"
#import "RechnungItem.h"
#import "RechnungsSelector.h"
#import "StringManager.h"
#import "TextParser.h"
#import "TheApp.h"
#import "ZahlungBuchungsController.h"
#import "ZahlungItem.h"

#import "RechnungsDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation RechnungsDocument:MasterDocument
{
	id	browser;
	id	kundennameField;
	id	aufnrField;
	id	datumField;
	id	rechnungsbetragNettoField;
	id	zahlungssummeNettoField;
	id	nochoffenNettoField;
	id	rechnungsbetragSkontoField;
	id	zahlungssummeSkontoField;
	id	nochoffenSkontoField;
	
	id	storniertField;
	
	id	bezahltSwitch;
	id	adactaSwitch;
	id	mahnstufeField;
	id	zahlungDeleteButton;
	id	neueZahlungButton;
	id	neueMahnungButton;
	id	stornierenButton;
}

- itemClass { return [RechnungItem class]; }

- initNib
{
	[super initNib];
	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];
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
	item = [[RechnungItem alloc] initIdentity:identity];
	return self;
}

/* ===== WINDOW I/O METHODS ============================================================== */

- setReadOnly
{
	SETDISABLED(bezahltSwitch);
	SETDISABLED(adactaSwitch);
	SETREADONLYFIELD(mahnstufeField);
	SETDISABLED(zahlungDeleteButton);
	SETDISABLED(neueZahlungButton);
	SETDISABLED(neueMahnungButton);
	SETDISABLED(stornierenButton);
	
	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,kundenname,kundennameField);
	WRITEINTOCELL(item,aufnr,aufnrField);
	WRITEINTOCELL(item,datum,datumField);
	WRITEINTOSWITCH(item,bezahlt,bezahltSwitch);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	WRITEINTOCELL(item,mahnstufe,mahnstufeField);
	[iconListView reload];
	[self writeZahlungenIntoWindow];
	if([[item storniert] isTrue]) {
		[storniertField setStringValue:[[NXApp stringMgr] stringFor:"CANCELLED"]];
		[stornierenButton setEnabled:NO];
		[neueMahnungButton setEnabled:NO];
	} else {
		[storniertField setStringValue:""];
		[stornierenButton setEnabled:![self isReadOnly]];
		[neueMahnungButton setEnabled:![self isReadOnly]];
	}
	return self;
}

- writeZahlungenIntoWindow
{
	WRITEINTOCELL(item,rechnungsbetragNetto,rechnungsbetragNettoField);
	WRITEINTOCELL(item,zahlungssummeNetto,zahlungssummeNettoField);
	WRITEINTOCELL(item,nochoffenNetto,nochoffenNettoField);
	WRITEINTOCELL(item,rechnungsbetragSkonto,rechnungsbetragSkontoField);
	WRITEINTOCELL(item,zahlungssummeSkonto,zahlungssummeSkontoField);
	WRITEINTOCELL(item,nochoffenSkonto,nochoffenSkontoField);
	[zahlungDeleteButton setEnabled:NO];
	[browser loadColumnZero];
	return self;
}

- readFromWindow
{
	READFROMSWITCH(item,bezahlt,bezahltSwitch);
	READFROMSWITCH(item,adacta,adactaSwitch);
	READFROMCELL(item,mahnstufe,mahnstufeField);
	return self;
}

/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{ 
	return	([anItem isKindOf:[FileItem class]]); 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else {
		return nil;
	}
}

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[RechnungsSelector newInstance] find:sender];
	return self;
}

/* ===== NETWORK UPDATE METHODS ========================================================== */

- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,"Kundenkonto")) {
		if([[item kundennr] compareSTR:identitySTR] == 0) {
			[item reloadZahlungen];
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
	[[NXApp printButton] setEnabled:!iamReadOnly];
	[[NXApp destroyButton] setEnabled:NO];
	return self;
}

- print:sender
{
	id			printitem;
	id			newParser;
	id			identity = [String str:"RechnungItem:Attach:"];
	id			supplDescription = [String str:[[NXApp stringMgr] stringFor:"InvoicePrintNr"]];
	id			today = [Date today];
	id			description = [today copyAsString];
	id			data = [[[NXApp layoutMgr] defaultLayoutForRechnung] copy];
	[supplDescription concat:[item nr]];
	[identity concatINT:[[item attachmentList] count]];
		
	newParser = [[TextParser alloc] init];
	[newParser parseString:data withItem:item];

	printitem = [[PrintRTFItem alloc] initIdentity:identity description:description supplDescription:supplDescription data:data];
	
	[item addAttachment:printitem];
	[self save];
	[self updateWindow];
	
	[[[PrintoutDocument alloc]
		initItem:[[[item attachmentList] lastObject] copy]] makeActive:self];
	
	[newParser free];
	[today free];
	[printitem free];
	[identity free];
	[description free];
	[supplDescription free];
	[data free];
	
	return self;
}
- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	return [[item zahlungen] count];
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	zahlung = [[item zahlungen] objectAt:row];
	[cell setColumnCount:3];
	[cell setDistance:0.0];
	[cell setLength:8 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:10 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[cell setLength:10 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:2];
	[[zahlung datum] writeIntoCell:cell inColumn:0];
	[[zahlung betrag] writeIntoCell:cell inColumn:1];
	[[zahlung bemerkung] writeIntoCell:cell inColumn:2];
	[cell setTag:row];
	[cell setLoaded:YES];

	return self;
}

- browserClicked:sender
{
	id	list = [[List alloc] init];
	[[browser matrixInColumn:0] sendAction:@selector(addObject:) to:list forAllCells:NO];
	[zahlungDeleteButton setEnabled:!iamReadOnly && ([list count] == 1)];
	[[list empty] free];
	return self;
}

- browserDoubleClicked:sender
{
	id	list = [[List alloc] init];
	[[browser matrixInColumn:0] sendAction:@selector(addObject:) to:list forAllCells:NO];
	if([list count] == 1) {
		id	zahlung = [[[item zahlungen] objectAt:[[list objectAt:0] tag]] copy];
		[[[ZahlungBuchungsController alloc] initItem:zahlung] makeActive:self];
	}
	[[list empty] free];
	return self;
}

- zahlungDeleteButtonClicked:sender
{
	id	list = [[List alloc] init];
	[[browser matrixInColumn:0] sendAction:@selector(addObject:) to:list forAllCells:NO];
	if([list count] == 1) {
		if([[NXApp errorMgr] showDialog:"DeletePayment" yesButton:"DoDelete" noButton:"CANCEL"] == EHYES_BUTTON) {
			if([[[item zahlungen] objectAt:[[list objectAt:0] tag]] delete]) {
				[NXApp sendChangedClass:"Kundenkonto" identity:[[item kundennr] str]];
			}
		}
	}
	[[list empty] free];
	return self;
}

- neueZahlungButtonClicked:sender
{
	id	zahlung = [[ZahlungItem alloc] initKundennr:[item kundennr] rechnr:[item nr]];
	[[[ZahlungBuchungsController alloc] initItem:zahlung] makeActive:self];
	return self;
}

- neueMahnungButtonClicked:sender
{
	if([[NXApp errorMgr] showDialog:"NewReminder" yesButton:"Remind" noButton:"CANCEL"] == EHYES_BUTTON) {
		id	mahnung;
		
		[[item mahnstufe] setInt:MIN([[item mahnstufe] int]+1,3)];
		mahnung = [MahnungRTFItem neueMahnungForRechnung:item];
		[item addAttachment:mahnung];
		[self save];
		[self updateWindow];
			
		[[[PrintoutDocument alloc]
			initItem:[[[item attachmentList] lastObject] copy]] makeActive:self];
		
		[mahnung free];
		return self;
	}
	return self;
}

- stornierenButtonClicked:sender
{
	if([[NXApp errorMgr] showDialog:"CancelInvoice" yesButton:"DoCancel" noButton:"CANCEL"] == EHYES_BUTTON) {
		[self readFromWindow];
		if([item stornieren]) {
			[self sendChanged:[item identity]];
			[self reloadItem];
			[NXApp sendChangedClass:"AuftragItem" identity:[[item aufnr] str]];
			[NXApp sendChangedClass:"Kundenkonto" identity:[[item kundennr] str]];
		} else {
			[[NXApp errorMgr] showDialog:"ErrorOnInvoiceCancel"];
		}
	}
	return self;
}

@end
