#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "AddressList.h"
#import "ArtikelItem.h"
#import "AttachmentList.h"
#import "AuftragsArtikelItem.h"
#import "AuftragsArtikelList.h"
#import "DefaultsDatabase.h"
#import "LagerChecker.h"
#import "LayoutManager.h"
#import "LieferscheinItemList.h"
#import "PrintRTFItem.h"
#import "SeriennummernList.h"
#import "StringManager.h"
#import "TextParser.h"
#import "TheApp.h"
#import "UserManager.h"

#import "LieferscheinItem.h"

#pragma .h #import "MasterItem.h"

@implementation LieferscheinItem:MasterItem
{
	id	nr;
	id	aufnr;
	id	datum;
	id	storniert;
	id	geliefert;
	id	adacta;

	id	kundennr;
	id	kundenname;

	id	artikel;

	id	attachmentList;
	id	adressen;
	
	id	seriennummern;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from lieferschein where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

+ neuerLieferschein:artikellist auftrag:auftrag
{
	id		lieferschein = [[LieferscheinItem alloc] initAuftrag:auftrag artikel:artikellist];
	BOOL	result = lieferschein != nil;
	
	if(result) {
		result = [[NXApp defaultQuery] beginTransaction];
		if(result) {
			result = [lieferschein insert];
		}
		if(result) {
			int	i;
			id	string;
			[lieferschein setIsNew:NO];
			string = [QueryString str:"update auftragsartikel set liefnr="];
			[string concatField:[lieferschein nr]];
			[string concatSTR:" where class=\"AU\" and id="];
			[string concatField:[auftrag nr]];
			[string concatSTR:" and position in ("];
			for(i=0; i<[artikellist count]-1; i++) {
				[string concatFieldComma:[[artikellist objectAt:i] position]];
			}
			[string concatField:[[artikellist lastObject] position]];
			[string concatSTR:")"];
			[[[NXApp defaultQuery] performQuery:string] free];
			result = [[NXApp defaultQuery] lastError] == NOERROR;
			[string free];
		}
		if(result) {
			result = [self updateAuftragGeliefert:[auftrag nr]];
		}
		if(result) {
			id	string = [QueryString str:"insert into attachments values(\"AU\","];
			[string concatFieldComma:[auftrag nr]];
			[string concatINTComma:[[auftrag attachmentList] count]];
			[string concatSTR:"\"LieferscheinAttachItem\","];
			[string concatFieldComma:[lieferschein nr]];
			[string concatFieldComma:[lieferschein nr]];
			[string concatSTR:"\"Lieferschein ("];
			[string concatSTR:[[lieferschein datum] str]];
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
	}
	if(result) {
		return lieferschein;
	} else {
		[lieferschein free];
		return nil;
	}
}

+ (BOOL)updateAuftragGeliefert:auftragsnr
{
	id		string;
	BOOL	result;
	id		queryResult;
	
	string = [QueryString str:"select count(*) from auftragsartikel"];
	[string concatSTR:" where class=\"AU\" and id="];
	[string concatField:auftragsnr];
	[string concatSTR:" and liefnr=\"0\""];
	queryResult = [[NXApp defaultQuery] performQuery:string];
	[string free];
	result =   ([[NXApp defaultQuery] lastError] == NOERROR)
			&& ([[queryResult objectAt:0] objectAt:0] != nil);
	if(result) {
		string = [QueryString str:"update auftrag set geliefert="];
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
{ return [LieferscheinItemList class]; }

- initIdentity:identity
{
	id	queryResult, lieferschein;
	
	[self init];
	
	queryString = [QueryString str:"select l.nr, l.aufnr, l.datum, l.storniert, l.geliefert, l.adacta, k.nr, k.kname from lieferschein l, kunden k, auftrag a where a.kundennr*=k.nr and a.nr=l.aufnr and l.nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	lieferschein = [queryResult objectAt:0];
	if(lieferschein) {
		[self setNr:[lieferschein objectAt:0]];
		[self setAufnr:[lieferschein objectAt:1]];
		[self setDatum:[lieferschein objectAt:2]];
		[self setStorniert:[lieferschein objectAt:3]];
		[self setGeliefert:[lieferschein objectAt:4]];
		[self setAdacta:[lieferschein objectAt:5]];
		[self setKundennr:[lieferschein objectAt:6]];
		[self setKundenname:[lieferschein objectAt:7]];
		
		artikel = [[AuftragsArtikelList alloc] initForLieferschein:nr];
		attachmentList = [[AttachmentList alloc] initForLieferschein:nr];
		adressen = [[AddressList alloc] initForAuftrag:[self aufnr]];
		seriennummern = [[SeriennummernList alloc] initForLieferschein:nr];

		isNew = NO;
		[queryResult free];
		return self;
	} else {
		[queryResult free];
		return [self free];
	}
}


- initAuftrag:auftrag artikel:artikellist
{
	id	defaultLager = [[NXApp defaultsDB] valueForKey:"defaultLagerZumAusbuchen"];
	[self init];
	
	if(defaultLager != nil) {
		nr				= [String str:""];
		aufnr			= [[auftrag nr] copy];
		datum			= [Date today];
		storniert		= [Integer int:0];
		geliefert		= [Integer int:0];
		adacta			= [Integer int:0];
		artikel			= [artikellist copy];
		[artikel renumber];
		[artikel setAusbuchLager:defaultLager];
		
		kundennr		= [[auftrag kundennr] copy];
		kundenname		= [[auftrag kundenname] copy];
		adressen		= [[auftrag adressen] copy];
		
		seriennummern	= [[SeriennummernList alloc] initNew];
		attachmentList	= [[AttachmentList alloc] initNew];
		return self;
	} else {
		[self free];
		return nil;
	}
}

- free
{
	[nr free];
	[aufnr free];
	[datum free];
	[storniert free];
	[geliefert free];
	[adacta free];
	[kundennr free];
	[kundenname free];
	[artikel free];
	[attachmentList free];
	[seriennummern free];
	[adressen free];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	nr				= [nr copy];
	aufnr			= [aufnr copy];
	datum			= [datum copy];
	storniert		= [storniert copy];
	geliefert		= [geliefert copy];
	adacta			= [adacta copy];
	kundennr		= [kundennr copy];
	kundenname		= [kundenname copy];
	artikel			= [artikel copy];
	attachmentList	= [attachmentList copy];
	seriennummern	= [seriennummern copy];
	adressen		= [adressen copy];
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
	queryString = [QueryString str:"update lieferschein set "];
	[[queryString concatSTR:"aufnr="] concatFieldComma:aufnr];
	[[queryString concatSTR:"datum="] concatFieldComma:datum];
	[[queryString concatSTR:"storniert="] concatFieldComma:storniert];
	[[queryString concatSTR:"geliefert="] concatFieldComma:geliefert];
	[[queryString concatSTR:"adacta="] concatField:adacta];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString]
		&& [attachmentList saveForLieferschein:nr]
		&& [seriennummern saveForLieferschein:nr]
		&& [artikel saveForLieferschein:nr];
}

- (BOOL)insert
{
	id	string;
	id	result;
	
	string = [QueryString str:"select maxnr+1 from maxlieferschein holdlock"];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
		id	value = [[[NXApp defaultsDB] valueForKey:"LieferscheinItemNrBegin"] copy];
		string = [QueryString str:"update maxlieferschein set maxnr="];
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
			queryString = [QueryString str:"insert into lieferschein values("];
			[queryString concatFieldComma:nr];
			[queryString concatFieldComma:aufnr];
			[queryString concatFieldComma:datum];
			[queryString concatFieldComma:storniert];
			[queryString concatFieldComma:geliefert];
			[queryString concatField:adacta];
			[queryString concatSTR:")"];
			
			return [self insertAndFreeQueryString]
				&& [attachmentList saveForLieferschein:nr]
				&& [seriennummern saveForLieferschein:nr]
				&& [artikel saveForLieferschein:nr];
		}
	}
	return NO;
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from lieferschein where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [attachmentList destroyForLieferschein:nr]
		&& [seriennummern destroyForLieferschein:nr]
		&& [artikel destroyForLieferschein:nr];
}

- addAttachment:attachment
{
	[attachmentList addAttachment:attachment];
	return self;
}

- (BOOL)stornieren
{
	int	wargeliefert = [geliefert int];
	
	[storniert setInt:1];
	[geliefert setInt:0];
	
	if(	   [[NXApp defaultQuery] beginTransaction]
		&& [self performStornieren]
		&& [[NXApp defaultQuery] commitTransaction]) {
		return YES;
	} else {
		[storniert setInt:0];
		[geliefert setInt:wargeliefert];
		[[NXApp defaultQuery] rollbackTransaction];
		return NO;
	}
}

- (BOOL)stornierenMitOriginalLager
{
	int	wargeliefert = [geliefert int];
	
	[storniert setInt:1];
	[geliefert setInt:0];
	
	if(	   [[NXApp defaultQuery] beginTransaction]
		&& [self performZurueckbuchen:nil]
		&& [self performStornieren]
		&& [[NXApp defaultQuery] commitTransaction]) {
		return YES;
	} else {
		[storniert setInt:0];
		[geliefert setInt:wargeliefert];
		[[NXApp defaultQuery] rollbackTransaction];
		return NO;
	}
}

- (BOOL)stornierenMitDefaultLager
{
	id		defaultLager = [[[NXApp defaultsDB] valueForKey:"defaultLagerZumAusbuchen"] copy];
	BOOL	result = defaultLager != nil;
	int		wargeliefert = [geliefert int];
	
	[storniert setInt:1];
	[geliefert setInt:0];
	
	if(result) {
		result =   [[NXApp defaultQuery] beginTransaction]
				&& [self performZurueckbuchen:defaultLager]
				&& [self performStornieren]
				&& [[NXApp defaultQuery] commitTransaction];
		if(!result) {
			[[NXApp defaultQuery] rollbackTransaction];
		}
	}
	if(!result) {
		[storniert setInt:0];
		[geliefert setInt:wargeliefert];
	}
	[defaultLager free];
	return result;
}

- (BOOL)performStornieren
{
	BOOL	result;
	
	queryString = [QueryString str:"update auftragsartikel set liefnr=\"0\""];
	[queryString concatSTR:" where class=\"AU\" and id="];
	[queryString concatField:[self aufnr]];
	[queryString concatSTR:" and liefnr="];
	[queryString concatField:[self nr]];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	result = [[NXApp defaultQuery] lastError] == NOERROR;
	[queryString free];
	if(result) {
		result = [[self class] updateAuftragGeliefert:[self aufnr]] && [self update];
	}
	return result;
}

- (BOOL)ausbuchen:nichtvorhandenString
{
	if([geliefert isFalse]) {
		if(	   [[NXApp defaultQuery] beginTransaction]
			&& [self checkIfInLager:nichtvorhandenString]
			&& [self performAusbuchen]) {
			[geliefert setInt:1];
			if([self update] && [[NXApp defaultQuery] commitTransaction]) {
				return YES;
			} else {
				[geliefert setInt:0];
			}
		}
		[[NXApp defaultQuery] rollbackTransaction];
	}
	return NO;
}

- addToList:list atPos:(int)i artnr:artnr lager:lager anzahl:anzahl
{
	if(i<[list count]) {
		id	slot = [list objectAt:i];
		if([[slot objectAt:0] isEqual:artnr] && [[slot objectAt:1] isEqual:lager]) {
			[[slot objectAt:2] addInt:[anzahl int]];
		} else {
			[self addToList:list atPos:i+1 artnr:artnr lager:lager anzahl:anzahl];
		}
	} else {
		id	slot = [[List alloc] initCount:3];
		[slot addObject:[artnr copy]];
		[slot addObject:[lager copy]];
		[slot addObject:[anzahl copy]];
		[list addObject:slot];
	}
	return self;
}

- (BOOL)checkIfInLager:nichtvorhandenString
{
	int		i;
	BOOL	result = YES;
	id		list = [[List alloc] initCount:0];
	
	for(i=0; i<[artikel count]; i++) {
		id	art = [artikel objectAt:i];
		[self addToList:list
			  atPos:0 artnr:[art nr]
			  lager:[art ausbuchLager]
			  anzahl:[art anzahl]];
	}
	for(i=0; i<[list count]; i++) {
		id	art = [list objectAt:i];
		DEBUG("list[%d]:{\"%s\",\"%s\",%d}\n",i,[[art objectAt:0] str],[[art objectAt:1] str],[[art objectAt:2] int]);
		if([ArtikelItem hatLagerhaltung:[art objectAt:0]]) {
			if(-1 == [LagerChecker checkArtikel:[art objectAt:0]
									inLager:[art objectAt:1]
									forCount:[art objectAt:2]]) {
				result = NO;
				[nichtvorhandenString concat:[art objectAt:0]];
				[nichtvorhandenString concatSTR:"\t("];
				[nichtvorhandenString concat:[art objectAt:1]];
				[nichtvorhandenString concatSTR:")\n"];
			}
		}
	}
	[list makeObjectsPerform:@selector(freeObjects)];
	[list freeObjects];
	[list free];
	return result;
}

- (BOOL)performAusbuchen
{
	id		today = [Date today];
	int		i, count = [artikel count];
	BOOL	result = YES;
	char	buff[10000];
	id		comment;
	sprintf(buff,[[NXApp stringMgr] stringFor:"OutputtedDS"],
					[[self nr] str], [today str]);
	comment = [String str:buff];
	
	for(i=0; (i<count) && result; i++) {
		id	art = [artikel objectAt:i];
		if([ArtikelItem hatLagerhaltung:[art nr]]) {
			if([LagerChecker subtractFromLager:[art ausbuchLager]
								theArticle:[art nr]
								numPieces:[art anzahl]]) {
				if(![LagerChecker addToLagervorgang:[art ausbuchLager]
									theArticle:[art nr]
									numPieces:[art anzahl]
									comment:comment
									userno:[[NXApp userMgr] currentUserID]]) {
					result = NO;
				}
			} else {
				result = NO;
			}
		}
	}
	[comment free];
	[today free];
	return result;
}

- (BOOL)performZurueckbuchen:defLager
{
	id		today = [Date today];
	int		i, count = [artikel count];
	BOOL	result = YES;
	char	buff[10000];
	id		comment;
	sprintf(buff,[[NXApp stringMgr] stringFor:"CancelledDSInputted"],
					[[self nr] str], [today str]);
	comment = [String str:buff];

	for(i=0; (i<count) && result; i++) {
		id	art = [artikel objectAt:i];
		if([ArtikelItem hatLagerhaltung:[art nr]]) {
			if([LagerChecker addToLager:((defLager!=nil)?defLager:[art ausbuchLager])
								theArticle:[art nr]
								numPieces:[art anzahl]
								andInsert:YES]) {
				if(![LagerChecker addToLagervorgang:((defLager!=nil)?defLager:[art ausbuchLager])
									theArticle:[art nr]
									numPieces:[art anzahl]
									comment:comment
									userno:[[NXApp userMgr] currentUserID]]) {
					result = NO;
				}
			} else {
				result = NO;
			}
		}
	}
	[comment free];
	[today free];
	return result;
}

- identity
{
	return [self nr];
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- aufnr { return aufnr; }
- setAufnr:anObject { [aufnr free]; aufnr = [anObject copy]; return self; }
- datum { return datum; }
- setDatum:anObject { [datum free]; datum = [anObject copy]; return self; }
- storniert { return storniert; }
- setStorniert:anObject { [storniert free]; storniert = [anObject copy]; return self; }
- geliefert { return geliefert; }
- setGeliefert:anObject { [geliefert free]; geliefert = [anObject copy]; return self; }
- adacta { return adacta; }
- setAdacta:anObject { [adacta free]; adacta = [anObject copy]; return self; }

- kundennr { return kundennr; }
- setKundennr:anObject { [kundennr free]; kundennr = [anObject copy]; return self; }
- kundenname { return kundenname; }
- setKundenname:anObject { [kundenname free]; kundenname = [anObject copy]; return self; }

- artikel { return artikel; }
- setArtikel:anObject { [artikel free]; artikel = [anObject copy]; return self; }

- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }
- adressen { return adressen; }
- setAdressen:anObject { [adressen free]; adressen = [anObject copy]; return self; }
- seriennummern { return seriennummern; }
- setSeriennummern:anObject { [seriennummern free]; seriennummern = [anObject copy]; return self; }

@end


#if 0
BEGIN TABLE DEFS

create table lieferschein
(
	nr				varchar(15),
	aufnr			varchar(15),
	datum			datetime,
	storniert		int,
	geliefert		int,
	adacta			tinyint
)
create unique index lieferscheinindex on lieferschein(nr)
create index lieferscheinaufnrindex on lieferschein(aufnr)
create table maxlieferschein
(
	maxnr int
)
insert into maxlieferschein values(0)
go

END TABLE DEFS
#endif



