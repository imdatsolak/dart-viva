#import <c.h>
#import <string.h>
#import <stdlib.h>
#import <math.h>
#import <appkit/TextField.h>
#import <appkit/Matrix.h>
#import <appkit/Button.h>
#import <appkit/NXCursor.h>

#import "dart/fieldvaluekit.h"
#import "dart/PaletteView.h"

#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "AuftragsArtikelItem.h"
#import "BestellungItem.h"
#import "BestellungItemList.h"
#import "LagerArtikelSelector.h"
#import "LagerChecker.h"
#import "LagerItem.h"
#import "LagerItemList.h"
#import "LagerSelector.h"
#import "LagerUmbuchController.h"
#import "StringManager.h"
#import "LagerVorgangsSelector.h"
#import "TheApp.h"
#import "UserManager.h"

#import "LagerDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation LagerDocument:MasterDocument
{
	id	nrField;
	id	lnameField;
	id	betreuernrPopup;
	id	browser;
	id	headButton;
	id	countField;
	id	countSelectedField;
	id	artikelIconButton;
	id	itemSelector;
	
	id	sumAllArtikelVkField;
	id	sumAllArtikelField;
	id	sumSelectedArtikelField;
	
	id	einbuchButton;
	id	einbuchPanel;
	id	einbuchArtikelNrField;
	id	einbuchArtikelNameField;
	id	einbuchArtikelAnzahlField;
	id	einbuchAnzahlField;
	id	einbuchKommentarField;
	id	einbuchOkButton;
	id	einbuchCancelButton;
	id	einbuchungsArtikel;
	
	id	heuteField;
	
	BOOL	lagerArtikelChanged;
}


- itemClass { return [LagerItem class]; }

- createNewItem
{
	item = [[LagerItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[LagerItem alloc] initIdentity:identity];
	return self;
}

- initNib
{
	[super initNib];
	return self;
}

- free
{
	itemSelector = [itemSelector free];
	return [super free];
}

- makeActive:sender
{
	[self reloadItemSelector];
	return [super makeActive:sender];
}

- reloadItemSelector
{
	if (itemSelector) {
		itemSelector = [itemSelector free];
	}
	itemSelector = [[LagerArtikelSelector alloc] initForWindow:window
								  browser:browser
								  headButton:headButton
								  iconButton:artikelIconButton
								  countField:countField
								  countSelectedField:countSelectedField
								  anIdentity:[item identity]
								  andOwner:self];
	[itemSelector setSummeAllerArtikelField:sumAllArtikelField];
	[itemSelector setSummeAllerArtikelVkField:sumAllArtikelVkField];
	[itemSelector setSummeAusgewaehlterArtikelField:sumSelectedArtikelField];
	[itemSelector makeActive:self];
	return self;
}
/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	SETREADONLYFIELD(nrField);
	if (![self isReadOnly]) {
		[lnameField selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETDISABLED(einbuchButton);
	SETREADONLYFIELD(nrField);
	SETREADONLYFIELD(lnameField);
	SETDISABLED(betreuernrPopup);
	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,nr,nrField);
	WRITEINTOCELL(item,lname,lnameField);
	WRITEINTOCELL(item,betreuernr,betreuernrPopup);
	return self;
}

- readFromWindow
{
	READFROMCELL(item,nr,nrField);
	READFROMCELL(item,lname,lnameField);
	READFROMCELL(item,betreuernr,betreuernrPopup);

	return self;
}

- reloadItem
{
	[super reloadItem];
	return [self reloadItemSelector];
}
/* ===== COPY/PASTE METHODS ============================================================== */
- (BOOL)iWannaUpdate { return YES; }
- sendAdded:identity
{
	[NXApp sendAddedClass:[[self itemClass] name] identity:[identity str]];
	[NXApp sendChangedClass:[[NXApp popupMgr] name] identity:"lagerpopupview"];
	return self;
}

- (BOOL)acceptsItem:anItem
{
	return [anItem isKindOf:[ArtikelItemList class]] || 
		  ([anItem isKindOf:[BestellungItemList class]] && [anItem isSingle]);
}

- pasteItem:anItem
{
	if ([anItem isKindOf:[ArtikelItemList class]]) {
		if ([[anItem senderOfItems] isKindOf:[LagerItemList class]]) {
			[self createUmbuchPanelAndPaste:anItem];
			return self;
		} else if ([anItem senderOfItems] == nil) {
			[self insertOrAdd:anItem];
			return self;
		} else { 
			// dooof;
		}
	} else if ([anItem isKindOf:[BestellungItemList class]] && [anItem isSingle]) {
		[self bucheBestellungEin:anItem];
	}
	return nil;
}

- bucheBestellungEin:anItem
{
	BOOL	finish = NO;
	id		bestellung = [anItem copyLoadedFirstObject];
	id		artikel = [bestellung artikel];
	int		i, count = [artikel count];
	id		comment = [String str:[[NXApp stringMgr] stringFor:"OrderInput"]];
	char	*commentStr;
	
	commentStr = malloc([comment length] + 128);
	sprintf(commentStr,[comment str], [[bestellung nr] str], [[bestellung datum] str]);
	[comment str:commentStr];
	free(commentStr);
	
	for (i=0;(i<count) && !finish;i++) {
		int	maxNum = [[[artikel objectAt:i] anzahl] int];
		id	oneArtId = [[artikel objectAt:i] nr];
		id	oneArt = [[ArtikelItem alloc] initIdentity:oneArtId];
		if ([[oneArt lagerhaltung] int] != 0) {
			finish = ([self bucheArtikelEin:[oneArt copy] withDefaultComment:comment andMaxNum:maxNum] == nil);
		}
		[oneArt free];
	}
	[comment free];
	[bestellung free];
	return self;
}

- insertOrAdd:anItem
{
	int i, count = [anItem count];
	BOOL	finish = NO;
	BOOL	lagerChanged = NO;
	for (i=0;(i<count) && !finish;i++) {
		id	anArticle = [anItem copyLoadedObjectAt:i];
		if ([[anArticle lagerhaltung] int] != 0) {
			if ([LagerChecker insertArtikel:[anArticle identity] intoLager:[item identity]]) {
				lagerChanged = YES;
				if ([self bucheArtikelEin:anArticle withDefaultComment:nil andMaxNum:MAXINT] == nil) {
					finish = YES;
				}
			} else {
				finish = YES;
			}
		} else {
			[anArticle free];
			[NXApp beep:"ArticleWithoutLagerhaltung"];
		}
	}
	if (lagerChanged) {
		[self sendChanged:[item identity]];
		[NXApp sendChangedClass:[[LagerVorgangsSelector class] name] identity:"*"];
	}
	return self;
}

- createUmbuchPanelAndPaste:anItem
{
	id 	anUmbuch = [[LagerUmbuchController newInstance] makeActive:self];
	
	[anUmbuch setSourceLager:[anItem senderOfItems]
			  destinationLager:[[[LagerItemList alloc] initCount:0] addObject:[[item identity] copy]]
			  andArtikel:anItem];
	return self;
}

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[LagerSelector newInstance] find:sender];
	return self;
}

