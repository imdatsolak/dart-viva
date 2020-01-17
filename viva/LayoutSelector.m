#import <appkit/Cell.h>
#import <appkit/Button.h>
#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "LayoutItem.h"
#import "LayoutItemList.h"
#import "LayoutDocument.h"
#import "LayoutSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation LayoutSelector:MasterSelector
{
	id	nrField;
	id	beschreibungField;
	id	kategorieSwitch;
	id	betreuerSwitch;
	id	beschreibungSwitch;

	id	nrStr;
	id	beschreibungStr;

	id	beschreibungSwitchState;
	id	kategorieSwitchState;
	id	betreuerSwitchState;
}
- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(beschreibungStr,String,beschreibungField);
	CREATESWITCHSTATE(beschreibungSwitchState,beschreibungSwitch);
	CREATESWITCHSTATE(kategorieSwitchState,kategorieSwitch);
	CREATESWITCHSTATE(betreuerSwitchState,betreuerSwitch);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[beschreibungStr free];
	[beschreibungSwitchState free];
	[kategorieSwitchState free];
	[betreuerSwitchState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	beschreibungStr = NXReadObject(typedStream);
	beschreibungSwitchState = NXReadObject(typedStream);
	kategorieSwitchState = NXReadObject(typedStream);
	betreuerSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,beschreibungStr);
	NXWriteObject(typedStream,beschreibungSwitchState);
	NXWriteObject(typedStream,kategorieSwitchState);
	NXWriteObject(typedStream,betreuerSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(beschreibungStr,beschreibungField);
	READFINDPANELSWITCH(beschreibungSwitchState,beschreibungSwitch);
	READFINDPANELSWITCH(kategorieSwitchState,kategorieSwitch);
	READFINDPANELSWITCH(betreuerSwitchState,betreuerSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(beschreibungStr,beschreibungField);
	WRITEFINDPANELSWITCH(beschreibungSwitchState,beschreibungSwitch);
	WRITEFINDPANELSWITCH(kategorieSwitchState,kategorieSwitch);
	WRITEFINDPANELSWITCH(betreuerSwitchState,betreuerSwitch);
	return self;
}

- performQuery
{
	id		aQueryResult, queryStr;
	
	queryStr = [QueryString str:"select nr Nr"];
	if([beschreibungSwitchState isTrue]) [queryStr concatSTR:",beschreibung Beschreibung"];
	if([kategorieSwitchState isTrue]) [queryStr concatSTR:", layoutkategorien.value Kategorie"];
	[queryStr concatSTR:" from layout"];
	if([kategorieSwitchState isTrue]) [queryStr concatSTR:", layoutkategorien"];
	[queryStr concatSTR:" where nr like "];
	[queryStr concatField:nrStr];
	[queryStr concatSTR:" and beschreibung like "];
	[queryStr concatField:beschreibungStr];
	if([kategorieSwitchState isTrue]) [queryStr concatSTR:" and kategorie=layoutkategorien.key"];

	aQueryResult = [[NXApp defaultQuery] performQuery:queryStr];
	
	[queryStr free];

	if(theEntryList) [theEntryList free];
	[self localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [LayoutDocument class]; }

- itemClass
{ return [LayoutItem class]; }

- itemListClass
{ return [LayoutItemList class]; }

- copyObjectIdentityAtRow:(int)row
{ return [[[theEntryList objectAt:row] objectWithTag:1] copy]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
