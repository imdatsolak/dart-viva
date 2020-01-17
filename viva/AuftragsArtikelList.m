#import <libc.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "AuftragsArtikelItem.h"
#import "KonditionenItem.h"
#import "KundeItem.h"
#import "TheApp.h"

#import "AuftragsArtikelList.h"

#pragma .h #import "SubItemList.h"

@implementation AuftragsArtikelList:SubItemList
{
}

- initNew
{
	return [super initCount:0];
}

- initForAngebot:angebotsNr		{ return [self initAndLoad:"AN" for:angebotsNr]; }
- initForAuftrag:auftragsNr		{ return [self initAndLoad:"AU" for:auftragsNr]; }
- initForBestellung:bestellNr	{ return [self initAndLoad:"BE" for:bestellNr]; }
- initForLieferschein:liefNr	{ return [self initAndLoad:"LI" for:liefNr]; }
- initForRechnung:rechnungsNr	{ return [self initAndLoad:"RE" for:rechnungsNr]; }

- (BOOL)saveForAngebot:angebotsNr	{ return [self save:"AN" for:angebotsNr]; }
- (BOOL)saveForAuftrag:auftragsNr	{ return [self save:"AU" for:auftragsNr]; }
- (BOOL)saveForBestellung:bestellNr	{ return [self save:"BE" for:bestellNr]; }
- (BOOL)saveForLieferschein:liefNr	{ return [self save:"LI" for:liefNr]; }
- (BOOL)saveForRechnung:rechnungsNr	{ return [self save:"RE" for:rechnungsNr]; }

- (BOOL)destroyForAngebot:angebotsNr	{	return [self destroy:"AN" for:angebotsNr]; }
- (BOOL)destroyForAuftrag:auftragsNr	{	return [self destroy:"AU" for:auftragsNr]; }
- (BOOL)destroyForBestellung:bestellNr	{	return [self destroy:"BE" for:bestellNr]; }
- (BOOL)destroyForLieferschein:liefNr	{	return [self destroy:"LI" for:liefNr]; }
- (BOOL)destroyForRechnung:rechnungsNr	{	return [self destroy:"RE" for:rechnungsNr]; }

- initAndLoad:(const char *)what for:which
{
	id	queryString;

	queryString = [QueryString str:"select position, nr, beschreibung, vk, mwstsatz, mwst, anzahl, mengeneinheitstr, rabatt, status, rechnr, liefnr from auftragsartikel where id="];
	[queryString concatField:which];
	[queryString concatSTR:" and class=\""];
	[queryString concatSTR:what];
	[queryString concatSTR:"\""];
	[self initFromQuery:queryString];
	[queryString free];
	[self sort];
	
	return self;
}


- createItem:aQueryResultRow
{
	id	newItem = [AuftragsArtikelItem alloc];
	
	[newItem initPosition:[aQueryResultRow objectAt:0]
			 nr:[aQueryResultRow objectAt:1]
			 beschreibung:[aQueryResultRow objectAt:2]
			 vk:[aQueryResultRow objectAt:3]
			 mwstsatz:[aQueryResultRow objectAt:4]
			 mwst:[aQueryResultRow objectAt:5]
			 anzahl:[aQueryResultRow objectAt:6]
			 mengeneinheitstr:[aQueryResultRow objectAt:7]
			 rabatt:[aQueryResultRow objectAt:8]
			 status:[aQueryResultRow objectAt:9]
			 rechnr:[aQueryResultRow objectAt:10]
			 liefnr:[aQueryResultRow objectAt:11]];
	
	[self addObject:newItem];
	
	return self;
}

