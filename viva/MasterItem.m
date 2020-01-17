#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"
#import "dart/debug.h"

#import "DefaultsDatabase.h"
#import "ImageManager.h"
#import "MasterItemList.h"
#import "StringManager.h"
#import "TheApp.h"

#import "MasterItem.h"

#pragma .h #import <objc/Object.h>

@implementation MasterItem:Object
{
	id		icon;
	int		tag;
	int		lastError;
	BOOL	isNew;
	id		queryString;
}


+ (BOOL)exists:identitiy
{
	return (BOOL)[self subclassResponsibility:_cmd];
}

+ makeJJMMDDFrom:today into:pp
{
	char buf[128];
	sprintf(buf,"%02d%02d%02d",[today yearWithoutCentury], [today month], [today day]);
	[pp str:buf];
	return self;
}

+ makeDDMMJJJJFrom:today into:pp
{
	char buf[128];
	sprintf(buf,"%02d%02d%04d",[today day], [today month], [today year]);
	[pp str:buf];
	return self;
}

+ makeDDMMJJFrom:today into:pp
{
	char buf[128];
	sprintf(buf,"%02d%02d%02d",[today day], [today month], [today yearWithoutCentury]);
	[pp str:buf];
	return self;
}

+ makeJJJJFrom:today into:pp
{
	char buf[128];
	sprintf(buf,"%04d", [today year]);
	[pp str:buf];
	return self;
}

+ makeJJJJMMDDFrom:today into:pp
{
	char buf[128];
	sprintf(buf,"%04d%02d%02d", [today year],[today month],[today day]);
	[pp str:buf];
	return self;
}

+ makeJJFrom:today into:pp
{
	char buf[128];
	sprintf(buf,"%02d",[today yearWithoutCentury]);
	[pp str:buf];
	return self;
}

+ copyMakeIdentityNrFromString:aStringNr prePostfix:prePostfixSelect prePostfixKind:prePostfixKind withDash:withDash
{
	id		aNr = [String str:""];
	id		pp = [String str:""];
	BOOL	hasDash = NO;
	BOOL	isPrefix = YES;
	
	if ((prePostfixSelect != nil) && (![prePostfixSelect isFalse]) ) {
		id	today = [Date today];
		if ([prePostfixSelect int] == 1) {
			isPrefix = YES;
		} else {
			isPrefix = NO;
		}
		if (prePostfixKind != nil) {
			switch ([prePostfixKind int]) {
				case 0: [[self class] makeJJMMDDFrom:today into:pp]; break;
				case 1: [[self class] makeDDMMJJJJFrom:today into:pp]; break;
				case 2: [[self class] makeDDMMJJFrom:today into:pp]; break;
				case 3: [[self class] makeJJJJFrom:today into:pp]; break;
				case 4: [[self class] makeJJJJMMDDFrom:today into:pp]; break;
				case 5: [[self class] makeJJFrom:today into:pp]; break;
			}
		}
		if (withDash != nil) {
			hasDash = [withDash isTrue];
		}
		if (isPrefix) {
			[aNr str:[pp str]];
			if (hasDash) {
				[aNr concatSTR:"-"];
			}
			[aNr concatSTR:[aStringNr str]];
		} else {
			[aNr str:[aStringNr str]];
			if (hasDash) {
				[aNr concatSTR:"-"];
			}
			[aNr concatSTR:[pp str]];
		}
	} else {
		[aNr str:[aStringNr str]];
	}
	[pp free];
	return aNr;
}

+ copyNrFromInteger:anInteger andBreite:breiteInt
{
	id		prePostfixSelect;
	id		prePostfixKind;
	id		withDash;
	id		newNr;
	id		aNr;
	id		aClassKey = [String str:""];
	char	s[1024];
	
	[[aClassKey str:[self name]] concatSTR:"NrPrePostfixSelect"];
	prePostfixSelect = [[[NXApp defaultsDB] valueForKey:[aClassKey str]] copy];
	
	[[aClassKey str:[self name]] concatSTR:"NrPrefixKind"];
	prePostfixKind = [[[NXApp defaultsDB] valueForKey:[aClassKey str]] copy];
	
	[[aClassKey str:[self name]] concatSTR:"NrWithDash"];
	withDash = [[[NXApp defaultsDB] valueForKey:[aClassKey str]] copy];
	
	sprintf(s,"%0*d", breiteInt?[breiteInt int]:6, [anInteger int]);
	aNr = [String str:s];
	newNr = [self copyMakeIdentityNrFromString:aNr 
				  prePostfix:prePostfixSelect 
				  prePostfixKind:prePostfixKind
				  withDash:withDash];
	[aNr free];
	return newNr;
}


- (const char *)publicClassName
{
	return [[NXApp stringMgr] publicClassNameFor:[self name]];
}

