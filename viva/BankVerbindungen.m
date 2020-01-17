#import <appkit/TextField.h>
#import <appkit/NXBrowser.h>
#import <appkit/Matrix.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/PaletteView.h"

#import "BankVerbindungen.h"
#import "ErrorManager.h"
#import "KundeItem.h"
#import "KundeItemList.h"
#import "KundenDocument.h"
#import "StringManager.h"
#import "TheApp.h"

#pragma .h #import "SlaveSelector.h"

@implementation BankVerbindungen:SlaveSelector
{
	id		editPanel;
	id		blzField;
	id		kundennrField;
	id		kontonrField;
	id		kontoinhaberField;
	id		okButton;
	
	id		currentRow;
}


- initForIdentity:anIdentity andOwner:anObject
{
	[super initForIdentity:anIdentity andOwner:anObject];
	[NXApp registerDocument:self];
	iamReadOnly = NO;
	currentRow = [Integer int:-1];
	return self;
}

- free
{
	[NXApp unregisterDocument:self];
	[owner bankverbindungenClosed:self];
	[currentRow free];
	return [super free];
}

- setReadOnly:(BOOL)flag
{
	iamReadOnly = flag;
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
	
	queryString = [QueryString str:"select bankverbindung.lfdnr LfdNr, bankverbindung.blz BLZ, bankverbindung.kontonr KontoNr, bankverbindung.kontoinhaber Inhaber from  bankverbindung where bankverbindung.kundennr = "];
	[queryString concatField:identity];
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	
	return self;
}

- documentClass
{ return [KundenDocument class]; }

- itemClass
{ return [KundeItem class]; }

- itemListClass
{ return [KundeItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

- checkMenus
{
	[super checkMenus];
	[[NXApp destroySelectionButton] setEnabled:([iconButton content] != nil)];
	return self;
}


- makeActive:sender
{
	NXRect	aFrame;
	[super makeActive:sender];
	[self setWindowTitle];
	[window makeKeyAndOrderFront:self];
	[[window contentView] getFrame:&aFrame];
	maxWidth = aFrame.size.width * 1.5;
	return self;
}

- (BOOL)needsOwnTitle { return YES; }

- (BOOL)exists:anId
{
	return NO;
}


- (BOOL)update:aKundenId setKontoNr:aKontonr andKontoInhaber:anInhaber forLfdNr:anLfdNr
{
	BOOL	updated;
	id		queryString = [QueryString str:"update bankverbindung set "];
	if (aKontonr != nil) {
		[queryString concatSTR:" kontonr="];
		[queryString concatField:aKontonr];
		if (anInhaber != nil) {
			[queryString concatSTR:","];
		}
	}
	if (anInhaber != nil) {
		[queryString concatSTR:" kontoinhaber="];
		[queryString concatField:anInhaber];
	}
	[queryString concatSTR:" where kundennr = "];
	[queryString concatField:aKundenId];
	[queryString concatSTR:" and lfdnr = "];
	[queryString concatField:anLfdNr];
	[[NXApp defaultQuery] beginTransaction];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	updated = ([[NXApp defaultQuery] lastError] == NOERROR);
	if (updated) {
		[[NXApp defaultQuery] commitTransaction];
	} else {
		[[NXApp defaultQuery] rollbackTransaction];
	}
	return updated;
}

- (BOOL)insert:aKundenId withBlz:aBlz kontoNr:aKontonr andKontoInhaber:anInhaber
{
	BOOL	inserted;
	id		queryString;
	id		result;
	
	[[NXApp defaultQuery] beginTransaction];
	queryString = [QueryString str:"select max(lfdnr) from bankverbindung where kundennr="];
	[queryString concatField:aKundenId];
	result = [[NXApp defaultQuery] performQuery:queryString];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		int	lfdnr = [[[result objectAt:0] objectAt:0] int]+1;
		[queryString str:"insert into bankverbindung values("];
		[queryString concatINT:lfdnr];
		[queryString concatSTR:","];
		[queryString concatFieldComma:aKundenId];
		[queryString concatFieldComma:aBlz];
		[queryString concatFieldComma:aKontonr];
		[queryString concatField:anInhaber];
		[queryString concatSTR:")"];
		[[[NXApp defaultQuery] performQuery:queryString] free];
		inserted = ([[NXApp defaultQuery] lastError] == NOERROR);
		if (inserted) {
			[[NXApp defaultQuery] commitTransaction];
		} else {
			[[NXApp defaultQuery] rollbackTransaction];
		}
	} else {
		[[NXApp defaultQuery] rollbackTransaction];
		inserted = NO;
	}
	[queryString free];
	[result free];
	return inserted;
}

- destroy:sender
{
	id	anId = [self copyObjectIdentityAtRow:[sender tag]];
	id	queryString = [QueryString str:"delete from bankverbindung where lfdnr="];
	[queryString concatField:anId];
	[queryString concatSTR:" and kundennr = "];
	[queryString concatField:identity];
	[[NXApp defaultQuery] beginTransaction];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	[anId free];
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
		[[NXApp defaultQuery] rollbackTransaction];
		return nil;
	} else {
		[[NXApp defaultQuery] commitTransaction];
		return self;
	}
}

