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

@end