- itemListClass
{
	return [self subclassResponsibility:_cmd];
}

- (BOOL)isNew
{
	return isNew;
}

- (BOOL)isSaveable
{
	return [[self identity] length] > 0;
}

- setIsNew:(BOOL)flag
{
	isNew = flag;
	return self;
}

- init
{
	[super init];
	icon = [[NXApp imageMgr] iconFor:[self name]];
	isNew = YES;
	return self;
}

- initNew
{
	return [self subclassResponsibility:_cmd];
}

- initIdentity:identity
{
	return [self subclassResponsibility:_cmd];
}

- free
{
	queryString = [queryString free];
	return [super free];
}

- copyAsItemList
{
	return [[[[self itemListClass] alloc] initCount:0] addIdentityOf:self];
}

- icon
{
	return icon;
}

- (BOOL)saveBulkdata
{
	return YES;
}

- (BOOL)save
{
	DEBUG5("%s save:\"%s\"\n",[[self class] name],[[self identity] str]);
	DEBUG6("i'm %snew\n",[self isNew]?"":"not ");
	
	if ([self saveBulkdata]) {
		[[NXApp defaultQuery] beginTransaction];
		if([[self class] exists:[self identity]]) {
			DEBUG6("and i'm existing\n");
			if([self isNew]) {
				[NXApp beep:"ItemExists"];
				//error row with identity exists
				[[NXApp defaultQuery] rollbackTransaction];
				return NO;
			} else {
				if([self update] && [[NXApp defaultQuery] commitTransaction]) {
					return YES;
				} else {
					[NXApp beep:"ErrorWhileUpdating"];
					//error while updating row
					[[NXApp defaultQuery] rollbackTransaction];
					return NO;
				}
			}
		} else {
			DEBUG6("and i'm not existing\n");
			if([self isNew]) {
				if([self insert] && [[NXApp defaultQuery] commitTransaction]) {
					isNew = NO;
					return YES;
				} else {
					[NXApp beep:"ErrorWhileInserting"];
					//error while inserting new row
					[[NXApp defaultQuery] rollbackTransaction];
					return NO;
				}
			} else {
				[self error:"Oooops! Tried to update something which does not exist!"];
				//error row with id doesn't exist
				[[NXApp defaultQuery] rollbackTransaction];
				return NO;
			}
		}
	} else {
		DEBUG5("saveBuldata fehlerhaft...\n");
		return NO;
	}
}

- (BOOL)deleteAndFree
{
	DEBUG5("%s deleteAndFree:\"%s\"\n",[[self class] name],[[self identity] str]);
	[[NXApp defaultQuery] beginTransaction];
	if([self delete] && [[NXApp defaultQuery] commitTransaction]) {
		[self free];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)update
{
	[self subclassResponsibility:_cmd];
	return NO;
}

- (BOOL)insert
{
	[self subclassResponsibility:_cmd];
	return NO;
}

- (BOOL)delete
{
	[self subclassResponsibility:_cmd];
	return NO;
}

- selectAndFreeQueryString
{
	id	queryResult;
	
	queryResult = [[NXApp defaultQuery] performQuery:queryString];
	queryString = [queryString free];
	lastError = [[NXApp defaultQuery] lastError];
	
	return queryResult;
}


- (BOOL)updateAndFreeQueryString
{
	id	queryResult;
	
	queryResult = [[NXApp defaultQuery] performQuery:queryString];
	queryString = [queryString free];
	lastError = [[NXApp defaultQuery] lastError];
	if(queryResult) {
		[queryResult free];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)insertAndFreeQueryString
{
	id	queryResult;
	
	queryResult = [[NXApp defaultQuery] performQuery:queryString];
	queryString = [queryString free];
	lastError = [[NXApp defaultQuery] lastError];
	if(queryResult) {
		[queryResult free];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)deleteAndFreeQueryString
{
	BOOL	result;
	
	[[[NXApp defaultQuery] performQuery:queryString] free];
	result = queryString != nil;
	queryString = [queryString free];
	lastError = [[NXApp defaultQuery] lastError];
	return result;
}


- identity
{
	return [self subclassResponsibility:_cmd];
}

- setNr:anObject
{
	return [self subclassResponsibility:_cmd];
}

- setNrFromInteger:anInteger
{
	id		newNr;
	id		key = [[String str:[[self class] name]] concatSTR:"NrBreite"];
	id		breiteInt = [[NXApp defaultsDB] valueForKey:[key str]];
	newNr = [[self class] copyNrFromInteger:anInteger andBreite:breiteInt];
	[self setNr:newNr];
	[newNr free];
	return self;
}

- description
{
	return [self identity];
}

- (int)lastError
{
	return lastError;
}


@end
