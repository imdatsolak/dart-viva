#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "AddressList.h"
#import "AttachmentList.h"
#import "AuftragItemList.h"
#import "AuftragsArtikelList.h"
#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "UserManager.h"

#import "AuftragItem.h"

#pragma .h #import "AItem.h"

@implementation AuftragItem:AItem
{
	id	nr;
	id	datum;
	id	kundennr;
	id	bestelldatum;
	id	bestellnr;
	id	lieferdatum;
	id	skontotage;
	id	skontoprozent;
	id	zahlungsziel;
	id	mahnzeit1;
	id	mahnzeit2;
	id	mahnzeit3;
	id	gesamtpreis;
	id	nurgesamtpreis;
	id	mwst;
	id	betreuernr;
	id	mwstberechnen;
	id	beschreibung;
	id	beschreibunganzeigen;
	id	berechnet;
	id	geliefert;
	id	adacta;

	id	adressen;
	id	artikel;
	id	attachmentList;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from auftrag where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- (BOOL)keineRechOderLief
{
	return NO;
}

- itemListClass
{ return [AuftragItemList class]; }

- initIdentity:identity
{
	id	queryResult, auftrag;
	
	[self init];
	
	queryString = [QueryString str:"select nr, datum, kundennr, bestelldatum, bestellnr, lieferdatum, skontotage, skontoprozent, zahlungsziel, mahnzeit1, mahnzeit2, mahnzeit3, gesamtpreis, nurgesamtpreis, mwst, betreuernr, mwstberechnen, beschreibung, beschreibunganzeigen, geliefert, berechnet, adacta from auftrag where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	auftrag = [queryResult objectAt:0];
	if(auftrag) {
		[self setNr:[auftrag objectAt:0]];
		[self setDatum:[auftrag objectAt:1]];
		[self setKundennr:[auftrag objectAt:2]];
		[self setBestelldatum:[auftrag objectAt:3]];
		[self setBestellnr:[auftrag objectAt:4]];
		[self setLieferdatum:[auftrag objectAt:5]];
		[self setSkontotage:[auftrag objectAt:6]];
		[self setSkontoprozent:[auftrag objectAt:7]];
		[self setZahlungsziel:[auftrag objectAt:8]];
		[self setMahnzeit1:[auftrag objectAt:9]];
		[self setMahnzeit2:[auftrag objectAt:10]];
		[self setMahnzeit3:[auftrag objectAt:11]];
		[self setGesamtpreis:[auftrag objectAt:12]];
		[self setNurgesamtpreis:[auftrag objectAt:13]];
		[self setMwst:[auftrag objectAt:14]];
		[self setBetreuernr:[auftrag objectAt:15]];
		[self setMwstberechnen:[auftrag objectAt:16]];
		[self setBeschreibung:[auftrag objectAt:17]];
		[self setBeschreibunganzeigen:[auftrag objectAt:18]];
		[self setGeliefert:[auftrag objectAt:19]];
		[self setBerechnet:[auftrag objectAt:20]];
		[self setAdacta:[auftrag objectAt:21]];
		
		adressen = [[AddressList alloc] initForAuftrag:nr];
		artikel = [[AuftragsArtikelList alloc] initForAuftrag:nr];
		attachmentList = [[AttachmentList alloc] initForAuftrag:nr];
			
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
	
	nr						= [String str:""];
	datum					= [Date today];
	kundennr				= [String str:""];
	bestelldatum			= [Date today];
	bestellnr				= [String str:""];
	lieferdatum				= [Date today];
	skontotage				= [Integer int:0];
	skontoprozent			= [Double double:0.0];
	zahlungsziel			= [Integer int:0];
	mahnzeit1				= [Integer int:0];
	mahnzeit2				= [Integer int:0];
	mahnzeit3				= [Integer int:0];
	gesamtpreis				= [Double double:0.0];
	nurgesamtpreis			= [Integer int:0];
	mwst					= [Double double:14.0];
	betreuernr				= [[[NXApp userMgr] currentUserID] copy];
	mwstberechnen			= [Integer int:1];
	beschreibung			= [Integer int:0];
	beschreibunganzeigen	= [Integer int:0];
	berechnet				= [Integer int:0];
	geliefert				= [Integer int:0];
	adacta					= [Integer int:0];
	adressen				= [[AddressList alloc] initNewCount:2];
	artikel					= [[AuftragsArtikelList alloc] initNew];
	attachmentList			= [[AttachmentList alloc] initNew];
	[self readPreferences];
	return self;
}

- readPreferences
{
	id	value;
	if ((value = [[[NXApp defaultsDB] valueForKey:"AuftragBezBeschr"] copy]) != nil) 
		[self setBeschreibunganzeigen:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"AuftragNurGesamtpreis"] copy]) != nil) 
		[self setNurgesamtpreis:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"defaultMwSt"] copy]) != nil) 
		[self setMwst:value];
	return self;
}

