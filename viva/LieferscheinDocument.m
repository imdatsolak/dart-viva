#import <appkit/NXBrowser.h>
#import <appkit/Matrix.h>
#import <appkit/Text.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#import "AuftragsArtikelItem.h"
#import "AuftragsArtikelList.h"
#import "ErrorManager.h"
#import "FileItem.h"
#import "IconListView.h"
#import "LayoutManager.h"
#import "LieferscheinItem.h"
#import "LieferscheinSelector.h"
#import "PrintRTFItem.h"
#import "PrintoutDocument.h"
#import "SeriennummernItem.h"
#import "SeriennummernList.h"
#import "StringManager.h"
#import "TextParser.h"
#import "LagerVorgangsSelector.h"
#import "TheApp.h"

#import "LieferscheinDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation LieferscheinDocument:MasterDocument
{
	id	postenBrowser;
	id	seriennrBrowser;
	id	kundennameField;
	id	aufnrField;
	id	datumField;
	
	id	postenField;
	id	artikelnrField;
	id	anzahlField;
	id	lagerPopup;
	id	seriennrField;
	
	id	storniertField;
	
	id	adactaSwitch;
	id	seriennrDeleteButton;
	id	seriennrOkButton;
	id	ausbuchenButton;
	id	stornierenButton;
}

- itemClass { return [LieferscheinItem class]; }

- initNib
{
	[super initNib];
	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];
	[postenBrowser setDelegate:self];
	[postenBrowser setTarget:self];
	[postenBrowser setAction:@selector(postenBrowserClicked:)];
	[postenBrowser setCellClass:[ColumnBrowserCell class]];
	[seriennrBrowser setDelegate:self];
	[seriennrBrowser setTarget:self];
	[seriennrBrowser setAction:@selector(seriennrBrowserClicked:)];
	[seriennrBrowser setCellClass:[ColumnBrowserCell class]];
	return self;
}

- createNewItem
{
	return [self doesNotRecognize:_cmd];
}

- createIdentityItem:identity
{
	item = [[LieferscheinItem alloc] initIdentity:identity];
	return self;
}

/* ===== WINDOW I/O METHODS ============================================================== */

- setReadOnly
{
	SETDISABLED(adactaSwitch);
	SETDISABLED(ausbuchenButton);
	SETDISABLED(stornierenButton);
	return self;
}

- writeIntoWindow
{
	[ausbuchenButton setEnabled:![[item geliefert] int] && ![[item storniert] int]];
	[stornierenButton setEnabled:![[item storniert] int]];
	WRITEINTOCELL(item,kundenname,kundennameField);
	WRITEINTOCELL(item,aufnr,aufnrField);
	WRITEINTOCELL(item,datum,datumField);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	[iconListView reload];
	if([[item storniert] isTrue]) {
		[storniertField setStringValue:[[NXApp stringMgr] stringFor:"CANCELLED"]];
	} else if([[item geliefert] isTrue]) {
		[storniertField setStringValue:[[NXApp stringMgr] stringFor:"DELIVERED"]];
	} else {
		[storniertField setStringValue:""];
	}
	[self reloadPostenBrowser];
	return self;
}

- reloadSeriennrBrowser
{
	[window disableFlushWindow];
	[seriennrBrowser loadColumnZero];
	[self seriennrBrowserClicked:self];
	[window reenableFlushWindow];
	[window flushWindow];
	return self;
}

- reloadPostenBrowser
{
	[window disableFlushWindow];
	[postenBrowser loadColumnZero];
	[self postenBrowserClicked:self];
	[window reenableFlushWindow];
	[window display];
	return self;
}

