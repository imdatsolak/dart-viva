#import <appkit/NXCursor.h>
#import <appkit/NXBrowser.h>
#import <appkit/Matrix.h>
#import <appkit/TextField.h>
#import <appkit/Text.h>
#import <appkit/Button.h>
#import "dart/PaletteView.h"
#import "dart/fieldvaluekit.h"
#import "dart/Query.h"
#import "dart/QueryString.h"
#import "dart/ColumnBrowserCell.h"
#import "dart/Localizer.h"

#import "TheApp.h"
#import "StringManager.h"
#import "ImageManager.h"
#import "ErrorManager.h"
#import "UserManager.h"
#import "Timer.h"
#import "LagerDocument.h"
#import "LagerItemList.h"
#import "LagerVorgangsSelector.h"
#import "LagerItem.h"
#import "ArtikelItemList.h"
#import "ArtikelItem.h"
#import "LagerChecker.h"

#import "LagerUmbuchController.h"

#pragma .h #import "MasterObject.h"

@implementation LagerUmbuchController:MasterObject
{
	id	fromBrowser;
	id	fromLagerField;
	id	fromArtikelNrField;
	id	fromArtikelNameField;
	id	fromArtikelAnzahlField;
	id	fromOkButton;
	id	fromDeleteButton;

	id	toBrowser;
	id	toLagerField;
	id	toArtikelNrField;
	id	toArtikelNameField;
	id	toArtikelAnzahlField;
	id	toOkButton;
	id	toDeleteButton;
	
	id	fromList;
	id	toList;
	
	id	fromLager;
	id	toLager;
	
	id	umbuchButton;
	
	id	fillingList;
}


