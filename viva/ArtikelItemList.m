#import "ArtikelItem.h"
#import "ArtikelDocument.h"

#import "ArtikelItemList.h"

#pragma .h #import "MasterItemList.h"

@implementation ArtikelItemList:MasterItemList
{
	id	senderOfItems;
}

- initCount:(unsigned )c
{
	[super initCount:c];
	senderOfItems = nil;
	return self;
}

- free
{
	[[senderOfItems freeObjects] free];
	return [super free];
}

- itemClass
{ return [ArtikelItem class]; }

- documentClass
{ return [ArtikelDocument class]; }

- senderOfItems { return senderOfItems; }
- setSenderOfItems:anObject { [senderOfItems free]; senderOfItems = [anObject copy]; return self; }

- copy
{
	id	theCopy = [super copy];
	[theCopy setSenderOfItems:senderOfItems];
	return theCopy;
}
@end
