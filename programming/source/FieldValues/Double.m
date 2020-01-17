#import <stdio.h>
#import <string.h>
#import <math.h>

#import "dart/debug.h"
#import "dart/dartlib.h"
#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#pragma .h #import "dart/FieldValue.h"

@implementation Double:FieldValue
{
	double	myDouble;
	id		dfLocalized;
	id		myStr;
}
const char *ParseDoubleSTR(const char *DF_local, double theValue)
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
		double	truncPart = rint(theValue);
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


static char DF_localized[12] = "1,000.00\0";


+ setDoubleFormat:(const char *)aFormat
{
	strncpy0(DF_localized, aFormat, sizeof(DF_localized));
	return self;
}

+ (const char *)doubleFormat
{
	return DF_localized;
}

+ double:(double)aDouble tag:(int)theTag
{
	self = [[super alloc] initDouble:aDouble tag:theTag];
	return self;
}

+ double:(double)aDouble
{
	self = [[super alloc] initDouble:aDouble tag:0];
	return self;
}

- init
{
	[super init];
	tag = 0;
	myDouble = 0.0;
	return self;
}

- initDouble:(double)aDouble tag:(int)theTag
{
	[super init];
	tag = theTag;
	myDouble = aDouble;
	return self;
}

- free
{
	[dfLocalized free];
	[myStr free];
	return [super free];
}

- copy
{
	id	theCopy = [super copy];
	dfLocalized = [dfLocalized copy];
	myStr = [myStr copy];
	return theCopy;
}

- setDoubleFormat:(const char *)aFormat
{
	if (dfLocalized == nil) {
		dfLocalized = [String str:""];
	}
	[dfLocalized str:aFormat];
	return self;
}

- (const char *)doubleFormat
{
	if (dfLocalized == nil) {
		return [[self class] doubleFormat];
	} else {
		return [dfLocalized str];
	}
}

- (double)double
{
	return myDouble;
}

- setDouble:(double)aDouble
{
	myDouble = aDouble;
	return self;
}

- copyAsStringWidth:(int)width decimal:(int)decimal
{
	char	s[1000];
	sprintf(s,"%*.*lf",width,decimal,myDouble);
	return [String str:s];
}

- copyAsString
{
	char	s[1000];
	sprintf(s,"%lf",myDouble);
	return [String str:s];
}

- (const char *)str
{
	if (myStr == nil) {
		myStr = [String str:""];
	}
	[myStr str:ParseDoubleSTR(DF_localized, myDouble)];
	return [myStr str];
}

- (int)int
{
	return (int)myDouble;
}

- addDouble:(double)aDouble
{
	myDouble += aDouble;
	return self;
}


- subDouble:(double)aDouble
{
	myDouble -= aDouble;
	return self;
}


- multDouble:(double)aDouble
{
	myDouble *= aDouble;
	return self;
}


- divDouble:(double)aDouble
{
	myDouble /= aDouble;
	return self;
}

- (int)compareDouble:(double)aDouble
{
	if(myDouble == aDouble) {
		return 0;
	} else if(myDouble < aDouble) {
		return -1;
	} else {
		return 1;
	};
}

- (int)compare:aDouble
{
	return [self compareDouble:[aDouble double]];
}

- (BOOL)isEqual:aDouble
{
	return myDouble == [aDouble double];
}

- (BOOL)isEqualDouble:(double)aDouble
{
	return myDouble == aDouble;
}

- writeIntoCell:aCell
{
	[aCell setDoubleValue:myDouble];
	return self;
}

- writeIntoCell:aCell inColumn:(int)column
{
	[aCell setStringValue:[self str] ofColumn:column];
	return self;
}

- readFromCell:aCell
{
	myDouble = [aCell doubleValue];
	return self;
}

- writeIntoStream:(NXStream *)aStream
{
	NXPrintf(aStream,"%lf", [self double]);
	return self;
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteTypes(stream,"d",&myDouble);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadTypes(stream,"d",&myDouble);
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

