#import <string.h>
#import <stdlib.h>
#import <stdio.h>

#import "dart/dartlib.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

@implementation QueryString

- concatField:aField
{
	if([aField isKindOf:[Integer class]]) {
		[self concatINT:[aField int]];
	} else if([aField isKindOf:[Double class]]) {
		[self concatDOUBLE:[aField double]];
	} else if([aField isKindOf:[Date class]]) {
		char	s[20];
		[aField sybaseSTR:s length:sizeof(s)];
		[self concatSTR:"\""];
		[self concatSTR:s];
		[self concatSTR:"\""];
	} else if([aField isKindOf:[String class]]) {
		id	queryString = [[QueryString str:[aField str]] translateQuotes];
		[self concatSTR:"\""];
		[self concat:queryString];
		[self concatSTR:"\" "];
		[queryString free];
	} else if([aField isKindOf:[NullValue class]]) {
		[self concatSTR:"NULL"];
	} else {
		[self error:"unknown field class:%s",object_getClassName(aField)];
	}
	
	return self;
}


- concatFieldComma:aField
{	
	return [[self concatField:aField] concatSTR:","];
}

- translateRTF
{
	int	i;
	for(i=0; i<length; i++) {
		if((string[i] == '\\') && (string[i+1]=='\n')) {
			char	*aStr = malloc(length);
			strcpy(aStr, [self str]);
			aStr[i] = '\0';
			[self str:aStr];
			[self concatSTR:"\\\\\n\n"];
			[self concatSTR:(aStr+i+2)];
			free(aStr);
			i += 2;
		}
	}
	return self;
}

- translateQuotes
{
	int		i;
	char	*s = malloc(size);
	strncpy0(s,string,size);
	
	[self str:""];
	for(i=0; s[i]; i++) {
		[self concatCHAR:s[i]];
		if(s[i] == '\"') [self concatCHAR:s[i]];
	}
	free(s);
	return self;
}

- concatINT:(int)i
{
	char	s[20];
	sprintf(s,"%d ",i);
	[self concatSTR:s];
	return self;
}

- concatDOUBLE:(double)d
{
	char	s[20];
	sprintf(s,"%lf ",d);
	[self concatSTR:s];
	return self;
}

- concatINTComma:(int)i
{
	return [[self concatINT:i] concatSTR:","];
}

- concatDOUBLEComma:(double)d
{
	return [[self concatDOUBLE:d] concatSTR:","];
}

@end

