#import "dart/fieldvaluekit.h"

#pragma .h #import <streams/streams.h> 
#pragma .h #import <objc/Object.h>

@implementation FieldValue:Object
{
	int	tag;
}

- (int)tag
{
	return tag;
}

- setTag:(int)theTag
{
	tag = theTag;
	return self;
}

- writeIntoCell:cell
{
	return [self subclassResponsibility:_cmd];
}

- readFromCell:cell
{
	return [self subclassResponsibility:_cmd];
}

- writeIntoCell:cell inColumn:(int)column
{
	return [self subclassResponsibility:_cmd];
}

- writeIntoStream:(NXStream *)aStream
{
	return [self subclassResponsibility:_cmd];
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteTypes(stream,"i",&tag);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadTypes(stream,"i",&tag);
	return self;
}

- (int)compareFirstCharWith:(char )aChar
{
	return -1;
}
@end
