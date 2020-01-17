#import <stdio.h>
#import <stdlib.h>
#import <string.h>
#include <strings.h>
#include <ctype.h>
#include <math.h>
#import <time.h>

#import <appkit/Text.h>
#import <appkit/TextField.h>

#import "Julian.h"
#import "SmarterTFCell.h"
@implementation SmarterTFCell

- initTextCell:(const char *)aString
{
	[super initTextCell:aString];
	fieldType = SMTFC_ALNUM;
	alnumMinLength = 0;
	alnumMaxLength = 10000000;

	alphaMinLength = 0;
	alphaMaxLength = 10000000;
	alphaIsName = NO;
	
	numericMinValue = -10000000;
	numericMaxValue = 100000000;
	
	doubleMinValue = -1E32;
	doubleMaxValue = +1E32;
	
	currencyMinValue = -1E32;
	currencyMaxValue = +1E32;
	currencyDecimalDelimiter = ',';
	currencyThousandsDelimiter = '.';
	
	dateKind = SMTFC_DT_DDMMYYYY;
	dateDelimiter = '.';

	return self;
}

	
- select:(const NXRect *)aRect inView:controlView editor:textObj delegate:anObject start:(int)selStart length:(int)selLength
{
	[super select:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
 
	oldTextFilter = [textObj textFilter];
	switch (fieldType) {
		case SMTFC_NUMERIC:
			[textObj setTextFilter:(NXTextFilterFunc)numericFilter];
			break;
		case SMTFC_FLOAT:
			[textObj setTextFilter:(NXTextFilterFunc)numericFloatFilter];
			break;
		case SMTFC_CURRENCY:
			[textObj setTextFilter:(NXTextFilterFunc)currencyFilter];
			break;
		case SMTFC_ALNUM:	
			[textObj setTextFilter:(NXTextFilterFunc)alphaNumericFilter];	
			break;
		case SMTFC_ALPHA:	
			[textObj setTextFilter:(NXTextFilterFunc)alphaFilter];
			break;
		case SMTFC_DATE:	
			[textObj setTextFilter:(NXTextFilterFunc)dateFilter];
			break;
		default:			
			[textObj setTextFilter:(NXTextFilterFunc)alphaNumericFilter];	
			break;
	}	
	return self;
}

- edit:(const NXRect *)aRect inView:controlView editor:textObj delegate:anObject event:(NXEvent *)theEvent
{
	[super edit:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];

	oldTextFilter = [textObj textFilter];
	switch (fieldType) {
		case SMTFC_NUMERIC:
			[textObj setTextFilter:(NXTextFilterFunc)numericFilter];
			break;
		case SMTFC_FLOAT:
			[textObj setTextFilter:(NXTextFilterFunc)numericFloatFilter];
			break;
		case SMTFC_CURRENCY:
			[textObj setTextFilter:(NXTextFilterFunc)currencyFilter];
			break;
		case SMTFC_ALNUM:	
			[textObj setTextFilter:(NXTextFilterFunc)alphaNumericFilter];	
			break;
		case SMTFC_ALPHA:	
			[textObj setTextFilter:(NXTextFilterFunc)alphaFilter];
			break;
		case SMTFC_DATE:	
			[textObj setTextFilter:(NXTextFilterFunc)dateFilter];
			break;
		default:			
			[textObj setTextFilter:(NXTextFilterFunc)alphaNumericFilter];	
			break;
	}	
	return self;
}

- endEditing:anObject
{
	[anObject setTextFilter:(NXTextFilterFunc)oldTextFilter];
	[super endEditing:anObject];
	return self;
}

- (long)todayLong
{
	time_t		timer;
	struct tm	*myTime;
	long		theLong;
	
	timer = time(&timer);
	myTime = localtime(&timer);
	theLong = (myTime->tm_year+1900)*10000 + (myTime->tm_mon+1)*100 + myTime->tm_mday;

	return theLong;
}

- (long)currentCentury
{
	time_t		timer;
	struct tm	*myTime;
	long		theLong;
	
	timer = time(&timer);
	myTime = localtime(&timer);
	theLong = myTime->tm_year+1900;
	theLong = (theLong / 100) * 100;

	return theLong;
}

- (long)dateAsLong
{
	long	theLong = 0;
	char	buf[256];

	strcpy(buf,[self stringValue]);

	buf[2] = buf[5] = (char)0;
	switch(dateKind) {
		case SMTFC_DT_DDMMYY:
				theLong = atol(buf+6)*10000L + atol(buf+3)*100L + atol(buf) + ([self currentCentury]*10000L);
				break;
		case SMTFC_DT_DDMMYYYY:	
				theLong = atol(buf+6)*10000L + atol(buf+3)*100L + atol(buf);
				break;
		case SMTFC_DT_MMDDYY:
				theLong = atol(buf+6)*10000L + atol(buf)*100L + atol(buf+3) + ([self currentCentury]*10000L);
				break;
		case SMTFC_DT_MMDDYYYY:
				theLong = atol(buf+6)*10000L + atol(buf)*100L + atol(buf+3);
				break;
	}
	
	return theLong;
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteType(stream,"i",&fieldType);
	NXWriteType(stream,"i",&alnumMinLength);
	NXWriteType(stream,"i",&alnumMaxLength);
	NXWriteType(stream,"i",&alphaMinLength);
	NXWriteType(stream,"i",&alphaMaxLength);
	NXWriteType(stream,"i",&alphaIsName);
	NXWriteType(stream,"i",&numericMinValue);
	NXWriteType(stream,"i",&numericMaxValue);
	NXWriteType(stream,"d",&doubleMinValue);
	NXWriteType(stream,"d",&doubleMaxValue);
	NXWriteType(stream,"d",&currencyMinValue);
	NXWriteType(stream,"d",&currencyMaxValue);
	NXWriteType(stream,"c",&currencyDecimalDelimiter);
	NXWriteType(stream,"c",&currencyThousandsDelimiter);
	NXWriteType(stream,"i",&dateKind);
	NXWriteType(stream,"c",&dateDelimiter);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadType(stream,"i",&fieldType);
	NXReadType(stream,"i",&alnumMinLength);
	NXReadType(stream,"i",&alnumMaxLength);
	NXReadType(stream,"i",&alphaMinLength);
	NXReadType(stream,"i",&alphaMaxLength);
	NXReadType(stream,"i",&alphaIsName);
	NXReadType(stream,"i",&numericMinValue);
	NXReadType(stream,"i",&numericMaxValue);
	NXReadType(stream,"d",&doubleMinValue);
	NXReadType(stream,"d",&doubleMaxValue);
	NXReadType(stream,"d",&currencyMinValue);
	NXReadType(stream,"d",&currencyMaxValue);
	NXReadType(stream,"c",&currencyDecimalDelimiter);
	NXReadType(stream,"c",&currencyThousandsDelimiter);
	NXReadType(stream,"i",&dateKind);
	NXReadType(stream,"c",&dateDelimiter);
	return self;
}
- setIntValue:(int)aValue
{
	if ([self fieldType] == SMTFC_CURRENCY) {
		return self;
	} else {
		return [super setIntValue:aValue];
	}
}

- setFloatValue:(float)aValue
{
	if ([self fieldType] == SMTFC_CURRENCY) {
		return [self setDoubleValue:aValue];
	} else {
		return [super setFloatValue:aValue];
	}
}

- setDoubleValue:(double)aValue
{
	if ([self fieldType] == SMTFC_CURRENCY) {
		[self setOldDoubleValue:aValue];
		if ([self currencyShowType] == SMTFC_CT_VTVVVDVV) {
			return [super setStringValue:showCurrencyThousandsOLD(self,[self stringValue])];
		} else {
			return [super setStringValue: showCurrencyOLD(self,[self stringValue])];
		}
	} else {
		return [super setDoubleValue:aValue];
	}
}

- (double)doubleValue
{
	if ([self fieldType] == SMTFC_CURRENCY) {
		char	*bStr = malloc(strlen([self stringValue])+10);
		double	trunc = 0;
		double	fractional;
		double	finalValue;
		char 	doof[2];
		char	*vorkomma, *nachkomma;
		
		trunc = 0.0;
		fractional = 0.0;
		strcpy(bStr,[self stringValue]);
		doof[0] = (char)currencyDecimalDelimiter;
		doof[1] = '\0';
		strtok(bStr," \t\n");
		
		if (bStr[0] == currencyDecimalDelimiter) {
			nachkomma = strtok(bStr, doof);
			vorkomma=NULL;
		} else {
			vorkomma = strtok(bStr, doof);
			if (vorkomma != NULL) {
				nachkomma = strtok(NULL,"");
			} else {
				nachkomma = NULL;
			}
		}
		
		if (vorkomma != NULL) {
			int		i=0;
			char	*s=vorkomma;
			while (s[i]) {
				if (s[i]==currencyThousandsDelimiter) {
					strcpy(s+i,s+i+1);
				} else {
					i++;
				}
			}
			trunc = atof(vorkomma);						
		} else {
			trunc = 0.0;
		}
		
		if (nachkomma != NULL) {
			char nk[512];
			sprintf(nk,"0.%-.50s",nachkomma);
			fractional = atof(nk);
		} else {
			fractional = 0.0;
		}
		
		finalValue = trunc + fractional;
		return finalValue;
	} else {
		return [super doubleValue];
	}
}

- (float)floatValue
{
	return [self doubleValue];
}

- setOldDoubleValue:(double)aValue
{
	return [super setDoubleValue:aValue];
}

- (double)oldDoubleValue
{
	return [super doubleValue];
}

- setFieldType:(int)aType
{
	if ((aType >= SMTFC_ALNUM) && (aType <= SMTFC_DATE)) {
		fieldType = aType;
	}
	return self;
}

- (int)fieldType
{
	return fieldType;
}

- setAlnumMinLength:(int )aValue
{
	alnumMinLength=aValue;
	return self;
}

- (int)alnumMinLength { return alnumMinLength; }


- setAlnumMaxLength:(int )aValue
{
	alnumMaxLength=aValue;
	return self;
}

- (int)alnumMaxLength { return alnumMaxLength; }


- setAlphaMinLength:(int )aValue
{
	alphaMinLength=aValue;
	return self;
}

- (int)alphaMinLength { return alphaMinLength; }


- setAlphaMaxLength:(int )aValue
{
	alphaMaxLength=aValue;
	return self;
}

- (int)alphaMaxLength { return alphaMaxLength; }


- setAlphaIsName:(int )aValue
{
	alphaIsName=aValue;
	return self;
}

- (int)alphaIsName { return alphaIsName; }


- setNumericMinValue:(int )aValue
{
	numericMinValue=aValue;
	return self;
}

- (int)numericMinValue { return numericMinValue; }


- setNumericMaxValue:(int )aValue
{
	numericMaxValue=aValue;
	return self;
}

- (int)numericMaxValue { return numericMaxValue; }


- setDoubleMinValue:(double )aValue
{
	doubleMinValue=aValue;
	return self;
}

- (double)doubleMinValue { return doubleMinValue; }


- setDoubleMaxValue:(double )aValue
{
	doubleMaxValue=aValue;
	return self;
}

- (double)doubleMaxValue { return doubleMaxValue; }


- setCurrencyMinValue:(double )aValue
{
	currencyMinValue=aValue;
	return self;
}

- (double)currencyMinValue { return currencyMinValue; }


- setCurrencyMaxValue:(double )aValue
{
	currencyMaxValue=aValue;
	return self;
}

- (double)currencyMaxValue { return currencyMaxValue; }


- setCurrencyDecimalDelimiter:(char )aValue
{
	currencyDecimalDelimiter=aValue;
	return self;
}

- (char)currencyDecimalDelimiter { return currencyDecimalDelimiter; }


- setCurrencyThousandsDelimiter:(char )aValue
{
	currencyThousandsDelimiter=aValue;
	return self;
}

- (char)currencyThousandsDelimiter { return currencyThousandsDelimiter; }

- setCurrencyShowType:(int)aType
{
	dateKind = aType;
	return self;
}

- (int)currencyShowType { return dateKind; }

- setDateKind:(int )aValue
{
	dateKind=aValue;
	return self;
}

- (int)dateKind { return dateKind; }


- setDateDelimiter:(char )aValue
{
	dateDelimiter=aValue;
	return self;
}

- (char)dateDelimiter { return dateDelimiter; }


BOOL checkFirstPart(char *inputText, int position, int dateType, const char *aText)
{
	char	minLimit, maxLimit;
	
	if ((dateType == SMTFC_DT_DDMMYY) || (dateType == SMTFC_DT_DDMMYYYY)){
		if (position == 0) {
			if ((*inputText >= '0') && (*inputText <= '3')) {
				return YES;
			}
		} 
		if (position == 1) {
			minLimit = 0;
			if (aText[0] == '3') {
				maxLimit = '1';
			} else {
				if (aText[0] == '0') {
					minLimit = '1';
				} 
				maxLimit = '9';
			}
			if ((*inputText >= minLimit) && (*inputText <= maxLimit)) {
				return YES;
			}
		}
	} else if ((dateType == SMTFC_DT_MMDDYY) || (dateType == SMTFC_DT_MMDDYYYY)) {
		if (position == 0) {
			if ((*inputText == '0') || (*inputText == '1')) {
				return YES;
			}
		} 
		if (position == 1) {
			if (aText[0] == '1') {
				minLimit = '0';
				maxLimit = '2';
			} else {
				minLimit = '1';
				maxLimit = '9';
			}
			if ((*inputText >= minLimit) && (*inputText <= maxLimit)) {
				return YES;
			}
		}
	}
	return NO;
}


BOOL checkSecondPart(char *inputText, int position, int dateType, const char *aText)
{
	char	minLimit, maxLimit;
	
	if ((dateType == SMTFC_DT_MMDDYY) || (dateType == SMTFC_DT_MMDDYYYY)) {
		if (position == 3) {
			if ((*inputText >= '0') && (*inputText <= '3')) {
				return YES;
			}
		} 
		if (position == 4) {
			minLimit = 0;
			if (aText[3] == '3') {
				maxLimit = '1';
			} else {
				if (aText[3] == '0') {
					minLimit = '1';
				} 
				maxLimit = '9';
			}
			if ((*inputText >= minLimit) && (*inputText <= maxLimit)) {
				return YES;
			}
		}
	} else 	if ((dateType == SMTFC_DT_DDMMYY) || (dateType == SMTFC_DT_DDMMYYYY)) {
		if (position == 3) {
			if ((*inputText == '0') || (*inputText == '1')) {
				return YES;
			}
		} 
		if (position == 4) {
			if (aText[3] == '1') {
				minLimit = '0';
				maxLimit = '2';
			} else {
				minLimit = '1';
				maxLimit = '9';
			}
			if ((*inputText >= minLimit) && (*inputText <= maxLimit)) {
				return YES;
			}
		}
	}
	return NO;
}


char *dateFilter(id textObj, char *inputText, int *inputLength, int position)
{
	char 	temp[] = "";
	
	char	dateDelimiter = [[textObj delegate]  dateDelimiter];
	int		dateType =  [[textObj delegate]  dateKind];
	const char	*aText = [[textObj delegate] stringValue];
	
	if (((dateType == SMTFC_DT_DDMMYYYY) || (dateType == SMTFC_DT_MMDDYYYY)) && (position >= 10)) {
		*inputLength = 0;
		return (temp);
	}
	if (((dateType == SMTFC_DT_MMDDYY) || (dateType == SMTFC_DT_DDMMYY)) && (position >=8)) {
		*inputLength = 0;
		return (temp);
	}
	switch (position) {
		case	2:
		case	5:	if (*inputText != dateDelimiter) {
						*inputLength = 0;
						return (temp);
					} else {
						return (inputText);
					}
					break;
		case	0:
		case	1: 	if (checkFirstPart(inputText, position, dateType, aText)) {
						return (inputText);
					} else {
						*inputLength = 0;
						return (temp);
					}
					break;
		case	3:
		case	4: 	if (checkSecondPart(inputText, position, dateType, aText)) {
						return (inputText);
					} else {
						*inputLength = 0;
						return (temp);
					}
					break;
		case	6:
		case	7:
		case	8:
		case	9:	if ( (*inputText >= '0') && (*inputText <= '9') ) {
						return (inputText);
					} else {
						*inputLength = 0;
						return (temp);
					}
					break;
		default	 : *inputLength =0; return(temp);
	}
}

char *alphaFilter(id textObj, char *inputText, int *inputLength, int position)
{
	char temp[] = "";
	
	if (position >= [[textObj delegate]  alphaMaxLength]) {
		*inputLength = 0;
		return (temp);
	}
	
	if (((*inputText >= 'a') && (*inputText <= 'z')) ||
		((*inputText >= 'A') && (*inputText <= 'Z')) ||
		(*inputText == '-') ||
		(*inputText == ' ') ||
		(*inputText == ',') ||
		(*inputText == '.')) {
		if ([[textObj delegate]  alphaIsName] == 1) {
			const char *val = [[textObj delegate] stringValue];
			if ((position==0) || isspace(val[position-1]) || ispunct(val[position-1])) {
				*inputText = toupper(*inputText);
			}
		}
	   	return (inputText);
	} else {
		*inputLength = 0;
		return (temp);
	}
}

char *alphaNumericFilter(id textObj, char *inputText, int *inputLength, int position)
{
	char temp[] = "";
	
	if (position >= [[textObj delegate] alnumMaxLength]) {
		*inputLength = 0;
		return (temp);
	}
	return (inputText);
}

char *numericFilter(id textObj, char *inputText, int *inputLength, int position)
{
	char temp[] = "";
	if ((*inputText >= '0') && (*inputText <= '9')) {
		return (inputText);
	}
	if (((*inputText == '-') || (*inputText == '+')) && (position == 0)) {
		return (inputText);
	}
	*inputLength = 0;
	return (temp);
}

char *numericFloatFilter(id textObj, char *inputText, int *inputLength, int position)
{
	char temp[] = "";
	if ((*inputText >= '0') && (*inputText <= '9')) {
		return (inputText);
	}
	if (((*inputText == '-') || (*inputText == '+')) && (position == 0)) {
		return (inputText);
	}
	if (*inputText == '.') {
		const char *aText= [[textObj delegate] stringValue];
		if (strstr(aText,".")== NULL) {
			return (inputText);
		}
	}
	*inputLength = 0;
	return (temp);
}

char *currencyFilter(id textObj, char *inputText, int *inputLength, int position)
{
	const char 	*currVal = [[textObj delegate] stringValue];
	char 		temp[] = "";
	int			decPos=-1;

	if (index(currVal, [[textObj delegate] currencyDecimalDelimiter]) != NULL) {
		decPos = index(currVal, [[textObj delegate] currencyDecimalDelimiter])-currVal;
	}
	if ((*inputText == [[textObj delegate] currencyDecimalDelimiter]) && (decPos>=0)) {
		*inputLength = 0;
		return (temp);
	} 
	if (((*inputText < '0') || (*inputText > '9')) && (*inputText != [[textObj delegate] currencyDecimalDelimiter])){
		*inputLength = 0;
		return (temp);
	}
	return (inputText);
}

BOOL endEditing(id anObject, const char *aString)
{
	int	fieldType = [anObject fieldType];
	switch (fieldType) {
		case SMTFC_ALNUM: 	return endALNUMEditing(anObject,aString);
		case SMTFC_ALPHA:	return endALPHAEditing(anObject,aString);
		case SMTFC_NUMERIC: return endNUMERICEditing(anObject,aString);
		case SMTFC_FLOAT:	return endFLOATEditing(anObject,aString);
		case SMTFC_DATE:	return endDATEEditing(anObject,aString);
		default:			return YES;
	}
}

BOOL endALNUMEditing(id	aField, const char *aString)
{
	if ((strlen(aString) < [aField alnumMinLength]) || (strlen(aString) > [aField alnumMaxLength])) {
		return NO;
	} else {
		return YES;
	}
}

BOOL endALPHAEditing(id	aField, const char *aString)
{
	if ((strlen(aString) < [aField alphaMinLength]) || (strlen(aString) > [aField alphaMaxLength])) {
		return NO;
	} else {
		return YES;
	}
}

BOOL endNUMERICEditing(id	aField, const char *aString)
{
	if ((atoi(aString) < [aField numericMinValue]) || (atoi(aString) > [aField numericMaxValue])) {
		return NO;
	} else {
		return YES;
	}
}

BOOL endFLOATEditing(id	aField, const char *aString)
{
	if ((atof(aString) < [aField doubleMinValue]) || (atof(aString) > [aField doubleMaxValue])) {
		return NO;
	} else {
		return YES;
	}
}

const char *SF_ParseDoubleSTR(const char *DF_local, double theValue)
{
	char		decimalDelimiter = '.';
	char		thousandsDelimiter = ',';
	int			numDecimals = 2;
	BOOL		hasThousands = NO;
	static char	dVal[128];
	int			i,j;
	BOOL		decFnd = NO, thoFnd = NO;
	dVal[0] = '\0';
	for (i=strlen(DF_local)-1; i>=0; i--) {
		if ((DF_local[i] < '0') || (DF_local[i] > '9')) {
			if (decFnd == YES) {
				thoFnd = YES;
				thousandsDelimiter = DF_local[i];
				hasThousands = YES;
			} else {
				decFnd = YES;
				decimalDelimiter = DF_local[i];
				numDecimals = ((strlen(DF_local)-i)-1);
			}
		}
	}

	if (!hasThousands) {
		sprintf(dVal,"%.*lf", numDecimals, theValue);
		strstr(dVal,".")[0] = decimalDelimiter;
	} else {
		double	truncPart = (double)((int)(theValue));
		char	buf[256];
		char	buf2[512];
		int		i,len;
		
		sprintf(buf,"%.0lf",truncPart);
		for(j=i=0,len=strlen(buf); i<len; i++) {
			buf2[j++] = buf[len-1-i];
			if((i+1<len) && (((i+1) % 3)==0)) {
				buf2[j++] = thousandsDelimiter;
			}
		}
		for(i=0; i<j; i++) {
			buf[i] = buf2[j-1-i];
		}
		buf[i++] = decimalDelimiter;
		buf[i] = '\0';
		theValue -= truncPart;
		sprintf(buf2,"%.*lf", numDecimals, theValue);
		if (index(buf2,'.') != NULL) {
			strcat(buf,index(buf2,'.')+1); 
		} else {
			strcat(buf,"BEEF");
		}
		strcpy(dVal,buf);
	}
	return dVal;
}


const char * showCurrencyThousandsOLD(id aField, const char *aString)
{
	char	fmt[32];
	sprintf(fmt,"1%c000%c00",[aField currencyThousandsDelimiter], [aField currencyDecimalDelimiter]);
	return SF_ParseDoubleSTR(fmt,[aField oldDoubleValue]);
}

const char * showCurrencyOLD(id aField, const char *aString)
{
	static char 	buf[128];
	
	sprintf(buf,"%.02lf",[aField oldDoubleValue]);
	if (strstr(buf,".") == NULL) {
		strcat(buf,".00");
	}
	(strstr(buf,"."))[0] = [aField currencyDecimalDelimiter];
	return buf;
}

const char * showCurrencyThousands(id aField, const char *aString)
{
	char	fmt[32];
	sprintf(fmt,"1%c000%c00",[aField currencyThousandsDelimiter], [aField currencyDecimalDelimiter]);
	return SF_ParseDoubleSTR(fmt,[aField doubleValue]);
}

const char * showCurrency(id aField, const char *aString)
{
	static char 	buf[128];
	
	sprintf(buf,"%.02lf",[aField doubleValue]);
	if (strstr(buf,".") == NULL) {
		strcat(buf,".00");
	}
	(strstr(buf,"."))[0] = [aField currencyDecimalDelimiter];
	return buf;
}

const char *endCURRENCYEditing(id	aField, const char *aString)
{
	double	value = [aField doubleValue];
	if ((value < [aField currencyMinValue]) || (value >  [aField currencyMaxValue])) {
		return NULL;
	}
	if ([aField currencyShowType] == SMTFC_CT_VTVVVDVV) {
		return showCurrencyThousands(aField,aString);
	} else {
		return showCurrency(aField,aString);
	}
}

BOOL endDATEEditing(id	aField, const char *aString)
{
	char 	aFString[12];
	int		mon,day,year;
	int		century = [[aField cell] currentCentury] / 100;
	sprintf(aFString,"%%d%c%%d%c%%d",[aField dateDelimiter],[aField dateDelimiter]);
	switch ([aField dateKind]) {
		case SMTFC_DT_DDMMYY:	sscanf(aString,aFString,&day,&mon,&year); year += century*100; break;
		case SMTFC_DT_DDMMYYYY:	sscanf(aString,aFString,&day,&mon,&year); break;
		case SMTFC_DT_MMDDYY:	sscanf(aString,aFString,&mon,&day,&year); year += century*100; break;
		case SMTFC_DT_MMDDYYYY:	sscanf(aString,aFString,&mon,&day,&year); break;
	}
	return [Julian validDay:day :mon :year :0 :0 :0];
}

@end
