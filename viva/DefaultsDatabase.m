#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/debug.h"

#import "UserManager.h"
#import "TheApp.h"

#import "DefaultsDatabase.h"

#pragma .h #import <objc/Object.h>

@implementation DefaultsDatabase:Object
{
	id	cacheList;
}

- init
{
	[super init];
	cacheList = [[List alloc] initCount:0];
	return self;
}

- free
{
	[[cacheList freeObjects] free];
	return [super free];
}

- searchKey:(const char *)aKey
{
	int		i, count = [cacheList count];
	id		defaultsEntry= nil;
	BOOL	found = NO;
	
	for (i=0;(i<count) && !found;i++) {
		defaultsEntry = [cacheList objectAt:i];
		found = ([[defaultsEntry objectAt:0] compareSTR:aKey] == 0);
	}
	return found? defaultsEntry:nil;
}

- addToCache:anEntry
{
	id	theValue = nil;
	id	theList = [[List alloc] initCount:0];
	int valuetype = [[anEntry objectAt:3] charAt:0];
	
	if (valuetype == 'i') {
		theValue = [Integer int:[[anEntry objectAt:4] long]];
	} else if (valuetype == 's') {
		theValue = [[anEntry objectAt:4] copy];
	} else if (valuetype == 'd') {
		theValue = [Double double:[[anEntry objectAt:4] double]];
	} else if (valuetype == 't') {
		theValue = [[[Date alloc] init] setDateLong:[[anEntry objectAt:4] long]];
	} else {
		[self error:"Unknown data type in defaults database"];
	}
	
	[theList addObject:[[anEntry objectAt:1] copy]];
	[theList addObject:theValue];
	[cacheList addObject:theList];
	
	return theList;
}	
	

- readValueForKey:(const char *)aKey forUser:anID range:(int )range
{
	id	queryResult;
	id	queryString = [QueryString str:"select userid, key, range, valuetype, value from preferences"];
	
	[queryString concatSTR:" where key = "];
	[queryString concatSTR:"\""];
	[queryString concatSTR:aKey];
	[queryString concatSTR:"\""];
	if (range == 1) {
		[queryString concatSTR:" and range = 1"];
	} else {
		[queryString concatSTR:" and userid = "];
		[queryString concatField:[[NXApp userMgr] currentUserID]];
	} 
	queryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	if (queryResult && [queryResult objectAt:0]) {
		id	theEntry = [queryResult objectAt:0];
		id	newEntry = [self addToCache:theEntry];
		[queryResult free];
		return newEntry;
	}
	return nil;
}

- valueForKey:(const char *)aKey
{
	id	theEntry = [self searchKey:aKey];

	if (!theEntry) {
		theEntry = [self readValueForKey:aKey forUser:[[NXApp userMgr] currentUserID] range:0];
	}
	if (!theEntry) {
		theEntry = [self readValueForKey:aKey forUser:0 range:1];
	}
	if (!theEntry) {
		return nil;
	}
	return [theEntry objectAt:1];
}


- setValue:aValue forKey:(const char *)aKey
{
	id	finalValue = nil;
	id	result;
	id	queryString = [QueryString str:"delete from preferences"];
	
	[queryString concatSTR:" where key = "];
	[queryString concatSTR:"\""];
	[queryString concatSTR:aKey];
	[queryString concatSTR:"\""];
	if ([[NXApp userMgr] isSuperuser]) {
		[queryString concatSTR:" and range = 1"];
	} else {
		[queryString concatSTR:" and userid = "];
		[queryString concatField:[[NXApp userMgr] currentUserID]];
	} 
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	
	queryString = [QueryString str:"insert into preferences"];
	[queryString concatSTR:" values ("];
	[queryString concatFieldComma:[[NXApp userMgr] currentUserID]];
	[queryString concatSTR:"\""];
	[queryString concatSTR: aKey];
	[queryString concatSTR:"\","];
	[queryString concatSTR:([[NXApp userMgr] isSuperuser])? "1,":"0,"];
	if ([aValue isKindOf:[String class]]) {
		finalValue = [aValue copy];
		[queryString concatSTR:"\"s\","];
	} else if ([aValue isKindOf:[Integer class]]) {
		finalValue = [aValue copyAsString];
		[queryString concatSTR:"\"i\","];
	} else if ([aValue isKindOf:[Double class]]) {
		finalValue = [aValue copyAsString];
		[queryString concatSTR:"\"d\","];
	} else if ([aValue isKindOf:[Date class]]) {
		id	datelong = [Integer int:[aValue long]];
		finalValue = [datelong copyAsString];
		[datelong free];
		[queryString concatSTR:"\"t\","];
	} else {
		[self error:"Unknow data type %s",[aValue name]];
	}
	[queryString concatField:finalValue];
	DEBUG5("DefaultsDB:setValue:[%s] forKey:[%s]\n",finalValue, aKey);
	[finalValue free];

	[queryString concatSTR:")"];
	
	if ((result = [[NXApp defaultQuery] performQuery:queryString]) == nil) {
		[NXApp beep:"CouldNotSavePreferences"];
	} else {
		[result free];
	}
	[queryString free];
	[self setCacheDirtyFor:aKey];
	return self;
}

- setCacheDirtyFor:(const char *)aKey
{
	int i, count = [cacheList count];
	for (i=count-1;i>=0;i--) {
		if ([[[cacheList objectAt:i] objectAt:0] compareSTR:aKey] == 0) {
			[[[[cacheList removeObjectAt:i] freeObjects] empty] free];
		}
	}
	return self;	
}

@end
