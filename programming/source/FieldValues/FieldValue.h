#import <streams/streams.h> 
#import <objc/Object.h>

@interface FieldValue:Object
{
	int	tag;
}

- (int)tag;
- setTag:(int)theTag;
- writeIntoCell:cell;
- readFromCell:cell;
- writeIntoCell:cell inColumn:(int)column;
- writeIntoStream:(NXStream *)aStream;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;
- (int)compareFirstCharWith:(char )aChar;

@end

