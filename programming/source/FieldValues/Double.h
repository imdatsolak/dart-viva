#import "dart/FieldValue.h"

@interface Double:FieldValue
{
	double	myDouble;
	id		dfLocalized;
	id		myStr;
}

+ setDoubleFormat:(const char *)aFormat;
+ (const char *)doubleFormat;
+ double:(double)aDouble tag:(int)theTag;
+ double:(double)aDouble;
- init;
- initDouble:(double)aDouble tag:(int)theTag;
- free;
- copy;
- setDoubleFormat:(const char *)aFormat;
- (const char *)doubleFormat;
- (double)double;
- setDouble:(double)aDouble;
- copyAsStringWidth:(int)width decimal:(int)decimal;
- copyAsString;
- (const char *)str;
- (int)int;
- addDouble:(double)aDouble;
- subDouble:(double)aDouble;
- multDouble:(double)aDouble;
- divDouble:(double)aDouble;
- (int)compareDouble:(double)aDouble;
- (int)compare:aDouble;
- (BOOL)isEqual:aDouble;
- (BOOL)isEqualDouble:(double)aDouble;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:aCell;
- writeIntoStream:(NXStream *)aStream;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;
- (int)compareFirstCharWith:(char )aChar;

@end

