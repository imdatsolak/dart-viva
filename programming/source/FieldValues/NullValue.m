#import "dart/ColumnBrowserCell.h"

#import <dart/fieldvaluekit.h>

#pragma .h #import "dart/FieldValue.h"

@implementation NullValue:FieldValue
{
}

- writeIntoCell:aCell
{
	[aCell setStringValue:"NULL"];
	return self;
}

- writeIntoCell:aCell inColumn:(int)column
{
	[aCell setStringValue:"NULL" ofColumn:column];
	return self;
}

- readFromCell:cell
{
	return [self doesNotRecognize:_cmd];
}

- writeIntoStream:(NXStream *)aStream
{
	NXPrintf(aStream,"NULL");
	return self;
}

- (int)compareFirstCharWith:(char )aChar
{
	return -1;
}

- (double)double
{
	return 0.0;
}

- (int)int
{
	return 0;
}

- (const char *)str
{
	return "";
}
@end
