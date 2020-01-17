#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "AttachmentList.h"
#import "DefaultsDatabase.h"
#import "TableManager.h"
#import "TheApp.h"
#import "UserManager.h"

#pragma .h #import "MasterItem.h"

@implementation ArtikelItem:MasterItem
{
	id	nr;
	id	aname;
	id	beschreibung;
	id	kategorie;
	id	lieferbar;
	id	lagerhaltung;
	id	mindestbestand;
	id	mwstsatz;
	id	vk;
	id	ek;
	id	betreuernr;
	id	mengeneinheit;
	id	stueckliste;
	id	bestelldauer;
	id	gewicht;
	id	konditionen;
	id	adacta;
	
	id	attachmentList;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from artikel where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

+ (BOOL)istStueckliste:identity
{
	id		result;
	id		string;
	BOOL	istStueckliste;
	
	string = [[QueryString str:"select stueckliste from artikel where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	istStueckliste = (result != nil) && [[[result objectAt:0] objectAt:0] isTrue];
	[result free];
	[string free];
	
	return istStueckliste;
}

+ (BOOL)hatLagerhaltung:identity
{
	id		result;
	id		string;
	BOOL	hatLagerhaltung;
	
	string = [[QueryString str:"select lagerhaltung from artikel where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	hatLagerhaltung = (result != nil) && [[[result objectAt:0] objectAt:0] isTrue];
	[result free];
	[string free];
	
	return hatLagerhaltung;
}

+ (double)ekFor:identity
{
	id		result;
	id		string;
	double	theEk;
	
	string = [[QueryString str:"select ek from artikel where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	if([[result objectAt:0] objectAt:0]) {
		theEk = [[[result objectAt:0] objectAt:0] double];
	} else {
		theEk = 0.0;
	}
	[result free];
	[string free];
	
	return theEk;
}

- itemListClass
{ return [ArtikelItemList class]; }

- initIdentity:identity
{
	id	queryResult;
	id	artikel;
	
	queryString = [QueryString str:"select nr, aname, beschreibung, kategorie, lieferbar, lagerhaltung, mindestbestand, mwstsatz, vk, ek, betreuernr, mengeneinheit, stueckliste, bestelldauer, gewicht, konditionen, adacta from artikel where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	artikel = [queryResult objectAt:0];
	if(artikel) {
		[self setNr:[artikel objectAt:0]];
		[self setAname:[artikel objectAt:1]];
		[self setBeschreibung:[artikel objectAt:2]];
		[self setKategorie:[artikel objectAt:3]];
		[self setLieferbar:[artikel objectAt:4]];
		[self setLagerhaltung:[artikel objectAt:5]];
		[self setMindestbestand:[artikel objectAt:6]];
		[self setMwstsatz:[artikel objectAt:7]];
		[self setVk:[artikel objectAt:8]];
		[self setEk:[artikel objectAt:9]];
		[self setBetreuernr:[artikel objectAt:10]];
		[self setMengeneinheit:[artikel objectAt:11]];
		[self setStueckliste:[artikel objectAt:12]];
		[self setBestelldauer:[artikel objectAt:13]];
		[self setGewicht:[artikel objectAt:14]];
		[self setKonditionen:[artikel objectAt:15]];
		[self setAdacta:[artikel objectAt:16]];

		attachmentList	= [[AttachmentList alloc] initForArtikel:[self identity]];

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
	aname			= [String str:""];
	beschreibung	= [String str:""];
	kategorie		= [Integer int:0];
	lieferbar		= [Integer int:0];
	lagerhaltung	= [Integer int:0];
	mindestbestand	= [Integer int:0];
	mwstsatz		= [Integer int:0];
	vk				= [Double double:0];
	ek				= [Double double:0];
	betreuernr		= [[[NXApp userMgr] currentUserID] copy];
	mengeneinheit	= [Integer int:0];
	stueckliste		= [Integer int:0];
	bestelldauer	= [Integer int:0];
	gewicht			= [Integer int:0];
	konditionen		= [String str:""];
	adacta			= [Integer int:0];
	attachmentList	= [[AttachmentList alloc] initNew];
	[self readPreferences];
	return self;
}

- readPreferences
{
	id	value;
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelMindestbestand"] copy]) != nil) 
		[self setMindestbestand:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelKategorie"] copy]) != nil) 
		[self setKategorie:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelME"] copy]) != nil) 
		[self setMengeneinheit:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelMwst"] copy]) != nil) 
		[self setMwstsatz:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelLagerhaltung"] copy]) != nil) 
		[self setLagerhaltung:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelLieferbar"] copy]) != nil) 
		[self setLieferbar:value];
	if ((value = [[[NXApp defaultsDB] valueForKey:"artikelStueckliste"] copy]) != nil) 
		[self setStueckliste:value];
	return self;
}

- free
{
	[nr free];
	[aname free];
	[beschreibung free];
	[kategorie free];
	[lieferbar free];
	[lagerhaltung free];
	[mindestbestand free];
	[mwstsatz free];
	[vk free];
	[ek free];
	[betreuernr free];
	[mengeneinheit free];
	[stueckliste free];
	[bestelldauer free];
	[gewicht free];
	[konditionen free];
	[adacta free];
	[attachmentList free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	nr				= [nr copy];
	aname			= [aname copy];
	beschreibung	= [beschreibung copy];
	kategorie		= [kategorie copy];
	lieferbar		= [lieferbar copy];
	lagerhaltung	= [lagerhaltung copy];
	mindestbestand	= [mindestbestand copy];
	mwstsatz		= [mwstsatz copy];
	vk				= [vk copy];
	ek				= [ek copy];
	betreuernr		= [betreuernr copy];
	mengeneinheit	= [mengeneinheit copy];
	stueckliste		= [stueckliste copy];
	bestelldauer	= [bestelldauer copy];
	gewicht			= [gewicht copy];
	konditionen		= [konditionen copy];
	adacta			= [adacta copy];
	attachmentList	= [attachmentList copy];
	
	return theCopy;
}

- (BOOL)saveBulkdata
{
	return [attachmentList saveBulkdata];
}


- (BOOL)update
{
	queryString = [QueryString str:"update artikel set "];
	[[queryString concatSTR:"nr="] concatFieldComma:nr];
	[[queryString concatSTR:"aname="] concatFieldComma:aname];
	[[queryString concatSTR:"beschreibung="] concatFieldComma:beschreibung];
	[[queryString concatSTR:"kategorie="] concatFieldComma:kategorie];
	[[queryString concatSTR:"lieferbar="] concatFieldComma:lieferbar];
	[[queryString concatSTR:"lagerhaltung="] concatFieldComma:lagerhaltung];
	[[queryString concatSTR:"mindestbestand="] concatFieldComma:mindestbestand];
	[[queryString concatSTR:"mwstsatz="] concatFieldComma:mwstsatz];
	[[queryString concatSTR:"vk="] concatFieldComma:vk];
	[[queryString concatSTR:"ek="] concatFieldComma:ek];
	[[queryString concatSTR:"betreuernr="] concatFieldComma:betreuernr];
	[[queryString concatSTR:"mengeneinheit="] concatFieldComma:mengeneinheit];
	[[queryString concatSTR:"stueckliste="] concatFieldComma:stueckliste];
	[[queryString concatSTR:"bestelldauer="] concatFieldComma:bestelldauer];
	[[queryString concatSTR:"gewicht="] concatFieldComma:gewicht];
	[[queryString concatSTR:"konditionen="] concatFieldComma:konditionen];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString] && [attachmentList saveForArtikel:[self identity]];
}

- (BOOL)insert
{
	queryString = [QueryString str:"insert into artikel values("];
	[queryString concatFieldComma:nr];
	[queryString concatFieldComma:aname];
	[queryString concatFieldComma:beschreibung];
	[queryString concatFieldComma:kategorie];
	[queryString concatFieldComma:lieferbar];
	[queryString concatFieldComma:lagerhaltung];
	[queryString concatFieldComma:mindestbestand];
	[queryString concatFieldComma:mwstsatz];
	[queryString concatFieldComma:vk];
	[queryString concatFieldComma:ek];
	[queryString concatFieldComma:betreuernr];
	[queryString concatFieldComma:mengeneinheit];
	[queryString concatFieldComma:stueckliste];
	[queryString concatFieldComma:bestelldauer];
	[queryString concatFieldComma:gewicht];
	[queryString concatFieldComma:konditionen];
	[queryString concatField:adacta];
	[queryString concatSTR:")"];
	
	return [self insertAndFreeQueryString] && [attachmentList saveForArtikel:[self identity]];
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from artikel where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString] && [attachmentList destroyForArtikel:[self identity]];
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

- mwst
{
	return [[NXApp popupMgr] valueFor:[mwstsatz int] inTable:"mwstsaetze"];
}

- mengeneinheitstr
{
	return [[NXApp popupMgr] valueFor:[mengeneinheit int] inTable:"mengeneinheiten"];
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- aname { return aname; }
- setAname:anObject { [aname free]; aname = [anObject copy]; return self; }
- beschreibung { return beschreibung; }
- setBeschreibung:anObject { [beschreibung free]; beschreibung = [anObject copy]; return self; }
- kategorie { return kategorie; }
- setKategorie:anObject { [kategorie free]; kategorie = [anObject copy]; return self; }
- lieferbar { return lieferbar; }
- setLieferbar:anObject { [lieferbar free]; lieferbar = [anObject copy]; return self; }
- lagerhaltung { return lagerhaltung; }
- setLagerhaltung:anObject { [lagerhaltung free]; lagerhaltung = [anObject copy]; return self; }
- mindestbestand { return mindestbestand; }
- setMindestbestand:anObject { [mindestbestand free]; mindestbestand = [anObject copy]; return self; }
- mwstsatz { return mwstsatz; }
- setMwstsatz:anObject { [mwstsatz free]; mwstsatz = [anObject copy]; return self; }
- vk { return vk; }
- setVk:anObject { [vk free]; vk = [anObject copy]; return self; }
- ek { return ek; }
- setEk:anObject { [ek free]; ek = [anObject copy]; return self; }
- betreuernr { return betreuernr; }
- setBetreuernr:anObject { [betreuernr free]; betreuernr = [anObject copy]; return self; }
- mengeneinheit { return mengeneinheit; }
- setMengeneinheit:anObject { [mengeneinheit free]; mengeneinheit = [anObject copy]; return self; }
- stueckliste { return stueckliste; }
- setStueckliste:anObject { [stueckliste free]; stueckliste = [anObject copy]; return self; }
- bestelldauer { return bestelldauer; }
- setBestelldauer:anObject { [bestelldauer free]; bestelldauer = [anObject copy]; return self; }
- gewicht { return gewicht; }
- setGewicht:anObject { [gewicht free]; gewicht = [anObject copy]; return self; }
- konditionen { return konditionen; }
- setKonditionen:anObject { [konditionen free]; konditionen = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }
- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }

@end
#if 0
BEGIN TABLE DEFS

create table artikel
(
	nr				varchar(30),
	aname			varchar(50),
	beschreibung	text,
	kategorie		int,
	lieferbar		int,
	lagerhaltung	int,
	mindestbestand	int,
	mwstsatz		int,
	vk				float,
	ek				float,
	betreuernr		int,
	mengeneinheit	int,
	stueckliste		int,
	bestelldauer	int,
	gewicht			int,
	konditionen		varchar(30),
	adacta			tinyint
)
go
create unique clustered index artikelindex on artikel(nr)
go

END TABLE DEFS
#endif



