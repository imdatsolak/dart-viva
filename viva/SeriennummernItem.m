#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "SeriennummernItem.h"

#pragma .h #import <objc/Object.h>

@implementation SeriennummernItem:Object
{
	id	position;
	id	seriennr;
}

- initPosition:aPosition seriennr:aSeriennr
{
	[self init];
	position	= [aPosition copy];
	seriennr	= [[SortList alloc] initCount:1];
	[seriennr addObject:[aSeriennr copy]];
	return self;
}

- copy
{
	int	i;
	id	theCopy 	= [super copy];
	
	position	= [position copy];
	seriennr	= [seriennr copy];
	for(i=0; i<[seriennr count]; i++) {
		[seriennr replaceObjectAt:i with:[[seriennr objectAt:i] copy]];
	}
	
	return theCopy;
}

- free
{
	[position free];
	[[[seriennr freeObjects] empty] free];
	return [super free];
}

- appendFieldsOfNr:(int)i toQueryString:queryString
{
	[queryString concatFieldComma:position];
	[queryString concatField:[seriennr objectAt:i]];
	
	return self;
}

- addSeriennr:newNr
{
	[seriennr addObject:[newNr copy]];
	return self;
}

- sort
{
	[seriennr sort];
	return self;
}

- (unsigned)count
{
	return [seriennr count];
}

- seriennrAt:(unsigned)i
{
	return [seriennr objectAt:i];
}

- removeSeriennrAt:(unsigned)i
{
	return [[seriennr removeObjectAt:i] free];
}

- (int)compare:anotherObject
{
	return [position compare:[anotherObject position]];
}

- position { return position; }
- setPosition:anObject { [position free]; position = [anObject copy]; return self; }
- seriennr { return seriennr; }
- setSeriennr:anObject { [seriennr free]; seriennr = [anObject copy]; return self; }

@end


#if 0
BEGIN TABLE DEFS

create table seriennummern
(
	class		char(2),
	id			varchar(15),
	position	int,
	seriennr	varchar(50)
)
create clustered index seriennummernindex on seriennummern(class,id,position)
go

END TABLE DEFS
#endif

