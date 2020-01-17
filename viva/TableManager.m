#import <string.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "CustomPopupButton.h"
#import "TheApp.h"

#import "TableManager.h"

#pragma .h #import <objc/Object.h>

@implementation TableManager:Object
{
	id tableList;
	id registeredPopupsList;
}

- init
{
	[super init];
	tableList = [[List alloc] initCount:0];
	registeredPopupsList = [[List alloc] initCount:0];
	return self;
}
	
- free
{
	[tableList makeObjectsPerform:@selector(freeObjects)];
	[[tableList freeObjects] free];
	[registeredPopupsList free];
	return [super free];
}


- tableFor:(const char *)tableName
{
	id	theEntry = [self findEntryFor:tableName];
	if (theEntry) {
		return [theEntry objectAt:1];
	} else {
		return [self performOneQueryFor:tableName];
	}
}

- findEntryFor:(const char *)tableName
{
	int	i,count=[tableList count];
	
	for (i=0;i<count;i++) {
		if ([[[tableList objectAt:i] objectAt:0] compareSTR:tableName]==0) {
			return [tableList objectAt:i];
		}
	}
	return nil;
}

- getNullValueOfTable:(const char *)thisTable
{
	id 	queryString = [QueryString str:"select value from "];
	id	result;
	id	retval = nil;
	[queryString concatSTR:thisTable];
	[queryString concatSTR:" where convert(varchar(15),key) = \"0\""];
	result = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		retval = [[[result objectAt:0] objectAt:0] copy];
	}
	[result free];
	return retval;
}

- performOneQueryFor:(const char *)thisTable
{
	id	entryList;
	id 	queryString = [QueryString str:"select key, value from "];
	
	[queryString concatSTR:thisTable];
	[queryString concatSTR:" where convert(varchar(15),key) != \"0\""];
	entryList = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if (entryList) {
		id	theList = [[List alloc] initCount:3];
		[theList addObject:[String str:thisTable]];
		[theList addObject:entryList];
		[theList addObject:[self getNullValueOfTable:thisTable]];
		[tableList addObject:theList];
	}
	return entryList;
}


- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[self name])) {
		id	theEntry = [self findEntryFor:identitySTR];
		
		if (theEntry) {
			[tableList removeObject:theEntry];
			[[theEntry freeObjects] free];
			[self performOneQueryFor:identitySTR];
			[registeredPopupsList makeObjectsPerform:@selector(tableChanged:) with:(id)identitySTR];
		}
	}
	return self;
}

- titleForKey:(int)aKey inTable:(const char *)theTable
{
	int	i,count;
	id	entryList = [self tableFor:theTable];
	
	count = [entryList count];
	for (i=0;i<count;i++) {
		if ([[[entryList objectAt:i] objectAt:0] compareInt:aKey] == 0 ) {
			return [[entryList objectAt:i] objectAt:1];
		}
	}
	return [[self findEntryFor:theTable] objectAt:2];
}


- valueFor:(int)aKey inTable:(const char *)aTable
{ return [self titleForKey:aKey inTable:aTable]; }


- registerCustomPopup:sender
{
	[registeredPopupsList addObject:sender];
	return self;
}

- unregisterCustomPopup:sender
{
	[registeredPopupsList removeObject:sender];
	return self;
}
@end

#if 0
BEGIN TABLE DEFS

create table artikelkategorien (key int, value varchar(30))
create unique clustered index artikelkategorienindex on artikelkategorien(key)
insert into artikelkategorien values (0,"")

create table kundeneinstufung (key int, value varchar(30))
create unique clustered index kundeneinstufungindex on kundeneinstufung(key)
insert into kundeneinstufung values (0,"")

create table kundengroesse (key int, value varchar(30))
create unique clustered index kundengroesseindex on kundengroesse(key)
insert into kundengroesse values (0,"")

create table kundenkategorien (key int, value varchar(30))
create unique clustered index kundenkategorienindex on kundenkategorien(key)
insert into kundenkategorien values (0,"")

create table mengeneinheiten (key int, value varchar(30))
create unique clustered index mengeneinheitenindex on mengeneinheiten(key)
insert into mengeneinheiten values (0,"")

create table sammelrechnungen (key int, value varchar(30))
create unique clustered index sammelrechnungenindex on sammelrechnungen(key)
insert into sammelrechnungen values (0,"")

create table zugriffsrechte (key int, value varchar(24))
create unique clustered index zugriffsrechteindex on zugriffsrechte(key)
insert into zugriffsrechte values (0,"")

create table laender (key int, value varchar(50))
create unique clustered index laenderindex on laender(key)
insert into laender values (0,"")

create table layoutkategorien (key int, value varchar(50))
create unique clustered index layoutkategorienindex on layoutkategorien(key)
insert into layoutkategorien values (0,"")

create table mwstsaetze (key int, value float)
create unique clustered index mwstsaetzeindex on mwstsaetze(key)
insert into mwstsaetze values (0,0.0)

create table janein (i int, bool varchar(4))
create unique clustered index janeinindex on janein(i)
insert into janein values (0,"nein")
insert into janein values (1,"ja")

END TABLE DEFS
#endif
