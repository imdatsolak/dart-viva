#import <appkit/Cell.h>
#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "ArtikelDocument.h"
#import "ArtikelSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation ArtikelSelector:MasterSelector
{
	id	nrField;
	id	anameField;
	id	beschreibungField;
	id	kategorieField;
	id	konditionenField;
	id	vkminField;
	id	vkmaxField;
	id	ekminField;
	id	ekmaxField;
	id	adactaRadio;
	
	id	anameSwitch;
	id	kategorieSwitch;
	id	lieferbarSwitch;
	id	lagerhaltungSwitch;
	id	mindestbestandSwitch;
	id	mwstsatzSwitch;
	id	vkSwitch;
	id	ekSwitch;
	id	betreuerSwitch;
	id	mengeneinheitSwitch;
	id	stuecklisteSwitch;
	id	bestelldauerSwitch;
	id	gewichtSwitch;
	id	konditionenSwitch;
	id	adactaSwitch;
	
	id	nrStr;
	id	anameStr;
	id	beschreibungStr;
	id	kategorieStr;
	id	konditionenStr;
	id	vkminDouble;
	id	vkmaxDouble;
	id	ekminDouble;
	id	ekmaxDouble;
	id	adactaRadioState;
	id	anameSwitchState;
	id	kategorieSwitchState;
	id	lieferbarSwitchState;
	id	lagerhaltungSwitchState;
	id	mindestbestandSwitchState;
	id	mwstsatzSwitchState;
	id	vkSwitchState;
	id	ekSwitchState;
	id	betreuerSwitchState;
	id	mengeneinheitSwitchState;
	id	stuecklisteSwitchState;
	id	bestelldauerSwitchState;
	id	gewichtSwitchState;
	id	konditionenSwitchState;
	id	adactaSwitchState;
}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(anameStr,String,anameField);
	CREATEFIELD(beschreibungStr,String,beschreibungField);
	CREATEFIELD(kategorieStr,String,kategorieField);
	CREATEFIELD(konditionenStr,String,konditionenField);
	CREATEFIELD(vkminDouble,Double,vkminField);
	CREATEFIELD(vkmaxDouble,Double,vkmaxField);
	CREATEFIELD(ekminDouble,Double,ekminField);
	CREATEFIELD(ekmaxDouble,Double,ekmaxField);
	CREATERADIOSTATE(adactaRadioState,adactaRadio);
	CREATESWITCHSTATE(anameSwitchState,anameSwitch);
	CREATESWITCHSTATE(kategorieSwitchState,kategorieSwitch);
	CREATESWITCHSTATE(lieferbarSwitchState,lieferbarSwitch);
	CREATESWITCHSTATE(lagerhaltungSwitchState,lagerhaltungSwitch);
	CREATESWITCHSTATE(mindestbestandSwitchState,mindestbestandSwitch);
	CREATESWITCHSTATE(mwstsatzSwitchState,mwstsatzSwitch);
	CREATESWITCHSTATE(vkSwitchState,vkSwitch);
	CREATESWITCHSTATE(ekSwitchState,ekSwitch);
	CREATESWITCHSTATE(betreuerSwitchState,betreuerSwitch);
	CREATESWITCHSTATE(mengeneinheitSwitchState,mengeneinheitSwitch);
	CREATESWITCHSTATE(stuecklisteSwitchState,stuecklisteSwitch);
	CREATESWITCHSTATE(bestelldauerSwitchState,bestelldauerSwitch);
	CREATESWITCHSTATE(gewichtSwitchState,gewichtSwitch);
	CREATESWITCHSTATE(konditionenSwitchState,konditionenSwitch);
	CREATESWITCHSTATE(adactaSwitchState,adactaSwitch);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[anameStr free];
	[beschreibungStr free];
	[kategorieStr free];
	[konditionenStr free];
	[vkminDouble free];
	[vkmaxDouble free];
	[ekminDouble free];
	[ekmaxDouble free];
	[adactaRadioState free];
	[anameSwitchState free];
	[kategorieSwitchState free];
	[lieferbarSwitchState free];
	[lagerhaltungSwitchState free];
	[mindestbestandSwitchState free];
	[mwstsatzSwitchState free];
	[vkSwitchState free];
	[ekSwitchState free];
	[betreuerSwitchState free];
	[mengeneinheitSwitchState free];
	[stuecklisteSwitchState free];
	[bestelldauerSwitchState free];
	[gewichtSwitchState free];
	[konditionenSwitchState free];
	[adactaSwitchState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	anameStr = NXReadObject(typedStream);
	beschreibungStr = NXReadObject(typedStream);
	kategorieStr = NXReadObject(typedStream);
	konditionenStr = NXReadObject(typedStream);
	vkminDouble = NXReadObject(typedStream);
	vkmaxDouble = NXReadObject(typedStream);
	ekminDouble = NXReadObject(typedStream);
	ekmaxDouble = NXReadObject(typedStream);
	adactaRadioState = NXReadObject(typedStream);
	anameSwitchState = NXReadObject(typedStream);
	kategorieSwitchState = NXReadObject(typedStream);
	lieferbarSwitchState = NXReadObject(typedStream);
	lagerhaltungSwitchState = NXReadObject(typedStream);
	mindestbestandSwitchState = NXReadObject(typedStream);
	mwstsatzSwitchState = NXReadObject(typedStream);
	vkSwitchState = NXReadObject(typedStream);
	ekSwitchState = NXReadObject(typedStream);
	betreuerSwitchState = NXReadObject(typedStream);
	mengeneinheitSwitchState = NXReadObject(typedStream);
	stuecklisteSwitchState = NXReadObject(typedStream);
	bestelldauerSwitchState = NXReadObject(typedStream);
	gewichtSwitchState = NXReadObject(typedStream);
	konditionenSwitchState = NXReadObject(typedStream);
	adactaSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,anameStr);
	NXWriteObject(typedStream,beschreibungStr);
	NXWriteObject(typedStream,kategorieStr);
	NXWriteObject(typedStream,konditionenStr);
	NXWriteObject(typedStream,vkminDouble);
	NXWriteObject(typedStream,vkmaxDouble);
	NXWriteObject(typedStream,ekminDouble);
	NXWriteObject(typedStream,ekmaxDouble);
	NXWriteObject(typedStream,adactaRadioState);
	NXWriteObject(typedStream,anameSwitchState);
	NXWriteObject(typedStream,kategorieSwitchState);
	NXWriteObject(typedStream,lieferbarSwitchState);
	NXWriteObject(typedStream,lagerhaltungSwitchState);
	NXWriteObject(typedStream,mindestbestandSwitchState);
	NXWriteObject(typedStream,mwstsatzSwitchState);
	NXWriteObject(typedStream,vkSwitchState);
	NXWriteObject(typedStream,ekSwitchState);
	NXWriteObject(typedStream,betreuerSwitchState);
	NXWriteObject(typedStream,mengeneinheitSwitchState);
	NXWriteObject(typedStream,stuecklisteSwitchState);
	NXWriteObject(typedStream,bestelldauerSwitchState);
	NXWriteObject(typedStream,gewichtSwitchState);
	NXWriteObject(typedStream,konditionenSwitchState);
	NXWriteObject(typedStream,adactaSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(anameStr,anameField);
	READFINDPANELCELL(beschreibungStr,beschreibungField);
	READFINDPANELCELL(kategorieStr,kategorieField);
	READFINDPANELCELL(konditionenStr,konditionenField);
	READFINDPANELCELL(vkminDouble,vkminField);
	READFINDPANELCELL(vkmaxDouble,vkmaxField);
	READFINDPANELCELL(ekminDouble,ekminField);
	READFINDPANELCELL(ekmaxDouble,ekmaxField);
	READFINDPANELRADIO(adactaRadioState,adactaRadio);
	READFINDPANELSWITCH(anameSwitchState,anameSwitch);
	READFINDPANELSWITCH(kategorieSwitchState,kategorieSwitch);
	READFINDPANELSWITCH(lieferbarSwitchState,lieferbarSwitch);
	READFINDPANELSWITCH(lagerhaltungSwitchState,lagerhaltungSwitch);
	READFINDPANELSWITCH(mindestbestandSwitchState,mindestbestandSwitch);
	READFINDPANELSWITCH(mwstsatzSwitchState,mwstsatzSwitch);
	READFINDPANELSWITCH(vkSwitchState,vkSwitch);
	READFINDPANELSWITCH(ekSwitchState,ekSwitch);
	READFINDPANELSWITCH(betreuerSwitchState,betreuerSwitch);
	READFINDPANELSWITCH(mengeneinheitSwitchState,mengeneinheitSwitch);
	READFINDPANELSWITCH(stuecklisteSwitchState,stuecklisteSwitch);
	READFINDPANELSWITCH(bestelldauerSwitchState,bestelldauerSwitch);
	READFINDPANELSWITCH(gewichtSwitchState,gewichtSwitch);
	READFINDPANELSWITCH(konditionenSwitchState,konditionenSwitch);
	READFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(anameStr,anameField);
	WRITEFINDPANELCELL(beschreibungStr,beschreibungField);
	WRITEFINDPANELCELL(kategorieStr,kategorieField);
	WRITEFINDPANELCELL(konditionenStr,konditionenField);
	WRITEFINDPANELCELL(vkminDouble,vkminField);
	WRITEFINDPANELCELL(vkmaxDouble,vkmaxField);
	WRITEFINDPANELCELL(ekminDouble,ekminField);
	WRITEFINDPANELCELL(ekmaxDouble,ekmaxField);
	WRITEFINDPANELRADIO(adactaRadioState,adactaRadio);
	WRITEFINDPANELSWITCH(anameSwitchState,anameSwitch);
	WRITEFINDPANELSWITCH(kategorieSwitchState,kategorieSwitch);
	WRITEFINDPANELSWITCH(lieferbarSwitchState,lieferbarSwitch);
	WRITEFINDPANELSWITCH(lagerhaltungSwitchState,lagerhaltungSwitch);
	WRITEFINDPANELSWITCH(mindestbestandSwitchState,mindestbestandSwitch);
	WRITEFINDPANELSWITCH(mwstsatzSwitchState,mwstsatzSwitch);
	WRITEFINDPANELSWITCH(vkSwitchState,vkSwitch);
	WRITEFINDPANELSWITCH(ekSwitchState,ekSwitch);
	WRITEFINDPANELSWITCH(betreuerSwitchState,betreuerSwitch);
	WRITEFINDPANELSWITCH(mengeneinheitSwitchState,mengeneinheitSwitch);
	WRITEFINDPANELSWITCH(stuecklisteSwitchState,stuecklisteSwitch);
	WRITEFINDPANELSWITCH(bestelldauerSwitchState,bestelldauerSwitch);
	WRITEFINDPANELSWITCH(gewichtSwitchState,gewichtSwitch);
	WRITEFINDPANELSWITCH(konditionenSwitchState,konditionenSwitch);
	WRITEFINDPANELSWITCH(adactaSwitchState,adactaSwitch);
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
		
	queryString = [QueryString str:"select a.nr ArtikelNr"];
	if([anameSwitchState isTrue]) [queryString concatSTR:",a.aname Name"];
	if([kategorieSwitchState isTrue]) [queryString concatSTR:",ak.value Kategorie"];
	if([lieferbarSwitchState isTrue]) [queryString concatSTR:",janein1.bool Lief"];
	if([lagerhaltungSwitchState isTrue]) [queryString concatSTR:",janein2.bool Lager"];
	if([mindestbestandSwitchState isTrue]) [queryString concatSTR:",a.mindestbestand MBest"];
	if([mwstsatzSwitchState isTrue]) [queryString concatSTR:",mw.value MwSt"];
	if([vkSwitchState isTrue]) [queryString concatSTR:",a.vk VK"];
	if([ekSwitchState isTrue]) [queryString concatSTR:",a.ek EK"];
	if([betreuerSwitchState isTrue]) [queryString concatSTR:",b.value Betreuer"];
	if([mengeneinheitSwitchState isTrue]) [queryString concatSTR:",me.value ME"];
	if([stuecklisteSwitchState isTrue]) [queryString concatSTR:",janein3.bool Stueckliste"];
	if([bestelldauerSwitchState isTrue]) [queryString concatSTR:",a.bestelldauer Bestelldauer"];
	if([gewichtSwitchState isTrue]) [queryString concatSTR:",a.gewicht Gewicht"];
	if([konditionenSwitchState isTrue]) [queryString concatSTR:",a.konditionen Konditionen"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:",janein4.bool adacta"];
	
	[queryString concatSTR:" from artikel a,artikelkategorien ak"];
	if([lieferbarSwitchState isTrue]) [queryString concatSTR:",janein janein1"];
	if([lagerhaltungSwitchState isTrue]) [queryString concatSTR:",janein janein2"];
	if([mwstsatzSwitchState isTrue]) [queryString concatSTR:",mwstsaetze mw"];
	if([betreuerSwitchState isTrue]) [queryString concatSTR:",benutzerpopupview b"];
	if([mengeneinheitSwitchState isTrue]) [queryString concatSTR:",mengeneinheiten me"];
	if([stuecklisteSwitchState isTrue]) [queryString concatSTR:",janein janein3"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:",janein janein4"];

	[queryString concatSTR:" where a.nr like "];
	[queryString concatField:nrStr];
	[queryString concatSTR:" and a.aname like "];
	[queryString concatField:anameStr];
	[queryString concatSTR:" and a.beschreibung like "];
	[queryString concatField:beschreibungStr];
	[queryString concatSTR:" and a.vk between "];
	[queryString concatField:vkminDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:vkmaxDouble];
	[queryString concatSTR:" and a.ek between "];
	[queryString concatField:ekminDouble];
	[queryString concatSTR:" and "];
	[queryString concatField:ekmaxDouble];
	[queryString concatSTR:" and a.konditionen like "];
	[queryString concatField:konditionenStr];
	[queryString concatSTR:" and ak.value like "];
	[queryString concatField:kategorieStr];
	
	switch([adactaRadioState int]) {
		case 0:
			[queryString concatSTR:" and a.adacta=1"];
			break;
		case 1:
			[queryString concatSTR:" and a.adacta=0"];
			break;
		default:
			break;
	}
	
	[queryString concatSTR:" and a.kategorie*=ak.key"];	

	if([lieferbarSwitchState isTrue]) [queryString concatSTR:" and janein1.i=*a.lieferbar"];
	if([lagerhaltungSwitchState isTrue]) [queryString concatSTR:" and janein2.i=*a.lagerhaltung"];
	if([mwstsatzSwitchState isTrue]) [queryString concatSTR:" and mw.key=*a.mwstsatz"];
	if([betreuerSwitchState isTrue]) [queryString concatSTR:" and b.key=*a.betreuernr"];
	if([mengeneinheitSwitchState isTrue]) [queryString concatSTR:" and me.key=*a.mengeneinheit"];
	if([stuecklisteSwitchState isTrue]) [queryString concatSTR:" and janein3.i=*a.stueckliste"];
	if([adactaSwitchState isTrue]) [queryString concatSTR:" and janein4.i=*a.adacta"];
		
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [ArtikelDocument class]; }

- itemClass
{ return [ArtikelItem class]; }

- itemListClass
{ return [ArtikelItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
