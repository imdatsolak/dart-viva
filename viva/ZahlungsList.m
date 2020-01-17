#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "ZahlungItem.h"

#import "ZahlungsList.h"

#pragma .h #import "SubItemList.h"

@implementation ZahlungsList:SubItemList
{
}

- initNew
{
	return [super initCount:0];
}

- initForRechnung:rechnungsNr
{
	id	queryString;

	queryString = [QueryString str:"select kundennr, buchungsnr, datum, betrag, rechnr, bemerkung from kundenkonto where betrag>=0 and rechnr="];
	[queryString concatField:rechnungsNr];
	[self initFromQuery:queryString];
	[queryString free];
	[self sort];
	
	return self;
}


- initForKunde:kundenNr
{
	id	queryString;

	queryString = [QueryString str:"select kundennr, buchungsnr, datum, betrag, rechnr, bemerkung from kundenkonto where kundennr="];
	[queryString concatField:kundenNr];
	[self initFromQuery:queryString];
	[queryString free];
	[self sort];
	
	return self;
}

- createItem:aQueryResultRow
{
	id	newItem = [ZahlungItem alloc];
	[newItem initKundennr:[aQueryResultRow objectAt:0]
			 buchungsnr:[aQueryResultRow objectAt:1]
			 datum:[aQueryResultRow objectAt:2]
			 betrag:[aQueryResultRow objectAt:3]
			 rechnr:[aQueryResultRow objectAt:4]
			 bemerkung:[aQueryResultRow objectAt:5]];
	[newItem setIsNew:NO];
	[self addObject:newItem];
	return self;
}

- (double)summeDouble
{
	double	d;
	int		i;
	for(i=0, d=0.0; i<[self count]; d += [[[self objectAt:i] betrag] double], i++);
	return d;
}

@end


#if 0
BEGIN TABLE DEFS

create table kundenkonto
(
	kundennr	varchar(15),
	buchungsnr	int,
	datum		datetime,
	betrag		float,
	rechnr		varchar(15),
	bemerkung	varchar(50)
)
create unique clustered index kundenkontoindex on kundenkonto(kundennr,buchungsnr)
create index kundenkontorechnrindex on kundenkonto(rechnr)
create table maxbuchung
(
	kundennr	varchar(15),
	maxnr		int
)
create unique clustered index maxbuchungindex on maxbuchung(kundennr)
go

END TABLE DEFS
#endif
