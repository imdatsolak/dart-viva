#import "dart/querykit.h"

#import "TheApp.h"
#import "BankItemList.h"

#import "BankItem.h"

#pragma .h #import "MasterItem.h"

@implementation BankItem:MasterItem
{
	id	blz;
	id	kurzBezeichnung;
	id	bezeichnung;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select blz from banken where blz="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- itemListClass
{ return [BankItemList class]; }

- initIdentity:identity
{
	id	queryResult, bank;

	[self init];
	
	queryString = [QueryString str:"select blz, kurzbezeichnung, bezeichnung from banken where blz="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	bank = [queryResult objectAt:0];
	if(bank) {
		[self setBlz:[bank objectAt:0]];
		[self setKurzBezeichnung:[bank objectAt:1]];
		[self setBezeichnung:[bank objectAt:2]];
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
	
	blz				= [String str:""];
	kurzBezeichnung	= [String str:""];
	bezeichnung		= [String str:""];
	
	return self;
}


- free
{
	[blz free];
	[kurzBezeichnung free];
	[bezeichnung free];
	
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	blz				= [blz copy];
	kurzBezeichnung	= [kurzBezeichnung copy];
	bezeichnung		= [bezeichnung copy];
	
	return theCopy;
}


- (BOOL)update
{
	queryString = [QueryString str:"update banken set "];
	[[queryString concatSTR:"kurzbezeichnung="] concatFieldComma:kurzBezeichnung];
	[[queryString concatSTR:"bezeichnung="] concatField:bezeichnung];
	[[queryString concatSTR:" where blz="] concatField:blz];
	
	return [self updateAndFreeQueryString];
}

- (BOOL)insert
{
	queryString = [QueryString str:"insert into banken values("];
	[queryString concatFieldComma:blz];
	[queryString concatFieldComma:kurzBezeichnung];
	[queryString concatField:bezeichnung];
	[queryString concatSTR:")"];
	
	return [self insertAndFreeQueryString];
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from banken where blz="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString];
}

- identity
{
	return [self blz];
}


- blz
{ return blz; }
- setBlz:anObject
{ [blz free]; blz = [anObject copy]; return self; }

- kurzBezeichnung
{ return kurzBezeichnung; }
- setKurzBezeichnung:anObject
{ [kurzBezeichnung free]; kurzBezeichnung = [anObject copy]; return self; }

- bezeichnung
{ return bezeichnung; }
- setBezeichnung:anObject
{ [bezeichnung free]; bezeichnung = [anObject copy]; return self; }


@end

#if 0
BEGIN TABLE DEFS
create table banken
(
	blz	varchar(15),
	kurzbezeichnung	varchar(10),
	bezeichnung	varchar(50)
)
create unique clustered index bankenindex on banken(blz)
go

END TABLE DEFS
#endif



