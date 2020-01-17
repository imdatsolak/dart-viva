#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>
#import <appkit/ScrollView.h>
#import <appkit/Text.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#import "ErrorManager.h"
#import "KonditionenItem.h"
#import "KonditionenItemList.h"
#import "KonditionenSelector.h"
#import "StringManager.h"
#import "SubkonditionenItem.h"
#import "SubkonditionenList.h"
#import "TableManager.h"
#import "TheApp.h"

#import "KonditionenDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation KonditionenDocument:MasterDocument
{
	id	browser;
	id	nrField;
	id	kondnameField;
	id	bemerkungText;
	id	adactaSwitch;
	
	id	deleteButton;
	id	newButton;
	
	id	upperGroupView;
	id	lowerGroupView;
	
	id	kdkategoriePopup;
	id	gueltigvonField;
	id	gueltigbisField;
	id	proauftragRadio;
	id	istsummeRadio;
	id	istsonderpreisRadio;
	id	mengeField;
	id	summeField;
	id	rabattField;
	id	sonderpreisField;
	
	id	panelCancelButton;
	id	panelOkButton;
	
	id	panel;
	
	id	editSubkondition;
}

- itemClass { return [KonditionenItem class]; }

- initNib
{
	[super initNib];
	[browser setDelegate:self];
	[browser setTarget:self];
	[browser setAction:@selector(browserClicked:)];
	[browser setDoubleAction:@selector(browserDoubleClicked:)];
	[browser setCellClass:[ColumnBrowserCell class]];
	bemerkungText = [[bemerkungText docView] setDelegate:self];
	[upperGroupView removeFromSuperview];
	[lowerGroupView removeFromSuperview];
	[splitView addSubview:upperGroupView];
	[splitView addSubview:lowerGroupView];
	[splitView setDelegate:self];
	gnubbleMinY = 177;
	return self;
}

