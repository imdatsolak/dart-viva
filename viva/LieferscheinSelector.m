#import <appkit/Button.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "LieferscheinDocument.h"
#import "LieferscheinItemList.h"
#import "LieferscheinItem.h"

#import "LieferscheinSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation LieferscheinSelector:MasterSelector
{
	id	nrField;
	id	aufnrField;
	id	kundennrField;
	id	kundennameField;
	id	datumMinField;
	id	datumMaxField;
	
	id	geliefertRadio;
	id	storniertRadio;
	id	adactaRadio;
	
	id	nrSwitch;
	id	datumSwitch;
	id	kundennrSwitch;
	id	kundennameSwitch;
	id	aufnrSwitch;
	id	adactaSwitch;
	id	geliefertSwitch;
	id	storniertSwitch;
	
	id	nrStr;
	id	aufnrStr;
	id	kundennrStr;
	id	kundennameStr;
	id	datumMinDate;
	id	datumMaxDate;
	
	id	geliefertRadioState;
	id	storniertRadioState;
	id	adactaRadioState;
	
	id	nrSwitchState;
	id	datumSwitchState;
	id	kundennrSwitchState;
	id	kundennameSwitchState;
	id	aufnrSwitchState;
	id	adactaSwitchState;
	id	geliefertSwitchState;
	id	storniertSwitchState;
}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(aufnrStr,String,aufnrField);
	CREATEFIELD(kundennrStr,String,kundennrField);
	CREATEFIELD(kundennameStr,String,kundennameField);
	CREATEFIELD(datumMinDate,Date,datumMinField);
	CREATEFIELD(datumMaxDate,Date,datumMaxField);
	CREATERADIOSTATE(geliefertRadioState,geliefertRadio);
	CREATERADIOSTATE(storniertRadioState,storniertRadio);
	CREATERADIOSTATE(adactaRadioState,adactaRadio);
	CREATESWITCHSTATE(nrSwitchState,nrSwitch);
	CREATESWITCHSTATE(datumSwitchState,datumSwitch);
	CREATESWITCHSTATE(kundennrSwitchState,kundennrSwitch);
	CREATESWITCHSTATE(kundennameSwitchState,kundennameSwitch);
	CREATESWITCHSTATE(aufnrSwitchState,aufnrSwitch);
	CREATESWITCHSTATE(adactaSwitchState,adactaSwitch);
	CREATESWITCHSTATE(geliefertSwitchState,geliefertSwitch);
	CREATESWITCHSTATE(storniertSwitchState,storniertSwitch);
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
	[geliefertRadioState free];
	[storniertRadioState free];
	[adactaRadioState free];
	[nrSwitchState free];
	[datumSwitchState free];
	[kundennrSwitchState free];
	[kundennameSwitchState free];
	[aufnrSwitchState free];
	[adactaSwitchState free];
	[geliefertSwitchState free];
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
	geliefertRadioState = NXReadObject(typedStream);
	storniertRadioState = NXReadObject(typedStream);
	adactaRadioState = NXReadObject(typedStream);
	nrSwitchState = NXReadObject(typedStream);
	datumSwitchState = NXReadObject(typedStream);
	kundennrSwitchState = NXReadObject(typedStream);
	kundennameSwitchState = NXReadObject(typedStream);
	aufnrSwitchState = NXReadObject(typedStream);
	adactaSwitchState = NXReadObject(typedStream);
	geliefertSwitchState = NXReadObject(typedStream);
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
	NXWriteObject(typedStream,geliefertRadioState);
	NXWriteObject(typedStream,storniertRadioState);
	NXWriteObject(typedStream,adactaRadioState);
	NXWriteObject(typedStream,nrSwitchState);
	NXWriteObject(typedStream,datumSwitchState);
	NXWriteObject(typedStream,kundennrSwitchState);
	NXWriteObject(typedStream,kundennameSwitchState);
	NXWriteObject(typedStream,aufnrSwitchState);
	NXWriteObject(typedStream,adactaSwitchState);
	NXWriteObject(typedStream,geliefertSwitchState);
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
	READFINDPANELRADIO(geliefertRadioState,geliefertRadio);
	READFINDPANELRADIO(storniertRadioState,storniertRadio);
	READFINDPANELRADIO(adactaRadioState,adactaRadio);
	READFINDPANELSWITCH(nrSwitchState,nrSwitch);
	READFINDPANELSWITCH(datumSwitchState,datumSwitch);
	READFINDPANELSWITCH(kundennrSwitchState,kundennrSwitch);
	READFINDPANELSWITCH(kundennameSwitchState,kundennameSwitch);
	READFINDPANELSWITCH(aufnrSwitchState,aufnrSwitch);
	READFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	READFINDPANELSWITCH(geliefertSwitchState,geliefertSwitch);
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
	WRITEFINDPANELRADIO(geliefertRadioState,geliefertRadio);
	WRITEFINDPANELRADIO(storniertRadioState,storniertRadio);
	WRITEFINDPANELRADIO(adactaRadioState,adactaRadio);
	WRITEFINDPANELSWITCH(nrSwitchState,nrSwitch);
	WRITEFINDPANELSWITCH(datumSwitchState,datumSwitch);
	WRITEFINDPANELSWITCH(kundennrSwitchState,kundennrSwitch);
	WRITEFINDPANELSWITCH(kundennameSwitchState,kundennameSwitch);
	WRITEFINDPANELSWITCH(aufnrSwitchState,aufnrSwitch);
	WRITEFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	WRITEFINDPANELSWITCH(geliefertSwitchState,geliefertSwitch);
	WRITEFINDPANELSWITCH(storniertSwitchState,storniertSwitch);
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
	
	queryString = [QueryString str:"select l.nr LieferscheinNr"];
	if([datumSwitchState isTrue]) [queryString concatSTR:",l.datum Datum"];
	if([kundennrSwitchState isTrue]) [queryString concatSTR:", a.kundennr KundenNr"];
	if([kundennameSwitchState isTrue]) [queryString concatSTR:",k.kname Kundenname"];
	if([aufnrSwitchState isTrue]) [queryString concatSTR:",a.nr AuftragsNr"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:",janein1.bool adacta"];
	if([geliefertSwitchState isTrue]) [queryString concatSTR:",janein2.bool geliefert"];
	if([storniertSwitchState isTrue]) [queryString concatSTR:",janein3.bool storniert"];
	
	[queryString concatSTR:" from lieferschein l, auftrag a, kunden k"];
	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:", janein janein1"];
	}
	if([geliefertSwitchState isTrue]) {
		[queryString concatSTR:", janein janein2"];
	}
	if([storniertSwitchState isTrue]) {
		[queryString concatSTR:", janein janein3"];
	}
	
	[queryString concatSTR:" where l.nr like "];
	[queryString concatField:nrStr];
	
	[queryString concatSTR:" and a.nr like "];
	[queryString concatField:aufnrStr];
	
	[queryString concatSTR:" and a.kundennr like "];
	[queryString concatField:kundennrStr];
	
	[queryString concatSTR:" and k.kname like "];
	[queryString concatField:kundennameStr];
	
	[queryString concatSTR:" and l.datum between "];
	[queryString concatField:datumMinDate];
	[queryString concatSTR:" and "];
	[queryString concatField:datumMaxDate];
	
	switch([geliefertRadioState int]) {
		case 0:
			[queryString concatSTR:" and l.geliefert=1"];
			break;
		case 1:
			[queryString concatSTR:" and l.geliefert=0"];
			break;
		default:
			break;
	}

	switch([adactaRadioState int]) {
		case 0:
			[queryString concatSTR:" and l.adacta=1"];
			break;
		case 1:
			[queryString concatSTR:" and l.adacta=0"];
			break;
		default:
			break;
	}

	switch([storniertRadioState int]) {
		case 0:
			[queryString concatSTR:" and l.storniert=1"];
			break;
		case 1:
			[queryString concatSTR:" and l.storniert=0"];
			break;
		default:
			break;
	}


	[queryString concatSTR:" and l.aufnr=a.nr"];	
	[queryString concatSTR:" and a.kundennr*=k.nr"];	

	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:" and janein1.i=*l.adacta"];
	}
	if([geliefertSwitchState isTrue]) {
		[queryString concatSTR:" and janein2.i=*l.geliefert"];
	}
	if([storniertSwitchState isTrue]) {
		[queryString concatSTR:" and janein3.i=*l.storniert"];
	}
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [LieferscheinDocument class]; }

- itemClass
{ return [LieferscheinItem class]; }

- itemListClass
{ return [LieferscheinItemList class]; }

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
