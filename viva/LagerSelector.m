#import <appkit/Cell.h>
#import <appkit/Button.h>
#import "dart/querykit.h"

#import "TheApp.h"
#import "LagerItem.h"
#import "LagerItemList.h"
#import "LagerDocument.h"

#import "LagerSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation LagerSelector:MasterSelector
{
	id	nrField;
	id	nameField;
	
	id	nrStr;
	id	nameStr;
}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(nameStr,String,nameField);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[nameStr free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	nameStr = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,nameStr);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(nameStr,nameField);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(nameStr,nameField);
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
	
	queryString = [QueryString str:"select nr LagerNr, lname Bezeichnung,"];
	[queryString concatSTR:" betreuernr Betr from lager"];
	[queryString concatSTR:" where nr like "];
	[queryString concatField:nrStr];
	[queryString concatSTR:" and lname like "];
	[queryString concatField:nameStr];
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if(theEntryList) {
		[theEntryList free];
	}
	theEntryList = aQueryResult;
	[super localizeColumnNamesIn:aQueryResult];
	
	return self;
}
- documentClass
{ return [LagerDocument class]; }

- itemClass
{ return [LagerItem class]; }

- itemListClass
{ return [LagerItemList class]; }

- copyObjectIdentityAtRow:(int)row
{ return [[[theEntryList objectAt:row] objectWithTag:1] copy]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
