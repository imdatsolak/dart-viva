#import <stdlib.h>

#import <appkit/Cell.h>
#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "LagerVorgangsItemList.h"
#import "LagerVorgangsSelector.h"

#pragma .h #import "MasterSelector.h"


@implementation LagerVorgangsSelector:MasterSelector
{
	id	lagernrField;
	id	artikelnrField;
	id	datumMinField;
	id	datumMaxField;
	
	id	lagernrStr;
	id	artikelnrStr;
	id	datumMinDate;
	id	datumMaxDate;
}

- init
{
	[super init];
	CREATEFIELD(lagernrStr,String,lagernrField);
	CREATEFIELD(artikelnrStr,String,artikelnrField);
	CREATEFIELD(datumMinDate,Date,datumMinField);
	CREATEFIELD(datumMaxDate,Date,datumMaxField);
	[self writeFindPanel];
	return self;
}

- free
{
	[lagernrStr free];
	[artikelnrStr free];
	[datumMinDate free];
	[datumMaxDate free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	lagernrStr = NXReadObject(typedStream);
	artikelnrStr = NXReadObject(typedStream);
	datumMinDate = NXReadObject(typedStream);
	datumMaxDate = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,lagernrStr);
	NXWriteObject(typedStream,artikelnrStr);
	NXWriteObject(typedStream,datumMinDate);
	NXWriteObject(typedStream,datumMaxDate);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(lagernrStr,lagernrField);
	READFINDPANELCELL(artikelnrStr,artikelnrField);
	READFINDPANELCELL(datumMinDate,datumMinField);
	READFINDPANELCELL(datumMaxDate,datumMaxField);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(lagernrStr,lagernrField);
	WRITEFINDPANELCELL(artikelnrStr,artikelnrField);
	WRITEFINDPANELCELL(datumMinDate,datumMinField);
	WRITEFINDPANELCELL(datumMaxDate,datumMaxField);
	return self;
}

- performQuery
{
	id	aQueryResult, queryStr;

	queryStr = [QueryString str:"select datum Datum,lagernummer Lager,artikelnr ArtikelNr,anzahl Anzahl,kommentar Kommentar, benutzerpopupview.value Betreuer from lagervorgang, benutzerpopupview where lagernummer like "];
	[queryStr concatField:lagernrStr];
	[queryStr concatSTR:" and artikelnr like "];
	[queryStr concatField:artikelnrStr];
	[queryStr concatSTR:" and datum between "];
	[queryStr concatField:datumMinDate];
	[queryStr concatSTR:" and "];
	[queryStr concatField:datumMaxDate];
	[queryStr concatSTR:" and benutzerpopupview.key =* lagervorgang.benutzernr"];
	aQueryResult = [[NXApp defaultQuery] performQuery:queryStr];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}


- documentClass
{ return nil; }

- itemClass
{ return [self class]; }

- itemListClass
{ return [LagerVorgangsItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