- free
{
	[nr free];
	[datum free];
	[kundennr free];
	[bestelldatum free];
	[bestellnr free];
	[lieferdatum free];
	[skontotage free];
	[skontoprozent free];
	[zahlungsziel free];
	[mahnzeit1 free];
	[mahnzeit2 free];
	[mahnzeit3 free];
	[gesamtpreis free];
	[nurgesamtpreis free];
	[mwst free];
	[betreuernr free];
	[mwstberechnen free];
	[beschreibung free];
	[beschreibunganzeigen free];
	[berechnet free];
	[geliefert free];
	[adacta free];
	[adressen free];
	[artikel free];
	[attachmentList free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	nr						= [nr copy];
	datum					= [datum copy];
	kundennr				= [kundennr copy];
	bestelldatum			= [bestelldatum copy];
	bestellnr				= [bestellnr copy];
	lieferdatum				= [lieferdatum copy];
	skontotage				= [skontotage copy];
	skontoprozent			= [skontoprozent copy];
	zahlungsziel			= [zahlungsziel copy];
	mahnzeit1				= [mahnzeit1 copy];
	mahnzeit2				= [mahnzeit2 copy];
	mahnzeit3				= [mahnzeit3 copy];
	gesamtpreis				= [gesamtpreis copy];
	nurgesamtpreis			= [nurgesamtpreis copy];
	mwst					= [mwst copy];
	betreuernr				= [betreuernr copy];
	mwstberechnen			= [mwstberechnen copy];
	beschreibung			= [beschreibung copy];
	beschreibunganzeigen	= [beschreibunganzeigen copy];
	berechnet				= [berechnet copy];
	geliefert				= [geliefert copy];
	adacta					= [adacta copy];
	adressen				= [adressen copy];
	artikel					= [artikel copy];
	attachmentList			= [attachmentList copy];
	
	return theCopy;
}

- (BOOL)isSaveable
{
	return YES;
}

- (BOOL)saveBulkdata
{
	return [attachmentList saveBulkdata];
}

- (BOOL)update
{
	queryString = [QueryString str:"update auftrag set "];
	[[queryString concatSTR:"datum="] concatFieldComma:datum];
	[[queryString concatSTR:"kundennr="] concatFieldComma:kundennr];
	[[queryString concatSTR:"bestelldatum="] concatFieldComma:bestelldatum];
	[[queryString concatSTR:"bestellnr="] concatFieldComma:bestellnr];
	[[queryString concatSTR:"lieferdatum="] concatFieldComma:lieferdatum];
	[[queryString concatSTR:"skontotage="] concatFieldComma:skontotage];
	[[queryString concatSTR:"skontoprozent="] concatFieldComma:skontoprozent];
	[[queryString concatSTR:"zahlungsziel="] concatFieldComma:zahlungsziel];
	[[queryString concatSTR:"mahnzeit1="] concatFieldComma:mahnzeit1];
	[[queryString concatSTR:"mahnzeit2="] concatFieldComma:mahnzeit2];
	[[queryString concatSTR:"mahnzeit3="] concatFieldComma:mahnzeit3];
	[[queryString concatSTR:"gesamtpreis="] concatFieldComma:gesamtpreis];
	[[queryString concatSTR:"nurgesamtpreis="] concatFieldComma:nurgesamtpreis];
	[[queryString concatSTR:"mwst="] concatFieldComma:mwst];
	[[queryString concatSTR:"betreuernr="] concatFieldComma:betreuernr];
	[[queryString concatSTR:"mwstberechnen="] concatFieldComma:mwstberechnen];
	[[queryString concatSTR:"beschreibung="] concatFieldComma:beschreibung];
	[[queryString concatSTR:"beschreibunganzeigen="] concatFieldComma:beschreibunganzeigen];
	[[queryString concatSTR:"berechnet="] concatFieldComma:berechnet];
	[[queryString concatSTR:"geliefert="] concatFieldComma:geliefert];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString]
		&& [adressen saveForAuftrag:nr]
		&& [artikel saveForAuftrag:nr]
		&& [attachmentList saveForAuftrag:nr];
}

