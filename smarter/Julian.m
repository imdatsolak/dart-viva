#import <math.h>
#import <stdlib.h>
#import "Julian.h"

#pragma .h #import <objc/Object.h>

@implementation Julian:Object
{
	double	julianDayVal;
}

// Given a day month and year, calculate the julian date.
+ (double)julianDay:(int)day :(int)month :(int)year
{
	int a,b;
	double retVal;
	float yearCorr;

	yearCorr = (year > 0? 0.0 : 0.75);
	if( month <= 2)	{
		year--;
		month += 12;
	}
	b = 0;
	if( (year * 10000.0) + (month * 100.0) + day >= 15821015.0)	{
		a = year / 100;
		b = (2-a)+(a/4);
	}
	retVal = (long) ( (365.25 * year) - yearCorr);
	retVal += (long) (30.6001 * (month+1));
	retVal += (long) day;
	retVal += 1720994L;
	retVal += (long) b;
	return(retVal);
}

+ (double)julianDay:(int)day :(int)month :(int)year :(int)hour :(int)min :(int)sec
{
	double retVal, retFraction;

	retVal = [self julianDay:day:month:year];
	retFraction = (double)((double)hour/24.0) + (double)((double)min/1440.0) + (double)((double)sec/86400.0);
	return  (retVal+retFraction);
}

//Given a julian date, calculate the month day and year.
//The year will be Negitive if it's BC
+ (void)calendarDay:(double)julian :(int *)day :(int *)month :(int *)year
{
	long a,b,c,d,e,z, alpha;
	
	z = julian + 1;
	//Deal with Gregorian reform
	if( z < 2299161L) {
		a = z;
	} else {
		alpha = (long) (( z - 1867216.25) / 36524.25);
		a = z + 1 + alpha - alpha / 4;
	}
	b = a + 1524;
	c = (long) (( b - 122.1) / 365.25);
	d = (long) (365.25 * c);
	e = (long) (( b - d ) / 30.6001);
	*day	= (int) b - d - (long) (30.6001 * e);
	*month 	= (int) ( e < 13.5) ? e - 1 : e - 13;
	*year 	= (int) (*month > 2.5) ? (c - 4716) : c - 4715;
}

+ (void)calendarDay:(double)julian :(int *)day :(int *)month :(int *)year :(int *)hour :(int *)min :(int *)sec
{
	double fractionalPart;
	double tmpResult;
	double integerPart;

	[self calendarDay:(long)julian :day :month :year];
	fractionalPart = modf((double)julian,&integerPart);
	tmpResult = fractionalPart * 24.0;
	fractionalPart = modf(tmpResult,&integerPart);
	*hour = (int) integerPart;
	tmpResult  = fractionalPart *  60.0;
	fractionalPart = modf(tmpResult,&integerPart);
	*min = (int) integerPart;
	tmpResult  = fractionalPart *  60.0;
	fractionalPart = modf(tmpResult,&integerPart);
	*sec = (int) integerPart;
}

+ (BOOL)validDay:(int)day :(int)month :(int)year
{
	int calDay;
	int calMonth;
	int calYear;

	[self calendarDay:[self julianDay:day :month :year] :&calDay :&calMonth :&calYear];
	return(( day == calDay) && (month == calMonth) && (year == calYear) );
}

+ (BOOL)validDay:(int)day :(int)month :(int)year :(int)hour :(int)min :(int)sec
{
	int calDay;
	int calMonth;
	int calYear;
	int calHour;
	int calMin;
	int calSec;

	//convert it to julian
	[self calendarDay:[self julianDay:day:month:year:hour:min:sec] 
				:&calDay :&calMonth :&calYear :&calHour :&calMin :&calSec];
	return( (day == calDay) && (month == calMonth) && (year == calYear) && 
			(hour == calHour) && (min == calMin) && (sec == calSec) );
}

//0=Sunday 2 = Monday .... 6 = Saturday
+ (int)dow:(long)julian
{
	return (int) ((( julian + 2) % 7) + 1);
}

//week days from past dates
+ (double)wkd:(int)day :(int)month :(int)year
{
	long d;
	double g;
	double f;
	double ans;

	g = (month > 2) ? year : year-1;
	f = (month > 2) ? month + 1 : month + 13;
	d = day - (int) ( 0.75* (int) (g/100.0)-7) + (int) (365.25*g) + (int) (30.6*f);
	d-=2;				
	ans = (5* (int) (d/7)) + (0.5*(int) (1.801* (d % 7)));
	return ans;
}

//  Day of year
+ (int)doy:(int)day :(int)month :(int)year
{
	double curJulianDay;
	double janJulianDay;

	curJulianDay =[Julian  julianDay:day :month :year];
	janJulianDay = [Julian  julianDay:1 :1 :year];
	return (int) ( (curJulianDay - janJulianDay) + 1.0);
}

//instance methods
- init
{
	julianDayVal = 0.0;
	return self;
}

- (BOOL)initDay:(int)month :(int)day :(int)year
{
	[super init];
	return [self setJulianDay:month:day:year];
}
				
- (BOOL)initDay:(int)month :(int)day :(int)year :(int)hour :(int)min :(int)sec
{
	[super init];
	return [ self  setJulianDay:month :day :year :hour :min :sec];
}

- read:(NXTypedStream *)stream
{
    [super read:stream];
	NXReadType(stream,"d",&julianDayVal);
    return self;
}

- write:(NXTypedStream *)stream
{
    [super write:stream];
	NXWriteType(stream,"d",&julianDayVal);
    return self;
}

- (double)getJulianDay
{
	return julianDayVal;
}

- getCalandarDay :(int*)month :(int*)day :(int*)year
{
	[Julian calendarDay:julianDayVal :day :month :year];
	return self;
}

								
- getCalandarDay :(int*)month :(int*)day :(int*)year :(int*)hour :(int*)min :(int*)sec
{
	[Julian calendarDay:julianDayVal :day :month :year :hour :min :sec];
	return self;
}

- (BOOL)setJulianDay :(double)day
{
	julianDayVal = day;
	return YES;
}


- (BOOL)setJulianDay:(int)month :(int)day :(int)year
{
	if( [Julian validDay:month :day :year]) {
		julianDayVal = [Julian julianDay:month :day :year];
		return YES;
	}
	return NO;
}	
					
- (BOOL)setJulianDay:(int)month :(int)day :(int)year :(int)hour :(int)min :(int)sec
{
	if( [Julian validDay:month :day :year :hour :min :sec]) {
 		julianDayVal = [Julian validDay:month :day :year :hour :min :sec];
		return YES;
	}
	return NO;
}
@end
