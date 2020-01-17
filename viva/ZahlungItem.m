#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"

#import "ZahlungItem.h"

#pragma .h #import <objc/Object.h>

@implementation ZahlungItem:Object
{
	id		kundennr;
	id		buchungsnr;
	id		datum;
	id		betrag;
	id		rechnr;
	id		bemerkung;
	
	BOOL	iamNew;
}

- init
{
	[super init];
	iamNew = YES;
	return self;
}

- initKundennr:aKundennr buchungsnr:aBuchungsnr datum:aDatum betrag:aBetrag rechnr:aRechnr bemerkung:aBemerkung
{
	[self init];
	kundennr	= [aKundennr copy];
	buchungsnr	= [aBuchungsnr copy];
	datum		= [aDatum copy];
	betrag		= [aBetrag copy];
	rechnr		= [aRechnr copy];
	bemerkung	= [aBemerkung copy];
	return self;
}

- initKundennr:aKundennr datum:aDatum betrag:aBetrag rechnr:aRechnr bemerkung:aBemerkung
{
	id	null = [Integer int:0];
	[self initKundennr:aKundennr buchungsnr:null datum:aDatum betrag:aBetrag rechnr:aRechnr bemerkung:aBemerkung];
	[null free];
	return self;
}

- initKundennr:aKundennr rechnr:aRechnr
{
	id	today = [Date today];
	id	null = [Double double:0.0];
	id	leer = [String str:""];
	[self initKundennr:aKundennr datum:today betrag:null rechnr:aRechnr bemerkung:leer];
	[null free];
	[leer free];
	[today free];
	return self;
}

- initKundennr:aKundennr bemerkung:aBemerkung
{
	id	today = [Date today];
	id	null = [Double double:0.0];
	id	leer = [String str:""];
	[self initKundennr:aKundennr datum:today betrag:null rechnr:leer bemerkung:aBemerkung];
	[null free];
	[leer free];
	[today free];
	return self;
}

- copy
{
	id	theCopy = [super copy];
	kundennr	= [kundennr copy];
	buchungsnr	= [buchungsnr copy];
	datum		= [datum copy];
	betrag		= [betrag copy];
	rechnr		= [rechnr copy];
	bemerkung	= [bemerkung copy];
	return theCopy;
}

- free
{
	[kundennr free];
	[buchungsnr free];
	[datum free];
	[betrag free];
	[rechnr free];
	[bemerkung free];
	return [super free];
}

- (int)compare:anotherObject
{
	return [datum compare:[anotherObject datum]];
}

- (BOOL)save
{
	if(iamNew) {
		if([self insert]) {
			iamNew = NO;
			return YES;
		} else {
			return NO;
		}
	} else {
		return [self update];
	}
}

- (BOOL)insert
{
	if([[NXApp defaultQuery] beginTransaction]) {
		if([self insertInsideTran]) {
			return [[NXApp defaultQuery] commitTransaction];
		}
	}
	[[NXApp defaultQuery] rollbackTransaction];
	return NO;
}

- (BOOL)insertInsideTran
{
	id		queryString, queryResult;

	queryString = [QueryString str:"select maxnr+1 from maxbuchung holdlock where kundennr="];
	[queryString concatField:kundennr];
	queryResult = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if(queryResult) {
		if([queryResult objectAt:0] && [[queryResult objectAt:0] objectAt:0]) {
			[self setBuchungsnr:[[queryResult objectAt:0] objectAt:0]];
		} else {
			id	eins = [Integer int:1];
			[self setBuchungsnr:eins];
			[eins free];
			queryString = [QueryString str:"insert into maxbuchung values("];
			[queryString concatFieldComma:kundennr];
			[queryString concatSTR:"0)"];
			[[[NXApp defaultQuery] performQuery:queryString] free];
			[queryString free];
		}
		[queryResult free];
		if([[NXApp defaultQuery] lastError]==NOERROR) {
			queryString = [QueryString str:"update maxbuchung"];
			[queryString concatSTR:" set maxnr=maxnr+1 where kundennr="];
			[queryString concatField:kundennr];
			[[[NXApp defaultQuery] performQuery:queryString] free];
			[queryString free];
			if([[NXApp defaultQuery] lastError]==NOERROR) {
				queryString = [QueryString str:"insert into kundenkonto values("];
				[queryString concatFieldComma:kundennr];
				[queryString concatFieldComma:buchungsnr];
				[queryString concatFieldComma:datum];
				[queryString concatFieldComma:betrag];
				[queryString concatFieldComma:rechnr];
				[queryString concatField:bemerkung];
				[queryString concatSTR:")"];
				[[[NXApp defaultQuery] performQuery:queryString] free];
				[queryString free];
				if([[NXApp defaultQuery] lastError] == NOERROR) {
					return YES;
				}
			}
		}
	}
	return NO;
}

- (BOOL)update
{
	id queryString = [QueryString str:"update kundenkonto set "];
	[[queryString concatSTR:"datum="] concatFieldComma:datum];
	[[queryString concatSTR:"betrag="] concatFieldComma:betrag];
	[[queryString concatSTR:"rechnr="] concatFieldComma:rechnr];
	[[queryString concatSTR:"bemerkung="] concatField:bemerkung];
	[queryString concatSTR:" where kundennr="];
	[queryString concatField:kundennr];
	[queryString concatSTR:" and buchungsnr="];
	[queryString concatField:buchungsnr];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	return [[NXApp defaultQuery] lastError] == NOERROR;
}

- (BOOL)delete
{
	id	queryString = [QueryString str:"delete from kundenkonto"];
	[queryString concatSTR:" where kundennr="];
	[queryString concatField:kundennr];
	[queryString concatSTR:" and buchungsnr="];
	[queryString concatField:buchungsnr];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	return [[NXApp defaultQuery] lastError] == NOERROR;
}

- setIsNew:(BOOL)flag
{
	iamNew = flag;
	return self;
}

- kundennr { return kundennr; }
- setKundennr:anObject { [kundennr free]; kundennr = [anObject copy]; return self; }
- buchungsnr { return buchungsnr; }
- setBuchungsnr:anObject { [buchungsnr free]; buchungsnr = [anObject copy]; return self; }
- datum { return datum; }
- setDatum:anObject { [datum free]; datum = [anObject copy]; return self; }
- betrag { return betrag; }
- setBetrag:anObject { [betrag free]; betrag = [anObject copy]; return self; }
- rechnr { return rechnr; }
- setRechnr:anObject { [rechnr free]; rechnr = [anObject copy]; return self; }
- bemerkung { return bemerkung; }
- setBemerkung:anObject { [bemerkung free]; bemerkung = [anObject copy]; return self; }

@end