- (BOOL)save:(const char *)which for:what
{
	if([self destroy:which for:what]) {
		int	i;
		for(i=0; i<[self count]; i++) {
			id	queryString = [QueryString str:"insert into auftragsartikel values(\""];
			[queryString concatSTR:which];
			[queryString concatSTR:"\","];
			[queryString concatFieldComma:what];
			[[self objectAt:i] appendFieldsToQueryString:queryString];
			[queryString concatSTR:")"];
			[[[NXApp defaultQuery] performQuery:queryString] free];
			[queryString free];
			if([[NXApp defaultQuery] lastError]!=NOERROR) return NO;
		}
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)destroy:(const char *)which for:what
{
	
	id	queryString;
	queryString = [QueryString str:"delete from auftragsartikel where class=\""];
	[queryString concatSTR:which];
	[queryString concatSTR:"\" and id="];
	[queryString concatField:what];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	
	return [[NXApp defaultQuery] lastError]==NOERROR;
}

- (int)maxPosition
{
	int	i, mx;
	for(i=0,mx=0; i<[self count]; i++) {
		mx = MAX(mx,[[[self objectAt:i] position] int]);
	}
	return mx;
}


- addArtikelList:artikelList ek:(BOOL)useEK nurName:(BOOL)nurName
{
	int	mx = [self maxPosition] + 1;
	int	i, count = [artikelList count];
	
	for(i=0; i<count; i++) {
		id	artikel = [artikelList copyLoadedObjectAt:i];
		if(artikel) {
			id	auftragsArtikel = [AuftragsArtikelItem alloc];
			[auftragsArtikel initFromArticle:artikel position:mx++ ek:useEK nurName:nurName];
			[self addObject:auftragsArtikel];
		}
		[artikel free];
	}
	
	[self sort];
	
	return self;
}

- addArtikelListVK:artikelList nurName:(BOOL)nurName
{
	[self addArtikelList:artikelList ek:NO nurName:nurName];
	return self;
}

- addArtikelListEK:artikelList nurName:(BOOL)nurName
{
	[self addArtikelList:artikelList ek:YES nurName:nurName];
	return self;
}

- addAuftragsArtikel:auftragsartikel
{
	[self addObject:[auftragsartikel copy]];
	return self;
}

- addAuftragsArtikelList:auftragsartikellist
{
	int	i, count = [auftragsartikellist count];
	for(i=0; i<count; i++) {
		[self addObject:[[auftragsartikellist objectAt:i] copy]];
	}
	[self renumber];
	return self;
}

- reloadEKs
{
	[self makeObjectsPerform:@selector(reloadEK)];
	return self;
}

- renumber
{
	int	i, count = [self count];
	for(i=0; i<count; i++) {
		[[[self objectAt:i] position] setInt:i+1];
	}
	return self;
}

- moveObjectFrom:(unsigned)oldPos to:(unsigned)newPos
{
	[self insertObject:[self removeObjectAt:oldPos] at:newPos];
	[self renumber];
	return self;
}

- (double)nettoPreisDouble
{
	int	i, count = [self count];
	double d = 0.0;
	for(i=0; i<count; i++) {
		d += [[self objectAt:i] nettoPreisDouble];
	}
	return d;
}

- (double)mwstDouble
{
	int	i, count = [self count];
	double d = 0.0;
	for(i=0; i<count; i++) {
		d += [[self objectAt:i] mwstDouble];
	}
	return d;
}

- (double)bruttoPreisDouble
{
	int	i, count = [self count];
	double d = 0.0;
	for(i=0; i<count; i++) {
		d += [[self objectAt:i] bruttoPreisDouble];
	}
	return d;
}

- (BOOL)alleNochNichtInRechnung
{
	BOOL	result;
	int		i;
	
	for(result=YES, i=0; result && (i<[self count]); i++) {
		result = 0 == [[[self objectAt:i] rechnr] compareSTR:"0"];
	}
	
	return result;
}

- (BOOL)alleNochNichtGeliefert
{
	BOOL	result;
	int		i;
	
	for(result=YES, i=0; result && (i<[self count]); i++) {
		result = 0 == [[[self objectAt:i] liefnr] compareSTR:"0"];
	}
	
	return result;
}

- copyNettoPreis
{
	return [Double double:[self nettoPreisDouble]];
}

- copyBruttoPreis
{
	return [Double double:[self bruttoPreisDouble]];
}

- copyMwst
{
	return [Double double:[self mwstDouble]];
}

- (BOOL)existiertRechnungOderLieferschein
{
	int	i;
	for(i=0; i<[self count]; i++) {
		if([[self objectAt:i] istInRechnungGestellt] || [[self objectAt:i] istGeliefert]) {
			return YES;
		}
	}
	return NO;
}

- setAusbuchLager:lagernr
{
	int	i;
	for(i=0; i<[self count]; i++) {
		[[self objectAt:i] setAusbuchLager:lagernr];
	}
	return self;
}

- clearRechLiefStatus
{
	int	i;
	for(i=0; i<[self count]; i++) {
		[[self objectAt:i] clearRechLiefStatus];
	}
	return self;
}

- (BOOL)artikelnr:artikelnr istInList:list:(int)i
{
	DEBUG4("%*.*sartikelnr:\"%s\" istInList:...:%d --> ",i,i,"",[artikelnr str],i);
	if(i<[list count]) {
		if([artikelnr isEqual:[list objectAt:i]]) {
			DEBUG4("YES\n",i);
			return YES;
		} else {
			DEBUG4("rec\n");
			return [self artikelnr:artikelnr istInList:list:i+1];
		}
	} else {
		DEBUG4("NO\n");
		return NO;
	}
}

- konditionennr:konditionennr holeAusCache:kondCacheList:(int)i
{
	DEBUG4("%*.*skonditionennr:\"%s\" holeAusCache:...:%d --> ",i,i,"",[konditionennr str],i);
	if(i<[kondCacheList count]) {
		if([konditionennr isEqual:[[kondCacheList objectAt:i] nr]]) {
			DEBUG4("%d\n",i);
			return [kondCacheList objectAt:i];
		} else {
			DEBUG4("rec\n");
			return [self konditionennr:konditionennr holeAusCache:kondCacheList:i+1];
		}
	} else {
		DEBUG4("nil\n");
		return nil;
	}
}

- setzeAlleKondAuf:art beginningAt:(int)i
{
	DEBUG4("setzeAlleKondAuf:{\"%s\",%lf,%lf} beginnintAt:%d -->",[[art nr] str],[[art vk] double],[[art rabatt] double],i);
	for( ; i<[self count]; i++) {
		if([[[self objectAt:i] nr] isEqual:[art nr]]) {
			DEBUG4(" %d",i);
			[[self objectAt:i] setVk:[art vk]];
			[[self objectAt:i] setRabatt:[art rabatt]];
		}
	}
	DEBUG4(".\n");
	return self;
}

- (int)zaehleArt:art beginningAt:(int)i
{
	int	anzahl = 0;
	DEBUG4("zaehleArt:\"%s\" beginnintAt:%d --> %d",[art str],i,anzahl);
	for( ; i<[self count]; i++) {
		if([[[self objectAt:i] nr] isEqual:art]) {
			DEBUG4("+%d",[[[self objectAt:i] anzahl] int]);
			anzahl += [[[self objectAt:i] anzahl] int];
		}
	}
	DEBUG4(" = %d\n",anzahl);
	return anzahl;
}

- getKonditionen:konditionennr forKdkategorie:kdkategorie withCache:kondCacheList
{
	id	konditionen;
	DEBUG4("getKonditionen:\"%s\" withCache:...\n",[konditionennr str]);
	konditionen = [self konditionennr:konditionennr holeAusCache:kondCacheList:0];
	if(konditionen) {
		return konditionen;
	} else {
		konditionen = [[KonditionenItem alloc] initIdentity:konditionennr];
		[konditionen filterForKdkategorie:kdkategorie];
		[kondCacheList addObject:konditionen];
		DEBUG4("[kondCacheList addObject:\"%s\"]\n",[[konditionen nr] str]);
		return konditionen;
	}
}

- passeArt:art anzahl:(int)anzahl anMitKondCache:kondCacheList umsatzCachePtr:(id*)umsatz kunde:kunde auftragsnr:auftragsnr
{
	id	artikelitem;
	id	konditionen;
	id	null = [Double double:0.0];
	DEBUG4("passeArt:\"%s\" anzahl:%d anMitKondCache:... umsatzCachePtr:\"%s\" kunde:\"%s\" auftragsnr:\"%s\"\n",[[art nr] str],anzahl,*umsatz?[*umsatz str]:"nil",[[kunde nr] str],[auftragsnr str]);
	artikelitem = [[ArtikelItem alloc] initIdentity:[art nr]];
	konditionen = [self getKonditionen:[artikelitem konditionen] forKdkategorie:[kunde kategorie] withCache:kondCacheList];
	[art setVk:[artikelitem vk]];
	[art setRabatt:null];
	if(konditionen) {
		int	gesamtanzahl;
		if([konditionen needsGesamtanzahl]) {
			gesamtanzahl = [kunde gesamtanzahlOf:[art nr] ohneAuftrag:auftragsnr];
		} else {
			gesamtanzahl = 0;
		}
		if([konditionen needsUmsatz]) {
			if(*umsatz==nil) {
				*umsatz = [kunde copyUmsatzOhneAuftrag:auftragsnr];
			}
			[konditionen passeAnAnzahl:anzahl
						 vk:[art vk]
						 rabatt:[art rabatt]
						 umsatz:[*umsatz double]
						 gesamtanzahl:gesamtanzahl];
		} else {
			[konditionen passeAnAnzahl:anzahl
						 vk:[art vk]
						 rabatt:[art rabatt]
						 umsatz:0.0
						 gesamtanzahl:gesamtanzahl];
		}
	}
	[artikelitem free];
	[null free];
	return self;
}

- (BOOL)konditionenAnpassenForKunde:kundennr auftragsnr:auftragsnr
{
	id	kunde = [[KundeItem alloc] initIdentity:kundennr];
	DEBUG4("konditionenAnpassenForKunde:\"%s\" auftragsnr:\"%s\"\n",[kundennr str],[auftragsnr str]);
	if(kunde) {
		id	kondCacheList = [[List alloc] initCount:0];
		id	kundenUmsatzCache = nil;
		id	completedArtList = [[List alloc] initCount:0];
		int	i, count = [self count];
		for(i=0; i<count; i++) {
			id	art = [self objectAt:i];
			if(![self artikelnr:[art nr] istInList:completedArtList:0]) {
				[self passeArt:art
					  anzahl:[self zaehleArt:[art nr] beginningAt:i]
					  anMitKondCache:kondCacheList
					  umsatzCachePtr:&kundenUmsatzCache
					  kunde:kunde
					  auftragsnr:auftragsnr];
				[self setzeAlleKondAuf:art beginningAt:i+1];
				[completedArtList addObject:[[art nr] copy]];
			}
		}
		[[completedArtList freeObjects] free];
		[kundenUmsatzCache free];
		[[kondCacheList freeObjects] free];
		[kunde free];
		return YES;
	} else {
		return NO;
	}
}

@end
