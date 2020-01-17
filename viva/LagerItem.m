#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "AddressItem.h"
#import "ArtikelItem.h"
#import "LagerChecker.h"
#import "LagerItemList.h"
#import "TableManager.h"
#import "TheApp.h"
#import "UserManager.h"

#import "LagerItem.h"

#pragma .h #import "MasterItem.h"

@implementation LagerItem:MasterItem
{
	id	nr;
	id	lname;
	id	betreuernr;
	id	adacta;
}


+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from lager where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- itemListClass
{ return [LagerItemList class]; }

- initIdentity:identity
{
	id	queryResult, lager;
	
	[self init];
	
	queryString = [QueryString str:"select nr, lname, betreuernr, adacta from lager where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	lager = [queryResult objectAt:0];
	if(lager) {
		[self setNr:[lager objectAt:0]];
		[self setLname:[lager objectAt:1]];
		[self setBetreuernr:[lager objectAt:2]];
		[self setAdacta:[lager objectAt:3]];

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
	lname			= [String str:""];
	betreuernr		= [[[NXApp userMgr] currentUserID] copy];
	adacta			= [Integer int:0];
	return self;
}


- free
{
	[nr free];
	[lname free];
	[betreuernr free];
	[adacta free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	nr				= [nr copy];
	lname			= [lname copy];
	betreuernr		= [betreuernr copy];
	adacta			= [adacta copy];
	
	return theCopy;
}


- (BOOL)update
{
	queryString = [QueryString str:"update lager set "];
	[[queryString concatSTR:"nr="] concatFieldComma:nr];
	[[queryString concatSTR:"lname="] concatFieldComma:lname];
	[[queryString concatSTR:"betreuernr="] concatFieldComma:betreuernr];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString];
}

- (BOOL)insert
{
	queryString = [QueryString str:"insert into lager values("];
	[queryString concatFieldComma:nr];
	[queryString concatFieldComma:lname];
	[queryString concatSTR:"\"\","];
	[queryString concatFieldComma:betreuernr];
	[queryString concatField:adacta];
	[queryString concatSTR:")"];
	
	return [self insertAndFreeQueryString];
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from lager where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString];
}

- identity
{
	return [self nr];
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- lname { return lname; }
- setLname:anObject { [lname free]; lname = [anObject copy]; return self; }
- betreuernr { return betreuernr; }
- setBetreuernr:anObject { [betreuernr free]; betreuernr = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }

@end

#if 0
BEGIN TABLE DEFS

create table lager
(
	nr				varchar(15),
	lname			varchar(50),
	standort		text,
	betreuernr		int,
	adacta			tinyint
)
create unique clustered index lagerindex on lager(nr)
create table lagerartikel
(
	lagernr	varchar(15),
	artnr	varchar(30),
	anzahl	int
)
create unique clustered index lagerartikelindex on lagerartikel(lagernr, artnr)
create index lagerartikelartikelindex on lagerartikel(artnr)
go
create view lagerpopupview(key,value) as select nr, nr from lager
go
END TABLE DEFS
#endif


