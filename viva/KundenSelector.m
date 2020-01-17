#import <stdlib.h>

#import <appkit/Cell.h>
#import <appkit/Button.h>

#import "dart/Integer.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "KundeItem.h"
#import "KundeItemList.h"
#import "KundenDocument.h"
#import "KundenSelector.h"

#pragma .h #import "MasterSelector.h"


@implementation KundenSelector:MasterSelector
{
	id	nrField;
	id	knameField;
	id	name1Field;
	id	name2Field;
	id	name3Field;
	id	strasseField;
	id	plzOrtField;
	id	adactaRadio;
	
	id	nameSwitch;
	id	einstufungSwitch;
	id	kategorieSwitch;
	id	liefersperreSwitch;
	id	mwstSwitch;
	id	betreuerSwitch;
	id	groesseSwitch;
	id	sammelrechnungenSwitch;
	id	kreditlimitSwitch;
	
	id	name1Switch;
	id	name2Switch;
	id	name3Switch;
	id	streetSwitch;
	id	plzortSwitch;
	id	telSwitch;
	id	faxSwitch;
	id	emailSwitch;

	id	adressenPopup;

	id	nrStr;
	id	knameStr;
	id	name1Str;
	id	name2Str;
	id	name3Str;
	id	strasseStr;
	id	plzOrtStr;
	id	adactaRadioState;
	
	id	nameSwitchState;
	id	einstufungSwitchState;
	id	kategorieSwitchState;
	id	liefersperreSwitchState;
	id	mwstSwitchState;
	id	betreuerSwitchState;
	id	groesseSwitchState;
	id	sammelrechnungenSwitchState;
	id	kreditlimitSwitchState;
	id	name1SwitchState;
	id	name2SwitchState;
	id	name3SwitchState;
	id	streetSwitchState;
	id	plzortSwitchState;
	id	telSwitchState;
	id	faxSwitchState;
	id	emailSwitchState;
	id	adressenPopupState;

}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(knameStr,String,knameField);
	CREATEFIELD(name1Str,String,name1Field);
	CREATEFIELD(name2Str,String,name2Field);
	CREATEFIELD(name3Str,String,name3Field);
	CREATEFIELD(strasseStr,String,strasseField);
	CREATEFIELD(plzOrtStr,String,plzOrtField);
	CREATERADIOSTATE(adactaRadioState,adactaRadio);
	CREATESWITCHSTATE(nameSwitchState,nameSwitch);
	CREATESWITCHSTATE(einstufungSwitchState,einstufungSwitch);
	CREATESWITCHSTATE(kategorieSwitchState,kategorieSwitch);
	CREATESWITCHSTATE(liefersperreSwitchState,liefersperreSwitch);
	CREATESWITCHSTATE(mwstSwitchState,mwstSwitch);
	CREATESWITCHSTATE(betreuerSwitchState,betreuerSwitch);
	CREATESWITCHSTATE(groesseSwitchState,groesseSwitch);
	CREATESWITCHSTATE(sammelrechnungenSwitchState,sammelrechnungenSwitch);
	CREATESWITCHSTATE(kreditlimitSwitchState,kreditlimitSwitch);
	CREATESWITCHSTATE(name1SwitchState,name1Switch);
	CREATESWITCHSTATE(name2SwitchState,name2Switch);
	CREATESWITCHSTATE(name3SwitchState,name3Switch);
	CREATESWITCHSTATE(streetSwitchState,streetSwitch);
	CREATESWITCHSTATE(plzortSwitchState,plzortSwitch);
	CREATESWITCHSTATE(telSwitchState,telSwitch);
	CREATESWITCHSTATE(faxSwitchState,faxSwitch);
	CREATESWITCHSTATE(emailSwitchState,emailSwitch);
	CREATEPOPUPSTATE(adressenPopupState,adressenPopup);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[knameStr free];
	[name1Str free];
	[name2Str free];
	[name3Str free];
	[strasseStr free];
	[plzOrtStr free];
	[adactaRadioState free];
	[nameSwitchState free];
	[einstufungSwitchState free];
	[kategorieSwitchState free];
	[liefersperreSwitchState free];
	[mwstSwitchState free];
	[betreuerSwitchState free];
	[groesseSwitchState free];
	[sammelrechnungenSwitchState free];
	[kreditlimitSwitchState free];
	[name1SwitchState free];
	[name2SwitchState free];
	[name3SwitchState free];
	[streetSwitchState free];
	[plzortSwitchState free];
	[telSwitchState free];
	[faxSwitchState free];
	[emailSwitchState free];
	[adressenPopupState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	knameStr = NXReadObject(typedStream);
	name1Str = NXReadObject(typedStream);
	name2Str = NXReadObject(typedStream);
	name3Str = NXReadObject(typedStream);
	strasseStr = NXReadObject(typedStream);
	plzOrtStr = NXReadObject(typedStream);
	adactaRadioState = NXReadObject(typedStream);
	nameSwitchState = NXReadObject(typedStream);
	einstufungSwitchState = NXReadObject(typedStream);
	kategorieSwitchState = NXReadObject(typedStream);
	liefersperreSwitchState = NXReadObject(typedStream);
	mwstSwitchState = NXReadObject(typedStream);
	betreuerSwitchState = NXReadObject(typedStream);
	groesseSwitchState = NXReadObject(typedStream);
	sammelrechnungenSwitchState = NXReadObject(typedStream);
	kreditlimitSwitchState = NXReadObject(typedStream);
	name1SwitchState = NXReadObject(typedStream);
	name2SwitchState = NXReadObject(typedStream);
	name3SwitchState = NXReadObject(typedStream);
	streetSwitchState = NXReadObject(typedStream);
	plzortSwitchState = NXReadObject(typedStream);
	telSwitchState = NXReadObject(typedStream);
	faxSwitchState = NXReadObject(typedStream);
	emailSwitchState = NXReadObject(typedStream);
	adressenPopupState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,knameStr);
	NXWriteObject(typedStream,name1Str);
	NXWriteObject(typedStream,name2Str);
	NXWriteObject(typedStream,name3Str);
	NXWriteObject(typedStream,strasseStr);
	NXWriteObject(typedStream,plzOrtStr);
	NXWriteObject(typedStream,adactaRadioState);
	NXWriteObject(typedStream,nameSwitchState);
	NXWriteObject(typedStream,einstufungSwitchState);
	NXWriteObject(typedStream,kategorieSwitchState);
	NXWriteObject(typedStream,liefersperreSwitchState);
	NXWriteObject(typedStream,mwstSwitchState);
	NXWriteObject(typedStream,betreuerSwitchState);
	NXWriteObject(typedStream,groesseSwitchState);
	NXWriteObject(typedStream,sammelrechnungenSwitchState);
	NXWriteObject(typedStream,kreditlimitSwitchState);
	NXWriteObject(typedStream,name1SwitchState);
	NXWriteObject(typedStream,name2SwitchState);
	NXWriteObject(typedStream,name3SwitchState);
	NXWriteObject(typedStream,streetSwitchState);
	NXWriteObject(typedStream,plzortSwitchState);
	NXWriteObject(typedStream,telSwitchState);
	NXWriteObject(typedStream,faxSwitchState);
	NXWriteObject(typedStream,emailSwitchState);
	NXWriteObject(typedStream,adressenPopupState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(knameStr,knameField);
	READFINDPANELCELL(name1Str,name1Field);
	READFINDPANELCELL(name2Str,name2Field);
	READFINDPANELCELL(name3Str,name3Field);
	READFINDPANELCELL(strasseStr,strasseField);
	READFINDPANELCELL(plzOrtStr,plzOrtField);
	READFINDPANELRADIO(adactaRadioState,adactaRadio);
	READFINDPANELSWITCH(nameSwitchState,nameSwitch);
	READFINDPANELSWITCH(einstufungSwitchState,einstufungSwitch);
	READFINDPANELSWITCH(kategorieSwitchState,kategorieSwitch);
	READFINDPANELSWITCH(liefersperreSwitchState,liefersperreSwitch);
	READFINDPANELSWITCH(mwstSwitchState,mwstSwitch);
	READFINDPANELSWITCH(betreuerSwitchState,betreuerSwitch);
	READFINDPANELSWITCH(groesseSwitchState,groesseSwitch);
	READFINDPANELSWITCH(sammelrechnungenSwitchState,sammelrechnungenSwitch);
	READFINDPANELSWITCH(kreditlimitSwitchState,kreditlimitSwitch);
	READFINDPANELSWITCH(name1SwitchState,name1Switch);
	READFINDPANELSWITCH(name2SwitchState,name2Switch);
	READFINDPANELSWITCH(name3SwitchState,name3Switch);
	READFINDPANELSWITCH(streetSwitchState,streetSwitch);
	READFINDPANELSWITCH(plzortSwitchState,plzortSwitch);
	READFINDPANELSWITCH(telSwitchState,telSwitch);
	READFINDPANELSWITCH(faxSwitchState,faxSwitch);
	READFINDPANELSWITCH(emailSwitchState,emailSwitch);
	READFINDPANELPOPUP(adressenPopupState,adressenPopup);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(knameStr,knameField);
	WRITEFINDPANELCELL(name1Str,name1Field);
	WRITEFINDPANELCELL(name2Str,name2Field);
	WRITEFINDPANELCELL(name3Str,name3Field);
	WRITEFINDPANELCELL(strasseStr,strasseField);
	WRITEFINDPANELCELL(plzOrtStr,plzOrtField);
	WRITEFINDPANELRADIO(adactaRadioState,adactaRadio);
	WRITEFINDPANELSWITCH(nameSwitchState,nameSwitch);
	WRITEFINDPANELSWITCH(einstufungSwitchState,einstufungSwitch);
	WRITEFINDPANELSWITCH(kategorieSwitchState,kategorieSwitch);
	WRITEFINDPANELSWITCH(liefersperreSwitchState,liefersperreSwitch);
	WRITEFINDPANELSWITCH(mwstSwitchState,mwstSwitch);
	WRITEFINDPANELSWITCH(betreuerSwitchState,betreuerSwitch);
	WRITEFINDPANELSWITCH(groesseSwitchState,groesseSwitch);
	WRITEFINDPANELSWITCH(sammelrechnungenSwitchState,sammelrechnungenSwitch);
	WRITEFINDPANELSWITCH(kreditlimitSwitchState,kreditlimitSwitch);
	WRITEFINDPANELSWITCH(name1SwitchState,name1Switch);
	WRITEFINDPANELSWITCH(name2SwitchState,name2Switch);
	WRITEFINDPANELSWITCH(name3SwitchState,name3Switch);
	WRITEFINDPANELSWITCH(streetSwitchState,streetSwitch);
	WRITEFINDPANELSWITCH(plzortSwitchState,plzortSwitch);
	WRITEFINDPANELSWITCH(telSwitchState,telSwitch);
	WRITEFINDPANELSWITCH(faxSwitchState,faxSwitch);
	WRITEFINDPANELSWITCH(emailSwitchState,emailSwitch);
	WRITEFINDPANELPOPUP(adressenPopupState,adressenPopup);
	return self;
}

