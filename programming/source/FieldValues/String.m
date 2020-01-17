#import <stdio.h>
#import <string.h>
#import <stdlib.h>
#import <appkit/Text.h>

#import "dart/ColumnBrowserCell.h"

#import "dart/fieldvaluekit.h"

#pragma .h #import "dart/FieldValue.h"

@implementation String:FieldValue
{
	unsigned	length;
	unsigned	size;
	char		*string;
}


+ str:(const char *)aSTR
{
	self = [[super alloc] initStr:aSTR tag:0];
	return self;
}


+ str:(const char *)aSTR tag:(int)theTag
{
	self = [[super alloc] initStr:aSTR tag:theTag];
	return self;
}


+ str:(const char *)aSTR len:(int)len
{
	self = [[super alloc] initStr:aSTR len:len tag:0];
	return self;
}


+ str:(const char *)aSTR len:(int)len tag:(int)theTag
{
	self = [[super alloc] initStr:aSTR len:len tag:theTag];
	return self;
}


- init
{
	return [self initStr:"" tag:0];
}

- initStr:(const char *)aSTR tag:(int)theTag
{
	int	len;
	if(aSTR) len = strlen(aSTR); else len = 0;
	return [self initStr:aSTR len:len tag:theTag];
}

- initStr:(const char *)aSTR len:(int)len tag:(int)theTag
{
	[super init];
	if(aSTR == NULL) {
		aSTR = "initStr with NULL-pointer";
		len = strlen(aSTR);
	}
	tag = theTag;
	length = len;
	size = length+1;
	string = malloc(size);
	strncpy(string, aSTR,len);
	string[len] = (char)0;
	return self;
}

- free
{
	free(string);
	return [super free];
}

- copy
{
	return [[[self class] alloc] initStr:string tag:tag];
}

- (unsigned)length
{
	return length;
}

- (const char *)str
{
	return string;
}

- str:(const char *)aSTR
{
	length = strlen(aSTR);
	if(size < length+1) {
		free(string);
		size = length+1;
		string = malloc(size);
	}
	strcpy(string, aSTR);
	return self;
}

- (int)int
{
	return atoi(string);
}

- (long)long
{
	return atol(string);
}

- (double)double
{
	return atof(string);
}

- (char)charAt:(unsigned)anOffset
{
	if( (0<=anOffset) && (anOffset<=length) ) {
		return string[anOffset];
	} else {
		[self error:"char offset in charAt: out of bounds"];
		return (char)0;
	}
}

- (char)charAt:(unsigned)anOffset put:(char)aChar
{
	if( (0<=anOffset) && (anOffset<=length) ) {
		char	oldChar = string[anOffset];
		string[anOffset] = aChar;
		return oldChar;
	} else {
		[self error:"char offset in charAt:put: out of bounds"];
		return (char)0;
	}
}

- copyStrtok:(const char *)delimiters
{
	char	*tok, *s = malloc(size);
	id		result;
	
	strcpy(s,string);
	tok = strtok(s,delimiters);
	if(tok) {
		result = [[self class] str:tok];
	} else {
		result = nil;
	}
	tok = strtok(NULL,"");
	if(tok) {
		strcpy(string,tok);
	} else {
		string[0] = (char)0;
	}
	length = strlen(string);
	free(s);
	return result;
}

- concat:aString
{
	if(size <= (length + [aString length])) {
		char	*s;
		length += [aString length];
		size = length + 1;
		s = malloc(size);
		strcpy(s,string);
		strcat(s,[aString str]);
		free(string);
		string = s;
	} else {
		length += [aString length];
		strcat(string,[aString str]);
	}
	return self;
}

- concatSTR:(const char *)aSTR
{
	unsigned	cStringLen = strlen(aSTR);
	
	if(size <= (length + cStringLen)) {
		char	*s;
		length += cStringLen;
		size = length + 1;
		s = malloc(size);
		strcpy(s,string);
		strcat(s, aSTR);
		free(string);
		string = s;
	} else {
		length += cStringLen;
		strcat(string, aSTR);
	}
	return self;
}

- concatCHAR:(int)c
{
	if(size <= (length + 1)) {
		char	*s;
		size = length + 11;
		s = malloc(size);
		strcpy(s,string);
		s[length++] = (char)c;
		s[length] = (char)0;
		free(string);
		string = s;
	} else {
		string[length++] = (char)c;
		string[length] = (char)0;
	}
	return self;
}

