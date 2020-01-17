#import "dart/fieldvaluekit.h"

#import "AuftragsArtikelList.h"
#import "KundeItem.h"

#import "AItem.h"

#pragma .h #import "MasterItem.h"

@implementation AItem:MasterItem
{
	id	kundenname;
	id	kundenkategorie;
}

- (BOOL)save
{
	if([[self nurgesamtpreis] isFalse]) {
		[self gesamtpreisUebernehmen];
	}
	return [super save];
}

- copy
{
	id	theCopy = [super copy];
	kundenname = [kundenname copy];
	kundenkategorie = [kundenkategorie copy];
	return theCopy;
}

- free
{
	[self freeKnameUndKategorie];
	return [super free];
}

- freeKnameUndKategorie
{
	kundenname = [kundenname free];
	kundenkategorie = [kundenkategorie free];
	return self;
}

- kundenname { if(kundenname==nil) [self setKnameUndKategorie]; return kundenname; }
- kundenkategorie { if(kundenkategorie==nil) [self setKnameUndKategorie]; return kundenkategorie; }

- setKnameUndKategorie
{
	id	kunde = [[KundeItem alloc] initIdentity:[self kundennr]];
	[kundenname free];
	[kundenkategorie free];
	if(kunde) {
		kundenname = [[kunde kname] copy];
		kundenkategorie = [[kunde kategorieStr] copy];
		[kunde free];
	} else {
		kundenname = [String str:""];
		kundenkategorie = [String str:""];
	}
	return self;
}

- kundennr
{
	return [self subclassResponsibility:_cmd];
}

- artikel
{
	return [self subclassResponsibility:_cmd];
}

- beschreibung
{
	return [self subclassResponsibility:_cmd];
}

- gesamtpreis
{
	return [self subclassResponsibility:_cmd];
}

- setGesamtpreis:sender
{
	return [self subclassResponsibility:_cmd];
}

- mwstberechnen
{
	return [self subclassResponsibility:_cmd];
}

- mwst
{
	return [self subclassResponsibility:_cmd];
}

- nurgesamtpreis
{
	return [self subclassResponsibility:_cmd];
}

- addArtikelListVK:artikelList
{
	[[self artikel] addArtikelListVK:artikelList nurName:[[self beschreibung] int]];
	return self;
}

- addArtikelListEK:artikelList
{
	[[self artikel] addArtikelListEK:artikelList nurName:[[self beschreibung] int]];
	return self;
}

- addAuftragsArtikelList:auftragsartikellist
{
	[[self artikel] addAuftragsArtikelList:auftragsartikellist];
	return self;
}

- gesamtpreisUebernehmen
{
	id	d = [Double double:[[self artikel] nettoPreisDouble]];
	[self setGesamtpreis:d];
	[d free];
	return self;
}

- (double)nettoPreisDouble
{
	if([[self nurgesamtpreis] int]) {
		return [[self gesamtpreis] double];
	} else {
		return [[self artikel] nettoPreisDouble];
	}
}

- (double)mwstDouble
{
	if([[self mwstberechnen] int]) {
		if([[self nurgesamtpreis] int]) {
			return [[self gesamtpreis] double] * ([[self mwst] double] / 100);
		} else {
			return [[self artikel] mwstDouble];
		}
	} else {
		return 0.0;
	}
}

- (double)bruttoPreisDouble
{
	if([[self mwstberechnen] int]) {
		if([[self nurgesamtpreis] int]) {
			return [self nettoPreisDouble] + [self mwstDouble];
		} else {
			return [[self artikel] bruttoPreisDouble];
		}
	} else {
		return [self nettoPreisDouble];
	}
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

@end

