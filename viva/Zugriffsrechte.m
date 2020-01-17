#import <stdlib.h>
#import <string.h>

#import <appkit/Button.h>
#import <appkit/Matrix.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/debug.h"

#import "TheApp.h"
#import "ArtikelDocument.h"
#import "KundenDocument.h"
#import "BestellungsDocument.h"
#import "AngebotsDocument.h"
#import "AuftragsDocument.h"
#import "BankenDocument.h"
#import "LagerDocument.h"
#import "KonditionenDocument.h"
#import "RechnungsDocument.h"
#import "LieferscheinDocument.h"
#import "LayoutDocument.h"
#import "Zugriffsrechte.h"

#pragma .h #import "MasterDocument.h"

@implementation Zugriffsrechte:MasterDocument
{
	id	zugriffpopup;
	id	zugriffmatrix;
	
	id	zugriffe;
	int	currentPriv;
}

+ (BOOL)canHaveMultipleInstances
{ return NO; }

- itemClass
{ return [self class]; }

- init
{
	[super init];
	[self loadZugriffe];
	[self writeIntoWindow];
	item = nil;
	return self;
}

- free
{
	if (zugriffe) {
		zugriffe = [zugriffe free];
	}
	return [super free];
}

- (BOOL)loadZugriffe
{
	id	queryString;
	id	result;
	
	if (zugriffe) {
		zugriffe = [zugriffe free];
	}	
	queryString = [QueryString str:"select privileg, klassenname, permissions from zugriffe"];
	result = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if (result && ([[NXApp defaultQuery] lastError] == NOERROR)) {
		zugriffe = result;
		[zugriffe sort];
	} else {
		[result free];
		[NXApp beep:"CouldNotAccesAnyZugriffe"];
		return NO;
	}
	return YES;
}

- saveZugriffe
{
	BOOL	isOk = YES;
	id		queryString;
	[self readFromWindow];
	[[NXApp defaultQuery] beginTransaction];
	queryString = [QueryString str:"delete from zugriffe"];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	queryString = [queryString free];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		int 	i, count = [zugriffe count];
		for (i=0;(i<count)&& isOk;i++) {
			queryString = [QueryString str:"insert into zugriffe values("];
			[queryString concatFieldComma:[[zugriffe objectAt:i] objectAt:0]];
			[queryString concatFieldComma:[[zugriffe objectAt:i] objectAt:1]];
			[queryString concatField:[[zugriffe objectAt:i] objectAt:2]];
			[queryString concatSTR:")"];
			[[[NXApp defaultQuery] performQuery:queryString] free];
			[queryString free];
			if ([[NXApp defaultQuery] lastError] != NOERROR) {
				isOk = NO;
			}
		}
	} else {
		isOk = NO;
	}
	if (!isOk) {
		[[NXApp defaultQuery] rollbackTransaction];
		return nil;
	} else {
		[[NXApp defaultQuery] commitTransaction];
		return self;
	}
}

- (BOOL)save
{
	if ([self saveZugriffe]) {
		id	fake = [String str:""];
		[window setDocEdited:NO];
		[self sendChanged:fake];
		[fake free];
		return YES;
	}
	return NO;
}

- (BOOL) revertToSaved
{ 
	[self loadZugriffe];
	[self writeIntoWindow];
	[window setDocEdited:NO];
	return YES; 
}


- writeIntoWindow
{
	int		i,count = [zugriffe count];
	BOOL	found = NO;
	

	currentPriv = [zugriffpopup intValue];
	if (currentPriv == 0) {
		currentPriv = [[[zugriffe objectAt:11] objectAt:0] int];
		[zugriffpopup setIntValue:currentPriv];
	}
	[window disableFlushWindow];
	for (i=0;i<count;i++) {
		id	cRow = [zugriffe objectAt:i];
		if ([[cRow objectAt:0] compareInt:currentPriv]==0) {
			int startTag = [self startTagFor:cRow];
			if (startTag >= 0) {
				[self showPrivFor:cRow withStartTag:startTag];
			}
			found = YES;
		}
	}
	if (!found) {
		[self createZugriffeFor:currentPriv];
		[self writeIntoWindow];
	}
	[window reenableFlushWindow];
	[window display];
	return self;
}

- readFromWindow
{
	int	i,count = [zugriffe count];
	for (i=0;i<count;i++) {
		id	cRow = [zugriffe objectAt:i];
		if ([[cRow objectAt:0] compareInt:currentPriv]==0) {
			int startTag = [self startTagFor:cRow];
			if (startTag >= 0) {
				[self readPrivFor:cRow withStartTag:startTag];
			}
		}
	}
	return self;
}