- concatINT:(int)i
{
	char	s[20];
	sprintf(s,"%d",i);
	[self concatSTR:s];
	return self;
}

- concatDOUBLE:(double)d
{
	char	s[20];
	sprintf(s,"%lf",d);
	[self concatSTR:s];
	return self;
}

- (int)compareSTR:(const char *)aSTR
{
	return NXOrderStrings((const unsigned char *)string,
						  (const unsigned char *)aSTR,
						  NO, -1, NXDefaultStringOrderTable());
}

- (int)compare:aString
{
	return NXOrderStrings((const unsigned char *)string,
						  (const unsigned char *)[aString str],
						  NO, -1, NXDefaultStringOrderTable());
}

- (BOOL)isEqual:aString
{
	return NXOrderStrings((const unsigned char *)string,
						  (const unsigned char *)[aString str],
						  YES, -1, NXDefaultStringOrderTable()) == 0;
}

- (BOOL)isEqualSTR:(const char *)aSTR
{
	return NXOrderStrings((const unsigned char *)string,
						  (const unsigned char *)aSTR,
						  YES, -1, NXDefaultStringOrderTable()) == 0;
}

- writeIntoCell:aCell
{
	[aCell setStringValue:string];
	return self;
}

- writeIntoCell:aCell inColumn:(int)column
{
	[aCell setStringValue:string ofColumn:column];
	return self;
}

- readFromCell:aCell
{
	const char	*stringValue = [aCell stringValue];
	
	length = strlen(stringValue);
	
	if(size<=length) {
		free(string);
		size = length + 1;
		string = malloc(size);
	}
	strcpy(string,stringValue);
	return self;
}

- writeIntoText:aText
{
	[aText setText:string];
	return self;
}

- readFromText:aText
{
	length = [aText byteLength];
	
	if(size<=length) {
		free(string);
		size = length + 1;
		string = malloc(size);
	}
	[aText getSubstring:string start:0 length:length];
	string[length] = '\0';
	return self;
}


- writeRTFIntoText:aText
{
	NXStream *stream = NXOpenMemory(NULL,0,NX_READWRITE);
	[self writeIntoStream:stream];
	NXSeek(stream, 0, NX_FROMSTART);	
	[aText readRichText:stream];
	NXCloseMemory(stream, NX_FREEBUFFER);
	return self;
}

- readRTFFromText:aText
{
	NXStream *stream = NXOpenMemory(NULL, 0, NX_READWRITE);
	[aText writeRichText:stream];
	[self readFromStream:stream];
	NXCloseMemory(stream, NX_FREEBUFFER);
	return self;
}


- writeIntoStream:(NXStream *)stream
{
	NXWrite(stream,string,length);
	return self;
}

- readFromStream:(NXStream *)stream
{
	NXSeek(stream, 0, NX_FROMEND);
	length = NXTell(stream);
	NXSeek(stream, 0, NX_FROMSTART);	
	if(size<=length) {
		free(string);
		size = length + 1;
		string = malloc(size);
	}
	NXRead(stream, string, length);
	string[length] = '\0';
	return self;
}

- readHexFromStream:(NXStream *)stream
{
	char	buf[1000];
	BOOL	ready = NO;
	[self str:""];
	while(!ready) {
		int	i=0;
		while((i<sizeof(buf)-5) && !ready) {
			unsigned char	c;
			NXRead(stream, &c, 1);
			buf[i++] = c/16+'0';
			buf[i++] = c%16+'0';
			ready = NXAtEOS(stream);
		}
		buf[i] = (char)0;
		[self concatSTR:buf];
	}
	return self;
}

- writeHexToStream:(NXStream *)stream
{
	int	i = 0;
	while(i<length-1) {
		unsigned char c;
		c = (unsigned char)((string[i++]-'0')*16);
		c += (unsigned char)(string[i++]-'0');
		NXWrite(stream,&c,1);
	}
	return self;
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteTypes(stream,"ii",&length,&size);
	NXWriteArray(stream,"c",length,string);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadTypes(stream,"ii",&length,&size);
	string = NXZoneMalloc([self zone],size);
	NXReadArray(stream,"c",length,string);
	string[length] = (char)0;
	return self;
}

- (int)compareFirstCharWith:(char )aChar
{
	char x = [self charAt:0];
	if (x==aChar) {
		return 0;
	} else if (x<aChar) {
		return -1;
	} else {
		return 1;
	}
}
@end

