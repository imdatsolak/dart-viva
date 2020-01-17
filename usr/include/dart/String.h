#import <dart/FieldValue.h>

@interface String:FieldValue
{
	unsigned	length;
	unsigned	size;
	char		*string;
}

+ str:(const char *)aCString;
+ str:(const char *)aCString tag:(int)theTag;
+ str:(const char *)aCString len:(int)len;
+ str:(const char *)aCString len:(int)len tag:(int)theTag;
- init;
- initStr:(const char *)aCString tag:(int)theTag;
- initStr:(const char *)aCString len:(int)len tag:(int)theTag;
- free;
- copy;
- (unsigned)length;
- (const char *)str;
- (int)asInt;
- (long)asLong;
- (double)asDouble;
- (char)charAt:(unsigned)anOffset;
- (char)charAt:(unsigned)anOffset put:(char)aChar;
- concat:aString;
- concatSTR:(const char *)aCString;
- (int)compareSTR:(const char *)aCString;
- (int)compare:aString;
- (BOOL)isEqual:aString;
- (BOOL)isEqualSTR:(const char *)aCString;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:aCell;
- writeIntoText:aText;
- readFromText:aText;
- writeIntoStream:(NXStream *)aStream;

@end
