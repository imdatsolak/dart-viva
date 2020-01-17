#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#include <strings.h>
#import <time.h>

#import <otikit/smartkit.h>

#import "dart/dartlib.h"
#import "dart/ColumnBrowserCell.h"
#import <dart/fieldvaluekit.h>

static char DF_localized[11] = "DD-MM-YYYY";
static int	dayPos=0, monthPos=3, yearPos=6;
static int	delimiterOne = 0, delimiterTwo= 0;

static void MakeSybaseDateFromMyDate(char *sybDate, int day, int month, int year)
{
	char mon[12][4] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};

	if((1<=month) && (month<=12)) {
		sprintf(sybDate,"%s %2d %d",mon[month-1], day, year);
	}

	return;
}				

static void MakeMyDateFromSybaseDate(char *myDate, const char *sybDate)
{
	char mon[12][4] = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
	int i, tMon=1, tDay=1, tYear=1991;
	char mmon[4];
	
	sscanf(sybDate, "%s%d%d",mmon, &tDay, &tYear);
	for(i=0;i<12;i++) {
		if(strcmp(mmon,mon[i]) == 0) tMon = i+1;
	}
	sprintf(myDate,"%02d.%02d.%04d",tDay, tMon, tYear);

	return;
}

static void Convert(const char *DF_local, char *fDate, char key, int value, int *positionAt)
{
	char		buf[10];
	int			pos;
	pos = index(DF_local, key) - DF_local;
	if ((pos > -1)  && (pos < 10)){
		*positionAt = pos;
		sprintf(buf,"%d", value);
		if (strlen(buf)==1) {
			int exist = index(DF_local+(pos+1), key) - DF_local;
			if (exist> -1) {
				fDate[exist] = buf[0];
				fDate[pos] = '0';
			} else {
				fDate[pos] = buf[0];
			}
		} else {
			fDate[pos] = buf[0];
			fDate[pos+1] = buf[1];
		}
	}
}

const char *ParseDateSTR(const char *DF_local, id from)
{
	static char	fDate[11];
	int			i, fnd = 0;

	for (i=0;i<10;i++) {
		fDate[i] = ' ';
	}
	for (i=0;i<strlen(DF_local);i++) {
		if ((DF_local[i] != 'Y') && (DF_local[i] != 'M') && (DF_local[i] != 'D')) {
			fDate[i] = DF_local[i];
			if (delimiterOne == 0) {
				delimiterOne = i;
			} else if (delimiterTwo == 0){
				delimiterTwo = i;
			}
		} else if (DF_local[i] == 'Y') {
			fnd++;
		}
	}
	Convert(DF_local, fDate, 'Y', [from yearWithoutCentury], &yearPos);
	if (fnd>2) {
		fnd = index(DF_local, 'Y') - DF_local;
		fDate[fnd+2] = fDate[fnd];
		fDate[fnd+3] = fDate[fnd+1];
		Convert(DF_local, fDate, 'Y', [from year], &yearPos);
	}
	Convert(DF_local, fDate, 'M', [from month], &monthPos);
	Convert(DF_local, fDate, 'D', [from day], &dayPos);
	return fDate;
}

#pragma .h #import "dart/FieldValue.h"

@implementation Date:FieldValue
{
	char	myDateStr[15];
}

+ setDateFormat:(const char *)aFormat
{
	strncpy0(DF_localized, aFormat, sizeof(DF_localized)-1);
	return self;
}

+ todayWithTag:(int)theTag
{
	self = [[super alloc] initTodayWithTag:theTag];
	return self;
}


+ today
{
	self = [[super alloc] initTodayWithTag:0];
	return self;
}


+ sybDate:(const char *)aDate tag:(int)theTag
{
	self = [[super alloc] initSybDate:aDate tag:theTag];
	return self;
}

+ sybDate:(const char *)aDate
{
	self = [[super alloc] initSybDate:aDate tag:0];
	return self;
}

- init
{
	[super init];
	tag = 0;
	strcpy(myDateStr, "01.01.1970");
	strcpy(myDateStr, ParseDateSTR(DF_localized, self));
	return self;
}

