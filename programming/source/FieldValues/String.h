#import "dart/FieldValue.h"

@interface String:FieldValue
{
	unsigned	length;
	unsigned	size;
	char		*string;
}

+ str:(const char *)aSTR;
+ str:(const char *)aSTR tag:(int)theTag;
+ str:(const char *)aSTR len:(int)len;
+ str:(const char *)aSTR len:(int)len tag:(int)theTag;
- init;
- initStr:(const char *)aSTR tag:(int)theTag;
- initStr:(const char *)aSTR len:(int)len tag:(int)theTag;
- free;
- copy;
- (unsigned)length;
- (const char *)str;
- str:(const char *)aSTR;
- (int)int;
- (long)long;
- (double)double;
- (char)charAt:(unsigned)anOffset;
- (char)charAt:(unsigned)anOffset put:(char)aChar;
- copyStrtok:(const char *)delimiters;
- concat:aString;
- concatSTR:(const char *)aSTR;
- concatCHAR:(int)c;
- concatINT:(int)i;
- concatDOUBLE:(double)d;
- (int)compareSTR:(const char *)aSTR;
- (int)compare:aString;
- (BOOL)isEqual:aString;
- (BOOL)isEqualSTR:(const char *)aSTR;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:aCell;
- writeIntoText:aText;
- readFromText:aText;
- writeRTFIntoText:aText;
- readRTFFromText:aText;
- writeIntoStream:(NXStream *)stream;
- readFromStream:(NXStream *)stream;
- readHexFromStream:(NXStream *)stream;
- writeHexToStream:(NXStream *)stream;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;
- (int)compareFirstCharWith:(char )aChar;

@end

