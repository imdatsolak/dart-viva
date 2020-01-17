#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "AddressList.h"
#import "AttachmentList.h"
#import "AuftragsArtikelList.h"
#import "BestellungItemList.h"
#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "UserManager.h"

#import "BestellungItem.h"

#pragma .h #import "AItem.h"

@implementation BestellungItem:AItem
{
	id	nr;
	id	datum;
	id	kundennr;
	id	skontotage;
	id	skontoprozent;
	id	zahlungsziel;
	id	gesamtpreis;
	id	nurgesamtpreis;
	id	mwst;
	id	betreuernr;
	id	mwstberechnen;
	id	beschreibung;
	id	beschreibunganzeigen;
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
	
	string = [[QueryString str:"select nr from bestellung where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- itemListClass
{ return [BestellungItemList class]; }

- initIdentity:identity
{
	id	queryResult, bestellung;
	
	[self init];
	
	queryString = [QueryString str:"select nr, datum, kundennr, skontotage, skontoprozent, zahlungsziel, gesamtpreis, nurgesamtpreis, mwst, betreuernr, mwstberechnen, beschreibung, beschreibunganzeigen, adacta from bestellung where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	bestellung = [queryResult objectAt:0];
	if(bestellung) {
		[self setNr:[bestellung objectAt:0]];
		[self setDatum:[bestellung objectAt:1]];
		[self setKundennr:[bestellung objectAt:2]];
		[self setSkontotage:[bestellung objectAt:3]];
		[self setSkontoprozent:[bestellung objectAt:4]];
		[self setZahlungsziel:[bestellung objectAt:5]];
		[self setGesamtpreis:[bestellung objectAt:6]];
		[self setNurgesamtpreis:[bestellung objectAt:7]];
		[self setMwst:[bestellung objectAt:8]];
		[self setBetreuernr:[bestellung objectAt:9]];
		[self setMwstberechnen:[bestellung objectAt:10]];
		[self setBeschreibung:[bestellung objectAt:11]];
		[self setBeschreibunganzeigen:[bestellung objectAt:12]];
		[self setAdacta:[bestellung objectAt:13]];
		
		adressen = [[AddressList alloc] initForBestellung:nr];
		artikel = [[AuftragsArtikelList alloc] initForBestellung:nr];
		attachmentList = [[AttachmentList alloc] initForBestellung:nr];
			
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
	skontotage				= [Integer int:0];
	skontoprozent			= [Double double:0.0];
	zahlungsziel			= [Integer int:0];
	gesamtpreis				= [Double double:0.0];
	nurgesamtpreis			= [Integer int:0];
	mwst					= [Double double:14.0];
	betreuernr				= [[[NXApp userMgr] currentUserID] copy];
	mwstberechnen			= [Integer int:1];
	beschreibung			= [Integer int:0];
	beschreibunganzeigen	= [Integer int:0];
	adacta					= [Integer int:0];
	adressen				= [[AddressList alloc] initNewCount:1];
	artikel					= [[AuftragsArtikelList alloc] initNew];
	attachmentList			= [[AttachmentList alloc] initNew];
	[self readPreferences];
	return self;
}

- readPreferences
{
	id	value;
	if ((value = [[[NXApp defaultsDB] valueForKey:"BestellBezBeschr"] copy]) != nil) 
		[self setBeschreibunganzeigen:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"BestellNurGesamtpreis"] copy]) != nil) 
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
	[skontotage free];
	[skontoprozent free];
	[zahlungsziel free];
	[gesamtpreis free];
	[nurgesamtpreis free];
	[mwst free];
	[betreuernr free];
	[mwstberechnen free];
	[beschreibung free];
	[beschreibunganzeigen free];
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
	skontotage				= [skontotage copy];
	skontoprozent			= [skontoprozent copy];
	zahlungsziel			= [zahlungsziel copy];
	gesamtpreis				= [gesamtpreis copy];
	nurgesamtpreis			= [nurgesamtpreis copy];
	mwst					= [mwst copy];
	betreuernr				= [betreuernr copy];
	mwstberechnen			= [mwstberechnen copy];
	beschreibung			= [beschreibung copy];
	beschreibunganzeigen	= [beschreibunganzeigen copy];
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
	queryString = [QueryString str:"update bestellung set "];
	[[queryString concatSTR:"datum="] concatFieldComma:datum];
	[[queryString concatSTR:"kundennr="] concatFieldComma:kundennr];
	[[queryString concatSTR:"skontotage="] concatFieldComma:skontotage];
	[[queryString concatSTR:"skontoprozent="] concatFieldComma:skontoprozent];
	[[queryString concatSTR:"zahlungsziel="] concatFieldComma:zahlungsziel];
	[[queryString concatSTR:"gesamtpreis="] concatFieldComma:gesamtpreis];
	[[queryString concatSTR:"nurgesamtpreis="] concatFieldComma:nurgesamtpreis];
	[[queryString concatSTR:"mwst="] concatFieldComma:mwst];
	[[queryString concatSTR:"betreuernr="] concatFieldComma:betreuernr];
	[[queryString concatSTR:"mwstberechnen="] concatFieldComma:mwstberechnen];
	[[queryString concatSTR:"beschreibung="] concatFieldComma:beschreibung];
	[[queryString concatSTR:"beschreibunganzeigen="] concatFieldComma:beschreibunganzeigen];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString]
		&& [adressen saveForBestellung:nr]
		&& [artikel saveForBestellung:nr]
		&& [attachmentList saveForBestellung:nr];
}

- (BOOL)insert
{
	id	string;
	id	result;
	
	string = [QueryString str:"select maxnr+1 from maxbestellung holdlock"];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
		id	value = [[[NXApp defaultsDB] valueForKey:"BestellungItemNrBegin"] copy];
		string = [QueryString str:"update maxbestellung set maxnr="];
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
			queryString = [QueryString str:"insert into bestellung values("];
			[queryString concatFieldComma:nr];
			[queryString concatFieldComma:datum];
			[queryString concatFieldComma:kundennr];
			[queryString concatFieldComma:skontotage];
			[queryString concatFieldComma:skontoprozent];
			[queryString concatFieldComma:zahlungsziel];
			[queryString concatFieldComma:gesamtpreis];
			[queryString concatFieldComma:nurgesamtpreis];
			[queryString concatFieldComma:mwst];
			[queryString concatFieldComma:betreuernr];
			[queryString concatFieldComma:mwstberechnen];
			[queryString concatFieldComma:beschreibung];
			[queryString concatFieldComma:beschreibunganzeigen];
			[queryString concatField:adacta];
			[queryString concatSTR:")"];
			
			return [self insertAndFreeQueryString]
				&& [adressen saveForBestellung:nr]
				&& [artikel saveForBestellung:nr]
				&& [attachmentList saveForBestellung:nr];
		}
	}
	return NO;
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from bestellung where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [adressen destroyForBestellung:nr]
		&& [artikel destroyForBestellung:nr]
		&& [attachmentList destroyForBestellung:nr];
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

