#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "ArtikelItem.h"

#import "AuftragsArtikelItem.h"

#pragma .h #import <objc/Object.h>

@implementation AuftragsArtikelItem:Object
{
	id	position;
	id	nr;
	id	beschreibung;
	id	vk;
	id	mwstsatz;
	id	mwst;
	id	anzahl;
	id	mengeneinheitstr;
	id	rabatt;
	id	status;
	id	rechnr;
	id	liefnr;
}

- initPosition:aPosition nr:aNr beschreibung:aBeschreibung vk:aVk mwstsatz:aMwstsatz mwst:aMwst anzahl:aAnzahl mengeneinheitstr:aMengeneinheitstr rabatt:aRabatt status:aStatus rechnr:aRechnr liefnr:aLiefnr
{
	[self init];
	position		= [aPosition copy];
	nr				= [aNr copy];
	beschreibung	= [aBeschreibung copy];
	vk				= [aVk copy];
	mwstsatz		= [aMwstsatz copy];
	mwst			= [aMwst copy];
	anzahl			= [aAnzahl copy];
	mengeneinheitstr= [aMengeneinheitstr copy];
	rabatt			= [aRabatt copy];
	status			= [aStatus copy];
	rechnr			= [aRechnr copy];
	liefnr			= [aLiefnr copy];
	return self;
}

- initFromArticle:article position:(int)pos ek:(BOOL)useEK nurName:(BOOL)nurName
{
	[self init];
	
	position		= [Integer int:pos];
	nr				= [[article nr] copy];
	if(nurName) {
		beschreibung = [[article aname] copy];
	} else {
		beschreibung = [[article beschreibung] copy];
	}
	if(useEK) {
		vk = [[article ek] copy];
	} else {
		vk = [[article vk] copy];
	}
	mwstsatz		= [[article mwstsatz] copy];
	mwst			= [[article mwst] copy];
	anzahl			= [Integer int:1];
	mengeneinheitstr= [[article mengeneinheitstr] copy];
	rabatt			= [Double double:0.0];
	status			= [Integer int:0];
	rechnr			= [String str:"0"];
	liefnr			= [String str:"0"];
	
	return self;
}

- clearRechLiefStatus
{
	[status free];
	[rechnr free];
	[liefnr free];
	status			= [Integer int:0];
	rechnr			= [String str:"0"];
	liefnr			= [String str:"0"];
	return self;
}

- reloadEK
{
	id	newEk = [Double double:[ArtikelItem ekFor:[self nr]]];
	[self setVk:newEk];
	[newEk free];
	return self;
}

- copy
{
	id	theCopy 	= [super copy];
	
	position		= [position copy];
	nr				= [nr copy];
	beschreibung	= [beschreibung copy];
	vk				= [vk copy];
	mwstsatz		= [mwstsatz copy];
	mwst			= [mwst copy];
	anzahl			= [anzahl copy];
	mengeneinheitstr= [mengeneinheitstr copy];
	rabatt			= [rabatt copy];
	status			= [status copy];
	rechnr			= [rechnr copy];
	liefnr			= [liefnr copy];
	
	return theCopy;
}

- free
{
	[position free];
	[nr free];
	[beschreibung free];
	[vk free];
	[mwstsatz free];
	[mwst free];
	[anzahl free];
	[mengeneinheitstr free];
	[rabatt free];
	[status free];
	[rechnr free];
	[liefnr free];
	return [super free];
}

- appendFieldsToQueryString:queryString
{
	[queryString concatFieldComma:position];
	[queryString concatFieldComma:nr];
	[queryString concatFieldComma:beschreibung];
	[queryString concatFieldComma:vk];
	[queryString concatFieldComma:mwstsatz];
	[queryString concatFieldComma:mwst];
	[queryString concatFieldComma:anzahl];
	[queryString concatFieldComma:mengeneinheitstr];
	[queryString concatFieldComma:rabatt];
	[queryString concatFieldComma:status];
	[queryString concatFieldComma:rechnr];
	[queryString concatField:liefnr];
	
	return self;
}

- (int)compare:anotherObject
{
	return [position compare:[anotherObject position]];
}

- (BOOL)istInRechnungGestellt
{
	return ! [rechnr isEqualSTR:"0"];
}

- (BOOL)istGeliefert
{
	return ! [liefnr isEqualSTR:"0"];
}

- (double)nettoPreisDouble
{
	return [[self vk] double] * [[self anzahl] int] * (1-([[self rabatt] double]/100));
}

- (double)mwstDouble
{
	return [self nettoPreisDouble] * ([[self mwst] double] / 100);
}

- (double)bruttoPreisDouble
{
	return [self nettoPreisDouble] + [self mwstDouble];
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

- setAusbuchLager:lagernr
{
	return [self setLiefnr:lagernr];
}

- ausbuchLager
{
	return [self liefnr];
}

- position { return position; }
- setPosition:anObject { [position free]; position = [anObject copy]; return self; }
- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- beschreibung { return beschreibung; }
- setBeschreibung:anObject { [beschreibung free]; beschreibung = [anObject copy]; return self; }
- vk { return vk; }
- setVk:anObject { [vk free]; vk = [anObject copy]; return self; }
- mwstsatz { return mwstsatz; }
- setMwstsatz:anObject { [mwstsatz free]; mwstsatz = [anObject copy]; return self; }
- mwst { return mwst; }
- setMwst:anObject { [mwst free]; mwst = [anObject copy]; return self; }
- anzahl { return anzahl; }
- setAnzahl:anObject { [anzahl free]; anzahl = [anObject copy]; return self; }
- mengeneinheitstr { return mengeneinheitstr; }
- setMengeneinheitstr:anObject { [mengeneinheitstr free]; mengeneinheitstr = [anObject copy]; return self; }
- rabatt { return rabatt; }
- setRabatt:anObject { [rabatt free]; rabatt = [anObject copy]; return self; }
- status { return status; }
- setStatus:anObject { [status free]; status = [anObject copy]; return self; }
- rechnr { return rechnr; }
- setRechnr:anObject { [rechnr free]; rechnr = [anObject copy]; return self; }
- liefnr { return liefnr; }
- setLiefnr:anObject { [liefnr free]; liefnr = [anObject copy]; return self; }

@end


#if 0
BEGIN TABLE DEFS

create table auftragsartikel
(
	class				char(2),
	id					varchar(15),
	position			int,
	nr					varchar(30),
	beschreibung		text,
	vk					float,
	mwstsatz			int,
	mwst				float,
	anzahl				int,
	mengeneinheitstr	varchar(20),
	rabatt				float,
	status				int,
	rechnr				varchar(15),
	liefnr				varchar(15)
)
create unique clustered index auftragsartikelindex on auftragsartikel(class,id,position)
create index auftragsartikelaufnrindex on auftragsartikel(nr)
go

END TABLE DEFS
#endif

