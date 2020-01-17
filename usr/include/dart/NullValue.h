#import <dart/FieldValue.h>

@interface NullValue:FieldValue
{
}

- (int)tag;
- setTag:(int)theTag;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:cell;
- writeIntoStream:(NXStream *)aStream;

@end