- adresse
{
	return [adressen objectAt:0];
}

- setAdresse:anObject
{
	[[adressen replaceObjectAt:0 with:[anObject copy]] free];
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

- skontotage { return skontotage; }
- setSkontotage:anObject { [skontotage free]; skontotage = [anObject copy]; return self; }
- skontoprozent { return skontoprozent; }
- setSkontoprozent:anObject { [skontoprozent free]; skontoprozent = [anObject copy]; return self; }
- zahlungsziel { return zahlungsziel; }
- setZahlungsziel:anObject { [zahlungsziel free]; zahlungsziel = [anObject copy]; return self; }
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

create table bestellung
(
	nr						varchar(15),
	datum					datetime,
	kundennr				varchar(15),
	skontotage				int,
	skontoprozent			float,
	zahlungsziel			int,
	gesamtpreis				float,
	nurgesamtpreis			int,
	mwst					float,
	betreuernr				int,
	mwstberechnen			int,
	beschreibung			int,
	beschreibunganzeigen	int,
	adacta					tinyint
)
go
create unique clustered index bestellungindex on bestellung(nr)
create index bestellungkundennrindex on bestellung(kundennr)
go

create table maxbestellung
(
	maxnr int
)
go
insert into maxbestellung values(0)
go

END TABLE DEFS
#endif