- readFromWindow
{
	READFROMSWITCH(item,adacta,adactaSwitch);
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
	[[LieferscheinSelector newInstance] find:sender];
	return self;
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
	id			identity = [String str:"LieferscheinItem:Attach:"];
	id			supplDescription = [String str:[[NXApp stringMgr] stringFor:"DSPrintNr"]];
	id			today = [Date today];
	id			description = [today copyAsString];
	id			data;
	
	if ([[item geliefert] isTrue]) {
		data = [[[NXApp layoutMgr] defaultLayoutForLieferschein] copy];
	} else {
		data = [[[NXApp layoutMgr] defaultLayoutForPackzettel] copy];
	}
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
	if(sender==postenBrowser) {
		return [[item artikel] count];
	} else {
		if([[postenBrowser matrixInColumn:0] selectedCell] != nil) {
			return [[item seriennummern] countForPositionINT:[[[postenBrowser matrixInColumn:0] selectedCell] tag]];
		} else {
			return 0;
		}
	}
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	if(sender==postenBrowser) {
		return [self postenBrowser:sender loadCell:cell atRow:(int)row inColumn:(int)column];
	} else {
		return [self seriennrBrowser:sender loadCell:cell atRow:(int)row inColumn:(int)column];
	}
}

- postenBrowser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	posten = [[item artikel] objectAt:row];
	[cell setColumnCount:4];
	[cell setDistance:0.0];
	[cell setLength:2 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:15 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[cell setLength:2 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:2];
	[cell setLength:8 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:3];
	[[posten position] writeIntoCell:cell inColumn:0];
	[[posten nr] writeIntoCell:cell inColumn:1];
	[[posten anzahl] writeIntoCell:cell inColumn:2];
	[[posten ausbuchLager] writeIntoCell:cell inColumn:3];
	[cell setTag:row];
	[cell setLoaded:YES];
	return self;
}

- seriennrBrowser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	snr = [[item seriennummern] snrForPositionINT:[[[postenBrowser matrixInColumn:0] selectedCell] tag]];
	[cell setColumnCount:1];
	[cell setDistance:0.0];
	[cell setLength:8 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[[snr seriennrAt:row] writeIntoCell:cell inColumn:0];
	[cell setTag:row];
	[cell setLoaded:YES];

	return self;
}

- postenBrowserClicked:sender
{
	if([[postenBrowser matrixInColumn:0] selectedCell] != nil) {
		id	posten = [[item artikel] objectAt:[[[postenBrowser matrixInColumn:0] selectedCell] tag]];
		[[posten position] writeIntoCell:postenField];
		[[posten nr] writeIntoCell:artikelnrField];
		[[posten anzahl] writeIntoCell:anzahlField];
		[[posten ausbuchLager] writeIntoCell:lagerPopup];
		[lagerPopup setEnabled:YES];
	} else {
		[lagerPopup setEnabled:NO];
	}
	[self reloadSeriennrBrowser];
	return self;
}

- seriennrBrowserClicked:sender
{
	if([[postenBrowser matrixInColumn:0] selectedCell] != nil) {
		int	posten = [[[postenBrowser matrixInColumn:0] selectedCell] tag];
		id	snr = [[item seriennummern] objectAt:posten];
		id	anzahl = [[[item artikel] objectAt:posten] anzahl];
		if([[seriennrBrowser matrixInColumn:0] selectedCell] != nil) {
			int	position = [[[seriennrBrowser matrixInColumn:0] selectedCell] tag];
			[[snr seriennrAt:position] writeIntoCell:seriennrField];
			[seriennrDeleteButton setEnabled:YES];
		} else {
			[seriennrField setStringValue:""];
			[seriennrDeleteButton setEnabled:NO];
		}
		if([anzahl int] > [snr count]) {
			[seriennrOkButton setEnabled:YES];
			[[[[seriennrField setStringValue:""] setEditable:YES] setBackgroundGray:NX_WHITE] selectText:self];
		} else {
			[seriennrOkButton setEnabled:NO];
			[[[seriennrField setEditable:NO] setSelectable:YES] setBackgroundGray:NX_LTGRAY];
		}
	} else {
		[seriennrDeleteButton setEnabled:NO];
		[seriennrOkButton setEnabled:NO];
		[[[seriennrField setStringValue:""] setEditable:NO] setBackgroundGray:NX_LTGRAY];
	}
	return self;
}

- seriennrDeleteButtonClicked:sender
{
	if([[postenBrowser matrixInColumn:0] selectedCell] != nil) {
		int	posten = [[[postenBrowser matrixInColumn:0] selectedCell] tag];
		if([[seriennrBrowser matrixInColumn:0] selectedCell] != nil) {
			int	position = [[[seriennrBrowser matrixInColumn:0] selectedCell] tag];
			[[[item seriennummern] objectAt:posten] removeSeriennrAt:position];
			[self reloadSeriennrBrowser];
		}
	}
	return self;
}

