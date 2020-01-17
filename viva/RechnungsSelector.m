#import <appkit/Button.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "RechnungsDocument.h"
#import "RechnungItemList.h"
#import "RechnungItem.h"

#import "RechnungsSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation RechnungsSelector:MasterSelector
{
	id	nrField;
	id	aufnrField;
	id	kundennrField;
	id	kundennameField;
	id	datumMinField;
	id	datumMaxField;
	id	mahnMinField;
	id	mahnMaxField;
	id	nettoMinField;
	id	nettoMaxField;
	
	id	bezahltRadio;
	id	storniertRadio;
	id	adactaRadio;
	
	id	nrSwitch;
	id	datumSwitch;
	id	kundennrSwitch;
	id	kundennameSwitch;
	id	aufnrSwitch;
	id	nettoSwitch;
	id	mwstSwitch;
	id	bruttoSwitch;
	id	adactaSwitch;
	id	bezahltSwitch;
	id	storniertSwitch;

	id	nrStr;
	id	aufnrStr;
	id	kundennrStr;
	id	kundennameStr;
	id	datumMinDate;
	id	datumMaxDate;
	id	mahnMinInt;
	id	mahnMaxInt;
	id	nettoMinDouble;
	id	nettoMaxDouble;
	
	id	bezahltRadioState;
	id	storniertRadioState;
	id	adactaRadioState;
	
	id	nrSwitchState;
	id	datumSwitchState;
	id	kundennrSwitchState;
	id	kundennameSwitchState;
	id	aufnrSwitchState;
	id	nettoSwitchState;
	id	mwstSwitchState;
	id	bruttoSwitchState;
	id	adactaSwitchState;
	id	bezahltSwitchState;
	id	storniertSwitchState;
}

- init
{
	[super init];
	CREATEFIELD(nrStr, String, nrField);
	CREATEFIELD(aufnrStr, String, aufnrField);
	CREATEFIELD(kundennrStr, String, kundennrField);
	CREATEFIELD(kundennameStr, String, kundennameField);
	CREATEFIELD(datumMinDate, Date, datumMinField);
	CREATEFIELD(datumMaxDate, Date, datumMaxField);
	CREATEFIELD(mahnMinInt, Integer, mahnMinField);
	CREATEFIELD(mahnMaxInt, Integer, mahnMaxField);
	CREATEFIELD(nettoMinDouble, Double, nettoMinField);
	CREATEFIELD(nettoMaxDouble, Double, nettoMaxField);
	
	CREATERADIOSTATE(bezahltRadioState, bezahltRadio);
	CREATERADIOSTATE(storniertRadioState, storniertRadio);
	CREATERADIOSTATE(adactaRadioState, adactaRadio);

	CREATESWITCHSTATE(nrSwitchState, nrSwitch);
	CREATESWITCHSTATE(datumSwitchState, datumSwitch);
	CREATESWITCHSTATE(kundennrSwitchState, kundennrSwitch);
	CREATESWITCHSTATE(kundennameSwitchState, kundennameSwitch);
	CREATESWITCHSTATE(aufnrSwitchState, aufnrSwitch);
	CREATESWITCHSTATE(nettoSwitchState, nettoSwitch);
	CREATESWITCHSTATE(mwstSwitchState, mwstSwitch);
	CREATESWITCHSTATE(bruttoSwitchState, bruttoSwitch);
	CREATESWITCHSTATE(adactaSwitchState, adactaSwitch);
	CREATESWITCHSTATE(bezahltSwitchState, bezahltSwitch);
	CREATESWITCHSTATE(storniertSwitchState, storniertSwitch);
	[self writeFindPanel];

	return self;
}

