#import "dart/String.h"

#import "VariableHolder.h"

#pragma .h #import <objc/Object.h>

@implementation VariableHolder:Object
{
	id		variablename;
	int		positionInText;
	id		variablevalue;
	BOOL	isProtected;
	BOOL	isSpecial;
}


- initForVariablename:(const char *)varname positionInText:(int)position isProtected:(BOOL)flag isSpecial:(BOOL)specFlag andValue:aValue 
{
	[super init];
	variablename = [String str:varname];
	positionInText = position;
	isProtected = flag;
	variablevalue = [aValue copy];
	isSpecial = specFlag;
	return self;
}

- free
{
	if (variablename) {
		variablename = [variablename free];
	}
	if (variablevalue) {
		variablevalue = [variablevalue free];
	}
	return [super free];
}
	
- setVariablename:(const char *)varname forPositionInText:(int)position
{
	if (variablename) {
		variablename = [variablename free];
	}
	variablename = [String str:varname];
	positionInText = position;
	return self;
}

- setPositionInText:(int)position
{ positionInText = position; return self; }
	
- (int)compareSTR:(const char *)aCString
{
	if (variablename) {
		return [variablename compareSTR:aCString];
	} else {
		return 0;
	}
}

- (const char *)variablenameSTR { return [variablename str]; }
- variablename { return variablename; }
- (int)positionInText { return positionInText; }
- variablevalue { return variablevalue; }
- (BOOL)isProtected { return isProtected; }
- (BOOL)isSpecial { return isSpecial; }

@end
