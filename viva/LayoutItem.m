#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "AttachmentList.h"
#import "LayoutItemList.h"
#import "PrintRTFItem.h"
#import "TheApp.h"
#import "UserManager.h"

#import "LayoutItem.h"

#pragma .h #import "MasterItem.h"

@implementation LayoutItem:MasterItem
{
	id	nr;
	id	beschreibung;
	id	betreuernr;
	id	kategorie;

	id	attachmentList;
}

+ (BOOL)exists:identity
{
	id		result;
	id		string;
	BOOL	found;
	
	string = [[QueryString str:"select nr from layout where nr="] concatField:identity];
	result = [[NXApp defaultQuery] performQuery:string];
	found = (result != nil) && ([result count] > 0);
	[result free];
	[string free];
	
	return found;
}

- itemListClass
{ return [LayoutItemList class]; }

- initIdentity:identity
{
	id	queryResult, layout;

	[self init];
	
	queryString = [QueryString str:"select nr, beschreibung, betreuernr, kategorie from layout where nr="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	layout = [queryResult objectAt:0];
	if(layout) {
		[self setNr:[layout objectAt:0]];
		[self setBeschreibung:[layout objectAt:1]];
		[self setBetreuernr:[layout objectAt:2]];
		[self setKategorie:[layout objectAt:3]];
		attachmentList = [[AttachmentList alloc] initForLayout:nr];
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
	
	nr			= [String str:""];
	beschreibung= [String str:""];
	betreuernr	= [[[NXApp userMgr] currentUserID] copy];
	kategorie	= [Integer int:0];
	attachmentList	= [[AttachmentList alloc] initNew];
	{
		id	identity	= [[String str:"LayoutItem:Attach:"] concat:nr];
		id	data		= [String str:""];
		id	printitem	= [[PrintRTFItem alloc] initIdentity:identity
												description:identity
												supplDescription:identity
												data:data];
		[attachmentList addAttachment:printitem];
		[identity free];
		[printitem free];
		[data free];
	}
	
	return self;
}


- free
{
	[nr free];
	[beschreibung free];
	[betreuernr free];
	[kategorie free];
	[attachmentList free];	
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	nr				= [nr copy];
	beschreibung	= [beschreibung copy];
	betreuernr		= [betreuernr copy];
	kategorie		= [kategorie copy];
	attachmentList	= [attachmentList copy];
	
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
	queryString = [QueryString str:"update layout set "];
	[[queryString concatSTR:"beschreibung="] concatFieldComma:beschreibung];
	[[queryString concatSTR:"betreuernr="] concatFieldComma:betreuernr];
	[[queryString concatSTR:"kategorie="] concatField:kategorie];
	[[queryString concatSTR:" where nr="] concatField:nr];
	
	return [self updateAndFreeQueryString]
		&& [attachmentList saveForLayout:nr];
}

- (BOOL)insert
{
	id	string;
	id	result;
	
	string = [QueryString str:"select maxnr+1 from maxlayout holdlock"];
	result = [[NXApp defaultQuery] performQuery:string];
	[string free];
	if(result && [result objectAt:0] && [[result objectAt:0] objectAt:0]) {
		[self setNrFromInteger:[[result objectAt:0] objectAt:0]];
		string = [QueryString str:"update maxlayout set maxnr=maxnr+1"];
		[[[NXApp defaultQuery] performQuery:string] free];
		[string free];
		if([[NXApp defaultQuery] lastError]==NOERROR) {
			queryString = [QueryString str:"insert into layout values("];
			[queryString concatFieldComma:nr];
			[queryString concatFieldComma:beschreibung];
			[queryString concatFieldComma:betreuernr];
			[queryString concatField:kategorie];
			[queryString concatSTR:")"];
			
			return [self insertAndFreeQueryString]
				&& [attachmentList saveForLayout:nr];
		}
	}
	return NO;
}

- (BOOL)delete
{
	queryString = [QueryString str:"delete from layout where nr="];
	[queryString concatField:[self identity]];
	return [self deleteAndFreeQueryString]
		&& [attachmentList destroyForLayout:nr];
}

- identity
{
	return [self nr];
}

- content
{
	return [attachmentList objectAt:0];
}

- nr { return nr; }
- setNr:anObject { [nr free]; nr = [anObject copy]; return self; }
- beschreibung { return beschreibung; }
- setBeschreibung:anObject { [beschreibung free]; beschreibung = [anObject copy]; return self; }
- betreuernr { return betreuernr; }
- setBetreuernr:anObject { [betreuernr free]; betreuernr = [anObject copy]; return self; }
- kategorie { return kategorie; }
- setKategorie:anObject { [kategorie free]; kategorie = [anObject copy]; return self; }
- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }

@end

#if 0
BEGIN TABLE DEFS

create table layout
(
	nr				varchar(15),
	beschreibung	varchar(80),
	betreuernr		int,
	kategorie		int
)
go
create unique clustered index layoutindex on layout(nr)
go

create table maxlayout
(
	maxnr int
)
go
insert into maxlayout values(0)
go

END TABLE DEFS
#endif