- createNewItem
{
	item = [[KonditionenItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[KonditionenItem alloc] initIdentity:identity];
	return self;
}

/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	SETREADONLYFIELD(nrField);
	if (![self isReadOnly]) {
		[kondnameField selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(nrField);
	SETREADONLYFIELD(kondnameField);
	SETREADONLYFIELD(bemerkungText);
	SETDISABLED(adactaSwitch);
	SETDISABLED(deleteButton);
	SETDISABLED(newButton);
	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,nr,nrField);
	WRITEINTOCELL(item,kondname,kondnameField);
	WRITEINTOTEXT(item,bemerkung,bemerkungText);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	[self reloadBrowser];
	return self;
}

- reloadBrowser
{
	[browser loadColumnZero];
	[self browserClicked:self];
	return self;
}

- readFromWindow
{
	READFROMCELL(item,nr,nrField);
	READFROMCELL(item,kondname,kondnameField);
	READFROMTEXT(item,bemerkung,bemerkungText);
	READFROMSWITCH(item,adacta,adactaSwitch);
	return self;
}

/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{ 
	return [anItem isKindOf:[KonditionenItemList class]] && [anItem isSingle]; 
}

- pasteItem:anItem
{
	if ([anItem isKindOf:[KonditionenItemList class]] && [anItem isSingle]) {
		return [self pasteKonditionen:anItem];
	} else {
		return nil;
	}
}

- pasteKonditionen:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[self readFromWindow];
		[newItem setNr:[item nr]];
		[newItem setKondname:[item kondname]];
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
	[[KonditionenSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	return [[item subkonditionen] count];
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	kond = [[item subkonditionen] objectAt:row];
	[cell setColumnCount:8];
	[cell setDistance:8.0];
	[cell setLength:10 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:1 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[cell setLength:7 alignment:NX_RIGHTALIGNED andNumeric:NO ofColumn:2];
	[cell setLength:2 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:3];
	[cell setLength:6 alignment:NX_RIGHTALIGNED andNumeric:NO ofColumn:4];
	[cell setLength:2 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:5];
	[cell setLength:6 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:6];
	[cell setLength:6 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:7];
	[[[NXApp popupMgr] valueFor:[[kond kdkategorie] int] inTable:"kundenkategorien"]
		writeIntoCell:cell inColumn:0];
	[[kond gueltigvon] writeIntoCell:cell inColumn:6];
	[[kond gueltigbis] writeIntoCell:cell inColumn:7];
	if([[kond proauftrag] isTrue]) {
		[cell setStringValue:[[NXApp stringMgr] stringFor:"PerOrderLetter"] ofColumn:1];
	} else {
		[cell setStringValue:[[NXApp stringMgr] stringFor:"TotalOrders"] ofColumn:1];
	}
	if([[kond istsumme] isTrue]) {
		[[kond summe] writeIntoCell:cell inColumn:2];
		[cell setStringValue:[[NXApp stringMgr] stringFor:"MoneyUnit"] ofColumn:3];
	} else {
		[[kond menge] writeIntoCell:cell inColumn:2];
		[cell setStringValue:[[NXApp stringMgr] stringFor:"QuantityUnit"] ofColumn:3];
	}
	if([[kond istsonderpreis] isTrue]) {
		[[kond sonderpreis] writeIntoCell:cell inColumn:4];
		[cell setStringValue:[[NXApp stringMgr] stringFor:"MoneyUnit"] ofColumn:5];
	} else {
		[[kond rabatt] writeIntoCell:cell inColumn:4];
		[cell setStringValue:"%" ofColumn:5];
	}
	[cell setTag:row];
	[cell setLoaded:YES];
	return self;
}

- browserClicked:sender
{
	id	list = [[List alloc] init];
	[[browser matrixInColumn:0] sendAction:@selector(addObject:) to:list forAllCells:NO];
	[deleteButton setEnabled:([list count] == 1)];
	[[list empty] free];
	return self;
}

- browserDoubleClicked:sender
{
	if([[browser matrixInColumn:0] selectedCell]) {
		int	i = [[[browser matrixInColumn:0] selectedCell] tag];
		editSubkondition = [[[item subkonditionen] objectAt:i] copy];
		if([self editKondition]) {
			[item removeSubkonditionAt:i];
			[item addSubkondition:editSubkondition];
			[self perform:@selector(reloadBrowser) with:self afterDelay:1 cancelPrevious:YES];
		}
		editSubkondition = [editSubkondition free];
	}
	return self;
}

- deleteButtonClicked:sender
{
	if([[browser matrixInColumn:0] selectedCell]) {
		if([[NXApp errorMgr] showDialog:"DeleteSubCondition" yesButton:"DoDelete" noButton:"CANCEL"] == EHYES_BUTTON) {
			int	i = [[[browser matrixInColumn:0] selectedCell] tag];
			[item removeSubkonditionAt:i];
			[self reloadBrowser];
		}
	}
	return self;
}

- newButtonClicked:sender
{
	editSubkondition = [[SubkonditionenItem alloc] initNew];
	if([self editKondition]) {
		[item addSubkondition:editSubkondition];
		[self reloadBrowser];
	}
	editSubkondition = [editSubkondition free];
	return self;
}

- (BOOL)editKondition
{
	WRITEINTOCELL(editSubkondition,kdkategorie,kdkategoriePopup);
	WRITEINTOCELL(editSubkondition,gueltigvon,gueltigvonField);
	WRITEINTOCELL(editSubkondition,gueltigbis,gueltigbisField);
	WRITEINTORADIO(editSubkondition,proauftrag,proauftragRadio);
	WRITEINTORADIO(editSubkondition,istsumme,istsummeRadio);
	WRITEINTORADIO(editSubkondition,istsonderpreis,istsonderpreisRadio);
	WRITEINTOCELL(editSubkondition,summe,summeField);
	WRITEINTOCELL(editSubkondition,menge,mengeField);
	WRITEINTOCELL(editSubkondition,rabatt,rabattField);
	WRITEINTOCELL(editSubkondition,sonderpreis,sonderpreisField);
	[self setEditableStateInPanel];
	
	if(NX_RUNSTOPPED == [NXApp runModalFor:panel]) {
		READFROMCELL(editSubkondition,kdkategorie,kdkategoriePopup);
		READFROMCELL(editSubkondition,gueltigvon,gueltigvonField);
		READFROMCELL(editSubkondition,gueltigbis,gueltigbisField);
		READFROMRADIO(editSubkondition,proauftrag,proauftragRadio);
		READFROMRADIO(editSubkondition,istsumme,istsummeRadio);
		READFROMRADIO(editSubkondition,istsonderpreis,istsonderpreisRadio);
		READFROMCELL(editSubkondition,summe,summeField);
		READFROMCELL(editSubkondition,menge,mengeField);
		READFROMCELL(editSubkondition,rabatt,rabattField);
		READFROMCELL(editSubkondition,sonderpreis,sonderpreisField);
		[window setDocEdited:YES];
		[panel orderOut:self];
		return YES;
	} else {
		[panel orderOut:self];
		return NO;
	}
}

- proauftragRadioClicked:sender
{
	READFROMRADIO(editSubkondition,proauftrag,proauftragRadio);
	if([[editSubkondition proauftrag] isTrue]) {
		[[editSubkondition istsumme] setFalse];
	}
	[self setEditableStateInPanel];
	return self;
}

- istsummeRadioClicked:sender
{
	READFROMRADIO(editSubkondition,istsumme,istsummeRadio);
	if([[editSubkondition istsumme] isTrue]) {
		[[editSubkondition proauftrag] setFalse];
	}
	[self setEditableStateInPanel];
	return self;
}

- istsonderpreisRadio:sender
{
	READFROMRADIO(editSubkondition,istsonderpreis,istsonderpreisRadio);
	[self setEditableStateInPanel];
	return self;
}

- setEditableStateInPanel
{
	id	field1;
	id	field2;
	
	WRITEINTORADIO(editSubkondition,istsumme,istsummeRadio);
	WRITEINTORADIO(editSubkondition,proauftrag,proauftragRadio);
	
	if([[editSubkondition istsumme] isTrue]) {
		field1 = summeField;
		field2 = mengeField;
	} else {
		field1 = mengeField;
		field2 = summeField;
	}
	
	[[[field1 setEditable:YES] setBackgroundGray:NX_WHITE] setTextGray:NX_BLACK];
	[[[field2 setEditable:NO] setBackgroundGray:NX_LTGRAY] setTextGray:NX_LTGRAY];
	[field1 selectText:self];
	
	if([[editSubkondition istsonderpreis] isTrue]) {
		field1 = sonderpreisField;
		field2 = rabattField;
	} else {
		field1 = rabattField;
		field2 = sonderpreisField;
	}
	
	[[[field1 setEditable:YES] setBackgroundGray:NX_WHITE] setTextGray:NX_BLACK];
	[[[field2 setEditable:NO] setBackgroundGray:NX_LTGRAY] setTextGray:NX_LTGRAY];
	
	return self;
}

- panelOkButtonClicked:sender
{
	[NXApp stopModal];
	return self;
}

- panelCancelButtonClicked:sender
{
	[NXApp abortModal];
	return self;
}

@end
