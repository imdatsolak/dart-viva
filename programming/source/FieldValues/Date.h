#import "dart/FieldValue.h"

@interface Date:FieldValue
{
	char	myDateStr[15];
}

+ setDateFormat:(const char *)aFormat;
+ todayWithTag:(int)theTag;
+ today;
+ sybDate:(const char *)aDate tag:(int)theTag;
+ sybDate:(const char *)aDate;
- init;
- initTodayWithTag:(int)theTag;
- initSybDate:(const char *)aDate tag:(int)theTag;
- (const char *)dateSTR;
- sybaseSTR:(char *)s length:(int)len;
- setDateLong:(long)aLong;
- copyAsString;
- (const char *)str;
- (long)long;
- (int)day;
- (int)month;
- (int)year;
- (int)yearWithoutCentury;
- (int)compare:aDate;
- (BOOL)isEqual:aDate;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:aCell;
- writeIntoStream:(NXStream *)stream;
- write:(NXTypedStream *)stream;
- read:(NXTypedStream *)stream;
- (int)compareFirstCharWith:(char )aChar;

@end


@interface Object(DateCell)
- (long)dateAsLong;

@end

