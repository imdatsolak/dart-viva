#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "KonditionenItem.h"
#import "KonditionenItemList.h"
#import "KonditionenDocument.h"
#import "KonditionenSelector.h"

#pragma .h #import "MasterSelector.h"


@implementation KonditionenSelector:MasterSelector
{
	id	nrField;
	id	kondnameField;
	id	bemerkungField;
	
	id	kondnameSwitch;
	
	id	nrStr;
	id	kondnameStr;
	id	bemerkungStr;
	id	kondnameSwitchState;
}

- init
{
	[super init];
	CREATEFIELD(nrStr,String,nrField);
	CREATEFIELD(kondnameStr,String,kondnameField);
	CREATEFIELD(bemerkungStr,String,bemerkungField);
	CREATESWITCHSTATE(kondnameSwitchState,kondnameSwitch);
	[self writeFindPanel];
	return self;
}

- free
{
	[nrStr free];
	[kondnameStr free];
	[bemerkungStr free];
	[kondnameSwitchState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	nrStr = NXReadObject(typedStream);
	kondnameStr = NXReadObject(typedStream);
	bemerkungStr = NXReadObject(typedStream);
	kondnameSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,nrStr);
	NXWriteObject(typedStream,kondnameStr);
	NXWriteObject(typedStream,bemerkungStr);
	NXWriteObject(typedStream,kondnameSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(nrStr,nrField);
	READFINDPANELCELL(kondnameStr,kondnameField);
	READFINDPANELCELL(bemerkungStr,bemerkungField);
	READFINDPANELSWITCH(kondnameSwitchState,kondnameSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(nrStr,nrField);
	WRITEFINDPANELCELL(kondnameStr,kondnameField);
	WRITEFINDPANELCELL(bemerkungStr,bemerkungField);
	WRITEFINDPANELSWITCH(kondnameSwitchState,kondnameSwitch);
	return self;
}

- performQuery
{
	id	aQueryResult, queryString;
	
	queryString = [QueryString str:"select nr Nr"];

	if([kondnameSwitchState isTrue]) [queryString concatSTR:",kondname Name"];
	
	[queryString concatSTR:" from konditionen"];

	[queryString concatSTR:" where nr like "];
	[queryString concatField:nrStr];
	
	[queryString concatSTR:" and kondname like "];
	[queryString concatField:kondnameStr];

	[queryString concatSTR:" and bemerkung like "];
	[queryString concatField:bemerkungStr];

	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[super localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [KonditionenDocument class]; }

- itemClass
{ return [KonditionenItem class]; }

- itemListClass
{ return [KonditionenItemList class]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
