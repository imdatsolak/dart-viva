#import <stdlib.h>
#import <string.h>
#import <objc/objc-runtime.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "FileItem.h"

#import "AttachmentItem.h"
#import "AttachmentList.h"

#pragma .h #import "SubItemList.h"

@implementation AttachmentList:SubItemList
{
}

- initNew
{
	return [super initCount:0];
}

- initForAngebot:angebotsNr		{ return [self initAndLoad:"AN" for:angebotsNr]; }
- initForArtikel:artikelNr		{ return [self initAndLoad:"AR" for:artikelNr]; }
- initForAuftrag:auftragsNr		{ return [self initAndLoad:"AU" for:auftragsNr]; }
- initForBenutzer:rechnungsNr	{ return [self initAndLoad:"BN" for:rechnungsNr]; }
- initForBestellung:bestellNr	{ return [self initAndLoad:"BE" for:bestellNr]; }
- initForKunde:kundenNr			{ return [self initAndLoad:"KU" for:kundenNr]; }
- initForLayout:layoutNr		{ return [self initAndLoad:"LA" for:layoutNr]; }
- initForLieferschein:liefNr	{ return [self initAndLoad:"LI" for:liefNr]; }
- initForRechnung:rechnungsNr	{ return [self initAndLoad:"RE" for:rechnungsNr]; }

- (BOOL)saveForAngebot:angebotsNr	{ return [self save:"AN" for:angebotsNr]; }
- (BOOL)saveForArtikel:artikelNr	{ return [self save:"AR" for:artikelNr]; }
- (BOOL)saveForAuftrag:auftragsNr	{ return [self save:"AU" for:auftragsNr]; }
- (BOOL)saveForBenutzer:rechnungsNr	{ return [self save:"BN" for:rechnungsNr]; }
- (BOOL)saveForBestellung:bestellNr	{ return [self save:"BE" for:bestellNr]; }
- (BOOL)saveForKunde:kundenNr		{ return [self save:"KU" for:kundenNr]; }
- (BOOL)saveForLayout:layoutNr		{ return [self save:"LA" for:layoutNr]; }
- (BOOL)saveForLieferschein:liefNr	{ return [self save:"LI" for:liefNr]; }
- (BOOL)saveForRechnung:rechnungsNr	{ return [self save:"RE" for:rechnungsNr]; }

- (BOOL)destroyForAngebot:angebotsNr	{ return [self destroy:"AN" for:angebotsNr]; }
- (BOOL)destroyForArtikel:artikelNr		{ return [self destroy:"AR" for:artikelNr]; }
- (BOOL)destroyForAuftrag:auftragsNr	{ return [self destroy:"AU" for:auftragsNr]; }
- (BOOL)destroyForBenutzer:rechnungsNr	{ return [self destroy:"BN" for:rechnungsNr]; }
- (BOOL)destroyForBestellung:bestellNr	{ return [self destroy:"BE" for:bestellNr]; }
- (BOOL)destroyForKunde:kundenNr		{ return [self destroy:"KU" for:kundenNr]; }
- (BOOL)destroyForLayout:layoutNr		{ return [self destroy:"LA" for:layoutNr]; }
- (BOOL)destroyForLieferschein:liefNr	{ return [self destroy:"LI" for:liefNr]; }
- (BOOL)destroyForRechnung:rechnungsNr	{ return [self destroy:"RE" for:rechnungsNr]; }

- initAndLoad:(const char *)what for:which
{
	id	queryString;

	queryString = [QueryString str:"select position, attachmentclass, identity, description, supplDescription, bulkdataid from attachments where id="];
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
	id		newItemClass;
	id		newItem;
	char	*s = malloc([[aQueryResultRow objectAt:1] length] + 64);
	
	strcpy(s,[[aQueryResultRow objectAt:1] str]);
	newItemClass = objc_getClass(s);
	free(s);
	
	newItem = [newItemClass alloc];
	[newItem initPosition:[aQueryResultRow objectAt:0]
			 identity:[aQueryResultRow objectAt:2]
			 description:[aQueryResultRow objectAt:3]
			 supplDescription:[aQueryResultRow objectAt:4]
			 bulkdataid:[aQueryResultRow objectAt:5]];
	
	[self addObject:newItem];
	
	return self;
}

- (BOOL)save:(const char *)which for:what
{
	if([self destroy:which for:what]) {
		int	i;
		for(i=0; i<[self count]; i++) {
			id	queryString;
			queryString = [QueryString str:"insert into attachments values(\""];
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

- (BOOL)saveBulkdata
{
	int	i;
	for(i=0; (i<[self count]); i++) {
		[[self objectAt:i] saveYourBulkdataIfNecessary];
	}
	return YES;
}

- (BOOL)destroy:(const char *)which for:what
{
	
	id	queryString;
	queryString = [QueryString str:"delete from attachments where class=\""];
	[queryString concatSTR:which];
	[queryString concatSTR:"\" and id="];
	[queryString concatField:what];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	
	return [[NXApp defaultQuery] lastError]==NOERROR;
}

- addAttachment:attachment
{
	[self addObject:[attachment copy]];
	[self renumber];
	return attachment;
}

- removeAttachmentAt:(int)index
{
	[[self removeObjectAt:index] free];
	[self renumber];
	return self;
}

- renumber
{
	int	i, count = [self count];
	for(i=0; i<count; i++) {
		[[[self objectAt:i] position] setInt:i];
	}
	return self;
}

- moveObjectFrom:(unsigned)oldPos to:(unsigned)newPos
{
	[self insertObject:[self removeObjectAt:oldPos] at:newPos];
	[self renumber];
	return self;
}

@end


#if 0
BEGIN TABLE DEFS

create table attachments
(
	class				char(2),
	id					varchar(50),
	position			int,
	attachmentclass		varchar(30),
	identity			text,
	description			text,
	supplDescription	text,
	bulkdataid			int
)
go
create unique clustered index attachmentsindex on attachments(class,id,position)
go

create table bindata (id int,data image)
create unique clustered index bindataindex on bindata(id)
create table maxbindataid ( maxid int )
insert into maxbindataid values(1)
go

END TABLE DEFS
#endif
