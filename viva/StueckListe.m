#import <appkit/TextField.h>
#import <appkit/NXBrowser.h>
#import <appkit/Matrix.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/PaletteView.h"

#import "TheApp.h"
#import "ErrorManager.h"
#import "StringManager.h"
#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "ArtikelDocument.h"
#import "StueckListe.h"

#pragma .h #import "SlaveSelector.h"

@implementation StueckListe:SlaveSelector
{
	id		anzahlRequestPanel;
	id		stuecklistenArtikelIdentityField;
	id		eintragAnzahlField;
	id		eintragIdentityField;
	id		eintragOkButton;
	id		preiseUebernehmenButton;
}


- initForIdentity:anIdentity andOwner:anObject
{
	[super initForIdentity:anIdentity andOwner:anObject];
	[NXApp registerDocument:self];
	iamReadOnly = NO;
	return self;
}

- free
{
	[NXApp unregisterDocument:self];
	[owner stuecklisteClosed:self];
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
	
	queryString = [QueryString str:"select stuecklisten.subnr ArtikelNr, stuecklisten.anzahl Anzahl, artikel.aname Bezeichnung, artikel.vk VK from  stuecklisten, artikel"];
	
	[queryString concatSTR:" where stuecklisten.nr = "];
	[queryString concatField:identity];
	[queryString concatSTR:" and artikel.nr = stuecklisten.subnr "];
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	
	return self;
}

- documentClass
{ return [ArtikelDocument class]; }

- itemClass
{ return [ArtikelItem class]; }

- itemListClass
{ return [ArtikelItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

- artikelNameAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:2]; }

- artikelCountAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:4]; }

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

- (BOOL)needsOwnTitle
{ return YES; }

- (BOOL)exists:anArticleId
{
	id		queryString;
	BOOL	exist = NO;
	id		result;
	
	queryString = [QueryString str:"select count(*) from stuecklisten where nr="];
	[queryString concatField:identity];
	[queryString concatSTR:" and subnr ="];
	[queryString concatField:anArticleId];
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


- (BOOL)update:anArticleIdentity addAnzahl:anArticleAnzahl
{
	BOOL	updated;
	id		queryString = [QueryString str:"update stuecklisten set anzahl="];
	[queryString concatField:anArticleAnzahl];
	[queryString concatSTR:" where nr = "];
	[queryString concatField:identity];
	[queryString concatSTR:" and subnr = "];
	[queryString concatField:anArticleIdentity];
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

- (BOOL)insert:anArticleIdentity withAnzahl:anArticleAnzahl
{
	BOOL	inserted;
	id		queryString = [QueryString str:"insert into stuecklisten values("];
	[queryString concatFieldComma:identity];
	[queryString concatFieldComma:anArticleIdentity];
	[queryString concatField:anArticleAnzahl];
	[queryString concatSTR:")"];
	[[NXApp defaultQuery] beginTransaction];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	inserted = ([[NXApp defaultQuery] lastError] == NOERROR);
	if (inserted) {
		[[NXApp defaultQuery] commitTransaction];
	} else {
		[[NXApp defaultQuery] rollbackTransaction];
	}
	
	return inserted;
}

- destroy:sender
{
	id	anId = [self copyObjectIdentityAtRow:[sender tag]];
	id	queryString = [QueryString str:"delete from stuecklisten where nr="];
	[queryString concatField:identity];
	[queryString concatSTR:" and subnr = "];
	[queryString concatField:anId];
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

- performDoubleActionWith:theObject
{
	id retVal = [self addArtikelIdentity:theObject];
	[theObject free];
	return retVal;
}

- addArtikelIdentity:anArticleIdentity
{
	int retVal;
	
	[identity writeIntoCell:stuecklistenArtikelIdentityField];
	[anArticleIdentity writeIntoCell:eintragIdentityField];
	[[eintragAnzahlField setIntValue:0] selectText:self];
	retVal = [NXApp runModalFor:anzahlRequestPanel];
	[anzahlRequestPanel orderOut:self];
	if (retVal == [eintragOkButton tag]) {
		return self;
	} else {
		return nil;
	}
}


- doRealAdd:sender
{
	id		anArticleIdentity = [[String str:""] readFromCell:eintragIdentityField];
	id		anArticleAnzahl = [[Integer int:0] readFromCell:eintragAnzahlField];
	BOOL	retVal;

	if ([self exists:anArticleIdentity]) {
		retVal = [self update:anArticleIdentity addAnzahl:anArticleAnzahl];
	} else {
		retVal = [self insert:anArticleIdentity withAnzahl:anArticleAnzahl];
	}
	
	[anArticleIdentity free];
	[anArticleAnzahl free];

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
		[NXApp sendChangedClass:[[self itemClass] name] identity:[identity str]];
	}
	return self;
}


- destroyAll:sender
{
	[[browser matrixInColumn:0] sendAction:@selector(destroy:) to:self forAllCells:YES];
	[self updateBrowserWithCurrentSelection];
	return self;
}

- stuecklisteUebernehmenButtonClicked:sender
{
	if ([owner respondsTo:@selector(stuecklisteUebernehmenButtonClicked:)]) {
		[owner stuecklisteUebernehmenButtonClicked:sender];
	}
	return self;
}

- getGesamtEk:ek vk:vk undGewicht:gewicht
{
	id	result;
	id	queryString;
	
	queryString = [QueryString str:"select sum(convert(float,sl.anzahl * artikel.ek)), sum(convert(float,sl.anzahl * artikel.vk)), sum(convert(float,sl.anzahl * artikel.gewicht)) from stuecklisten sl, artikel where sl.nr = "];
	[queryString concatField:identity];
	[queryString concatSTR:" and artikel.nr = sl.subnr"];
	result = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		[ek setDouble:[[[result objectAt:0] objectAt:0] double]];
		[vk setDouble:[[[result objectAt:0] objectAt:1] double]];
		[gewicht setDouble:[[[result objectAt:0] objectAt:2] double]];
	}
	[result free];
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
create table stuecklisten
(
	nr		varchar(30),
	subnr	varchar(30),
	anzahl	int
)
create unique clustered index stuecklistenindex on stuecklisten(nr,subnr)
go
END TABLE DEFS
#endif