- initTodayWithTag:(int)theTag
{
	time_t		timer;
	struct tm	*myTime;
	long		theLong;
	
	timer = time(&timer);
	myTime = localtime(&timer);
	theLong = (myTime->tm_year+1900)*10000 + (myTime->tm_mon+1)*100 + myTime->tm_mday;
	
	[[[super init] setDateLong:theLong] setTag:theTag];

	return self;
}

- initSybDate:(const char *)aDate tag:(int)theTag
{
	[super init];
	tag = theTag;
	if(aDate) {
		MakeMyDateFromSybaseDate(myDateStr,aDate);
		strcpy(myDateStr, ParseDateSTR(DF_localized, self));
	}
	return self;
}

- (const char *)dateSTR
{
	return myDateStr;
}

- sybaseSTR:(char *)s length:(int)len
{
	if((len>=12) && s) {
		MakeSybaseDateFromMyDate(s,[self day],[self month],[self year]);
	}
	return self;
}

- setDateLong:(long)aLong
{
	sprintf(myDateStr,"%02d.%02d.%04d",aLong%100L,(aLong/100L)%100L, aLong/10000L);
	strcpy(myDateStr, ParseDateSTR(DF_localized, self));
	return self;
}

- copyAsString
{
	return [String str:myDateStr];
}

- (const char *)str
{
	return ParseDateSTR(DF_localized, self);
}

- (long)long
{
	long	theLong;

	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = (char)0;
	theLong = atol(myDateStr+yearPos)*10000L + atol(myDateStr+monthPos)*100L + atol(myDateStr+dayPos);
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = '.';
	
	return theLong;
}


- (int)day
{
	int	theResult;
	
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = (char)0;
	theResult = atoi(myDateStr+dayPos);
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = '.';
	
	return theResult;
}

- (int)month
{
	int	theResult;
	
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = (char)0;
	theResult = atoi(myDateStr+monthPos);
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = '.';
	
	return theResult;
}

- (int)year
{
	int	theResult;
	
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = (char)0;
	theResult = atoi(myDateStr+yearPos);
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = '.';
	
	return theResult;
}


- (int)yearWithoutCentury
{
	int	theResult;
	
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = (char)0;
	theResult = atoi(myDateStr+yearPos+2);
	myDateStr[delimiterOne] = myDateStr[delimiterTwo] = '.';
	
	return theResult;
}


- (int)compare:aDate
{
	int	myLong = [self long], theOtherLong = [aDate long];
	if(myLong < theOtherLong) {
		return -1;
	} else if(myLong == theOtherLong) {
		return 0;
	} else {
		return 1;
	}
}

- (BOOL)isEqual:aDate
{
	return 0 == strcmp(myDateStr,[aDate dateSTR]);
}

- writeIntoCell:aCell
{
	[aCell setStringValue:ParseDateSTR(DF_localized, self)];
	return self;
}

- writeIntoCell:aCell inColumn:(int)column
{
	[aCell setStringValue:ParseDateSTR(DF_localized, self) ofColumn:column];
	return self;
}

- readFromCell:aCell
{
	if ([aCell respondsTo:@selector(dateAsLong)]) {
		[self setDateLong:[aCell dateAsLong]];
	} else {
		sprintf(myDateStr, "%s", [aCell stringValue]);
		strcpy(myDateStr, ParseDateSTR(DF_localized, self));
	}
	return self;
}

- writeIntoStream:(NXStream *)stream
{
	NXPrintf(stream,"%s", ParseDateSTR(DF_localized, self));
	return self;
} 

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteArray(stream,"c",sizeof(myDateStr),myDateStr);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadArray(stream,"c",sizeof(myDateStr),myDateStr);
	return self;
}

- (int)compareFirstCharWith:(char )aChar
{
	const char *aStr = [self str];
	if (aStr != NULL) {
		if (aStr[0] == aChar) {
			return 0;
		} else if (aStr[0] < aChar) {
			return -1;
		} else {
			return 1;
		}
	}
	return -1;
}

@end

@interface Object(DateCell)
- (long)dateAsLong;
@end