- findArticle:sender
{
	[itemSelector find:sender];
	return self;
}

/* ===== EINBUCH METHODS ================================================================= */
- einbuchButtonClicked:sender
{
	lagerArtikelChanged = NO;
	[itemSelector sendAction:@selector(doRealEinbuch:) to:self forAllCells:NO];
	if (lagerArtikelChanged) {
		[self sendChanged:[item identity]];
		[NXApp sendChangedClass:[[LagerVorgangsSelector class] name] identity:"*"];
	}
	return self;
}

- doRealEinbuch:sender
{
	return [self bucheArtikelEin:[[ArtikelItem alloc] initIdentity:[itemSelector objectIdentityAtRow:[sender tag]]]
				 withDefaultComment:nil
				 andMaxNum:MAXINT];
}


- bucheArtikelEin:theArtikel withDefaultComment:aComment andMaxNum:(int)maxNum
{
	int	retVal;
	int	anzahl;
	if (theArtikel) {
		id	today = [Date today];
		anzahl = [LagerChecker checkArtikel:[theArtikel identity] inLager:[item identity] forCount:0];
		[einbuchPanel makeKeyAndOrderFront:self];
		WRITEINTOCELL(theArtikel, nr, einbuchArtikelNrField);
		WRITEINTOCELL(theArtikel, aname, einbuchArtikelNameField);
		[einbuchArtikelAnzahlField setIntValue:anzahl];
//		[einbuchAnzahlField setNumericMaxValue:maxNum]; // demnaechst einkommentieren
		[[einbuchAnzahlField setIntValue:0] selectText:self];
		[today writeIntoCell:heuteField];
		if (aComment != nil) {
			[aComment writeIntoCell:einbuchKommentarField];
		}
		einbuchungsArtikel = theArtikel;
		retVal = [NXApp runModalFor:einbuchPanel];
		[einbuchPanel orderOut:self];
		[theArtikel free];
		[today free];
		if (retVal == [einbuchOkButton tag]) {
			return self;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

- einbuchOkButtonClicked:sender
{
	id	numPieces = [Integer int:[einbuchAnzahlField intValue]];
	id	comment = [String str:[einbuchKommentarField stringValue]];

	if ([numPieces int] != 0) {
		[LagerChecker addToLager:[item identity] theArticle:[einbuchungsArtikel identity] numPieces:numPieces];
		[LagerChecker addToLagervorgang:[item identity] 
					  theArticle:[einbuchungsArtikel identity] 
					  numPieces:numPieces
					  comment:comment
					  userno:[[NXApp userMgr] currentUserID]];
		lagerArtikelChanged = YES;
	}
	[numPieces free];
	[NXApp stopModal:[sender tag]];
	return self;
}

- einbuchCancelButtonClicked:sender
{
	[NXApp stopModal:[sender tag]];
	return self;	
}

/* ===== METHODS TO DELEGATE TO ITEMSELECTOR ============================================= */
- moveSelectionBy:(int)count
{
	if ([itemSelector respondsTo:@selector(moveSelectionBy:)]) {
		[itemSelector moveSelectionBy:count];
	}
	return self;
}


/* ===== METHODS FRO DRAG & DROP ========================================================= */

- windowWillResize:sender toSize:(NXSize *)frameSize
{
	frameSize->width = MAX(MAX((MIN(frameSize->width,maxSize.width)),minSize.width), [itemSelector maxWidth]);
	frameSize->height = MAX(MIN(frameSize->height,maxSize.height),minSize.height);
	return self;
}

@end

#if 0
BEGIN TABLE DEFS

create table lagervorgang
(
	datum		datetime,
	lagernummer	varchar(15),
	artikelnr	varchar(30),
	anzahl		int,
	kommentar	varchar(100),
	benutzernr	int
)
go

END TABLE DEFS
#endif
