#import <string.h>

#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "StringManager.h"
#import "ImageManager.h"
#import "MasterDocument.h"
#import "MasterItem.h"

#import "MasterItemList.h"

#pragma .h #import "dart/SortList.h"

@implementation MasterItemList:SortList
{
	id	singleIcon;
	id	multipleIcon;
	id	description;
}

- itemClass
{ 
	return [self subclassResponsibility:_cmd];
}

- initCount:(unsigned)numSlots
{
	char	iconName[5000];
	
	[super initCount:numSlots];
	description = [String str:""];
	
	strcpy(iconName,[[self class] name]);
	iconName[strlen(iconName)-4] = (char)0;
	singleIcon = [[NXApp imageMgr] iconFor:iconName];
	multipleIcon = [[NXApp imageMgr] iconFor:[[self class] name]];
	return self;
}

- free
{
	[description free];
	[self freeObjects];
	return [super free];
}

- copy
{
	id	theCopy = [super copy];
	int i, count = [self count];
	
	for (i=0;i<count;i++) {
		[self replaceObjectAt:i with:[[self objectAt:i] copy]];
	}
	return theCopy;
}

- imageObject
{
	if([self isSingle]) {
		return singleIcon;
	} else {
		return multipleIcon;
	}
}

- (BOOL)isSingle
{
	return [self count] == 1;
}

- copyLoadedObjectAt:(unsigned)index
{
	return [[[self itemClass] alloc] initIdentity:[self objectAt:index]];
}

- copyLoadedFirstObject
{
	return [self copyLoadedObjectAt:0];
}

- openObjectAt:(unsigned )index
{
	[[[[self documentClass] alloc] initItem:[self copyLoadedObjectAt:index]] makeActive:self];
	return self;
}

- open:sender
{
	if ([self respondsTo:@selector(documentClass)]) {
		int i,count = [self count];
		
		for (i=0;i<count;i++) {
			[self openObjectAt:i];
		}
	}
	return self;
}


-(BOOL)removeAndFreeObjectWithIdentitySTR:(const char *)identitySTR
{
	int i, count = [self count];
	
	for (i=count-1;i>=0;i--) {
		id	theObject = [self objectAt:i];
		if ([theObject compareSTR:identitySTR] == 0) {
			[self removeObjectAt:i];
		}
	}
	return count != [self count];
}


- addIdentityOf:anItem
{
	[self addObject:[[anItem identity] copy]];
	return self;
}


- addIdentity:anIdentity
{
	[self addObject:[anIdentity copy]];
	return self;
}


- identity
{
	if (![self isSingle]) {
		return nil;
	}
	return [self objectAt:0];
}

- description
{
	if (![self isSingle]) {
		[description str:[[NXApp stringMgr] publicClassNameFor:[self name]]];
		return description;
	} else {
		return [self identity];
	}
}

@end

@interface Object(SubclassesOfMine)
- documentClass;
@end
