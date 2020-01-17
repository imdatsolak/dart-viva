#import <stdlib.h>
#import <strings.h>
#import <appkit/publicWraps.h>
#import <appkit/Text.h>

#import "dart/DateField.h"

#pragma .h #import <appkit/TextField.h>

@implementation DateField:TextField
{
	char	finalDate[12];
}

- (BOOL)checkEntryForAcceptance
{
	char	*myPtr;
	
	int		month=1,i;
	int		day=1;
	int		year=1;
	BOOL	entryOk = YES;
	
	myPtr = malloc(strlen([self stringValue])+1);
	strcpy(myPtr, [self stringValue]);
	for (i=0;(i<strlen(myPtr)) && (entryOk);i++) {
		if (myPtr[i] != '.') {
			if ((myPtr[i] < '0') || (myPtr[i] > '9')) {
				entryOk = NO;
			}
		} else if (myPtr[i+1] == '.') {
			entryOk = NO;
		}
	}
	if (entryOk) {
		sscanf(myPtr,"%d.",&day);
		if ((day > -1) && (day <=31)) {
			if (strstr(myPtr,".") != NULL) {
				sscanf(myPtr,"%d.%d",&day,&month);
				if ((month>-1) && (month <= 12) && (day > 0)) {
					if ((month != 2) || (day <= 29)) {
						if (strstr( strstr(myPtr,".")+1,".")) {
							sscanf(myPtr,"%d.%d.%d", &day,&month,&year);
							if ((year >= 1) && (month > 0)) {
								entryOk = YES;
							} else {
								entryOk = NO;
							}
						}
					} else {
						entryOk = NO;
					}
				} else {
					entryOk = NO;
				}
			}		} else {
			entryOk = NO;
		}
	}
	free(myPtr);
				
	if (!entryOk) {
		NXBeep();
		[self selectText:self];
	}	
	return entryOk;		
}


- (BOOL)finalCheck
{
	char	*myPtr;
	
	int		month=-1,i, countDots=0;
	int		day=-1;
	int		year=-1;
	BOOL	entryOk = YES;
	
	myPtr = malloc(strlen([self stringValue])+1);
	strcpy(myPtr, [self stringValue]);
	printf("Date:%s\n",myPtr);
	for (i=0;(i<strlen(myPtr)) && (entryOk);i++) {
		if (myPtr[i] != '.') {
			if ((myPtr[i] < '0') || (myPtr[i] > '9')) {
				entryOk = NO;
			}
		} else if (myPtr[i+1] == '.') {
			entryOk = NO;
		} else {
			countDots++;
		}
	}
	if (entryOk) {
		if (countDots == 2) {
			sscanf(myPtr,"%d.%d.%d", &day,&month,&year);
			if ((year >= 1) && (month >= 1) && (month <= 12) &&
				(day >= 1) && (day <=31)) {
				entryOk = YES;
				if ((month==2) && (day > 29)) {
					entryOk = NO;
				}
			} else {
				entryOk = NO;
			}
		} else {
			entryOk = NO;
		}
	}
	free(myPtr);
	if (entryOk) {
		sprintf(finalDate,"%02d.%02d.%d",day,month,year);
	} else {
		NXBeep();
		[self selectText:self];
	}
	return entryOk;		

}

- (BOOL)isValid
{
	BOOL retVal = [self finalCheck];
	retVal = retVal && (strlen([self stringValue])>0);
	return retVal;
}

- textDidEnd:textObject endChar:(unsigned short)whyEnd
{
	if ((whyEnd == NX_ILLEGAL) || ([self finalCheck])) {
		[super textDidEnd:textObject endChar:whyEnd];
		[self setStringValue:finalDate];
	}
	return self;
}

- textDidGetKeys:textObject isEmpty:(BOOL)flag
{
	if (!flag) {
		[self checkEntryForAcceptance];
	}
	return [[self textDelegate] textDidGetKeys:textObject isEmpty:flag];
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteArray(stream,"c",sizeof(finalDate),finalDate);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadArray(stream,"c",sizeof(finalDate),finalDate);
	return self;
}

@end
