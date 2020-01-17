#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "AddressItem.h"

#import "AddressList.h"

#pragma .h #import "SubItemList.h"

@implementation AddressList:SubItemList
{
}

- initNewCount:(unsigned)numSlots
{
	int	i;
	[super initCount:numSlots];
	for(i=0; i<numSlots; i++) {
		[self addObject:[[AddressItem alloc] initNewPosition:i]];
	}
	[self sort];
	return self;
}

- initForAngebot:angebotsNr
{
	return [self initAndLoad:"AN" for:angebotsNr];
}

- initForAuftrag:auftragsNr
{
	return [self initAndLoad:"AU" for:auftragsNr];
}

- initForKunde:kundenNr
{
	return [self initAndLoad:"KU" for:kundenNr];
}

- initForBestellung:bestellNr
{
	return [self initAndLoad:"BE" for:bestellNr];
}


- initAndLoad:(const char *)what for:which
{
	id	queryString;

	queryString = [QueryString str:"select position, name1, name2, name3, strasse, plzort, landnr, tel, fax, telex, email from adressen where class=\""];
	[queryString concatSTR:what];
	[queryString concatSTR:"\" and id="];
	[queryString concatField:which];
	[self initFromQuery:queryString];
	[queryString free];
	[self sort];
	
	return self;
}


- createItem:aQueryResultRow
{
	id	newItem = [AddressItem alloc];
	
	[newItem initPosition:[aQueryResultRow objectAt:0]
			 name1:[aQueryResultRow objectAt:1]
			 name2:[aQueryResultRow objectAt:2]
			 name3:[aQueryResultRow objectAt:3]
			 strasse:[aQueryResultRow objectAt:4]
			 plzort:[aQueryResultRow objectAt:5]
			 landnr:[aQueryResultRow objectAt:6]
			 tel:[aQueryResultRow objectAt:7]
			 fax:[aQueryResultRow objectAt:8]
			 telex:[aQueryResultRow objectAt:9]
			 email:[aQueryResultRow objectAt:10]];
	
	[self addObject:newItem];
	
	return self;
}

- (BOOL)saveForAngebot:angebotsNr
{
	return [self save:"AN" for:angebotsNr];
}

- (BOOL)saveForAuftrag:auftragsNr
{
	return [self save:"AU" for:auftragsNr];
}

- (BOOL)saveForKunde:kundenNr
{
	return [self save:"KU" for:kundenNr];
}

- (BOOL)saveForBestellung:bestellNr
{
	return [self save:"BE" for:bestellNr];
}

- (BOOL)save:(const char *)which for:what
{
	[self renumber];
	if([self destroy:which for:what]) {
		int	i;
		for(i=0; i<[self count]; i++) {
			id	queryString = [QueryString str:"insert into adressen values(\""];
			[queryString concatSTR:which];
			[queryString concatSTR:"\","];
			[queryString concatFieldComma:what];
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


- (BOOL)destroyForAngebot:angebotsNr
{
	return [self destroy:"AN" for:angebotsNr];
}

- (BOOL)destroyForAuftrag:auftragsNr
{
	return [self destroy:"AU" for:auftragsNr];
}


- (BOOL)destroyForKunde:kundenNr
{
	return [self destroy:"KU" for:kundenNr];
}

- (BOOL)destroyForBestellung:bestellNr
{
	return [self destroy:"BE" for:bestellNr];
}

- (BOOL)destroy:(const char *)which for:what
{
	
	id	queryString;
	queryString = [QueryString str:"delete from adressen where class=\""];
	[queryString concatSTR:which];
	[queryString concatSTR:"\" and id="];
	[queryString concatField:what];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	
	return [[NXApp defaultQuery] lastError]==NOERROR;
}

- renumber
{
	int	i, count = [self count];
	for(i=0; i<count; i++) {
		[[[self objectAt:i] position] setInt:i+1];
	}
	return self;
}


@end

#if 0
BEGIN TABLE DEFS

create table adressen
(
	class		char(2),
	id			varchar(30),
	position	int,
	name1		varchar(50),
	name2		varchar(50),
	name3		varchar(50),
	strasse		varchar(50),
	plzort		varchar(60),
	landnr		int,
	tel			varchar(25),
	fax			varchar(25),
	telex		varchar(25),
	email		varchar(50)
)
go
create unique clustered index adressenindex on adressen(class,id,position)
go			

END TABLE DEFS
#endif
