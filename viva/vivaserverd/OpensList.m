#import <stdio.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"

#import "OpensList.h"

#pragma .h #import <objc/List.h>

@implementation OpensList:List
{
}

- free
{
	[self makeObjectsPerform:@selector(freeObjects)];
	[self freeObjects];
	return [super free];
}

- removeOpensFor:(const char *)hostSTR
{
	int	i, count = [self count];
	for(i=count-1; i>=0; i--) {
		id	lock = [self objectAt:i];
		if(0==[[lock objectAt:0] compareSTR:hostSTR]) {
			[self removeObjectAt:i];
			[[lock freeObjects] free];
		}
	}
	
	IFDEBUG{[self printDebugLocks];}
	
	return self;
}

- (BOOL)isLockedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{
	int	i, count = [self count];

	DEBUG("isLockedClass:\"%s\" identity:\"%s\" -->",classNameSTR, identitySTR);

	for(i=0; i<count; i++) {
		id	lock = [self objectAt:i];
		if(     (0==[[lock objectAt:1] compareSTR:classNameSTR])
			 && (0==[[lock objectAt:2] compareSTR:identitySTR])) {
			DEBUG("YES\n");
			return YES;
		}
	}
	DEBUG("NO\n");
	
	return NO;
}

- lockHost:(const char *)hostSTR class:(const char *)classNameSTR identity:(const char *)identitySTR
{
	id	lock = [[List alloc] initCount:3];
	
	[lock addObject:[String str:hostSTR]];
	[lock addObject:[String str:classNameSTR]];
	[lock addObject:[String str:identitySTR]];
	
	[self addObject:lock];
	
	IFDEBUG{[self printDebugLocks];}
	
	return self;
}

- unlockHost:(const char *)hostSTR class:(const char *)classNameSTR identity:(const char *)identitySTR
{
	int	i, count = [self count];
	for(i=count-1; i>=0; i--) {
		id	lock = [self objectAt:i];
		if(     (0==[[lock objectAt:0] compareSTR:hostSTR])
		     && (0==[[lock objectAt:1] compareSTR:classNameSTR])
			 && (0==[[lock objectAt:2] compareSTR:identitySTR])) {
			[self removeObjectAt:i];
			[[lock freeObjects] free];
		}
	}
	
	IFDEBUG{[self printDebugLocks];}
	
	return self;
}


- printDebugLocks
{
	int	i, count = [self count];
	
	DEBUG("current locks:\n");
	
	for(i=0; i<count; i++) {
		id	lock = [self objectAt:i];
		DEBUG("\t(\"%s\",\"%s\") at %s\n",[[lock objectAt:1] str],[[lock objectAt:2] str],[[lock objectAt:0] str]);
	}
	
	return self;
}


@end
