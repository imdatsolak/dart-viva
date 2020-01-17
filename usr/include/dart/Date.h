#import <dart/FieldValue.h>

@interface Date:FieldValue
{
	char	myDateStr[15];
}

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
- asString;
- (long)asLong;
- (int)day;
- (int)month;
- (int)year;
- (int)yearWithoutCentury;
- (int)compare:aDate;
- (BOOL)isEqual:aDate;
- writeIntoCell:aCell;
- writeIntoCell:aCell inColumn:(int)column;
- readFromCell:aCell;
- writeIntoStream:(NXStream *)aStream;

@end
