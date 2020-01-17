#import <appkit/Cell.h>
#import <appkit/Button.h>
#import <appkit/NXBrowser.h>
#import <appkit/Matrix.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/PaletteView.h"

#import "TheApp.h"
#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "ArtikelDocument.h"
#import "LagerItemList.h"
#import "LagerArtikelSelector.h"

#pragma .h #import "SlaveSelector.h"

@implementation LagerArtikelSelector:SlaveSelector
{
	id	nrField;
	id	anameField;
	id	ekminField;
	id	ekmaxField;
	id	bestandMinField;
	id	bestandMaxField;
	id	summeAllerArtikel;
	id	summeAllerArtikelField;
	id	summeAllerArtikelVk;
	id	summeAllerArtikelVkField;
	id	summeAusgewaehlterArtikelField;
	
	id	findPanel;
	double	theSum;
}

- performQuery
{
	id	aQueryResult, queryString;
	id	nrString, anameString, ekminDouble, ekmaxDouble;
	
	nrString = [QueryString str:[nrField stringValue]];
	anameString = [QueryString str:[anameField stringValue]];
	ekminDouble = [Double double:[ekminField doubleValue]];
	ekmaxDouble = [Double double:[ekmaxField doubleValue]];
	
	queryString = [QueryString str:"select lagerartikel.artnr ArtikelNr, artikel.aname Bezeichnung, artikel.ek EK, lagerartikel.anzahl Bestand from lagerartikel, artikel"];
	
	[queryString concatSTR:" where lagerartikel.lagernr = "];
	[queryString concatField:identity];
	[queryString concatSTR:" and lagerartikel.artnr like "];
	[queryString concatField:nrString];
	[queryString concatSTR:" and artikel.nr = lagerartikel.artnr "];
	[queryString concatSTR:" and artikel.aname like "];
	[queryString concatField:anameString];
	[queryString concatSTR:" and artikel.ek between "];
	[queryString concatField:ekminDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:ekmaxDouble];
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];
	[nrString free];
	[anameString free];
	[ekminDouble free];
	[ekmaxDouble free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	
	queryString = [QueryString str:"select sum(artikel.ek * lagerartikel.anzahl),sum(artikel.vk * lagerartikel.anzahl) from lagerartikel, artikel where artikel.nr = lagerartikel.artnr and lagerartikel.lagernr = "];
	[queryString concatField:identity];
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if ( (aQueryResult) && ([aQueryResult objectAt:0]) ){
		summeAllerArtikel = [[[aQueryResult objectAt:0] objectAt:0] copy];
		summeAllerArtikelVk = [[[aQueryResult objectAt:0] objectAt:1] copy];
		[aQueryResult free];
	}
		
	return self;
}

- setSummeAllerArtikelField:anObject { summeAllerArtikelField = anObject;	return self;}
- setSummeAllerArtikelVkField:anObject { summeAllerArtikelVkField = anObject;	return self;}
- setSummeAusgewaehlterArtikelField:anObject { summeAusgewaehlterArtikelField = anObject;	return self;}


- updateBrowserWithCurrentSelection
{
	[super updateBrowserWithCurrentSelection];
	if (summeAllerArtikel) {
		[summeAllerArtikel writeIntoCell:summeAllerArtikelField];
	}
	if (summeAllerArtikelVk) {
		[summeAllerArtikelVk writeIntoCell:summeAllerArtikelVkField];
	}
	return self;
}

- browserClicked:sender
{
	theSum=0.0;
	[super browserClicked:sender];
	[[sender matrixInColumn:0] sendAction:@selector(performCalculation:) to:self forAllCells:NO];
	[summeAusgewaehlterArtikelField setDoubleValue:theSum];
	if ([iconButton content]) {
		id	senderOfItems = [[[LagerItemList alloc] initCount:0] addObject:[identity copy]];
		[[iconButton content] setSenderOfItems:senderOfItems];
		[senderOfItems free];
	}
	return self;
}

- performCalculation:sender
{
	theSum = theSum + ([[[theEntryList objectAt:[sender tag]] objectWithTag:3] double]* 
					   [[[theEntryList objectAt:[sender tag]] objectWithTag:4] int]);
	return self;
}

- free
{
	if (summeAllerArtikel) {
		summeAllerArtikel = [summeAllerArtikel free];
	}
	if (summeAllerArtikelVk) {
		summeAllerArtikelVk = [summeAllerArtikelVk free];
	}
	return [super free];
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

- find:sender
{
	[findPanel makeKeyAndOrderFront:sender];
	[nrField selectText:self];
	return self;
}

- findPanelFindButtonClicked:sender
{
	[self makeActive:self];
	[findPanel orderOut:self];
	return self;	
}


@end