- (BOOL)insert
{
	id	string;
	id	result;
	
	string = [QueryString str:"select maxnr+1 from maxauftrag holdlock"];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
		id	value = [[[NXApp defaultsDB] valueForKey:"AuftragItemNrBegin"] copy];
		string = [QueryString str:"update maxauftrag set maxnr="];
		if ((value == nil) || ([value compare:[[result objectAt:0] objectAt:0]] <= 0)) {
			[self setNrFromInteger:[[result objectAt:0] objectAt:0]];
			[string concatSTR:"maxnr+1"];
		} else {
			[self setNrFromInteger:value];
			[string concatField:value];
		}
		[value free];
		[[[NXApp defaultQuery] performQuery:string] free];
		[string free];

		if([[NXApp defaultQuery] lastError]==NOERROR) {
			queryString = [QueryString str:"insert into auftrag values("];
			[queryString concatFieldComma:nr];
			[queryString concatFieldComma:datum];
			[queryString concatFieldComma:kundennr];
			[queryString concatFieldComma:bestelldatum];
			[queryString concatFieldComma:bestellnr];
			[queryString concatFieldComma:lieferdatum];
			[queryString concatFieldComma:skontotage];
			[queryString concatFieldComma:skontoprozent];
			[queryString concatFieldComma:zahlungsziel];
			[queryString concatFieldComma:mahnzeit1];
			[queryString concatFieldComma:mahnzeit2];
			[queryString concatFieldComma:mahnzeit3];
			[queryString concatFieldComma:gesamtpreis];
			[queryString concatFieldComma:nurgesamtpreis];
			[queryString concatFieldComma:mwst];
			[queryString concatFieldComma:betreuernr];
			[queryString concatFieldComma:mwstberechnen];
			[queryString concatFieldComma:beschreibung];
			[queryString concatFieldComma:beschreibunganzeigen];
			[queryString concatFieldComma:berechnet];
			[queryString concatFieldComma:geliefert];
			[queryString concatField:adacta];
			[queryString concatSTR:")"];
			
			return [self insertAndFreeQueryString]
				&& [adressen saveForAuftrag:nr]
				&& [artikel saveForAuftrag:nr]
				&& [attachmentList saveForAuftrag:nr];
		}
	}
	return NO;
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from auftrag where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [adressen destroyForAuftrag:nr]
		&& [artikel destroyForAuftrag:nr]
		&& [attachmentList destroyForAuftrag:nr];
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

- rechnungsAdresse
{
	return [adressen objectAt:0];
}

- lieferAdresse
{
	return [adressen objectAt:1];
}

- setRechnungsAdresse:anObject
{
	[[adressen replaceObjectAt:0 with:[anObject copy]] free];
	return self;
}

