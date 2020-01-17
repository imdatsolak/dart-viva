#import "dart/FieldValue.h"

@interface Integer:FieldValue
{
	int		myInt;
	char	*myStr;
}

+ int:(int)anInt;
+ int:(int)anInt tag:(int)theTag;
- init;
- initInt:(int)anInt;
- initInt:(int)anInt tag:(int)theTag;
- free;
- copy;
- (int)int;
- setInt:(int)anInt;
- (BOOL)isTrue;
- (BOOL)isFalse;
- setTrue;
- setFalse;
- copyAsString;
- (const char *)str;
- (long)long;
- (double)double;
- countMe:sender;
- increment;
- decrement;
- addInt:(int)anInt;
- subInt:(int)anInt;
- multInt:(int)anInt;
- divInt:(int)anInt;
- (int)compareInt:(int)anInt;
- (int)compare:anInteger;
- (int)compareSTR:(const char *)STR;
- (BOOL)isEqual:anInteger;
- (BOOL)isEqualInt:(int)anInt;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:aCell;
- writeIntoStream:(NXStream *)stream;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;
- (int)compareFirstCharWith:(char )aChar;

@end

