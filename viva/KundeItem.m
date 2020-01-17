#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "AddressItem.h"
#import "AddressList.h"
#import "AttachmentList.h"
#import "DefaultsDatabase.h"
#import "KundeItemList.h"
#import "TableManager.h"
#import "TheApp.h"
#import "UserManager.h"

#import "KundeItem.h"

#pragma .h #import "MasterItem.h"
#pragma .h #define MAXKDADR		5

@implementation KundeItem:MasterItem
{
	id	nr;
	id	kname;
	id	einstufung;
	id	kategorie;
	id	groesse;
	id	liefersperre;
	id	zahlungsziel;
	id	kreditlimit;
	id	sammelrechnung;
	id	mahnzeit1;
	id	mahnzeit2;
	id	mahnzeit3;
	id	skontotage;
	id	skontoprozent;
	id	mwstberechnen;
	id	betreuernr;
	id	adacta;
	id	attachmentList;
	id	adressen;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from kunden where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- itemListClass
{ return [KundeItemList class]; }

- initIdentity:identity
{
	id	queryResult, kunde;
	
	[self init];
	
	queryString = [QueryString str:"select nr, kname, einstufung, kategorie, groesse, liefersperre, zahlungsziel, kreditlimit, sammelrechnung, mahnzeit1, mahnzeit2, mahnzeit3, skontotage, skontoprozent, mwstberechnen, betreuernr, adacta from kunden where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	kunde = [queryResult objectAt:0];
	if(kunde) {
		[self setNr:[kunde objectAt:0]];
		[self setKname:[kunde objectAt:1]];
		[self setEinstufung:[kunde objectAt:2]];
		[self setKategorie:[kunde objectAt:3]];
		[self setGroesse:[kunde objectAt:4]];
		[self setLiefersperre:[kunde objectAt:5]];
		[self setZahlungsziel:[kunde objectAt:6]];
		[self setKreditlimit:[kunde objectAt:7]];
		[self setSammelrechnung:[kunde objectAt:8]];
		[self setMahnzeit1:[kunde objectAt:9]];
		[self setMahnzeit2:[kunde objectAt:10]];
		[self setMahnzeit3:[kunde objectAt:11]];
		[self setSkontotage:[kunde objectAt:12]];
		[self setSkontoprozent:[kunde objectAt:13]];
		[self setMwstberechnen:[kunde objectAt:14]];
		[self setBetreuernr:[kunde objectAt:15]];
		[self setAdacta:[kunde objectAt:16]];

		adressen		= [[AddressList alloc] initForKunde:nr];
		attachmentList	= [[AttachmentList alloc] initForKunde:nr];

		isNew = NO;
		[queryResult free];
		return self;
	} else {
		[queryResult free];
		return [self free];
	}
}


- initNew
{
	[self init];

	nr				= [String str:""];
	kname			= [String str:""];
	einstufung		= [Integer int:0];
	kategorie		= [Integer int:0];
	groesse			= [Integer int:0];
	liefersperre	= [Integer int:0];
	zahlungsziel	= [Integer int:14];
	kreditlimit		= [Double double:100000.0];
	sammelrechnung	= [Integer int:0];
	mahnzeit1		= [Integer int:14];
	mahnzeit2		= [Integer int:28];
	mahnzeit3		= [Integer int:42];
	skontotage		= [Integer int:0];
	skontoprozent	= [Double double:0.0];
	mwstberechnen	= [Integer int:1];
	betreuernr		= [[[NXApp userMgr] currentUserID] copy];
	adacta			= [Integer int:0];
	adressen		= [[AddressList alloc] initNewCount:MAXKDADR];
	attachmentList	= [[AttachmentList alloc] initNew];
	[self readPreferences];
	return self;
}

- readPreferences
{
	id	value;
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeEinstufung"] copy]) != nil) 
		[self setEinstufung:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeKategorie"] copy]) != nil) 
		[self setKategorie:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeGroesse"] copy]) != nil) 
		[self setGroesse:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeLiefersperre"] copy]) != nil) 
		[self setLiefersperre:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeZahlungsziel"] copy]) != nil) 
		[self setZahlungsziel:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeKreditlimit"] copy]) != nil) 
		[self setKreditlimit:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeSammelrechnung"] copy]) != nil) 
		[self setSammelrechnung:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMahnzeit1"] copy]) != nil) 
		[self setMahnzeit1:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMahnzeit2"] copy]) != nil) 
		[self setMahnzeit2:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMahnzeit3"] copy]) != nil) 
		[self setMahnzeit3:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeSkontotage"] copy]) != nil) 
		[self setSkontotage:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeSkontoprozent"] copy]) != nil) 
		[self setSkontoprozent:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeMwstberechnen"] copy]) != nil) 
		[self setMwstberechnen:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"kundeAdrLand"] copy]) != nil) {
		int i;
		for (i=0;i<5;i++) {
			[[[self adressen] objectAt:i] setLandnr:value];
		}
	}
	return self;
}

- free
{
	[nr free];
	[kname free];
	[einstufung free];
	[kategorie free];
	[groesse free];
	[liefersperre free];
	[zahlungsziel free];
	[kreditlimit free];
	[sammelrechnung free];
	[mahnzeit1 free];
	[mahnzeit2 free];
	[mahnzeit3 free];
	[skontotage free];
	[skontoprozent free];
	[mwstberechnen free];
	[betreuernr free];
	[adacta free];
	[adressen free];
	[attachmentList free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	nr				= [nr copy];
	kname			= [kname copy];
	einstufung		= [einstufung copy];
	kategorie		= [kategorie copy];
	groesse			= [groesse copy];
	liefersperre	= [liefersperre copy];
	zahlungsziel	= [zahlungsziel copy];
	kreditlimit		= [kreditlimit copy];
	sammelrechnung	= [sammelrechnung copy];
	mahnzeit1		= [mahnzeit1 copy];
	mahnzeit2		= [mahnzeit2 copy];
	mahnzeit3		= [mahnzeit3 copy];
	skontotage		= [skontotage copy];
	skontoprozent	= [skontoprozent copy];
	mwstberechnen	= [mwstberechnen copy];
	betreuernr		= [betreuernr copy];
	adacta			= [adacta copy];
	adressen		= [adressen copy];
	attachmentList	= [attachmentList copy];
	
	return theCopy;
}

- (BOOL)saveBulkdata
{
	return [attachmentList saveBulkdata];
}


- (BOOL)update
{
	queryString = [QueryString str:"update kunden set "];
	[[queryString concatSTR:"kname="] concatFieldComma:kname];
	[[queryString concatSTR:"einstufung="] concatFieldComma:einstufung];
	[[queryString concatSTR:"kategorie="] concatFieldComma:kategorie];
	[[queryString concatSTR:"groesse="] concatFieldComma:groesse];
	[[queryString concatSTR:"liefersperre="] concatFieldComma:liefersperre];
	[[queryString concatSTR:"zahlungsziel="] concatFieldComma:zahlungsziel];
	[[queryString concatSTR:"kreditlimit="] concatFieldComma:kreditlimit];
	[[queryString concatSTR:"sammelrechnung="] concatFieldComma:sammelrechnung];
	[[queryString concatSTR:"mahnzeit1="] concatFieldComma:mahnzeit1];
	[[queryString concatSTR:"mahnzeit2="] concatFieldComma:mahnzeit2];
	[[queryString concatSTR:"mahnzeit3="] concatFieldComma:mahnzeit3];
	[[queryString concatSTR:"skontotage="] concatFieldComma:skontotage];
	[[queryString concatSTR:"skontoprozent="] concatFieldComma:skontoprozent];
	[[queryString concatSTR:"mwstberechnen="] concatFieldComma:mwstberechnen];
	[[queryString concatSTR:"betreuernr="] concatFieldComma:betreuernr];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString]
		&& [adressen saveForKunde:nr]
		&& [attachmentList saveForKunde:nr];
}

- (BOOL)insert
{
	queryString = [QueryString str:"insert into kunden values("];
	[queryString concatFieldComma:nr];
	[queryString concatFieldComma:kname];
	[queryString concatFieldComma:einstufung];
	[queryString concatFieldComma:kategorie];
	[queryString concatFieldComma:groesse];
	[queryString concatFieldComma:liefersperre];
	[queryString concatFieldComma:zahlungsziel];
	[queryString concatFieldComma:kreditlimit];
	[queryString concatFieldComma:sammelrechnung];
	[queryString concatFieldComma:mahnzeit1];
	[queryString concatFieldComma:mahnzeit2];
	[queryString concatFieldComma:mahnzeit3];
	[queryString concatFieldComma:skontotage];
	[queryString concatFieldComma:skontoprozent];
	[queryString concatFieldComma:mwstberechnen];
	[queryString concatFieldComma:betreuernr];
	[queryString concatField:adacta];
	[queryString concatSTR:")"];
	
	return [self insertAndFreeQueryString]
		&& [adressen saveForKunde:nr]
		&& [attachmentList saveForKunde:nr];
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from kunden where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [adressen destroyForKunde:nr]
		&& [attachmentList destroyForKunde:nr];
}

- identity
{
	return [self nr];
}

- addAttachment:attachment
{
	[attachmentList addAttachment:attachment];
	return self;
}

- kategorieStr
{
	return [[NXApp popupMgr] valueFor:[kategorie int] inTable:"kundenkategorien"];
}

- (int)gesamtanzahlOf:artikelnr ohneAuftrag:auftragsnr
{
	int	anzahl;
	id	result;
	id	string = [QueryString str:"select sum(anzahl) from auftragsartikel where class=\"AU\" and nr="];
	[string concatField:artikelnr];
	[string concatSTR:" and id in (select nr from auftrag where kundennr="];
	[string concatField:nr];
	if(auftragsnr) {
		[string concatSTR:" and auftrag.nr!="];
		[string concatField:auftragsnr];
	}
	[string concatSTR:")"];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(	   [[result objectAt:0] objectAt:0]
		&& [[[result objectAt:0] objectAt:0] respondsTo:@selector(int)]) {
		anzahl = [[[result objectAt:0] objectAt:0] int];
	} else {
		anzahl = 0;
	}
	[result free];
	return anzahl;
}

- copyUmsatzOhneAuftrag:auftragsnr
{
	id	umsatz;
	id	result;
	id	string = [QueryString str:"select sum(gesamtpreis) from auftrag where kundennr="];
	[string concatField:nr];
	if(auftragsnr) {
		[string concatSTR:" and nr!="];
		[string concatField:auftragsnr];
	}
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if([[result objectAt:0] objectAt:0]) {
		umsatz = [[[result objectAt:0] objectAt:0] copy];
	} else {
		umsatz = [Double double:0];
	}
	[result free];
	return umsatz;
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- kname { return kname; }
- setKname:anObject { [kname free]; kname = [anObject copy]; return self; }
- einstufung { return einstufung; }
- setEinstufung:anObject { [einstufung free]; einstufung = [anObject copy]; return self; }
- kategorie { return kategorie; }
- setKategorie:anObject { [kategorie free]; kategorie = [anObject copy]; return self; }
- groesse { return groesse; }
- setGroesse:anObject { [groesse free]; groesse = [anObject copy]; return self; }
- liefersperre { return liefersperre; }
- setLiefersperre:anObject { [liefersperre free]; liefersperre = [anObject copy]; return self; }
- zahlungsziel { return zahlungsziel; }
- setZahlungsziel:anObject { [zahlungsziel free]; zahlungsziel = [anObject copy]; return self; }
- kreditlimit { return kreditlimit; }
- setKreditlimit:anObject { [kreditlimit free]; kreditlimit = [anObject copy]; return self; }
- sammelrechnung { return sammelrechnung; }
- setSammelrechnung:anObject { [sammelrechnung free]; sammelrechnung = [anObject copy]; return self; }
- mahnzeit1 { return mahnzeit1; }
- setMahnzeit1:anObject { [mahnzeit1 free]; mahnzeit1 = [anObject copy]; return self; }
- mahnzeit2 { return mahnzeit2; }
- setMahnzeit2:anObject { [mahnzeit2 free]; mahnzeit2 = [anObject copy]; return self; }
- mahnzeit3 { return mahnzeit3; }
- setMahnzeit3:anObject { [mahnzeit3 free]; mahnzeit3 = [anObject copy]; return self; }
- skontotage { return skontotage; }
- setSkontotage:anObject { [skontotage free]; skontotage = [anObject copy]; return self; }
- skontoprozent { return skontoprozent; }
- setSkontoprozent:anObject { [skontoprozent free]; skontoprozent = [anObject copy]; return self; }
- mwstberechnen { return mwstberechnen; }
- setMwstberechnen:anObject { [mwstberechnen free]; mwstberechnen = [anObject copy]; return self; }
- betreuernr { return betreuernr; }
- setBetreuernr:anObject { [betreuernr free]; betreuernr = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }
- adressen { return adressen; }
- setAdressen:anObject { [adressen free]; adressen = [anObject copy]; return self; }
- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }

@end

#if 0
BEGIN TABLE DEFS

create table kunden
(
	nr				varchar(15),
	kname			varchar(50),
	einstufung		int,
	kategorie		int,
	groesse			int,
	liefersperre	int,
	zahlungsziel	int,
	kreditlimit		float,
	sammelrechnung	int,
	mahnzeit1		int,
	mahnzeit2		int,
	mahnzeit3		int,
	skontotage		int,
	skontoprozent	float,
	mwstberechnen	int,
	betreuernr		int,
	adacta			tinyint
)
go
create unique clustered index kundenindex on kunden(nr)
go

END TABLE DEFS
#endif


