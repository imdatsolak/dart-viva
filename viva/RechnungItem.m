#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "DefaultsDatabase.h"
#import "AddressList.h"
#import "AttachmentList.h"
#import "AuftragItem.h"
#import "AuftragsArtikelItem.h"
#import "AuftragsArtikelList.h"
#import "RechnungItemList.h"
#import "StringManager.h"
#import "TheApp.h"
#import "ZahlungItem.h"
#import "ZahlungsList.h"

#import "RechnungItem.h"

#pragma .h #import "MasterItem.h"

@implementation RechnungItem:MasterItem
{
	id	nr;
	id	aufnr;
	id	datum;
	id	mahnstufe;
	id	storniert;
	id	netto;
	id	mwst;
	id	bezahlt;
	id	adacta;

	id	kundennr;
	id	kundenname;
	id	mahnzeit1;
	id	mahnzeit2;
	id	mahnzeit3;
	id	skontotage;
	id	skontoprozent;
	id	zahlungsziel;
	id	mwstberechnen;
	id	nurgesamtpreis;

	id	artikel;

	id	zahlungen;
	id	attachmentList;
	id	adressen;

	id	rechnungsbetragNetto;
	id	zahlungssummeNetto;
	id	nochoffenNetto;
	id	rechnungsbetragSkonto;
	id	zahlungssummeSkonto;
	id	nochoffenSkonto;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from rechnung where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

+ neueRechnung:artlist auftrag:auftrag netto:(double)nettoD mwst:(double)mwstD
{
	BOOL	result;
	id		rechnung = [[self alloc] initAuftrag:auftrag artikel:artlist netto:nettoD mwst:mwstD];
	
	result = [[NXApp defaultQuery] beginTransaction];
	if(result) {
		result = [rechnung insert];
	}
	if(result) {
		int	i;
		id	string = [QueryString str:"update auftragsartikel set rechnr="];
		[string concatField:[rechnung nr]];
		[string concatSTR:" where class=\"AU\" and id="];
		[string concatField:[auftrag nr]];
		[string concatSTR:" and position in ("];
		for(i=0; i<[artlist count]-1; i++) {
			[string concatFieldComma:[[artlist objectAt:i] position]];
		}
		[string concatField:[[artlist lastObject] position]];
		[string concatSTR:")"];
		[[[NXApp defaultQuery] performQuery:string] free];
		result = [[NXApp defaultQuery] lastError] == NOERROR;
		[string free];
	}
	if(result) {
		result = [self updateAuftragBerechnet:[auftrag nr]];
	}
	if(result) {
		id	bemerkung = [String str:[[NXApp stringMgr] stringFor:"InvoiceCreated"]];
		id	betrag = [Double double:[[rechnung netto] double]+[[rechnung mwst] double]];
		id	zahlung = [[ZahlungItem alloc] initKundennr:[auftrag kundennr]
										   datum:[rechnung datum]
										   betrag:[betrag multDouble:-1.0]
										   rechnr:[rechnung nr]
										   bemerkung:bemerkung];
		result = [zahlung insertInsideTran];
		[zahlung free];
		[betrag free];
		[bemerkung free];
	}
	if(result) {
		id	string = [QueryString str:"insert into attachments values(\"AU\","];
		[string concatFieldComma:[auftrag nr]];
		[string concatINTComma:[[auftrag attachmentList] count]];
		[string concatSTR:"\"RechnungsAttachItem\","];
		[string concatFieldComma:[rechnung nr]];
		[string concatFieldComma:[rechnung nr]];
		[string concatSTR:"\"Rechnung ("];
		[string concatSTR:[[rechnung datum] str]];
		[string concatSTR:")\",0)"];
		[[[NXApp defaultQuery] performQuery:string] free];
		result = [[NXApp defaultQuery] lastError] == NOERROR;
		[string free];
	}
	if(result) {
		result = [[NXApp defaultQuery] commitTransaction];
	}
	if(!result) {
		[[NXApp defaultQuery] rollbackTransaction];
	}
	if(result) {
		return rechnung;
	} else {
		[rechnung free];
		return nil;
	}
}

+ (BOOL)updateAuftragBerechnet:auftragsnr
{
	id		string;
	BOOL	result;
	id		queryResult;
	
	string = [QueryString str:"select count(*) from auftragsartikel"];
	[string concatSTR:" where class=\"AU\" and id="];
	[string concatField:auftragsnr];
	[string concatSTR:" and rechnr=\"0\""];
	queryResult = [[NXApp defaultQuery] performQuery:string];
	[string free];
	result =   ([[NXApp defaultQuery] lastError] == NOERROR)
			&& ([[queryResult objectAt:0] objectAt:0] != nil);
	if(result) {
		string = [QueryString str:"update auftrag set berechnet="];
		if([[[queryResult objectAt:0] objectAt:0] int] == 0) {
			[string concatSTR:"1"];
		} else {
			[string concatSTR:"0"];
		}
		[string concatSTR:" where nr="];
		[string concatField:auftragsnr];
		[[[NXApp defaultQuery] performQuery:string] free];
		[string free];
		result = [[NXApp defaultQuery] lastError] == NOERROR;
	}
	[queryResult free];
	return result;
}

- itemListClass
{ return [RechnungItemList class]; }

- initIdentity:identity
{
	id	queryResult, rechnung;
	
	[self init];
	
	queryString = [QueryString str:"select r.nr, r.aufnr, r.datum, r.mahnstufe, r.storniert, r.netto, r.mwst, r.bezahlt, r.adacta, k.nr, k.kname, a.mahnzeit1, a.mahnzeit2, a.mahnzeit3, a.skontotage, a.skontoprozent, a.zahlungsziel, a.mwstberechnen, a.nurgesamtpreis from rechnung r, kunden k, auftrag a where a.kundennr=k.nr and a.nr=r.aufnr and r.nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	rechnung = [queryResult objectAt:0];
	if(rechnung) {
		[self setNr:[rechnung objectAt:0]];
		[self setAufnr:[rechnung objectAt:1]];
		[self setDatum:[rechnung objectAt:2]];
		[self setMahnstufe:[rechnung objectAt:3]];
		[self setStorniert:[rechnung objectAt:4]];
		[self setNetto:[rechnung objectAt:5]];
		[self setMwst:[rechnung objectAt:6]];
		[self setBezahlt:[rechnung objectAt:7]];
		[self setAdacta:[rechnung objectAt:8]];
		[self setKundennr:[rechnung objectAt:9]];
		[self setKundenname:[rechnung objectAt:10]];
		[self setMahnzeit1:[rechnung objectAt:11]];
		[self setMahnzeit2:[rechnung objectAt:12]];
		[self setMahnzeit3:[rechnung objectAt:13]];
		[self setSkontotage:[rechnung objectAt:14]];
		[self setSkontoprozent:[rechnung objectAt:15]];
		[self setZahlungsziel:[rechnung objectAt:16]];
		[self setMwstberechnen:[rechnung objectAt:17]];
		[self setNurgesamtpreis:[rechnung objectAt:18]];
		
		artikel = [[AuftragsArtikelList alloc] initForRechnung:nr];
		attachmentList = [[AttachmentList alloc] initForRechnung:nr];
		adressen = [[AddressList alloc] initForAuftrag:[self aufnr]];
		[self reloadZahlungen];

		isNew = NO;
		[queryResult free];
		return self;
	} else {
		[queryResult free];
		return [self free];
	}
}


- initAuftrag:auftrag artikel:artikellist netto:(double)nettoDouble mwst:(double)mwstDouble
{
	[self init];
	
	nr				= [String str:""];
	aufnr			= [[auftrag nr] copy];
	datum			= [Date today];
	mahnstufe		= [Integer int:0];
	storniert		= [Integer int:0];
	netto			= [Double double:nettoDouble];
	mwst			= [Double double:mwstDouble];
	bezahlt			= [Integer int:0];
	adacta			= [Integer int:0];
	artikel			= [artikellist copy];
	[artikel renumber];
	
	kundennr		= [[auftrag kundennr] copy];
	kundenname		= [[auftrag kundenname] copy];
	mahnzeit1		= [[auftrag mahnzeit1] copy];
	mahnzeit2		= [[auftrag mahnzeit2] copy];
	mahnzeit3		= [[auftrag mahnzeit3] copy];
	skontotage		= [[auftrag skontotage] copy];
	skontoprozent	= [[auftrag skontoprozent] copy];
	zahlungsziel	= [[auftrag zahlungsziel] copy];
	mwstberechnen	= [[auftrag mwstberechnen] copy];
	nurgesamtpreis	= [[auftrag nurgesamtpreis] copy];
	adressen		= [[auftrag adressen] copy];
	
	attachmentList	= [[AttachmentList alloc] initNew];
	zahlungen		= [[ZahlungsList alloc] initNew];
	[self setNettoSkontoFields];
	
	return self;
}

- reloadZahlungen
{
	[zahlungen free];
	zahlungen = [[ZahlungsList alloc] initForRechnung:nr];
	[self setNettoSkontoFields];
	return self;
}

- setNettoSkontoFields
{
	[rechnungsbetragNetto free];
	[zahlungssummeNetto free];
	[nochoffenNetto free];
	[rechnungsbetragSkonto free];
	[zahlungssummeSkonto free];
	[nochoffenSkonto free];
	rechnungsbetragNetto = [Double double:[netto double]+[mwst double]];
	zahlungssummeNetto = [Double double:[zahlungen summeDouble]];
	nochoffenNetto = [Double double:[rechnungsbetragNetto double]-[zahlungssummeNetto double]];
	rechnungsbetragSkonto = [Double double:[rechnungsbetragNetto double]*(1-[skontoprozent double]/100)];
	zahlungssummeSkonto = [zahlungssummeNetto copy];
	nochoffenSkonto = [Double double:[rechnungsbetragSkonto double]-[zahlungssummeSkonto double]];

	return self;
}

- free
{
	[nr free];
	[aufnr free];
	[datum free];
	[mahnstufe free];
	[storniert free];
	[netto free];
	[mwst free];
	[bezahlt free];
	[adacta free];
	[kundennr free];
	[kundenname free];
	[mahnzeit1 free];
	[mahnzeit2 free];
	[mahnzeit3 free];
	[skontotage free];
	[skontoprozent free];
	[zahlungsziel free];
	[mwstberechnen free];
	[nurgesamtpreis free];
	[artikel free];
	[zahlungen free];
	[attachmentList free];
	[adressen free];
	[rechnungsbetragNetto free];
	[zahlungssummeNetto free];
	[nochoffenNetto free];
	[rechnungsbetragSkonto free];
	[zahlungssummeSkonto free];
	[nochoffenSkonto free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	nr						= [nr copy];
	aufnr					= [aufnr copy];
	datum					= [datum copy];
	mahnstufe				= [mahnstufe copy];
	storniert				= [storniert copy];
	netto					= [netto copy];
	mwst					= [mwst copy];
	bezahlt					= [bezahlt copy];
	adacta					= [adacta copy];
	kundennr				= [kundennr copy];
	kundenname				= [kundenname copy];
	mahnzeit1				= [mahnzeit1 copy];
	mahnzeit2				= [mahnzeit2 copy];
	mahnzeit3				= [mahnzeit3 copy];
	skontotage				= [skontotage copy];
	skontoprozent			= [skontoprozent copy];
	zahlungsziel			= [zahlungsziel copy];
	mwstberechnen			= [mwstberechnen copy];
	nurgesamtpreis			= [nurgesamtpreis copy];
	artikel					= [artikel copy];
	zahlungen				= [zahlungen copy];
	attachmentList			= [attachmentList copy];
	adressen				= [adressen copy];
	rechnungsbetragNetto	= [rechnungsbetragNetto copy];
	zahlungssummeNetto		= [zahlungssummeNetto copy];
	nochoffenNetto			= [nochoffenNetto copy];
	rechnungsbetragSkonto	= [rechnungsbetragSkonto copy];
	zahlungssummeSkonto		= [zahlungssummeSkonto copy];
	nochoffenSkonto			= [nochoffenSkonto copy];
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
	queryString = [QueryString str:"update rechnung set "];
	[[queryString concatSTR:"aufnr="] concatFieldComma:aufnr];
	[[queryString concatSTR:"datum="] concatFieldComma:datum];
	[[queryString concatSTR:"mahnstufe="] concatFieldComma:mahnstufe];
	[[queryString concatSTR:"storniert="] concatFieldComma:storniert];
	[[queryString concatSTR:"netto="] concatFieldComma:netto];
	[[queryString concatSTR:"mwst="] concatFieldComma:mwst];
	[[queryString concatSTR:"bezahlt="] concatFieldComma:bezahlt];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
		
	return [self updateAndFreeQueryString]
		&& [attachmentList saveForRechnung:nr]
		&& [artikel saveForRechnung:nr];
}

- (BOOL)insert
{
	id	string;
	id	result;
	
	string = [QueryString str:"select maxnr+1 from maxrechnung holdlock"];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
		id	value = [[[NXApp defaultsDB] valueForKey:"RechnungItemNrBegin"] copy];
		string = [QueryString str:"update maxrechnung set maxnr="];
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
			queryString = [QueryString str:"insert into rechnung values("];
			[queryString concatFieldComma:nr];
			[queryString concatFieldComma:aufnr];
			[queryString concatFieldComma:datum];
			[queryString concatFieldComma:mahnstufe];
			[queryString concatFieldComma:storniert];
			[queryString concatFieldComma:netto];
			[queryString concatFieldComma:mwst];
			[queryString concatFieldComma:bezahlt];
			[queryString concatField:adacta];
			[queryString concatSTR:")"];
			
			if ( [self insertAndFreeQueryString]
				&& [attachmentList saveForRechnung:nr]
				&& [artikel saveForRechnung:nr]) {
				isNew = NO;
				return YES;
			}
			return NO;
		}
	}
	return NO;
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from rechnung where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [attachmentList destroyForRechnung:nr]
		&& [artikel destroyForRechnung:nr];
}

- addAttachment:attachment
{
	[attachmentList addAttachment:attachment];
	return self;
}

- (BOOL)stornieren
{
	BOOL	result;
	
	result = [[NXApp defaultQuery] beginTransaction];
	if(result) {
		queryString = [QueryString str:"update auftragsartikel set rechnr=\"0\""];
		[queryString concatSTR:" where class=\"AU\" and id="];
		[queryString concatField:[self aufnr]];
		[queryString concatSTR:" and rechnr="];
		[queryString concatField:[self nr]];
		[[[NXApp defaultQuery] performQuery:queryString] free];
		result = [[NXApp defaultQuery] lastError] == NOERROR;
		[queryString free];
	}
	if(result) {
		[storniert setInt:1];
		result = [self update];
	}
	if(result) {
		result = [[self class] updateAuftragBerechnet:[self aufnr]];
	}
	if(result) {
		id	bemerkung = [String str:[[NXApp stringMgr] stringFor:"CreditForCancelledInvoice"]];
		id	betrag = [Double double:[[self netto] double]+[[self mwst] double]];
		id	zahlung = [[ZahlungItem alloc] initKundennr:[self kundennr]
										   datum:[self datum]
										   betrag:betrag
										   rechnr:[self nr]
										   bemerkung:bemerkung];
		result = [zahlung insertInsideTran];
		[zahlung free];
		[betrag free];
		[bemerkung free];
	}
	if(result) {
		result = [[NXApp defaultQuery] commitTransaction];
	}
	if(!result) {
		[storniert setInt:0];
		[[NXApp defaultQuery] rollbackTransaction];
	}
	return result;
}

- identity
{
	return [self nr];
}

- copyBruttoPreis
{
	return [Double double:[netto double]+[mwst double]];
}

- copyMwst
{
	return [mwst copy];
}

- copyNettoPreis
{
	return [netto copy];
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- aufnr { return aufnr; }
- setAufnr:anObject { [aufnr free]; aufnr = [anObject copy]; return self; }
- datum { return datum; }
- setDatum:anObject { [datum free]; datum = [anObject copy]; return self; }
- mahnstufe { return mahnstufe; }
- setMahnstufe:anObject { [mahnstufe free]; mahnstufe = [anObject copy]; return self; }
- storniert { return storniert; }
- setStorniert:anObject { [storniert free]; storniert = [anObject copy]; return self; }
- netto { return netto; }
- setNetto:anObject { [netto free]; netto = [anObject copy]; return self; }
- mwst { return mwst; }
- setMwst:anObject { [mwst free]; mwst = [anObject copy]; return self; }
- bezahlt { return bezahlt; }
- setBezahlt:anObject { [bezahlt free]; bezahlt = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }

- artikel { return artikel; }
- setArtikel:anObject { [artikel free]; artikel = [anObject copy]; return self; }
- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }
- adressen { return adressen; }
- setAdressen:anObject { [adressen free]; adressen = [anObject copy]; return self; }

- kundennr { return kundennr; }
- setKundennr:anObject { [kundennr free]; kundennr = [anObject copy]; return self; }
- kundenname { return kundenname; }
- setKundenname:anObject { [kundenname free]; kundenname = [anObject copy]; return self; }
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
- zahlungsziel { return zahlungsziel; }
- setZahlungsziel:anObject { [zahlungsziel free]; zahlungsziel = [anObject copy]; return self; }
- mwstberechnen { return mwstberechnen; }
- setMwstberechnen:anObject { [mwstberechnen free]; mwstberechnen = [anObject copy]; return self; }
- nurgesamtpreis { return nurgesamtpreis; }
- setNurgesamtpreis:anObject { [nurgesamtpreis free]; nurgesamtpreis = [anObject copy]; return self; }

- zahlungen { return zahlungen; }

- rechnungsbetragNetto { return rechnungsbetragNetto; }
- zahlungssummeNetto { return zahlungssummeNetto; }
- nochoffenNetto { return nochoffenNetto; }
- rechnungsbetragSkonto { return rechnungsbetragSkonto; }
- zahlungssummeSkonto { return zahlungssummeSkonto; }
- nochoffenSkonto { return nochoffenSkonto; }

@end


#if 0
BEGIN TABLE DEFS

create table rechnung
(
	nr				varchar(15),
	aufnr			varchar(15),
	datum			datetime,
	mahnstufe		int,
	storniert		int,
	netto			float,
	mwst			float,
	bezahlt			int,
	adacta			tinyint
)
go
create unique clustered index rechnungindex on rechnung(nr)
create index rechnungaufnrindex on rechnung(aufnr)
go

create table maxrechnung
(
	maxnr int
)
go
insert into maxrechnung values(0)
go

END TABLE DEFS
#endif