- open:sender
{
	if (!iamReadOnly) {
		[[browser matrixInColumn:0] sendAction:@selector(doDoubleAction:) to:self forAllCells:NO];
 	} else {
		[NXApp beep:"ReadOnlyDocument"];
	}
   return self;
}

- browserDoubleClicked:sender
{
	if (!iamReadOnly) {
		[[sender matrixInColumn:0] sendAction:@selector(doDoubleAction:) to:self forAllCells:NO];
		[self perform:@selector(sendUpdate:) with:self afterDelay:1 cancelPrevious:YES];
	} else {
		[NXApp beep:"ReadOnlyDocument"];
	}
	return self;
}

- sendUpdate:sender
{
	[NXApp sendChangedClass:"KundeItem" identity:[identity str]];
	return self;
}


- doDoubleAction:sender
{
	[self performDoubleActionWithRow:[sender tag]];
	return self;
}

- performDoubleActionWithRow:(int)theRow
{
	id retVal = [self addBankverbindungRow:theRow];
	return retVal;
}

- addBankverbindungRow:(int)aRow
{
	int retVal;
	id	row = [theEntryList objectAt:aRow];
	
	[currentRow setInt:aRow];
	[identity writeIntoCell:kundennrField];
	[[row objectWithTag:2] writeIntoCell:blzField];
	[[row objectWithTag:3] writeIntoCell:kontonrField];
	[[row objectWithTag:4] writeIntoCell:kontoinhaberField];
	[kontonrField selectText:self];
	retVal = [NXApp runModalFor:editPanel];
	[editPanel orderOut:self];
	if (retVal == [okButton tag]) {
		return self;
	} else {
		return nil;
	}
}


- addBankverbindungIdentity:anIdentity
{
	int retVal;
	
	[currentRow setInt:-1];
	[identity writeIntoCell:kundennrField];
	[anIdentity writeIntoCell:blzField];
	[kontonrField setStringValue:""];
	[kontoinhaberField setStringValue:""];
	[kontonrField selectText:self];
	retVal = [NXApp runModalFor:editPanel];
	[editPanel orderOut:self];
	if (retVal == [okButton tag]) {
		return self;
	} else {
		return nil;
	};

}


- doRealAdd:sender
{
	id		aBankId	= [[String str:""] readFromCell:blzField];
	id		aKundenId = [[String str:""] readFromCell:kundennrField];
	id		aKontonr = [[String str:""] readFromCell:kontonrField];
	id		aKonotinhaber = [[String str:""] readFromCell:kontoinhaberField];
	BOOL	retVal;

	if ([currentRow int] >= 0) {
		retVal = [self update:aKundenId setKontoNr:aKontonr andKontoInhaber:aKonotinhaber forLfdNr:currentRow];
	} else {
		retVal = [self insert:identity withBlz:aBankId kontoNr:aKontonr andKontoInhaber:aKonotinhaber];
	}
	
	[aBankId free];
	[aKundenId free];
	[aKontonr free];
	[aKonotinhaber free];

	if (!retVal) {
		[NXApp stopModal:0];
		return nil;
	} else {
		[NXApp stopModal:[sender tag]];
		return self;
	}
}

- cancelButtonClicked:sender
{
	[NXApp stopModal:[sender tag]];
	return self;
}


- destroySelection:sender
{
	if ([[NXApp errorMgr] showDialog:"ReallyDeleteSelection" 
							yesButton:"NO" 
							noButton:"YES" explain:"DeleteSelectionExp"] == EHNO_BUTTON) {
		[[browser matrixInColumn:0] sendAction:@selector(destroy:) to:self forAllCells:NO];
		[self updateBrowserWithCurrentSelection];
		[NXApp sendChangedClass:"KundeItem" identity:[identity str]];
	}
	return self;
}


- destroyAll:sender
{
	[[browser matrixInColumn:0] sendAction:@selector(destroy:) to:self forAllCells:YES];
	[self updateBrowserWithCurrentSelection];
	return self;
}

- windowWillClose:sender
{
	[window setDelegate:nil];
	[self free];
	return (id)YES;
}

@end


#if 0
BEGIN TABLE DEFS
create table bankverbindung
(
	lfdnr		int,
	kundennr	varchar(15),
	blz			varchar(15),
	kontonr		varchar(15),
	kontoinhaber	varchar(50)
)
create unique clustered index bankverbindungindex on bankverbindung(kundennr, lfdnr)
go

END TABLE DEFS
#endif