- init
{
	if ([[NXApp userMgr] canChange:[[LagerDocument class] name]]) {
	//	NXRect	aFrame;
	
		[super init];
		[[NXApp localizer] loadLocalNib:[self name] owner:self];
		[[NXApp imageMgr] iconFor:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
		[window setMiniwindowIcon:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
		[window setDelegate:self];
	
	//	[[window contentView] getFrame:&aFrame];
	//	maxSize.width = aFrame.size.width;
	//	minSize.width = minSize.height = 300.0;
	//	maxSize.height = 832;
	//	[NXApp getNewCoordForFrame:&aFrame];
	//	[aWindow moveTo:aFrame.origin.x :aFrame.origin.y];
		
		[[NXApp registerDocument:self] setActiveDocument:self];
		fromList = [[List alloc] initCount:0];
		toList = [[List alloc] initCount:0];
	
		[fromBrowser setTarget:self];
		[fromBrowser setDelegate:self];
		[fromBrowser setAction:@selector(browserClicked:)];
		[fromBrowser setCellClass:[ColumnBrowserCell class]];
		[fromBrowser acceptArrowKeys:YES];
		[fromBrowser allowBranchSel:NO];
	
		[toBrowser setTarget:self];
		[toBrowser setDelegate:self];
		[toBrowser setAction:@selector(browserClicked:)];
		[toBrowser setCellClass:[ColumnBrowserCell class]];
		[toBrowser acceptArrowKeys:YES];
		[toBrowser allowBranchSel:NO];
		fromLager = nil;
		toLager = nil;
		[self setWindowTitle];
		return self;
	} else {
		return nil;
	}
}

- free
{
	[fromList makeObjectsPerform:@selector(freeObjects)];
	[toList makeObjectsPerform:@selector(freeObjects)];
	[[fromList freeObjects] free];
	[[toList freeObjects] free];
	[window orderOut:self];
	[NXApp unregisterDocument:self];
	return [super free];
}

/* ===== REMOTE CONTROL METHODS =============================================================== */

- setSourceLager:srcLagerList destinationLager:destLagerList andArtikel:listOfArtikel
{
	[window disableFlushWindow];
	fillingList = fromList;
	[self pasteLager:srcLagerList];
	[self pasteArtikel:listOfArtikel];
	fillingList = toList;
	[self pasteLager:destLagerList];
	[self pasteArtikel:listOfArtikel];
	[window reenableFlushWindow];
	[window flushWindow];
	return self;
}

/* ===== WINDOW I/O METHODS ============================================================== */
- setWindowTitle
{
	id	aString = [String str:""];
	
	if ((fromLager == nil) && (toLager == nil)) {
		[aString concatSTR:[[NXApp stringMgr] stringFor:"NoStoreSelected"]];
	} else {
		if (fromLager) {
			[aString concat:[fromLager lname]];
		} else {
			[aString concatSTR:[[NXApp stringMgr] stringFor:"NoStoreSelected"]];
		}
		[aString concatSTR:" -> "];
		if (toLager) {
			[aString concat:[toLager lname]];
		} else {
			[aString concatSTR:[[NXApp stringMgr] stringFor:"NoStoreSelected"]];
		}
	}
	
	[aString concatSTR:" Ð "];
	[aString concatSTR:[[NXApp stringMgr] windowTitleFor:[self name]]];
	
	[window setTitle:[aString str]];
	[aString free];
	
	return self;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	if (sender == fromBrowser) {
		fillingList = fromList;
	} else {
		fillingList = toList;
	}
	return [fillingList count];
}


- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	[self loadCell:cell atRow:row];
	return self;
}

- loadCell:cell atRow:(int)row
{	
	id	currRow = [fillingList objectAt:row];
	[cell setTag:row];
	[cell setColumnCount:3];
	[cell setLength:9 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:13 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[cell setLength:5 alignment:NX_RIGHTALIGNED andNumeric:YES ofColumn:2];
	[[currRow objectAt:0] writeIntoCell:cell inColumn:0];
	[[currRow objectAt:1] writeIntoCell:cell inColumn:1];
	[[currRow objectAt:2] writeIntoCell:cell inColumn:2];
	[cell setLoaded:YES];
	return self;
}

- browserClicked:sender
{
	id	theRow;
	int	rowNum = [[[sender matrixInColumn:0] selectedCell] tag];
	if (sender == fromBrowser) {
		if ([[sender matrixInColumn:0] selectedRow] >= 0) {
			theRow = [fromList objectAt:rowNum];
			[[theRow objectAt:0] writeIntoCell:fromArtikelNrField];
			[[theRow objectAt:1] writeIntoCell:fromArtikelNameField];
			[[theRow objectAt:2] writeIntoCell:fromArtikelAnzahlField];
			[fromArtikelAnzahlField selectText:self];
		} else {
			[fromArtikelNrField setStringValue:""];
			[fromArtikelNameField setStringValue:""];
			[fromArtikelAnzahlField setStringValue:""];
		}
	} else {
		if ([[sender matrixInColumn:0] selectedRow] >= 0) {
			theRow = [toList objectAt:rowNum];
			[[theRow objectAt:0] writeIntoCell:toArtikelNrField];
			[[theRow objectAt:1] writeIntoCell:toArtikelNameField];
			[[theRow objectAt:2] writeIntoCell:toArtikelAnzahlField];
			[toArtikelAnzahlField selectText:self];
		} else {
			[toArtikelNrField setStringValue:""];
			[toArtikelNameField setStringValue:""];
			[toArtikelAnzahlField setStringValue:""];
		}
	}
	[self checkButtons];
	return self;
}

- deleteButtonClicked:sender
{
	int	rowNum;
	id	theRow;
	id	matrix;
	if (sender == fromDeleteButton) {
		matrix = [fromBrowser matrixInColumn:0];
	} else {
		matrix = [toBrowser matrixInColumn:0];
	}
	if ([matrix selectedRow]>=0) {
		rowNum = [[matrix selectedCell] tag];
		if (sender == fromDeleteButton) {
			theRow = [fromList objectAt:rowNum];
			[fromList removeObject:theRow];
			[[theRow freeObjects] free];
			[fromBrowser loadColumnZero];
		} else {
			theRow = [toList objectAt:rowNum];
			[toList removeObject:theRow];
			[[theRow freeObjects] free];
			[toBrowser loadColumnZero];
		}
	}
	[self checkButtons];
	return self;
}

- okButtonClicked:sender
{
	int	rowNum;
	id	theRow;
	id	matrix;
	int	selectedRow;
	
	if (sender == fromOkButton) {
		matrix = [fromBrowser matrixInColumn:0];
	} else {
		matrix = [toBrowser matrixInColumn:0];
	}
	selectedRow = [matrix selectedRow];
	
	if (selectedRow >= 0) {
		rowNum = [[matrix selectedCell] tag];
		if (sender == fromOkButton) {
			theRow = [fromList objectAt:rowNum];
			[[theRow objectAt:2] setInt:[fromArtikelAnzahlField intValue]];
			[fromArtikelAnzahlField selectText:self];
		} else {
			theRow = [toList objectAt:rowNum];
			[[theRow objectAt:2] setInt:[toArtikelAnzahlField intValue]];
			[toArtikelAnzahlField selectText:self];
		}
		[[theRow objectAt:2] writeIntoCell:[matrix selectedCell] inColumn:2];
		
		if (selectedRow == [matrix cellCount]-1) {
			[matrix selectCellAt:0 :0];
		} else {
			[matrix selectCellAt:selectedRow+1 :0];
		}
		[matrix display];
	}
	return self;
}


- doUmbuch
{
	int		i, count;
	double	percentage = 100.0 / count;
	id		theTimer;
	id		theComment;
	char	buff[10000];
	
	theTimer = [[Timer alloc] initTitle:[[NXApp stringMgr] stringFor:"MovingArticles"]];
	percentage = 100.0 / ([fromList count] + [toList count]);
	[theTimer showTimer:self];
	count = [fromList count];

	sprintf(buff,[[NXApp stringMgr] stringFor:"Outputted"], [[toLager lname] str], [[toLager nr] str]);
	theComment = [String str:buff];
	[[NXApp defaultQuery] beginTransaction];
	for (i=0;i<count;i++) {
			BOOL ok = [LagerChecker subtractFromLager:[fromLager nr] 
									theArticle:[[fromList objectAt:i] objectAt:0]
									numPieces:[[fromList objectAt:i] objectAt:2]];
			ok = ok && [LagerChecker addToLagervorgang:[fromLager nr] 
									theArticle:[[fromList objectAt:i] objectAt:0] 
									numPieces:[[fromList objectAt:i] objectAt:2]
									comment:theComment
									userno:[[NXApp userMgr] currentUserID]];
		if (ok) {
			[theTimer updateTimer:percentage];
		} else {
			[[NXApp errorMgr] showDialog:"ErrorOnOutgoing"];
			[[NXApp defaultQuery] rollbackTransaction];
			return nil;
		}
	}
	[theComment free];
	
	sprintf(buff,[[NXApp stringMgr] stringFor:"Inputted"], [[fromLager lname] str], [[fromLager nr] str]);
	theComment = [String str:buff];
	count = [toList count];
	for (i=0;i<count;i++) {
			BOOL ok = [LagerChecker insertArtikel:[[toList objectAt:i] objectAt:0] intoLager:[toLager nr]];
			if (ok) {
				ok = [LagerChecker addToLager:[toLager nr] 
						theArticle:[[toList objectAt:i] objectAt:0]
						numPieces:[[toList objectAt:i] objectAt:2]];
			}
			if (ok) {
				ok = [LagerChecker addToLagervorgang:[toLager nr] 
									theArticle:[[toList objectAt:i] objectAt:0] 
									numPieces:[[toList objectAt:i] objectAt:2]
									comment:theComment
									userno:[[NXApp userMgr] currentUserID]];
			}
		if (ok) {
			[theTimer updateTimer:percentage];
		} else {
			[[NXApp errorMgr] showDialog:"ErrorOnIncoming"];
			[[NXApp defaultQuery] rollbackTransaction];
			return nil;
		}
	}
	[[NXApp defaultQuery] commitTransaction];

	[theComment free];
	[theTimer free];
	return self;
}

- (BOOL)save
{
	[umbuchButton performClick:self];
	return YES;
}

- umbuchButtonClicked:sender
{
	if ([[NXApp errorMgr] showDialog:"FinishedUmbuchen" yesButton:"YES" noButton:"NO"] == EHYES_BUTTON) {
		int		i, count = [fromList count];
		BOOL	anyWrongArticles = NO;
		id		param = [String str:""];
		double	percentage = 100.0 / count;
		id		theTimer = [[Timer alloc] initTitle:[[NXApp stringMgr] stringFor:"CheckingArticles"]];
	
		[theTimer showTimer:self];
		for (i=0;i<count;i++) {
			id	artnr = [[fromList objectAt:i] objectAt:0];
			id	lagernr = [fromLager nr];
			id	aCount = [[fromList objectAt:i] objectAt:2];
			if ([LagerChecker checkArtikel:artnr inLager:lagernr forCount:aCount] == -1) {
				anyWrongArticles = YES;
				[param concat:artnr];
				[param concatSTR:"\n"];
			}
			[theTimer updateTimer:percentage];
		}
		[theTimer free];
		if (anyWrongArticles) {
			[[NXApp errorMgr] showDialog:"MissingCounts" explain:"MissingCountsEXP" explainParam:[param str]];
		} else if ([self doUmbuch]) {
			[NXApp sendChangedClass:[[LagerItem class] name] identity:[[fromLager nr] str]];
			[NXApp sendChangedClass:[[LagerItem class] name] identity:[[toLager nr] str]];
			[NXApp sendChangedClass:[[LagerVorgangsSelector class] name] identity:"*"];
			[window setDocEdited:NO];
			[[NXApp errorMgr] showDialog:"UmbuchingComplete"];
			[window performClose:self];
			return nil;
		}			
		[param free];
	}
	return self;
}

- checkButtons
{
	[umbuchButton setEnabled:((fromLager != nil) && (toLager != nil) && 
							 ([fromList count]>0) && ([toList count] > 0))];
	[fromOkButton setEnabled:([[fromBrowser matrixInColumn:0] selectedRow] >= 0)];
	[fromDeleteButton setEnabled:([[fromBrowser matrixInColumn:0] selectedRow] >= 0)];
	[toOkButton setEnabled:([[toBrowser matrixInColumn:0] selectedRow] >= 0)];
	[toDeleteButton setEnabled:([[toBrowser matrixInColumn:0] selectedRow] >= 0)];
	return self;
}
/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{ 
	return [anItem isKindOf:[ArtikelItemList class]] ||
			([anItem isKindOf:[LagerItemList class]] && [anItem isSingle]); 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[ArtikelItemList class]]) {
		[self perform:@selector(pasteArtikel:) with:anItem afterDelay:1 cancelPrevious:NO];
	} else if ([anItem isKindOf:[LagerItemList class]] && [anItem isSingle]){
		[self perform:@selector(pasteLager:) with:anItem afterDelay:1 cancelPrevious:NO];
	} else {
		return nil;
	}
	return self;
}

