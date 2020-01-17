#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "TheApp.h"
#import "LagerChecker.h"

#pragma .h #import <objc/Object.h>

@implementation LagerChecker:Object
{
}

+ (int)checkArtikel:anArtikelId inLager:aLagerId forCount:aCount
{
	id		queryString, queryResult;
	int		retVal = -1;
	
	queryString = [QueryString str:"select anzahl from lagerartikel where artnr = "];
	[queryString concatField:anArtikelId];
	[queryString concatSTR:" and lagernr = "];
	[queryString concatField:aLagerId];
	queryResult = [[NXApp defaultQuery] performQuery:queryString];
	if (queryResult) {
		if ([queryResult objectAt:0]) {
			int	aVal = [[[queryResult objectAt:0] objectAt:0] int];
			retVal = (aVal >= [aCount int]) ? aVal:-1;
		}
		[queryResult free];
	}
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
		retVal = -1;
	}
	return retVal;
}


+ (BOOL)subtractFromLager:aLagerId theArticle:anArtikelId numPieces:aCount
{
	id queryString = [QueryString str:"update lagerartikel set anzahl=anzahl-"];
	[queryString concatField:aCount];
	[queryString concatSTR:" where artnr = "];
	[queryString concatField:anArtikelId];
	[queryString concatSTR:" and lagernr = "];
	[queryString concatField:aLagerId];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
		return NO;
	}
	return YES;
}

+ (BOOL)addToLager:aLagerId theArticle:anArtikelId numPieces:aCount
{
	id queryString = [QueryString str:"update lagerartikel set anzahl=anzahl+"];
	[queryString concatField:aCount];
	[queryString concatSTR:" where artnr = "];
	[queryString concatField:anArtikelId];
	[queryString concatSTR:" and lagernr = "];
	[queryString concatField:aLagerId];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
		return NO;
	}
	return YES;
}

+ (BOOL)addToLagervorgang:aLagerId theArticle:anArtikelId numPieces:aCount comment:aComment userno:aUserno
{
	id	today = [Date today];
	id 	queryString = [QueryString str:"insert into lagervorgang values("];
	[queryString concatFieldComma:today];
	[queryString concatFieldComma:aLagerId];
	[queryString concatFieldComma:anArtikelId];
	[queryString concatFieldComma:aCount];
	[queryString concatFieldComma:aComment];
	[queryString concatField:aUserno];
	[queryString concatSTR:")"];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	[today free];
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
		return NO;
	}
	return YES;
}

+ (BOOL)updateLager:aLagerId theArticle:anArtikelId numPieces:aCount
{
	id queryString = [QueryString str:"update lagerartikel set anzahl="];
	[queryString concatField:aCount];
	[queryString concatSTR:" where artnr = "];
	[queryString concatField:anArtikelId];
	[queryString concatSTR:" and lagernr = "];
	[queryString concatField:aLagerId];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] != NOERROR) {
		return NO;
	}
	return YES;
}


+ (BOOL)insertArtikel:anArtikelID intoLager:aLagerID
{
	BOOL	copied = NO;
	if ([LagerChecker checkArtikel:anArtikelID inLager:aLagerID forCount:0] > -1) {
		copied = YES;
	} else {
		id queryString = [QueryString str:"insert into lagerartikel "];
		[queryString concatSTR:"select lager.nr, artikel.nr, 0 from lager, artikel"];
		[queryString concatSTR:" where artikel.lagerhaltung =1"];
		[queryString concatSTR:" and lager.nr = "];
		[queryString concatField:aLagerID];
		[queryString concatSTR:" and artikel.nr = "];
		[queryString concatField:anArtikelID];
		[[[NXApp defaultQuery] performQuery:queryString] free];
		queryString = [queryString free];
		if ([LagerChecker checkArtikel:anArtikelID inLager:aLagerID forCount:0] > -1) {
			copied = YES;
		}
	}
	return copied;
}


+ (BOOL)addToLager:aLagerId theArticle:anArtikelId numPieces:aCount andInsert:(BOOL)flag
{
	BOOL	succesfull = YES;
	if (flag) {
		succesfull = [LagerChecker insertArtikel:anArtikelId intoLager:aLagerId];
	}
	if (succesfull) {
		succesfull = [LagerChecker addToLager:aLagerId theArticle:anArtikelId numPieces:aCount];
	}
	return succesfull;
}


@end