- seriennrOkButtonClicked:sender
{
	id	snr = [item seriennummern];
	id	newNr = [[String str:""] readFromCell:seriennrField];
	id	position = [Integer int:[[[postenBrowser matrixInColumn:0] selectedCell] tag]];
	[snr addNr:newNr forPosition:position];
	[position free];
	[newNr free];
	[snr sort];
	[self reloadSeriennrBrowser];
	return self;
}

- controlDidChange:sender
{
	if(sender == lagerPopup) {
		if([[postenBrowser matrixInColumn:0] selectedCell] != nil) {
			int	posten = [[[postenBrowser matrixInColumn:0] selectedCell] tag];
			[[[[item artikel] objectAt:posten] ausbuchLager] readFromCell:lagerPopup];
			[[[postenBrowser matrixInColumn:0] cellAt:posten:0] setLoaded:NO];
			[postenBrowser displayColumn:0];
		}
	}
	[super controlDidChange:sender];
	return self;
}

- buchenButtonClicked:sender
{
	id	nichtvorhandenString = [String str:""];
	[self readFromWindow];
	if([item ausbuchen:nichtvorhandenString]) {
		[self updateWindow];
		[NXApp sendChangedClass:"LagerItem" identity:"*"];
		[self sendChanged:[item identity]];
		[NXApp sendChangedClass:[[LagerVorgangsSelector class] name] identity:"*"];
	} else {
		if([nichtvorhandenString length] == 0) {
			[NXApp beep:"FEHLER BEIM AUSBUCHEN"];
		} else {
			[[NXApp errorMgr] showDialog:"ArticleNotIntStore"
							  explain:"ArticleNotIntStore_EXP"
							  explainParam:[nichtvorhandenString str]];
		}
	}
	[nichtvorhandenString free];
	return self;
}

- stornierenButtonClicked:sender
{
	BOOL	zurueckgebucht = NO;
	BOOL	storniert = NO;
	BOOL	canceled = NO;
	[self readFromWindow];
	if([[item geliefert] isTrue]) {
		int	button = [[NXApp errorMgr] showDialog:"CancelDSWithOutbooked"
									   yesButton:"CANCEL"
									   noButton:"OriginalStore"
									   altButton:"DefaultStore"
									   explain:"CancelDS_EXP"];
		switch(button) {
			case EHNO_BUTTON:
				zurueckgebucht = storniert = [item stornierenMitOriginalLager];
				break;
			case EHALT_BUTTON:
				zurueckgebucht = storniert = [item stornierenMitDefaultLager];
				break;
			case EHYES_BUTTON:
			default:
				canceled = YES;
				break;
		}
	} else {
		if([[NXApp errorMgr] showDialog:"CancelDS" yesButton:"DoCancel" noButton:"CANCEL"] == EHYES_BUTTON) {
			storniert = [item stornieren];
		} else {
			canceled = YES;
		}
	}
	if(!canceled) {
		if(storniert) {
			[self sendChanged:[item identity]];
			[self reloadItem];
			[NXApp sendChangedClass:"AuftragItem" identity:[[item aufnr] str]];
			if(zurueckgebucht) {
				[NXApp sendChangedClass:"LagerItem" identity:"*"];
			}
		} else {
			[NXApp beep:"FEHLER BEIM STORNIEREN"];
		}
	}

	return self;
}

- moveSelectionBy:(int)count
{
	int	selectedRow=0;
	id	matrix = [postenBrowser matrixInColumn:0];
	selectedRow = [matrix selectedRow] + count;
	if (selectedRow < 0) {
		selectedRow = 0;
	} else if(selectedRow >= [[matrix cellList] count]) {
		selectedRow = [[matrix cellList] count]-1;
	}
	[matrix selectCellAt:selectedRow :0];
	[matrix scrollCellToVisible:selectedRow :0];
	[self postenBrowserClicked:self];
	return self;
}

@end
