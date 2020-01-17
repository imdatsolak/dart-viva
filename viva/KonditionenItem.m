#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "SubkonditionenList.h"
#import "KonditionenItemList.h"
#import "TheApp.h"

#import "KonditionenItem.h"

#pragma .h #import "MasterItem.h"

@implementation KonditionenItem:MasterItem
{
	id	nr;
	id	kondname;
	id	bemerkung;
	id	adacta;
	id	subkonditionen;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from konditionen where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- itemListClass
{ return [KonditionenItemList class]; }

- initIdentity:identity
{
	id	queryResult, kondition;
	
	[self init];
	
	queryString = [QueryString str:"select nr, kondname, bemerkung, adacta from konditionen where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	kondition = [queryResult objectAt:0];
	if(kondition) {
		[self setNr:[kondition objectAt:0]];
		[self setKondname:[kondition objectAt:1]];
		[self setBemerkung:[kondition objectAt:2]];
		[self setAdacta:[kondition objectAt:3]];

		subkonditionen = [[SubkonditionenList alloc] initForKonditionen:nr];

		isNew = NO;
		[queryResult free];
		return self;
	} else {
		[queryResult free];
		return [self free];
	}
}


- initNew
{
	[self init];

	nr				= [String str:""];
	kondname		= [String str:""];
	bemerkung		= [String str:""];
	adacta			= [Integer int:0];
	subkonditionen	= [[SubkonditionenList alloc] initNew];
	return self;
}

- free
{
	[nr free];
	[kondname free];
	[bemerkung free];
	[adacta free];
	[subkonditionen free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	nr				= [nr copy];
	kondname		= [kondname copy];
	bemerkung		= [bemerkung copy];
	adacta			= [adacta copy];
	subkonditionen	= [subkonditionen copy];
	
	return theCopy;
}

- (BOOL)update
{
	queryString = [QueryString str:"update konditionen set "];
	[[queryString concatSTR:"kondname="] concatFieldComma:kondname];
	[[queryString concatSTR:"bemerkung="] concatFieldComma:bemerkung];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString]
		&& [subkonditionen saveForKonditionen:nr];
}

- (BOOL)insert
{
	queryString = [QueryString str:"insert into konditionen values("];
	[queryString concatFieldComma:nr];
	[queryString concatFieldComma:kondname];
	[queryString concatFieldComma:bemerkung];
	[queryString concatField:adacta];
	[queryString concatSTR:")"];
	
	return [self insertAndFreeQueryString]
		&& [subkonditionen saveForKonditionen:nr];
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from konditionen where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [subkonditionen destroyForKonditionen:nr];
}

- identity
{
	return [self nr];
}

- addSubkondition:anObject
{
	[subkonditionen addObject:[anObject copy]];
	[subkonditionen sort];
	return self;
}

- removeSubkonditionAt:(unsigned)i
{
	[[subkonditionen removeObjectAt:i] free];
	return self;
}

- filterForKdkategorie:kdkategorie
{
	[subkonditionen filterForKdkategorie:kdkategorie];
	return self;
}

- passeAnAnzahl:(int)anzahl vk:vk rabatt:rabatt umsatz:(double)umsatz gesamtanzahl:(int)gesamtanzahl
{
	[subkonditionen passeAnAnzahl:anzahl vk:vk rabatt:rabatt umsatz:umsatz gesamtanzahl:gesamtanzahl];
	return self;
}

- (BOOL)needsUmsatz
{
	return [subkonditionen needsUmsatz];
}

- (BOOL)needsGesamtanzahl
{
	return [subkonditionen needsGesamtanzahl];
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- kondname { return kondname; }
- setKondname:anObject { [kondname free]; kondname = [anObject copy]; return self; }
- bemerkung { return bemerkung; }
- setBemerkung:anObject { [bemerkung free]; bemerkung = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }
- subkonditionen { return subkonditionen; }
- setSubkonditionen:anObject { [subkonditionen free]; subkonditionen = [anObject copy]; return self; }

@end

#if 0
BEGIN TABLE DEFS

create table konditionen
(
	nr				varchar(8),
	kondname		varchar(30),
	bemerkung		text,
	adacta			tinyint
)
create unique clustered index konditionenindex on konditionen(nr)
go

END TABLE DEFS
#endif


