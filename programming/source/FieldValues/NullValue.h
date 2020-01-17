#import "dart/FieldValue.h"

@interface NullValue:FieldValue
{
}

- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:cell;
- writeIntoStream:(NXStream *)aStream;
- (int)compareFirstCharWith:(char )aChar;
- (double)double;
- (int)int;
- (const char *)str;

@end