- free
{
	[nrStr free];
	[aufnrStr free];
	[kundennrStr free];
	[kundennameStr free];
	[datumMinDate free];
	[datumMaxDate free];
	[mahnMinInt free];
	[mahnMaxInt free];
	[nettoMinDouble free];
	[nettoMaxDouble free];
	[bezahltRadioState free];
	[storniertRadioState free];
	[adactaRadioState free];
	[nrSwitchState free];
	[datumSwitchState free];
	[kundennrSwitchState free];
	[kundennameSwitchState free];
	[aufnrSwitchState free];
	[nettoSwitchState free];
	[mwstSwitchState free];
	[bruttoSwitchState free];
	[adactaSwitchState free];
	[bezahltSwitchState free];
	[storniertSwitchState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	aufnrStr = NXReadObject(typedStream);
	kundennrStr = NXReadObject(typedStream);
	kundennameStr = NXReadObject(typedStream);
	datumMinDate = NXReadObject(typedStream);
	datumMaxDate = NXReadObject(typedStream);
	mahnMinInt = NXReadObject(typedStream);
	mahnMaxInt = NXReadObject(typedStream);
	nettoMinDouble = NXReadObject(typedStream);
	nettoMaxDouble = NXReadObject(typedStream);
	bezahltRadioState = NXReadObject(typedStream);
	storniertRadioState = NXReadObject(typedStream);
	adactaRadioState = NXReadObject(typedStream);
	nrSwitchState = NXReadObject(typedStream);
	datumSwitchState = NXReadObject(typedStream);
	kundennrSwitchState = NXReadObject(typedStream);
	kundennameSwitchState = NXReadObject(typedStream);
	aufnrSwitchState = NXReadObject(typedStream);
	nettoSwitchState = NXReadObject(typedStream);
	mwstSwitchState = NXReadObject(typedStream);
	bruttoSwitchState = NXReadObject(typedStream);
	adactaSwitchState = NXReadObject(typedStream);
	bezahltSwitchState = NXReadObject(typedStream);
	storniertSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,aufnrStr);
	NXWriteObject(typedStream,kundennrStr);
	NXWriteObject(typedStream,kundennameStr);
	NXWriteObject(typedStream,datumMinDate);
	NXWriteObject(typedStream,datumMaxDate);
	NXWriteObject(typedStream,mahnMinInt);
	NXWriteObject(typedStream,mahnMaxInt);
	NXWriteObject(typedStream,nettoMinDouble);
	NXWriteObject(typedStream,nettoMaxDouble);
	NXWriteObject(typedStream,bezahltRadioState);
	NXWriteObject(typedStream,storniertRadioState);
	NXWriteObject(typedStream,adactaRadioState);
	NXWriteObject(typedStream,nrSwitchState);
	NXWriteObject(typedStream,datumSwitchState);
	NXWriteObject(typedStream,kundennrSwitchState);
	NXWriteObject(typedStream,kundennameSwitchState);
	NXWriteObject(typedStream,aufnrSwitchState);
	NXWriteObject(typedStream,nettoSwitchState);
	NXWriteObject(typedStream,mwstSwitchState);
	NXWriteObject(typedStream,bruttoSwitchState);
	NXWriteObject(typedStream,adactaSwitchState);
	NXWriteObject(typedStream,bezahltSwitchState);
	NXWriteObject(typedStream,storniertSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(aufnrStr,aufnrField);
	READFINDPANELCELL(kundennrStr,kundennrField);
	READFINDPANELCELL(kundennameStr,kundennameField);
	READFINDPANELCELL(datumMinDate,datumMinField);
	READFINDPANELCELL(datumMaxDate,datumMaxField);
	READFINDPANELCELL(mahnMinInt,mahnMinField);
	READFINDPANELCELL(mahnMaxInt,mahnMaxField);
	READFINDPANELCELL(nettoMinDouble,nettoMinField);
	READFINDPANELCELL(nettoMaxDouble,nettoMaxField);
	READFINDPANELRADIO(bezahltRadioState,bezahltRadio);
	READFINDPANELRADIO(storniertRadioState,storniertRadio);
	READFINDPANELRADIO(adactaRadioState,adactaRadio);
	READFINDPANELSWITCH(nrSwitchState,nrSwitch);
	READFINDPANELSWITCH(datumSwitchState,datumSwitch);
	READFINDPANELSWITCH(kundennrSwitchState,kundennrSwitch);
	READFINDPANELSWITCH(kundennameSwitchState,kundennameSwitch);
	READFINDPANELSWITCH(aufnrSwitchState,aufnrSwitch);
	READFINDPANELSWITCH(nettoSwitchState,nettoSwitch);
	READFINDPANELSWITCH(mwstSwitchState,mwstSwitch);
	READFINDPANELSWITCH(bruttoSwitchState,bruttoSwitch);
	READFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	READFINDPANELSWITCH(bezahltSwitchState,bezahltSwitch);
	READFINDPANELSWITCH(storniertSwitchState,storniertSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(aufnrStr,aufnrField);
	WRITEFINDPANELCELL(kundennrStr,kundennrField);
	WRITEFINDPANELCELL(kundennameStr,kundennameField);
	WRITEFINDPANELCELL(datumMinDate,datumMinField);
	WRITEFINDPANELCELL(datumMaxDate,datumMaxField);
	WRITEFINDPANELCELL(mahnMinInt,mahnMinField);
	WRITEFINDPANELCELL(mahnMaxInt,mahnMaxField);
	WRITEFINDPANELCELL(nettoMinDouble,nettoMinField);
	WRITEFINDPANELCELL(nettoMaxDouble,nettoMaxField);
	WRITEFINDPANELRADIO(bezahltRadioState,bezahltRadio);
	WRITEFINDPANELRADIO(storniertRadioState,storniertRadio);
	WRITEFINDPANELRADIO(adactaRadioState,adactaRadio);
	WRITEFINDPANELSWITCH(nrSwitchState,nrSwitch);
	WRITEFINDPANELSWITCH(datumSwitchState,datumSwitch);
	WRITEFINDPANELSWITCH(kundennrSwitchState,kundennrSwitch);
	WRITEFINDPANELSWITCH(kundennameSwitchState,kundennameSwitch);
	WRITEFINDPANELSWITCH(aufnrSwitchState,aufnrSwitch);
	WRITEFINDPANELSWITCH(nettoSwitchState,nettoSwitch);
	WRITEFINDPANELSWITCH(mwstSwitchState,mwstSwitch);
	WRITEFINDPANELSWITCH(bruttoSwitchState,bruttoSwitch);
	WRITEFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	WRITEFINDPANELSWITCH(bezahltSwitchState,bezahltSwitch);
	WRITEFINDPANELSWITCH(storniertSwitchState,storniertSwitch);
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
	
	queryString = [QueryString str:"select rechnung.nr RechnungsNr"];
	if([datumSwitchState isTrue]) [queryString concatSTR:",rechnung.datum Datum"];
	if([kundennrSwitchState isTrue]) [queryString concatSTR:", auftrag.kundennr KundenNr"];
	if([kundennameSwitchState isTrue]) [queryString concatSTR:",kunden.kname Kundenname"];
	if([aufnrSwitchState isTrue]) [queryString concatSTR:",auftrag.nr AuftragsNr"];
	if([nettoSwitchState isTrue]) [queryString concatSTR:",rechnung.netto Nettobetrag"];
	if([mwstSwitchState isTrue]) [queryString concatSTR:",rechnung.mwst MwSt"];
	if([bruttoSwitchState isTrue]) [queryString concatSTR:",rechnung.netto+rechnung.mwst Bruttobetrag"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:",janein1.bool adacta"];
	if([bezahltSwitchState isTrue]) [queryString concatSTR:",janein2.bool bezahlt"];
	if([storniertSwitchState isTrue]) [queryString concatSTR:",janein3.bool storniert"];
	
	[queryString concatSTR:" from rechnung, auftrag, kunden"];
	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:", janein janein1"];
	}
	if([bezahltSwitchState isTrue]) {
		[queryString concatSTR:", janein janein2"];
	}
	if([storniertSwitchState isTrue]) {
		[queryString concatSTR:", janein janein3"];
	}
	
	[queryString concatSTR:" where rechnung.nr like "];
	[queryString concatField:nrStr];
	
	[queryString concatSTR:" and auftrag.nr like "];
	[queryString concatField:aufnrStr];
	
	[queryString concatSTR:" and auftrag.kundennr like "];
	[queryString concatField:kundennrStr];
	
	[queryString concatSTR:" and kunden.kname like "];
	[queryString concatField:kundennameStr];
	
	[queryString concatSTR:" and rechnung.datum between "];
	[queryString concatField:datumMinDate];
	[queryString concatSTR:" and "];
	[queryString concatField:datumMaxDate];
	
	[queryString concatSTR:" and rechnung.mahnstufe between "];
	[queryString concatField:mahnMinInt];
	[queryString concatSTR:" and "];
	[queryString concatField:mahnMaxInt];

	[queryString concatSTR:" and rechnung.netto between "];
	[queryString concatField:nettoMinDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:nettoMaxDouble];
	
	switch([bezahltRadioState int]) {
		case 0:
			[queryString concatSTR:" and rechnung.bezahlt=1"];
			break;
		case 1:
			[queryString concatSTR:" and rechnung.bezahlt=0"];
			break;
		default:
			break;
	}

	switch([adactaRadioState int]) {
		case 0:
			[queryString concatSTR:" and rechnung.adacta=1"];
			break;
		case 1:
			[queryString concatSTR:" and rechnung.adacta=0"];
			break;
		default:
			break;
	}

	switch([storniertRadioState int]) {
		case 0:
			[queryString concatSTR:" and rechnung.storniert=1"];
			break;
		case 1:
			[queryString concatSTR:" and rechnung.storniert=0"];
			break;
		default:
			break;
	}


	[queryString concatSTR:" and rechnung.aufnr=auftrag.nr"];	
	[queryString concatSTR:" and auftrag.kundennr*=kunden.nr"];	

	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:" and janein.i=*rechnung.adacta"];
	}
	if([bezahltSwitchState isTrue]) {
		[queryString concatSTR:" and janein2.i=*rechnung.bezahlt"];
	}
	if([storniertSwitchState isTrue]) {
		[queryString concatSTR:" and janein3.i=*rechnung.storniert"];
	}
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];

	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [RechnungsDocument class]; }

- itemClass
{ return [RechnungItem class]; }

- itemListClass
{ return [RechnungItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

- checkMenus
{
	[super checkMenus];
	[[NXApp destroyButton] setEnabled: NO];
	[[NXApp newButton] setEnabled: NO];
	return self;
}
@end
