#import "dart/QueryResultRow.h"

@implementation QueryResultRow

+ new
{
	return [[super new] doesNotRecognize:_cmd];
}

- (const char *)publicClassName
{
	return "GenericItem";
}

- (int)tag
{
	return tag;
}

- setTag:(int)aTag
{
	tag = aTag;
	return self;
}

- init
{
	return [self initCount:0];
}

- copy
{
	int	i,count = [self count];
	id	theCopy = [[[self class] alloc] initCount:count];
	
	for(i=0; i<count; i++) {
		[theCopy addObject:[[self objectAt:i] copy]];
	}
	[theCopy setImage:icon];
	[theCopy setTag:tag];

	return theCopy;
}

- free
{
	[self freeObjects];
	return [super free];
}

- icon
{
	return icon;
}

- setImage:anImage
{
	icon = anImage;
	return self;
}

- objectWithTag:(int)aTag
{
	int i,count=[self count];
	
	for(i=0; (i<count); i++) {
		if([[self objectAt:i] tag] == aTag) {
			return [self objectAt:i];
		}
	}
	return nil;
}

- replaceObjectWithTag:(int)aTag with:theNewObject
{
	int i,count=[self count];
	
	for(i=0; (i<count); i++) {
		if([[self objectAt:i] tag] == aTag) {
			return [self replaceObjectAt:i with:theNewObject];
		}
	}
	return nil;
}

- (int)compare:anotherObject byTag:(int)aTag
{
	return [[self objectWithTag:aTag] compare:[anotherObject objectWithTag:aTag]];
}

- (int)compare:anotherObject byIndex:(int)i
{
	return [[self objectAt:i] compare:[anotherObject objectAt:i]];
}

- (int)compare:anotherObject
{
	int	i = 0, result = 0;
	while((i<[self count]) && (i<[anotherObject count]) && (result == 0)) {
		result = [[self objectAt:i] compare:[anotherObject objectAt:i]];
		i++;
	}
	return result;
}

- moveToLeftColumnWithTag:(int)aTag
{
	int i=0,done=0,count=[self count];
	
	while( !done && (i<count) ) {
		if( aTag == [[self objectAt:i] tag] ) {
			[self insertObject:[self removeObjectAt:i] at:0];
			done = 1;
		} else {
			i++;
		}
	}

	return self;
}

@end