- setLieferAdresse:anObject
{
	[[adressen replaceObjectAt:1 with:[anObject copy]] free];
	return self;
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- datum { return datum; }
- setDatum:anObject { [datum free]; datum = [anObject copy]; return self; }
- kundennr { return kundennr; }

- setKundennr:anObject
{
	[self freeKnameUndKategorie];
	[kundennr free];
	kundennr = [anObject copy];
	return self;
}

- konditionenAnpassen
{
	[[self artikel] konditionenAnpassenForKunde:[self kundennr] auftragsnr:nr];
	return self;
}

- bestelldatum { return bestelldatum; }
- setBestelldatum:anObject { [bestelldatum free]; bestelldatum = [anObject copy]; return self; }
- bestellnr { return bestellnr; }
- setBestellnr:anObject { [bestellnr free]; bestellnr = [anObject copy]; return self; }
- lieferdatum { return lieferdatum; }
- setLieferdatum:anObject { [lieferdatum free]; lieferdatum = [anObject copy]; return self; }
- skontotage { return skontotage; }
- setSkontotage:anObject { [skontotage free]; skontotage = [anObject copy]; return self; }
- skontoprozent { return skontoprozent; }
- setSkontoprozent:anObject { [skontoprozent free]; skontoprozent = [anObject copy]; return self; }
- zahlungsziel { return zahlungsziel; }
- setZahlungsziel:anObject { [zahlungsziel free]; zahlungsziel = [anObject copy]; return self; }
- mahnzeit1 { return mahnzeit1; }
- setMahnzeit1:anObject { [mahnzeit1 free]; mahnzeit1 = [anObject copy]; return self; }
- mahnzeit2 { return mahnzeit2; }
- setMahnzeit2:anObject { [mahnzeit2 free]; mahnzeit2 = [anObject copy]; return self; }
- mahnzeit3 { return mahnzeit3; }
- setMahnzeit3:anObject { [mahnzeit3 free]; mahnzeit3 = [anObject copy]; return self; }
- gesamtpreis { return gesamtpreis; }
- setGesamtpreis:anObject { [gesamtpreis free]; gesamtpreis = [anObject copy]; return self; }
- nurgesamtpreis { return nurgesamtpreis; }
- setNurgesamtpreis:anObject { [nurgesamtpreis free]; nurgesamtpreis = [anObject copy]; return self; }
- mwst { return mwst; }
- setMwst:anObject { [mwst free]; mwst = [anObject copy]; return self; }
- betreuernr { return betreuernr; }
- setBetreuernr:anObject { [betreuernr free]; betreuernr = [anObject copy]; return self; }
- mwstberechnen { return mwstberechnen; }
- setMwstberechnen:anObject { [mwstberechnen free]; mwstberechnen = [anObject copy]; return self; }
- beschreibung { return beschreibung; }
- setBeschreibung:anObject { [beschreibung free]; beschreibung = [anObject copy]; return self; }
- beschreibunganzeigen { return beschreibunganzeigen; }
- setBeschreibunganzeigen:anObject { [beschreibunganzeigen free]; beschreibunganzeigen = [anObject copy]; return self; }
- berechnet { return berechnet; }
- setBerechnet:anObject { [berechnet free]; berechnet = [anObject copy]; return self; }
- geliefert { return geliefert; }
- setGeliefert:anObject { [geliefert free]; geliefert = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }
- adressen { return adressen; }
- setAdressen:anObject { [adressen free]; adressen = [anObject copy]; return self; }
- artikel { return artikel; }
- setArtikel:anObject { [artikel free]; artikel = [anObject copy]; return self; }
- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }

@end


#if 0
BEGIN TABLE DEFS

create table auftrag
(
	nr						varchar(15),
	datum					datetime,
	kundennr				varchar(15),
	bestelldatum			datetime,
	bestellnr				varchar(30),
	lieferdatum				datetime,
	skontotage				int,
	skontoprozent			float,
	zahlungsziel			int,
	mahnzeit1				int,
	mahnzeit2				int,
	mahnzeit3				int,
	gesamtpreis				float,
	nurgesamtpreis			int,
	mwst					float,
	betreuernr				int,
	mwstberechnen			int,
	beschreibung			int,
	beschreibunganzeigen	int,
	geliefert				int,
	berechnet				int,
	adacta					tinyint
)
go
create unique clustered index auftragindex on auftrag(nr)
create index auftragkundennrindex on auftrag(kundennr)
create index auftragdatumindex on auftrag(datum)
go

create table maxauftrag
(
	maxnr int
)
go
insert into maxauftrag values(0)
go

END TABLE DEFS
#endif



