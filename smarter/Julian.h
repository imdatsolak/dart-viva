#import <objc/Object.h>

@interface Julian:Object
{
	double	julianDayVal;
}

+ (double)julianDay:(int)day :(int)month :(int)year;
+ (double)julianDay:(int)day :(int)month :(int)year :(int)hour :(int)min :(int)sec;
+ (void)calendarDay:(double)julian :(int *)day :(int *)month :(int *)year;
+ (void)calendarDay:(double)julian :(int *)day :(int *)month :(int *)year :(int *)hour :(int *)min :(int *)sec;
+ (BOOL)validDay:(int)day :(int)month :(int)year;
+ (BOOL)validDay:(int)day :(int)month :(int)year :(int)hour :(int)min :(int)sec;
+ (int)dow:(long)julian;
+ (double)wkd:(int)day :(int)month :(int)year;
+ (int)doy:(int)day :(int)month :(int)year;
- init;
- (BOOL)initDay:(int)month :(int)day :(int)year;
- (BOOL)initDay:(int)month :(int)day :(int)year :(int)hour :(int)min :(int)sec;
- read:(NXTypedStream *)stream;
- write:(NXTypedStream *)stream;
- (double)getJulianDay;
- getCalandarDay :(int*)month :(int*)day :(int*)year;
- getCalandarDay :(int*)month :(int*)day :(int*)year :(int*)hour :(int*)min :(int*)sec;
- (BOOL)setJulianDay :(double)day;
- (BOOL)setJulianDay:(int)month :(int)day :(int)year;
- (BOOL)setJulianDay:(int)month :(int)day :(int)year :(int)hour :(int)min :(int)sec;

@end

