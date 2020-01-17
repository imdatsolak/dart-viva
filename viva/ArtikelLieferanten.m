#import <appkit/TextField.h>
#import <appkit/NXBrowser.h>
#import <appkit/Matrix.h>

#import "dart/debug.h"
#import "dart/HeadButton.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/PaletteView.h"
#import "dart/NiftyMatrix.h"
#import "dart/ColumnBrowserCell.h"

#import "ArtikelDocument.h"
#import "ArtikelLieferanten.h"
#import "ErrorManager.h"
#import "KundeItem.h"
#import "KundeItemList.h"
#import "KundenDocument.h"
#import "StringManager.h"
#import "TheApp.h"

#pragma .h #import "SlaveSelector.h"

@implementation ArtikelLieferanten:SlaveSelector
{
	id		editPanel;
	id		artikelnrField;
	id		lieferantennrField;
	id		ekField;
	id		bestdauerField;
	id		okButton;
	
	id		currentEk;
	id		currentBestdauer;
	int		headButtonClickCount;
}


- initForIdentity:anIdentity andOwner:anObject
{
	[super initForIdentity:anIdentity andOwner:anObject];
	[browser setMatrixClass:[NiftyMatrix class]];
	[NXApp registerDocument:self];
	iamReadOnly = NO;
	currentEk = nil;
	currentBestdauer = nil;
	headButtonClickCount = 0;
	return self;
}

