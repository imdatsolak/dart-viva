#import <appkit/Button.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "AuftragsDocument.h"
#import "AuftragItemList.h"
#import "AuftragItem.h"
#import "AuftragsSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation AuftragsSelector:MasterSelector
{
	id	nrField;
	id	kundennrField;
	id	kundennameField;
	id	datumMinField;
	id	datumMaxField;
	id	ldatumMinField;
	id	ldatumMaxField;
	id	summeMinField;
	id	summeMaxField;
	id	berechnetRadio;
	id	geliefertRadio;
	id	adactaRadio;
	
	id	nrSwitch;
	id	datumSwitch;
	id	kundennrSwitch;
	id	kundennameSwitch;
	id	bestellDatumSwitch;
	id	bestellnrSwitch;
	id	gesamtpreisSwitch;
	id	ldatumSwitch;
	id	berechnetSwitch;
	id	geliefertSwitch;
	id	adactaSwitch;

	id	nrStr;
	id	kundennrStr;
	id	kundennameStr;
	id	datumMinDate;
	id	datumMaxDate;
	id	ldatumMinDate;
	id	ldatumMaxDate;
	id	summeMinDouble;
	id	summeMaxDouble;
	id	berechnetRadioState;
	id	geliefertRadioState;
	id	adactaRadioState;
	
	id	nrSwitchState;
	id	datumSwitchState;
	id	kundennrSwitchState;
	id	kundennameSwitchState;
	id	bestellDatumSwitchState;
	id	bestellnrSwitchState;
	id	gesamtpreisSwitchState;
	id	ldatumSwitchState;
	id	berechnetSwitchState;
	id	geliefertSwitchState;
	id	adactaSwitchState;

}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(kundennrStr,String,kundennrField);
	CREATEFIELD(kundennameStr,String,kundennameField);
	CREATEFIELD(datumMinDate,Date,datumMinField);
	CREATEFIELD(datumMaxDate,Date,datumMaxField);
	CREATEFIELD(ldatumMinDate,Date,ldatumMinField);
	CREATEFIELD(ldatumMaxDate,Date,ldatumMaxField);
	CREATEFIELD(summeMinDouble,Double,summeMinField);
	CREATEFIELD(summeMaxDouble,Double,summeMaxField);
	CREATERADIOSTATE(berechnetRadioState,berechnetRadio);
	CREATERADIOSTATE(geliefertRadioState,geliefertRadio);
	CREATERADIOSTATE(adactaRadioState,adactaRadio);
	CREATESWITCHSTATE(nrSwitchState,nrSwitch);
	CREATESWITCHSTATE(datumSwitchState,datumSwitch);
	CREATESWITCHSTATE(kundennrSwitchState,kundennrSwitch);
	CREATESWITCHSTATE(kundennameSwitchState,kundennameSwitch);
	CREATESWITCHSTATE(bestellDatumSwitchState,bestellDatumSwitch);
	CREATESWITCHSTATE(bestellnrSwitchState,bestellnrSwitch);
	CREATESWITCHSTATE(gesamtpreisSwitchState,gesamtpreisSwitch);
	CREATESWITCHSTATE(ldatumSwitchState,ldatumSwitch);
	CREATESWITCHSTATE(berechnetSwitchState,berechnetSwitch);
	CREATESWITCHSTATE(geliefertSwitchState,geliefertSwitch);
	CREATESWITCHSTATE(adactaSwitchState,adactaSwitch);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[kundennrStr free];
	[kundennameStr free];
	[datumMinDate free];
	[datumMaxDate free];
	[ldatumMinDate free];
	[ldatumMaxDate free];
	[summeMinDouble free];
	[summeMaxDouble free];
	[berechnetRadioState free];
	[geliefertRadioState free];
	[adactaRadioState free];
	[nrSwitchState free];
	[datumSwitchState free];
	[kundennrSwitchState free];
	[kundennameSwitchState free];
	[bestellDatumSwitchState free];
	[bestellnrSwitchState free];
	[gesamtpreisSwitchState free];
	[ldatumSwitchState free];
	[berechnetSwitchState free];
	[geliefertSwitchState free];
	[adactaSwitchState free];
	return [super free];
}
- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	kundennrStr = NXReadObject(typedStream);
	kundennameStr = NXReadObject(typedStream);
	datumMinDate = NXReadObject(typedStream);
	datumMaxDate = NXReadObject(typedStream);
	ldatumMinDate = NXReadObject(typedStream);
	ldatumMaxDate = NXReadObject(typedStream);
	summeMinDouble = NXReadObject(typedStream);
	summeMaxDouble = NXReadObject(typedStream);
	berechnetRadioState = NXReadObject(typedStream);
	geliefertRadioState = NXReadObject(typedStream);
	adactaRadioState = NXReadObject(typedStream);
	nrSwitchState = NXReadObject(typedStream);
	datumSwitchState = NXReadObject(typedStream);
	kundennrSwitchState = NXReadObject(typedStream);
	kundennameSwitchState = NXReadObject(typedStream);
	bestellDatumSwitchState = NXReadObject(typedStream);
	bestellnrSwitchState = NXReadObject(typedStream);
	gesamtpreisSwitchState = NXReadObject(typedStream);
	ldatumSwitchState = NXReadObject(typedStream);
	berechnetSwitchState = NXReadObject(typedStream);
	geliefertSwitchState = NXReadObject(typedStream);
	adactaSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,kundennrStr);
	NXWriteObject(typedStream,kundennameStr);
	NXWriteObject(typedStream,datumMinDate);
	NXWriteObject(typedStream,datumMaxDate);
	NXWriteObject(typedStream,ldatumMinDate);
	NXWriteObject(typedStream,ldatumMaxDate);
	NXWriteObject(typedStream,summeMinDouble);
	NXWriteObject(typedStream,summeMaxDouble);
	NXWriteObject(typedStream,berechnetRadioState);
	NXWriteObject(typedStream,geliefertRadioState);
	NXWriteObject(typedStream,adactaRadioState);
	NXWriteObject(typedStream,nrSwitchState);
	NXWriteObject(typedStream,datumSwitchState);
	NXWriteObject(typedStream,kundennrSwitchState);
	NXWriteObject(typedStream,kundennameSwitchState);
	NXWriteObject(typedStream,bestellDatumSwitchState);
	NXWriteObject(typedStream,bestellnrSwitchState);
	NXWriteObject(typedStream,gesamtpreisSwitchState);
	NXWriteObject(typedStream,ldatumSwitchState);
	NXWriteObject(typedStream,berechnetSwitchState);
	NXWriteObject(typedStream,geliefertSwitchState);
	NXWriteObject(typedStream,adactaSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(kundennrStr,kundennrField);
	READFINDPANELCELL(kundennameStr,kundennameField);
	READFINDPANELCELL(datumMinDate,datumMinField);
	READFINDPANELCELL(datumMaxDate,datumMaxField);
	READFINDPANELCELL(ldatumMinDate,ldatumMinField);
	READFINDPANELCELL(ldatumMaxDate,ldatumMaxField);
	READFINDPANELCELL(summeMinDouble,summeMinField);
	READFINDPANELCELL(summeMaxDouble,summeMaxField);
	READFINDPANELRADIO(berechnetRadioState,berechnetRadio);
	READFINDPANELRADIO(geliefertRadioState,geliefertRadio);
	READFINDPANELRADIO(adactaRadioState,adactaRadio);
	READFINDPANELSWITCH(nrSwitchState,nrSwitch);
	READFINDPANELSWITCH(datumSwitchState,datumSwitch);
	READFINDPANELSWITCH(kundennrSwitchState,kundennrSwitch);
	READFINDPANELSWITCH(kundennameSwitchState,kundennameSwitch);
	READFINDPANELSWITCH(bestellDatumSwitchState,bestellDatumSwitch);
	READFINDPANELSWITCH(bestellnrSwitchState,bestellnrSwitch);
	READFINDPANELSWITCH(gesamtpreisSwitchState,gesamtpreisSwitch);
	READFINDPANELSWITCH(ldatumSwitchState,ldatumSwitch);
	READFINDPANELSWITCH(berechnetSwitchState,berechnetSwitch);
	READFINDPANELSWITCH(geliefertSwitchState,geliefertSwitch);
	READFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(kundennrStr,kundennrField);
	WRITEFINDPANELCELL(kundennameStr,kundennameField);
	WRITEFINDPANELCELL(datumMinDate,datumMinField);
	WRITEFINDPANELCELL(datumMaxDate,datumMaxField);
	WRITEFINDPANELCELL(ldatumMinDate,ldatumMinField);
	WRITEFINDPANELCELL(ldatumMaxDate,ldatumMaxField);
	WRITEFINDPANELCELL(summeMinDouble,summeMinField);
	WRITEFINDPANELCELL(summeMaxDouble,summeMaxField);
	WRITEFINDPANELRADIO(berechnetRadioState,berechnetRadio);
	WRITEFINDPANELRADIO(geliefertRadioState,geliefertRadio);
	WRITEFINDPANELRADIO(adactaRadioState,adactaRadio);
	WRITEFINDPANELSWITCH(nrSwitchState,nrSwitch);
	WRITEFINDPANELSWITCH(datumSwitchState,datumSwitch);
	WRITEFINDPANELSWITCH(kundennrSwitchState,kundennrSwitch);
	WRITEFINDPANELSWITCH(kundennameSwitchState,kundennameSwitch);
	WRITEFINDPANELSWITCH(bestellDatumSwitchState,bestellDatumSwitch);
	WRITEFINDPANELSWITCH(bestellnrSwitchState,bestellnrSwitch);
	WRITEFINDPANELSWITCH(gesamtpreisSwitchState,gesamtpreisSwitch);
	WRITEFINDPANELSWITCH(ldatumSwitchState,ldatumSwitch);
	WRITEFINDPANELSWITCH(berechnetSwitchState,berechnetSwitch);
	WRITEFINDPANELSWITCH(geliefertSwitchState,geliefertSwitch);
	WRITEFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
	
	queryString = [QueryString str:"select auftrag.nr AuftragsNr"];
	if([datumSwitchState isTrue]) [queryString concatSTR:", auftrag.datum Datum"];
	if([kundennrSwitchState isTrue]) [queryString concatSTR:", auftrag.kundennr KundenNr"];
	if([kundennameSwitchState isTrue]) [queryString concatSTR:",kunden.kname Kundenname"];
	
	if([bestellDatumSwitchState isTrue]) [queryString concatSTR:",auftrag.bestelldatum BestDatum"];
	if([bestellnrSwitchState isTrue]) [queryString concatSTR:",auftrag.bestellnr BestellNr"];
	if([gesamtpreisSwitchState isTrue]) [queryString concatSTR:",auftrag.gesamtpreis Gesamtpreis"];
	if([ldatumSwitchState isTrue]) [queryString concatSTR:",auftrag.lieferdatum VorLiefDatum"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:",janein1.bool adacta"];
	if([berechnetSwitchState isTrue]) [queryString concatSTR:",janein2.bool Berechnet"];
	if([geliefertSwitchState isTrue]) [queryString concatSTR:",janein3.bool Geliefert"];
	
	[queryString concatSTR:" from auftrag, kunden"];
	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:", janein janein1"];
	}
	if([berechnetSwitchState isTrue]) {
		[queryString concatSTR:", janein janein2"];
	}
	if([geliefertSwitchState isTrue]) {
		[queryString concatSTR:", janein janein3"];
	}
	
	[queryString concatSTR:" where auftrag.nr like "];
	[queryString concatField:nrStr];
	
	[queryString concatSTR:" and auftrag.kundennr like "];
	[queryString concatField:kundennrStr];
	
	[queryString concatSTR:" and kunden.kname like "];
	[queryString concatField:kundennameStr];
	
	[queryString concatSTR:" and auftrag.datum between "];
	[queryString concatField:datumMinDate];
	[queryString concatSTR:" and "];
	[queryString concatField:datumMaxDate];
	
	[queryString concatSTR:" and auftrag.lieferdatum between "];
	[queryString concatField:ldatumMinDate];
	[queryString concatSTR:" and "];
	[queryString concatField:ldatumMaxDate];
	
	[queryString concatSTR:" and auftrag.gesamtpreis between "];
	[queryString concatField:summeMinDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:summeMaxDouble];
	
	switch([berechnetRadioState int]) {
		case 0:
			[queryString concatSTR:" and auftrag.berechnet=1"];
			break;
		case 1:
			[queryString concatSTR:" and auftrag.berechnet=0"];
			break;
		default:
			break;
	}

	switch([adactaRadioState int]) {
		case 0:
			[queryString concatSTR:" and auftrag.adacta=1"];
			break;
		case 1:
			[queryString concatSTR:" and auftrag.adacta=0"];
			break;
		default:
			break;
	}

	switch([geliefertRadioState int]) {
		case 0:
			[queryString concatSTR:" and auftrag.geliefert=1"];
			break;
		case 1:
			[queryString concatSTR:" and auftrag.geliefert=0"];
			break;
		default:
			break;
	}


	[queryString concatSTR:" and auftrag.kundennr*=kunden.nr"];	

	if([adactaSwitchState isTrue]) {
		[queryString concatSTR:" and janein.i=*auftrag.adacta"];
	}
	if([berechnetSwitchState isTrue]) {
		[queryString concatSTR:" and janein2.i=*auftrag.berechnet"];
	}
	if([geliefertSwitchState isTrue]) {
		[queryString concatSTR:" and janein3.i=*auftrag.geliefert"];
	}
	
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];

	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [AuftragsDocument class]; }

- itemClass
{ return [AuftragItem class]; }

- itemListClass
{ return [AuftragItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

- checkMenus
{
	[super checkMenus];
	[[NXApp destroyButton] setEnabled: NO];
	return self;
}
@end
