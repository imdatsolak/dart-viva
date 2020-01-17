#import <stdio.h>
#import <stdlib.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"

#pragma .h #import "dart/FieldValue.h"

@implementation Integer:FieldValue
{
	int		myInt;
	char	*myStr;
}

+ int:(int)anInt
{
	self = [[super alloc] initInt:anInt tag:0];
	return self;
}

+ int:(int)anInt tag:(int)theTag
{
	self = [[super alloc] initInt:anInt tag:theTag];
	return self;
}

- init
{
	[super init];
	tag = 0;
	myInt = 0;
	return self;
}

- initInt:(int)anInt
{
	[super init];
	myInt = anInt;
	return self;
}

- initInt:(int)anInt tag:(int)theTag
{
	[super init];
	tag = theTag;
	myInt = anInt;
	return self;
}

- free
{
	if(myStr) free(myStr);
	return [super free];
}

- copy
{
	id	theCopy = [super copy];
	myStr = NULL;
	return theCopy;
}

- (int)int
{
	return myInt;
}

- setInt:(int)anInt
{
	myInt = anInt;
	return self;
}

- (BOOL)isTrue
{
	return myInt;
}

- (BOOL)isFalse
{
	return !myInt;
}

- setTrue
{
	return [self setInt:YES];
}

- setFalse
{
	return [self setInt:NO];
}

- copyAsString
{
	return [String str:[self str]];
}

- (const char *)str
{
	if(!myStr) {
		myStr = malloc(13);
	}
	sprintf(myStr,"%d",myInt);
	return myStr;
}

- (long)long
{
	return (long)myInt;
}

- (double)double
{
	return (double)myInt;
}

- countMe:sender
{
	myInt++;
	return self;
}


- increment
{
	myInt++;
	return self;
}


- decrement
{
	myInt--;
	return self;
}


- addInt:(int)anInt
{
	myInt += anInt;
	return self;
}


- subInt:(int)anInt
{
	myInt -= anInt;
	return self;
}


- multInt:(int)anInt
{
	myInt *= anInt;
	return self;
}


- divInt:(int)anInt
{
	myInt /= anInt;
	return self;
}

- (int)compareInt:(int)anInt
{
	if(myInt == anInt) {
		return 0;
	} else if(myInt < anInt) {
		return -1;
	} else {
		return 1;
	};
}

- (int)compare:anInteger
{
	return [self compareInt:[anInteger int]];
}

- (int)compareSTR:(const char *)STR
{
	return [self compareInt:atoi(STR)];
}

- (BOOL)isEqual:anInteger
{
	return myInt == [anInteger int];
}

- (BOOL)isEqualInt:(int)anInt
{
	return myInt == anInt;
}

- writeIntoCell:aCell
{
	[aCell setIntValue:myInt];
	return self;
}

- writeIntoCell:aCell inColumn:(int)column
{
	[aCell setIntValue:myInt ofColumn:column];
	return self;
}

- readFromCell:aCell
{
	myInt = [aCell intValue];
	return self;
}

- writeIntoStream:(NXStream *)stream
{
	NXPrintf(stream,"%d", [self int]);
	return self;
}

- write:(NXTypedStream *)stream
{
	[super write:stream];
	NXWriteTypes(stream,"i",&myInt);
	return self;
}

- read:(NXTypedStream *)stream
{
	[super read:stream];
	NXReadTypes(stream,"i",&myInt);
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