- showPrivFor:(id)aRow withStartTag:(int)startTag
{
	const char privKeys[]= "ACRDES";
	int	fTag = startTag;
	const char *privVal = [[aRow objectAt:2] str];
	int	i;
	for (i=0;i<strlen(privKeys);i++) {
		[[zugriffmatrix findCellWithTag:fTag] setState:(index(privVal,privKeys[i])!=NULL)? 0:1];
		fTag +=11;
	}
	return self;
}

- readPrivFor:(id)aRow withStartTag:(int)startTag
{
	const char privKeys[]= "ACRDES";
	int	fTag = startTag;
	id	privVal = [aRow objectAt:2];
	int	i;
	[privVal str:""];
	for (i=0;i<strlen(privKeys);i++) {
		if ([[zugriffmatrix findCellWithTag:fTag] state] == 0) {
			[privVal concatCHAR:privKeys[i]];
		}
		fTag +=11;
	}
	return self;
}

- checkMenus
{
	[[NXApp saveButton] setEnabled:YES];
	[[NXApp revertButton] setEnabled:[window isDocEdited]];
	[[NXApp findButton] setEnabled:NO];
	return self;
}


- (BOOL)acceptsItem:anItem
{ 
	return NO; 
}

- (int)startTagFor:(id)aRow
{
	if ([[aRow objectAt:1] compareSTR:[[ArtikelDocument class] name]]==0) {
		return 0;
	} else if ([[aRow objectAt:1] compareSTR:[[KundenDocument class] name]]==0) {
		return 1;
	} else if ([[aRow objectAt:1] compareSTR:[[BestellungsDocument class] name]]==0) {
		return 2;
	} else if ([[aRow objectAt:1] compareSTR:[[AngebotsDocument class] name]]==0) {
		return 3;
	} else if ([[aRow objectAt:1] compareSTR:[[AuftragsDocument class] name]]==0) {
		return 4;
	} else if ([[aRow objectAt:1] compareSTR:[[BankenDocument class] name]]==0) {
		return 5;
	} else if ([[aRow objectAt:1] compareSTR:[[LagerDocument class] name]]==0) {
		return 6;
	} else if ([[aRow objectAt:1] compareSTR:[[KonditionenDocument class] name]]==0) {
		return 7;
	} else if ([[aRow objectAt:1] compareSTR:[[RechnungsDocument class] name]]==0) {
		return 8;
	} else if ([[aRow objectAt:1] compareSTR:[[LieferscheinDocument class] name]]==0) {
		return 9;
	} else if ([[aRow objectAt:1] compareSTR:[[LayoutDocument class] name]]==0) {
		return 10;
	}
	return -1;
}

- createZugriffeFor:(int)aPriv
{
	int	i;
	id	aList = [[QueryResultRow alloc] initCount:3];
	id	aPrivN = [Integer int:aPriv];
	id	aClass = [String str:""];
	id	aZugr = [String str:""];
	[aList addObject:aPrivN];
	[aList addObject:aClass];
	[aList addObject:aZugr];
	for (i=0;i<11;i++) {
		id	nList = [aList copy];
		[[nList objectAt:1] str:[self classnameForTag:i]];
		[zugriffe addObject:nList];
	}
	[aList free];
	return self;
}


- (const char *)classnameForTag:(int)aTag
{
	switch (aTag) {
		case 0 : return [[ArtikelDocument class] name];
		case 1 : return [[KundenDocument class] name];
		case 2 : return [[BestellungsDocument class] name];
		case 3 : return [[AngebotsDocument class] name];
		case 4 : return [[AuftragsDocument class] name];
		case 5 : return [[BankenDocument class] name];
		case 6 : return [[LagerDocument class] name];
		case 7 : return [[KonditionenDocument class] name];
		case 8 : return [[RechnungsDocument class] name];
		case 9 : return [[LieferscheinDocument class] name];
		case 10: return [[LayoutDocument class] name];
		default: return "";
	}
}

- controlDidChange:sender
{
	DEBUG2("ZugriffsPopupClicked:\n");
	[self readFromWindow];
	[self writeIntoWindow];
	return self;
}

- matrixClicked:sender
{
	[window setDocEdited:YES];
	return self;
}

@end
#if 0
BEGIN TABLE DEFS

create table zugriffe
( 
	privileg	int,
	klassenname	varchar(50),
	permissions	varchar(10)
)
go
create unique clustered index zugriffeindex on zugriffe(privileg,klassenname)
go

END TABLE DEFS
#endif