- performQuery
{
	id	aQueryResult, queryStr;
	BOOL	doJoin = [name1SwitchState isTrue] || [name2SwitchState isTrue] || [name3SwitchState isTrue] || 
					 [streetSwitchState isTrue] || [plzortSwitchState isTrue] || [telSwitchState isTrue] || 
					 [faxSwitchState isTrue] ||[emailSwitchState isTrue] || [name1Str compareSTR:"%"] ||
					 [name2Str compareSTR:"%"] || [name3Str compareSTR:"%"] || [strasseStr compareSTR:"%"] ||
					 [plzOrtStr compareSTR:"%"];

	queryStr = [QueryString str:"select kunden.nr KundenNr"];

	if([nameSwitchState isTrue]) [queryStr concatSTR:",kname Name"];
	if([einstufungSwitchState isTrue]) [queryStr concatSTR:",kundeneinstufung.value Einstufung"];
	if([kategorieSwitchState isTrue]) [queryStr concatSTR:",kundenkategorien.value Kategorie"];
	if([liefersperreSwitchState isTrue]) [queryStr concatSTR:",janein1.bool Liefersperre"];
	if([mwstSwitchState isTrue]) [queryStr concatSTR:",janein2.bool MwSt"];
	if([betreuerSwitchState isTrue]) [queryStr concatSTR:",benutzerpopupview.value Betreuer"];
	if([groesseSwitchState isTrue]) [queryStr concatSTR:",kundengroesse.value Groesse"];
	if([sammelrechnungenSwitchState isTrue]) [queryStr concatSTR:",sammelrechnungen.value SammelRechn"];
	if([kreditlimitSwitchState isTrue]) [queryStr concatSTR:",kreditlimit Kreditlimit "];
	if([name1SwitchState isTrue]) [queryStr concatSTR:",name1 Name1"];
	if([name2SwitchState isTrue]) [queryStr concatSTR:",name2 Name2"];
	if([name3SwitchState isTrue]) [queryStr concatSTR:",name3 Name3"];
	if([streetSwitchState isTrue]) [queryStr concatSTR:",strasse Strasse"];
	if([plzortSwitchState isTrue]) [queryStr concatSTR:",plzort PlzOrt"];
	if([telSwitchState isTrue]) [queryStr concatSTR:",tel Telefon"];
	if([faxSwitchState isTrue]) [queryStr concatSTR:",fax Telefax"];
	if([emailSwitchState isTrue]) [queryStr concatSTR:",email EMail"];
	
	[queryStr concatSTR:" from kunden"];
	if (doJoin) {
		[queryStr concatSTR:",adressen"];
	}
	if([liefersperreSwitchState isTrue]) {
		[queryStr concatSTR:",janein janein1"];
	}
	if([mwstSwitchState isTrue]) {
		[queryStr concatSTR:",janein janein2"];
	}
	
	if([einstufungSwitchState isTrue]) [queryStr concatSTR:",kundeneinstufung"];
	if([kategorieSwitchState isTrue]) [queryStr concatSTR:",kundenkategorien"];
	if([groesseSwitchState isTrue]) [queryStr concatSTR:",kundengroesse"];
	if([sammelrechnungenSwitchState isTrue]) [queryStr concatSTR:",sammelrechnungen"];
	if([betreuerSwitchState isTrue]) [queryStr concatSTR:", benutzerpopupview"];

	[queryStr concatSTR:" where kunden.nr like "];
	[queryStr concatField:nrStr];
	
	[queryStr concatSTR:" and kunden.kname like "];
	[queryStr concatField:knameStr];

	if (doJoin) {
		[queryStr concatSTR:" and adressen.name1 like "];
		[queryStr concatField:name1Str];
	
		[queryStr concatSTR:" and adressen.name2 like "];
		[queryStr concatField:name2Str];
	
		[queryStr concatSTR:" and adressen.name3 like "];
		[queryStr concatField:name3Str];
	
		[queryStr concatSTR:" and adressen.strasse like "];
		[queryStr concatField:strasseStr];
	
		[queryStr concatSTR:" and adressen.plzort like "];
		[queryStr concatField:plzOrtStr];
	}

	switch([adactaRadioState int]) {
		case 0:
			[queryStr concatSTR:" and kunden.adacta=1"];
			break;
		case 1:
			[queryStr concatSTR:" and kunden.adacta=0"];
			break;
		default:
			break;
	}

	if([liefersperreSwitchState isTrue]) {
		[queryStr concatSTR:" and janein1.i=*kunden.liefersperre"];
	}
	if([mwstSwitchState isTrue]) {
		[queryStr concatSTR:" and janein2.i=*kunden.mwstberechnen"];
	}


	if([einstufungSwitchState isTrue]) [queryStr concatSTR:" and kundeneinstufung.key=*kunden.einstufung"];
	if([kategorieSwitchState isTrue]) [queryStr concatSTR:" and kundenkategorien.key=*kunden.kategorie"];
	if([betreuerSwitchState isTrue]) [queryStr concatSTR:" and benutzerpopupview.key=*kunden.betreuernr"];
	if([groesseSwitchState isTrue]) [queryStr concatSTR:" and kundengroesse.key=*kunden.groesse"];
	if([sammelrechnungenSwitchState isTrue]) [queryStr concatSTR:" and sammelrechnungen.key=*kunden.sammelrechnung"];

	if (doJoin) {
		[queryStr concatSTR:" and kunden.nr=adressen.id and adressen.class=\"KU\" and adressen.position="];
		[queryStr concatINT:atoi([adressenPopupState str])];
	}
	aQueryResult = [[NXApp defaultQuery] performQuery:queryStr];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}


- documentClass
{ return [KundenDocument class]; }

- itemClass
{ return [KundeItem class]; }

- itemListClass
{ return [KundeItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
