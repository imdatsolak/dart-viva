#import "dart/debug.h"
#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "SubkonditionenItem.h"

#import "SubkonditionenList.h"

#pragma .h #import "SubItemList.h"

@implementation SubkonditionenList:SubItemList
{
}

- initNew
{
	return [self initCount:0];
}

- initForKonditionen:kondNr
{
	id	queryString;

	queryString = [QueryString str:"select kdkategorie, menge, summe, proauftrag, rabatt, sonderpreis, istsonderpreis, istsumme, gueltigvon, gueltigbis from subkonditionen where nr="];
	[queryString concatField:kondNr];
	[self initFromQuery:queryString];
	[queryString free];
	[self sort];
	
	return self;
}


- createItem:aQueryResultRow
{
	id	newItem = [SubkonditionenItem alloc];
	
	[newItem initKdkategorie:[aQueryResultRow objectAt:0]
			 menge:[aQueryResultRow objectAt:1]
			 summe:[aQueryResultRow objectAt:2]
			 proauftrag:[aQueryResultRow objectAt:3]
			 rabatt:[aQueryResultRow objectAt:4]
			 sonderpreis:[aQueryResultRow objectAt:5]
			 istsonderpreis:[aQueryResultRow objectAt:6]
			 istsumme:[aQueryResultRow objectAt:7]
			 gueltigvon:[aQueryResultRow objectAt:8]
			 gueltigbis:[aQueryResultRow objectAt:9]];
	
	[self addObject:newItem];
	
	return self;
}

- (BOOL)saveForKonditionen:kondNr
{
	if([self destroyForKonditionen:kondNr]) {
		int	i;
		for(i=0; i<[self count]; i++) {
			id	queryString = [QueryString str:"insert into subkonditionen values("];
			[queryString concatFieldComma:kondNr];
			[[self objectAt:i] appendFieldsToQueryString:queryString];
			[queryString concatSTR:")"];
			[[[NXApp defaultQuery] performQuery:queryString] free];
			[queryString free];
			if([[NXApp defaultQuery] lastError]!=NOERROR) return NO;
		}
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)destroyForKonditionen:kondNr
{
	id	queryString;
	queryString = [QueryString str:"delete from subkonditionen where nr="];
	[queryString concatField:kondNr];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];	
	return [[NXApp defaultQuery] lastError]==NOERROR;
}

- filterForKdkategorie:kdkategorie
{
	int	i;
	for(i = [self count]-1; i>=0; i--) {
		if(![[[self objectAt:i] kdkategorie] isEqual:kdkategorie]) {
			[[self removeObjectAt:i] free];
		}
	}
	return self;
}

- passeAnAnzahl:(int)anzahl vk:vk rabatt:rabatt umsatz:(double)umsatz gesamtanzahl:(int)gesamtanzahl
{
	int	found = -1;
	int	i, count = [self count];
	DEBUG4("  passeAnAnzahl:%d vk:%lf rabatt:%lf umsatz:%lf gesamtanzahl:%d\n",anzahl,[vk double],[rabatt double],umsatz,gesamtanzahl);
	for(i=0; i<count; i++) {
		[[self objectAt:i] calcNeuerpreisMitVk:[vk double]];
	}
	[self sort];
	found = -1;
	for(i=0; i<count && (found==-1); i++) {
		if([[self objectAt:i] passtAnzahl:anzahl umsatz:umsatz gesamtanzahl:gesamtanzahl]) {
			found = i;
		}
	}
	if(found != -1) {
		[[self objectAt:found] passeAnVk:vk rabatt:rabatt];
	}
	return self;
}

- (BOOL)needsUmsatz
{
	int		i, count = [self count];
	BOOL	result = NO;
	for(i=0; i<count && !result; i++) {
		result = [[self objectAt:i] needsUmsatz];
	}
	return result;
}

- (BOOL)needsGesamtanzahl
{
	int		i, count = [self count];
	BOOL	result = NO;
	for(i=0; i<count && !result; i++) {
		result = [[self objectAt:i] needsGesamtanzahl];
	}
	return result;
}

@end

#if 0
BEGIN TABLE DEFS

create table subkonditionen
(
	nr				varchar(8),
	kdkategorie		int,
	menge			int,
	summe			float,
	proauftrag		int,
	rabatt			float,
	sonderpreis		float,
	istsonderpreis	int,
	istsumme		int,
	gueltigvon		datetime,
	gueltigbis		datetime
)
create clustered index subkonditionenindex on subkonditionen(nr)
go			

END TABLE DEFS
#endif
