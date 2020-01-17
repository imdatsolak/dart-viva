#import <appkit/Button.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "BestellungsDocument.h"
#import "BestellungItemList.h"
#import "BestellungItem.h"
#import "BestellungsSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation BestellungsSelector:MasterSelector
{
	id	nrField;
	id	knrField;
	id	knameField;
	id	bestellMinField;
	id	bestellMaxField;
	id	summeMinField;
	id	summeMaxField;
	id	adactaRadio;
	
	id	nrSwitch;
	id	datumSwitch;
	id	knrSwitch;
	id	knameSwitch;
	id	betragSwitch;
	id	adactaSwitch;

	id	nrStr;
	id	knrStr;
	id	knameStr;
	id	bestellMinDate;
	id	bestellMaxDate;
	id	summeMinDouble;
	id	summeMaxDouble;
	id	adactaRadioState;
	
	id	nrSwitchState;
	id	datumSwitchState;
	id	knrSwitchState;
	id	knameSwitchState;
	id	betragSwitchState;
	id	adactaSwitchState;
}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(knrStr,String,knrField);
	CREATEFIELD(knameStr,String,knameField);
	CREATEFIELD(bestellMinDate,Date,bestellMinField);
	CREATEFIELD(bestellMaxDate,Date,bestellMaxField);
	CREATEFIELD(summeMinDouble,Double,summeMinField);
	CREATEFIELD(summeMaxDouble,Double,summeMaxField);
	CREATERADIOSTATE(adactaRadioState,adactaRadio);
	CREATESWITCHSTATE(nrSwitchState,nrSwitch);
	CREATESWITCHSTATE(datumSwitchState,datumSwitch);
	CREATESWITCHSTATE(knrSwitchState,knrSwitch);
	CREATESWITCHSTATE(knameSwitchState,knameSwitch);
	CREATESWITCHSTATE(betragSwitchState,betragSwitch);
	CREATESWITCHSTATE(adactaSwitchState,adactaSwitch);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[knrStr free];
	[knameStr free];
	[bestellMinDate free];
	[bestellMaxDate free];
	[summeMinDouble free];
	[summeMaxDouble free];
	[adactaRadioState free];
	[nrSwitchState free];
	[datumSwitchState free];
	[knrSwitchState free];
	[knameSwitchState free];
	[betragSwitchState free];
	[adactaSwitchState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	knrStr = NXReadObject(typedStream);
	knameStr = NXReadObject(typedStream);
	bestellMinDate = NXReadObject(typedStream);
	bestellMaxDate = NXReadObject(typedStream);
	summeMinDouble = NXReadObject(typedStream);
	summeMaxDouble = NXReadObject(typedStream);
	adactaRadioState = NXReadObject(typedStream);
	nrSwitchState = NXReadObject(typedStream);
	datumSwitchState = NXReadObject(typedStream);
	knrSwitchState = NXReadObject(typedStream);
	knameSwitchState = NXReadObject(typedStream);
	betragSwitchState = NXReadObject(typedStream);
	adactaSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,knrStr);
	NXWriteObject(typedStream,knameStr);
	NXWriteObject(typedStream,bestellMinDate);
	NXWriteObject(typedStream,bestellMaxDate);
	NXWriteObject(typedStream,summeMinDouble);
	NXWriteObject(typedStream,summeMaxDouble);
	NXWriteObject(typedStream,adactaRadioState);
	NXWriteObject(typedStream,nrSwitchState);
	NXWriteObject(typedStream,datumSwitchState);
	NXWriteObject(typedStream,knrSwitchState);
	NXWriteObject(typedStream,knameSwitchState);
	NXWriteObject(typedStream,betragSwitchState);
	NXWriteObject(typedStream,adactaSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(knrStr,knrField);
	READFINDPANELCELL(knameStr,knameField);
	READFINDPANELCELL(bestellMinDate,bestellMinField);
	READFINDPANELCELL(bestellMaxDate,bestellMaxField);
	READFINDPANELCELL(summeMinDouble,summeMinField);
	READFINDPANELCELL(summeMaxDouble,summeMaxField);
	READFINDPANELRADIO(adactaRadioState,adactaRadio);
	READFINDPANELSWITCH(nrSwitchState,nrSwitch);
	READFINDPANELSWITCH(datumSwitchState,datumSwitch);
	READFINDPANELSWITCH(knrSwitchState,knrSwitch);
	READFINDPANELSWITCH(knameSwitchState,knameSwitch);
	READFINDPANELSWITCH(betragSwitchState,betragSwitch);
	READFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(knrStr,knrField);
	WRITEFINDPANELCELL(knameStr,knameField);
	WRITEFINDPANELCELL(bestellMinDate,bestellMinField);
	WRITEFINDPANELCELL(bestellMaxDate,bestellMaxField);
	WRITEFINDPANELCELL(summeMinDouble,summeMinField);
	WRITEFINDPANELCELL(summeMaxDouble,summeMaxField);
	WRITEFINDPANELRADIO(adactaRadioState,adactaRadio);
	WRITEFINDPANELSWITCH(nrSwitchState,nrSwitch);
	WRITEFINDPANELSWITCH(datumSwitchState,datumSwitch);
	WRITEFINDPANELSWITCH(knrSwitchState,knrSwitch);
	WRITEFINDPANELSWITCH(knameSwitchState,knameSwitch);
	WRITEFINDPANELSWITCH(betragSwitchState,betragSwitch);
	WRITEFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	return self;
}

- performQuery
{
	id		aQueryResult, queryString;

	queryString = [QueryString str:"select bestellung.nr BestellungsNr"];
	if ([datumSwitchState isTrue]) [queryString concatSTR:",bestellung.datum Datum"];
	if ([knrSwitchState isTrue]) [queryString concatSTR:",bestellung.kundennr KundenNr"];
	if ([knameSwitchState isTrue]) [queryString concatSTR:",kunden.kname KundenName"];
	if ([betragSwitchState isTrue]) [queryString concatSTR:",bestellung.gesamtpreis Gesamtpreis"];
	if ([adactaSwitchState isTrue]) [queryString concatSTR:",bestellung.adacta adacta"];
	
	[queryString concatSTR:" from bestellung, kunden"];
	[queryString concatSTR:" where bestellung.nr like "];
	[queryString concatField:nrStr];
	[queryString concatSTR:" and bestellung.datum between "];
	[queryString concatField:bestellMinDate];
	[queryString concatSTR:" and "];
	[queryString concatField:bestellMaxDate];
	[queryString concatSTR:" and bestellung.kundennr like "];
	[queryString concatField:knrStr];
	[queryString concatSTR:" and kunden.kname like "];
	[queryString concatField:knameStr];
	[queryString concatSTR:" and kunden.nr =* bestellung.kundennr"];
	[queryString concatSTR:" and bestellung.gesamtpreis between "];
	[queryString concatField:summeMinDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:summeMaxDouble];
	switch([adactaRadioState int]) {
		case 0:
			[queryString concatSTR:" and bestellung.adacta=1"];
			break;
		case 1:
			[queryString concatSTR:" and bestellung.adacta=0"];
			break;
		default:
			break;
	}

	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];

	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [BestellungsDocument class]; }

- itemClass
{ return [BestellungItem class]; }

- itemListClass
{ return [BestellungItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
