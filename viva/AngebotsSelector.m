#import <appkit/Button.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "AngebotsDocument.h"
#import "AngebotItemList.h"
#import "AngebotItem.h"
#import "AngebotsSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation AngebotsSelector:MasterSelector
{
	id	nrField;
	id	knrField;
	id	knameField;
	id	angebotMinField;
	id	angebotMaxField;
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
	id	angebotMinDate;
	id	angebotMaxDate;
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
	CREATEFIELD(angebotMinDate,Date,angebotMinField);
	CREATEFIELD(angebotMaxDate,Date,angebotMaxField);
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

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,knrStr);
	NXWriteObject(typedStream,knameStr);
	NXWriteObject(typedStream,angebotMinDate);
	NXWriteObject(typedStream,angebotMaxDate);
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

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	knrStr = NXReadObject(typedStream);
	knameStr = NXReadObject(typedStream);
	angebotMinDate = NXReadObject(typedStream);
	angebotMaxDate = NXReadObject(typedStream);
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

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(knrStr,knrField);
	WRITEFINDPANELCELL(knameStr,knameField);
	WRITEFINDPANELCELL(angebotMinDate,angebotMinField);
	WRITEFINDPANELCELL(angebotMaxDate,angebotMaxField);
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

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(knrStr,knrField);
	READFINDPANELCELL(knameStr,knameField);
	READFINDPANELCELL(angebotMinDate,angebotMinField);
	READFINDPANELCELL(angebotMaxDate,angebotMaxField);
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

- performQuery
{
	id		aQueryResult, queryString;

	queryString = [QueryString str:"select angebot.nr AngebotsNr"];
	if ([datumSwitchState isTrue]) [queryString concatSTR:",angebot.datum Datum"];
	if ([knrSwitchState isTrue]) [queryString concatSTR:",angebot.kundennr KundenNr"];
	if ([knameSwitchState isTrue]) [queryString concatSTR:",kunden.kname KundenName"];
	if ([betragSwitchState isTrue]) [queryString concatSTR:",angebot.gesamtpreis Gesamtpreis"];
	if ([adactaSwitchState isTrue]) [queryString concatSTR:",janein.bool adacta"];
	
	[queryString concatSTR:" from angebot, kunden"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:",janein"];
	[queryString concatSTR:" where angebot.nr like "];
	[queryString concatField:nrStr];
	[queryString concatSTR:" and angebot.datum between "];
	[queryString concatField:angebotMinDate];
	[queryString concatSTR:" and "];
	[queryString concatField:angebotMaxDate];
	[queryString concatSTR:" and angebot.kundennr like "];
	[queryString concatField:knrStr];
	[queryString concatSTR:" and kunden.kname like "];
	[queryString concatField:knameStr];
	[queryString concatSTR:" and kunden.nr=*angebot.kundennr"];
	[queryString concatSTR:" and angebot.gesamtpreis between "];
	[queryString concatField:summeMinDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:summeMaxDouble];
	switch([adactaRadioState int]) {
		case 0:
			[queryString concatSTR:" and angebot.adacta=1"];
			break;
		case 1:
			[queryString concatSTR:" and angebot.adacta=0"];
			break;
		default:
			break;
	}
	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:" and angebot.adacta*=janein.i"];
	}

	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];

	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [AngebotsDocument class]; }

- itemClass
{ return [AngebotItem class]; }

- itemListClass
{ return [AngebotItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
