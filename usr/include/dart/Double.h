#import <dart/FieldValue.h>

@interface Double:FieldValue
{
	double	myDouble;
}

+ double:(double)aDouble tag:(int)theTag;
+ double:(double)aDouble;
- init;
- initDouble:(double)aDouble tag:(int)theTag;
- (double)double;
- setDouble:(double)aDouble;
- asStringWidth:(int)width decimal:(int)decimal;
- asString;
- (int)asInt;
- (double)asDouble;
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

@end