- pasteLager:anItem
{
	id	theLager = [anItem copyLoadedFirstObject];
	if (fillingList == fromList) {
		fromLager = theLager;
		[[fromLager lname] writeIntoCell:fromLagerField];
	} else {
		toLager = theLager;
		[[toLager lname] writeIntoCell:toLagerField];
	}
	[self checkButtons];
	[self setWindowTitle];
	return self;
}

- pasteArtikel:anItem
{
	int	i, count = [anItem count];
	int	oldCount = [fillingList count];
	
	for (i=0;i<count;i++) {
		BOOL	found = NO, j, count=[fillingList count];
		for (j=0;j<count && !found;j++) {
			if ([[[fillingList objectAt:j] objectAt:0] compare:[anItem objectAt:i]] == 0) {
				found = YES;
				[[[fillingList objectAt:j] objectAt:2] addInt:1];
			}
		}
		if (!found) {
			id	newItem = [anItem copyLoadedObjectAt:i];
			if (newItem) {
				if ([[newItem lagerhaltung] int] > 0) {
					id	newList = [[List alloc] initCount:3];
					[newList addObject:[[newItem nr] copy]];
					[newList addObject:[[newItem aname] copy]];
					[newList addObject:[Integer int:1]];
					[fillingList addObject:newList];
				}
				[newItem free];
			} 
		}
	}
	if (fillingList == fromList) {
		[fromBrowser loadColumnZero];
	} else {
		[toBrowser loadColumnZero];
	}
	if ([fillingList count] != oldCount) {
		[window setDocEdited:YES];
	}
	[self checkButtons];
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

- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	id		entryItem;
	BOOL 	accepted = NO;
	
	if ((source != iconButton) && ([source window] != [self window])) {
		if (((entryItem = [source content]) != nil ) && ([self acceptsItem:[source content]])) {
			NXRect aFrame;
			NXPoint	aPoint = *mouseLocation;
			[window convertScreenToBase:&aPoint];
			accepted = YES;
			[fromBrowser getFrame:&aFrame];
			if (aPoint.x <= (aFrame.size.width + aFrame.origin.x)) {
				fillingList = fromList;
			} else {
				fillingList = toList;
			}
			[self pasteItem:entryItem];
			[window makeKeyAndOrderFront:self];
		}
	}
	[NXArrow set];
	return accepted;
}
@end
