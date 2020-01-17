#import <libc.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "SeriennummernItem.h"

#import "SeriennummernList.h"

#pragma .h #import "SubItemList.h"

@implementation SeriennummernList:SubItemList
{
}

- initNew
{
	return [super initCount:0];
}

- initForLieferschein:liefNr	{ return [self initAndLoad:"LI" for:liefNr]; }

- (BOOL)saveForLieferschein:liefNr	{ return [self save:"LI" for:liefNr]; }

- (BOOL)destroyForLieferschein:liefNr	{	return [self destroy:"LI" for:liefNr]; }

- initAndLoad:(const char *)what for:which
{
	id	queryString;

	queryString = [QueryString str:"select position, seriennr from seriennummern where id="];
	[queryString concatField:which];
	[queryString concatSTR:" and class=\""];
	[queryString concatSTR:what];
	[queryString concatSTR:"\""];
	[self initFromQuery:queryString];
	[queryString free];
	[self sort];
	
	return self;
}

- createItem:aQueryResultRow
{
	[self addNr:[aQueryResultRow objectAt:1] forPosition:[aQueryResultRow objectAt:0]];
	return self;
}

- (BOOL)save:(const char *)which for:what
{
	if([self destroy:which for:what]) {
		int	i;
		for(i=0; i<[self count]; i++) {
			int	j;
			for(j=0; j<[[[self objectAt:i] seriennr] count]; j++) {
				id	queryString = [QueryString str:"insert into seriennummern values(\""];
				[queryString concatSTR:which];
				[queryString concatSTR:"\","];
				[queryString concatFieldComma:what];
				[[self objectAt:i] appendFieldsOfNr:j toQueryString:queryString];
				[queryString concatSTR:")"];
				[[[NXApp defaultQuery] performQuery:queryString] free];
				[queryString free];
				if([[NXApp defaultQuery] lastError]!=NOERROR) return NO;
			}
		}
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)destroy:(const char *)which for:what
{
	
	id	queryString;
	queryString = [QueryString str:"delete from seriennummern where class=\""];
	[queryString concatSTR:which];
	[queryString concatSTR:"\" and id="];
	[queryString concatField:what];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	
	return [[NXApp defaultQuery] lastError]==NOERROR;
}

- sort
{
	int	i;
	[super sort];
	for(i=0; i<[self count]; i++) {
		[[self objectAt:i] sort];
	}
	return self;
}

- (int)maxPosition
{
	int	i, mx;
	for(i=0,mx=0; i<[self count]; i++) {
		mx = MAX(mx,[[[self objectAt:i] position] int]);
	}
	return mx;
}

- (unsigned)countForPosition:position
{
	return [self countForPositionINT:[position int]];
}

- snrForPosition:position
{
	return [self snrForPositionINT:[position int]];
}

- (unsigned)countForPositionINT:(int)positionINT
{
	return [[self snrForPositionINT:positionINT] count];
}

- snrForPositionINT:(int)positionINT
{
	int	i;
	for(i=0; i<[self count]; i++) {
		if([[[self objectAt:i] position] compareInt:positionINT] == 0) {
			return [self objectAt:i];
		}
	}
	return nil;
}

- addNr:newNr forPosition:position
{
	id	newItem = [self snrForPosition:position];
	if(newItem == nil) {
		newItem = [SeriennummernItem alloc];
		[newItem initPosition:position seriennr:newNr];
		[self addObject:newItem];
	} else {
		[newItem addSeriennr:newNr];
	}
	return self;
}

@end