- free
{
	[NXApp unregisterDocument:self];
	[owner artikelLieferantenClosed:self];
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
	
	queryString = [QueryString str:"select artikellieferanten.nr LiefNr, artikellieferanten.artnr ArtikelNr, kunden.kname LiefName, artikellieferanten.ek EK, artikellieferanten.bestdauer BestDauer, artikellieferanten.prioritaet Priority from  artikellieferanten, kunden where artikellieferanten.artnr = "];
	[queryString concatField:identity];
	[queryString concatSTR:" and kunden.nr = artikellieferanten.nr "];
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	
	[theEntryList sortByTag:6];
	[headButton moveToLeft:6];
	currentSortTag = 6;
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

- (BOOL)exists:aLieferantenId
{
	id		queryString;
	BOOL	exist = NO;
	id		result;
	
	queryString = [QueryString str:"select count(*) from artikellieferanten where nr="];
	[queryString concatField:aLieferantenId];
	[queryString concatSTR:" and artnr ="];
	[queryString concatField:identity];
	result = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if (result && ([[NXApp defaultQuery] lastError] == NOERROR)) {
		exist = [[[result objectAt:0] objectAt:0] int] != 0;
	}
	if (result) {
		[result free];
	}
	return exist;
}


- (BOOL)update:aLieferantenId setEk:anEk andBestdauer:aBestdauer
{
	BOOL	updated;
	id		queryString = [QueryString str:"update artikellieferanten set "];
	if (anEk != nil) {
		[queryString concatSTR:" ek="];
		[queryString concatField:anEk];
		if (aBestdauer != nil) {
			[queryString concatSTR:","];
		}
	}
	if (aBestdauer != nil) {
		[queryString concatSTR:" bestdauer="];
		[queryString concatField:aBestdauer];
	}
	[queryString concatSTR:" where nr = "];
	[queryString concatField:aLieferantenId];
	[queryString concatSTR:" and artnr = "];
	[queryString concatField:identity];
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

- (BOOL)insert:aLieferantenId withEk:anEk andBestdauer:aBestdauer
{
	BOOL	inserted;
	id		queryString = [QueryString str:"insert into artikellieferanten values("];
	[queryString concatFieldComma:aLieferantenId];
	[queryString concatFieldComma:identity];
	[queryString concatFieldComma:anEk];
	[queryString concatFieldComma:aBestdauer];
	[queryString concatSTR:"10000)"];
	[[NXApp defaultQuery] beginTransaction];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	inserted = ([[NXApp defaultQuery] lastError] == NOERROR);
	if (inserted) {
		[[NXApp defaultQuery] commitTransaction];
	} else {
		[[NXApp defaultQuery] rollbackTransaction];
		[NXApp beep:"CouldNotInsertSupplier"];
	}
	
	return inserted;
}

- destroy:sender
{
	id	anId = [self copyObjectIdentityAtRow:[sender tag]];
	id	queryString = [QueryString str:"delete from artikellieferanten where nr="];
	[queryString concatField:anId];
	[queryString concatSTR:" and artnr = "];
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
	[NXApp sendChangedClass:"ArtikelItem" identity:[identity str]];
	return self;
}


- doDoubleAction:sender
{
	currentEk = [[[theEntryList objectAt:[sender tag]] objectWithTag:4] copy];
	currentBestdauer = [[[theEntryList objectAt:[sender tag]] objectWithTag:5] copy];
	[self performDoubleActionWith:[self copyObjectIdentityAtRow:[sender tag]]];
	currentEk = [currentEk free];
	currentBestdauer = [currentBestdauer free];
	return self;
}

- performDoubleActionWith:theObject
{
	id retVal = [self addLieferantIdentity:theObject];
	[theObject free];
	return retVal;
}

- addLieferantIdentity:aLieferantId
{
	int retVal;
	
	[identity writeIntoCell:artikelnrField];
	[aLieferantId writeIntoCell:lieferantennrField];
	[currentBestdauer writeIntoCell:bestdauerField];
	[currentEk writeIntoCell:ekField];
	[ekField selectText:self];
	retVal = [NXApp runModalFor:editPanel];
	[editPanel orderOut:self];
	if (retVal == [okButton tag]) {
		return self;
	} else {
		return nil;
	}
	return self;
}


- doRealAdd:sender
{
	id		aLieferantId = [[String str:""] readFromCell:lieferantennrField];
	id		anEk = [[Double double:0.0] readFromCell:ekField];
	id		aBestdauer = [[Integer int:0] readFromCell:bestdauerField];
	BOOL	retVal;

	if ([self exists:aLieferantId]) {
		retVal = [self update:aLieferantId setEk:anEk andBestdauer:aBestdauer];
	} else {
		retVal = [self insert:aLieferantId withEk:anEk andBestdauer:aBestdauer];
	}
	
	[aLieferantId free];
	[anEk free];
	[aBestdauer free];

	if (!retVal) {
		[NXApp stopModal:0];
		return nil;
	} else {
		[NXApp stopModal:[sender tag]];
		return self;
	}
	return self;

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
		[NXApp sendChangedClass:"ArtikelItem" identity:[identity str]];
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

- cellMovedFrom:(unsigned)oldPos to:(unsigned)newPos
{
	int	i, count = [[browser matrixInColumn:0] cellCount];
	int	begin,end;
	for(i=0; i<count; i++) {
		[[[browser matrixInColumn:0] cellAt:i:0] setTag:i];
	}
	
	[theEntryList insertObject:[theEntryList removeObjectAt:oldPos] at:newPos];
	[self renumber];
	if (newPos < oldPos) {
		begin = newPos;
		end = oldPos;
	} else {
		begin = oldPos;
		end = newPos;
	}
	for(i=begin; i<=end; i++) {
		[[[browser matrixInColumn:0] cellAt:i:0] setLoaded:NO];
		[self updateInDBTheRow:i];
	}
	
	return self;
}

- updateInDBTheRow:(int)row
{
	id	aLieferantenId = [self copyObjectIdentityAtRow:row];
	id	queryString = [QueryString str:"update artikellieferanten set prioritaet = "];
	[queryString concatINT:row+1];
	[queryString concatSTR:" where nr = "];
	[queryString concatField:aLieferantenId];
	[queryString concatSTR:" and artnr = "];
	[queryString concatField:identity];
	[[NXApp defaultQuery] beginTransaction];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		[[NXApp defaultQuery] commitTransaction];
	} else {
		[[NXApp defaultQuery] rollbackTransaction];
	}
	[aLieferantenId free];
	return self;
}

- renumber
{
	int i, count = [theEntryList count];
	for (i=0;i<count;i++) {
		[[[theEntryList objectAt:i] objectWithTag:6] setInt:i+1];
	}
	return self;
}

- headButtonClicked:sender
{
	headButtonClickCount++;
	if (headButtonClickCount == 3) {
		[[NXApp errorMgr] showDialog:"SortByHandPlease" yesButton:"OK" explain:"SortByHandPleaseExp"];
		headButtonClickCount = 0;
	} else {
		[NXApp beep:"SortByHandPlease"];
	}
	return self;
}

@end


#if 0
BEGIN TABLE DEFS
create table artikellieferanten
(
	nr			varchar(15),
	artnr		varchar(30),
	ek			float,
	bestdauer	int,
	prioritaet	int
)
create unique clustered index artikellieferantenindex on artikellieferanten(artnr,nr)
go

END TABLE DEFS
#endif

#if 0
use viva2DB
go
alter table artikellieferanten add prioritaet int NULL
go
update artikellieferanten set prioritaet = 10000
go
quit
#endif

