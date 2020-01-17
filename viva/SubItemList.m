#import "dart/querykit.h"

#import "TheApp.h"

#import "SubItemList.h"

#pragma .h #import "dart/SortList.h"

@implementation SubItemList:SortList
{
}


- initNew
{
	return [super initCount:0];
}


- initFromQuery:theQueryString
{
	id	queryResult;
	
	[super init];	
	
	queryResult = [[NXApp defaultQuery] performQuery:theQueryString];
	
	if(queryResult) {
		int	i, count = [queryResult count];
		for(i=0; i<count; i++) {
			id	aRow = [queryResult objectAt:i];
			if(aRow) {
				[self createItem:aRow];
			}
		}
	}
	
	[queryResult free];
	
	return self;
}


- free
{
	[[self freeObjects] empty];
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	int	i, count = [self count];
	for(i=0; i<count; i++) {
		[self replaceObjectAt:i with:[[self objectAt:i] copy]];
	}
	return theCopy;
}

- createItem:aRow
{
	return [self subclassResponsibility:_cmd];
}


@end
