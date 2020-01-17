#import <stdlib.h>
#import <string.h>
#import <math.h>

#import <objc/objc-runtime.h>
#import <appkit/Text.h>
#import <appkit/Window.h>
#import <appkit/ScrollView.h>

#import "dart/debug.h"
#import "dart/dartlib.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/Localizer.h"

#import "cUtils.h"

#import "TheApp.h"
#import "StringManager.h"
#import "VariableHolder.h"

#import "TextParser.h"
#import "AParser.h"

#pragma .h #import <objc/Object.h>

@implementation TextParser:Object
{
	id	variables;
	id	varHolders;
	id	variableItem;
	id	newText;
}

- init
{
	id	queryString;
	id	result;

	[super init];
	[[NXApp localizer] loadLocalNib:"TextParser" owner:self];
	varHolders = [[List alloc] initCount:0];
	queryString = [QueryString str:"select key, value, isviva, protected, special from variablen"];
	result = [[NXApp defaultQuery] performQuery:queryString];
	if (result && ([[NXApp defaultQuery] lastError] == NOERROR)) {
		variables = result;
	} else {
		variables = nil;
		result = [result free];
	}
	newText = [newText docView];
	DEBUG7("TextParser inited\n");
	return self;
}

- free
{
	if (variables) {
		variables = [variables free];
	}
	if (varHolders) {
		varHolders = [[[varHolders freeObjects] empty] free];
	}

	return [super free];
}

- newText
{
	return newText;
}

- setVariableItem:anItem
{
	variableItem = anItem;
	return self;
}

- refresh
{
	if (varHolders != nil) {
		[[varHolders freeObjects] empty];
	} else {
		varHolders = [[List alloc] initCount:0];
	}
	return self;
}


- parseString:aString withItem:anItem
{
	DEBUG7("TextParser beginning to parse\n");
	[aString writeRTFIntoText:newText];
	[self parseTextObject:newText withItem:anItem];
	[newText setSel:0 :[newText textLength]];
	[aString readRTFFromText:newText];
	DEBUG7("TextParser finished parsing\n");
	return self;
}

- parseTextObject:aTextObject withItem:anItem
{
	int		varBegPos;
	int		varEndPos;
	int		startPos = 0;
	char	varName[130];
	BOOL	specialMode = NO;
	
	variableItem = anItem;
	[[aTextObject window] disableFlushWindow];
	if (variables) {
		while ( (startPos < MAXINT) && ((varBegPos = [self find:"«" inText:aTextObject beginAt:startPos]) != -1)){
			if ((varEndPos = [self find:"»" inText:aTextObject beginAt:varBegPos]) != -1) {
				int	lenOfVar = varEndPos - (varBegPos + 1);
				if (lenOfVar <= 128) {
					[aTextObject getSubstring:varName start:varBegPos+1 length:lenOfVar];
					varName[lenOfVar] = '\0';
					if ([self checkVar:varName andCreateItemForPos:varBegPos specialMode:specialMode] == 2) {
						if (specialMode) {
							specialMode = NO;
						} else {
							specialMode = YES;
						}
					}
						
				}
				startPos = varEndPos;
			} else {
				startPos = MAXINT;
			}
		}
	}
	[self pasteVariablesInto:aTextObject];
	[[aTextObject window] reenableFlushWindow];
	return self;
}

- pasteVariablesInto:aTextObject
{
	id		currVar;
	int		length;
	id		nextVar;
	char	*variable;
	BOOL	fin = NO;
	int		cc;
	id		aListItem;
	int 	i, count = [varHolders count];
	for (i=count-1; i>=0; i--) {
		currVar = [varHolders objectAt:i];
		length = [currVar positionInText] + [[currVar variablename] length] + 2;
		if ([currVar isSpecial] && ((nextVar = [varHolders objectAt:i-1])!=nil) && ([nextVar isSpecial])) {
			variable = malloc([[nextVar variablevalue] length]+1);
			strcpy(variable, (char *)([[nextVar variablevalue] str]+1));
			aListItem = [self parseVariable:variable inItem:variableItem finished:&fin movedChars:&cc special:YES];
			free(variable);
			if ([aListItem isKindOf:[List class]]) {
				[self pasteList:aListItem useAsFirstVar:nextVar andLast:currVar intoText:aTextObject];
			}
			[aListItem free];
			i--;
		} else {
			[aTextObject setSel:[currVar positionInText] :length];
			[self pasteVariable:currVar intoText:aTextObject];
		}
	}
	return self;
}


- pasteList:aListItem useAsFirstVar:fVar andLast:lVar intoText:aTextObject
{
	id			newParser;
	id			strObj = [String str:""];
	int			i, count = [aListItem count];
	NXStream	*rtfStream = NXOpenMemory(NULL, 0, NX_READWRITE);
	id			strToPaste = [String str:""];
	id			hold;
	NXStream	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);

	newParser = [[AParser alloc] init];
	[newParser setRequestObj:variableItem];
	[aTextObject writeRichText:rtfStream from:[fVar positionInText] + [[fVar variablename] length] + 2 
		to:[lVar positionInText]-1];
	[aTextObject setSel:[fVar positionInText] :[lVar positionInText] + [[lVar variablename] length] + 2];

	NXSeek(rtfStream, 0, NX_FROMSTART);
	[strObj readFromStream:rtfStream];
	hold = [strObj copy];
	for (i=0;i<count;i++) {
		id			anItem = [aListItem objectAt:i];
		if (anItem != nil) {
			if (i==0) {
				[newParser parseString:strObj withItem:anItem];
			} else {
				id	aText = [newParser newText];
				[newParser setVariableItem:anItem];
				[strObj writeRTFIntoText:aText];
				[newParser pasteVariablesInto:aText];
				[aText setSel:0 :[aText textLength]];
				[strObj readRTFFromText:aText];
			}
			[strToPaste concat:strObj];
			[strObj free];
			strObj = [hold copy];
		}
	}
	[hold free];
	hold = strToPaste;
	strToPaste = [String str:"{"];
	[strToPaste concat:hold];
	[strToPaste concatSTR:"}"];
	NXSeek(stream, 0, NX_FROMSTART);
	[strToPaste writeIntoStream:stream];
	NXSeek(stream, 0, NX_FROMSTART);
	[aTextObject replaceSelWithRichText:stream];
	NXCloseMemory(stream, NX_FREEBUFFER);
	NXCloseMemory(rtfStream, NX_FREEBUFFER);
	[strToPaste free];
	[hold free];
	[newParser free];
	[strObj free];
	return self;
	
}

- (SEL)getSelectorFor:(char *)aSELName andParamInto:(int *)anInt hasParam:(BOOL *)hasParam
{
	char *aPtr;
	
	if ((aPtr=strstr(aSELName, ":")) == NULL) {
		*hasParam = NO;
		*anInt = 0;
	} else {
		sscanf(aPtr+1,"%d",anInt);
		*hasParam = YES;
		(aPtr+1)[0] = '\0';
	}
	return sel_getUid(aSELName);
}

- parseVariable:(char *)aVariable inItem:anItem finished:(BOOL *)finished movedChars:(int *)cc special:(BOOL)flag
{
	char	*varClassName = malloc(strlen(aVariable)+1);
	char	*varSelector = malloc(strlen(aVariable)+1);
	char	*aptr;
	char 	*bPtr;
	id		finalValue=nil;
	
	strcpy(varClassName, aVariable);
	if ((aptr = strstr((char *)(aVariable+1), "@")) != NULL) {
		SEL		aSelector;
		BOOL	hasParam;
		int		intParam;
		bPtr = strstr(aptr+1,"@");
		if (bPtr != NULL) {
			strncpy0(varSelector, aptr+1, (bPtr - aptr));
		} else {
			strcpy(varSelector, aptr+1);
		}
		strcpy(varClassName, aVariable);
		aptr = strstr(varClassName, "@");
		aptr[0] = '\0';
		aSelector = [self getSelectorFor:varSelector andParamInto:&intParam hasParam:&hasParam];
		if (((strcmp([[anItem class] name], varClassName)==0) || (strcmp(varClassName,"*")==0)) &&
			[anItem respondsTo:aSelector]) {
			if (hasParam == YES) {
				finalValue = [anItem perform:aSelector with:(id)intParam];
			} else {
				finalValue = [anItem perform:aSelector];
			}
			if (strstr(varSelector,"copy") == NULL) {
				finalValue = [finalValue copy];
			}
			if (((![finalValue isKindOf:[String class]]) &&
				(![finalValue isKindOf:[Integer class]]) &&
				(![finalValue isKindOf:[Date class]]) &&
				(![finalValue isKindOf:[Double class]]) && !flag) || (flag && ![finalValue isKindOf:[List class]]) ) {
				if (bPtr == NULL) {
					[finalValue free];
					finalValue = nil;
					*finished = YES;
				}
			} else {
				*finished = YES;
			}
			
		}
		if (finalValue != nil) {
			*cc = (bPtr - aVariable + 1);
		}
	}
	free(varClassName);
	free(varSelector);
	return finalValue;
}


- pasteVariable:whichOne intoText:aTextObject
{
	id 			finalValue = nil;
	BOOL		isProtected = [whichOne isProtected];
	NXStream 	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
	BOOL		isViva = NO;
	if ([[whichOne variablevalue] length] > 0) {
		if ([[whichOne variablevalue] charAt:0] == '@') {
			char	*variable = malloc([[whichOne variablevalue] length]+1);
			char	*varPtr;
			BOOL	fin = NO;
			int		cc;
			finalValue = variableItem;
			strcpy(variable, (char *)([[whichOne variablevalue] str]+1));
			varPtr = variable;
			do {
				cc = 0;
				finalValue = [self parseVariable:varPtr inItem:finalValue finished:&fin movedChars:&cc special:NO];
				varPtr += cc;
			} while ((finalValue != nil) && (fin != YES));
			free(variable);
			isViva = YES;
		} else {
			finalValue = [[whichOne variablevalue] copy];
		}
		if ( (isProtected) || (isViva) ){
			NXStream	*rtfStream = NXOpenMemory(NULL, 0, NX_READWRITE);
			NXSelPt		start, end;
			char		c;

			[aTextObject getSel:&start :&end];
			[aTextObject writeRichText:rtfStream from:start.cp to:start.cp+1];

			NXSeek(rtfStream, 0, NX_FROMSTART);
			if (isProtected) {
				NXPrintf(stream,"{{\\dARTProtectedValue {");
			}
			while (!NXAtEOS(rtfStream)) {
				NXRead(rtfStream, &c, 1);
				if (c == '«') {
					NXPrintf(stream,"%s", [finalValue str]);
				} else {
					NXWrite(stream, &c, 1);
				}
			}
			if (isProtected) {
				NXPrintf(stream,"¬}}¬}");
			}
			NXCloseMemory(rtfStream, NX_FREEBUFFER);
		} else {
			[finalValue writeIntoStream:stream];
		}
		NXSeek(stream, 0, NX_FROMSTART);
		if (finalValue != nil) {
			[aTextObject replaceSelWithRichText:stream];
		}
		[finalValue free];
	}
	NXCloseMemory(stream, NX_FREEBUFFER);
	return self;
}

- (int)checkVar:(char *)aVar andCreateItemForPos:(int)varBegPos specialMode:(BOOL)specialMode
{
	int			retVal = 1;
	int 		i, count= [variables count];
	BOOL		found = NO;
	const char	*varPtr = [[NXApp stringMgr] stringForVariableKey:aVar];
	for (i=0;(i<count) && !found;i++) {
		id	aVarId = [[variables objectAt:i] objectAt:0];
		if ([aVarId compareSTR:varPtr] == 0) {
			if ((specialMode && [[[variables objectAt:i] objectAt:4] isEqualInt:2]) ||
			    (!specialMode && ![[[variables objectAt:i] objectAt:4] isEqualInt:2]) ) {
				id	newVarHolder = [[VariableHolder alloc] 
										initForVariablename:varPtr 
										positionInText:varBegPos
										isProtected:[[[variables objectAt:i] objectAt:3] isEqualInt:1]
										isSpecial:![[[variables objectAt:i] objectAt:4] isEqualInt:0]
										andValue:[[variables objectAt:i] objectAt:1]];
				[varHolders addObject:newVarHolder];
				found = YES;
				if (![[[variables objectAt:i] objectAt:4] isEqualInt:0]) {
					retVal = 2;
				} else {
					retVal = 1;
				}
			}
		}
	}
	return retVal;
}


- (int)find:(char *)what inText:searchMe beginAt:(int)start
{
	char	*text, *textStart, *match;
	int		count, newStart;
	NXStream	*stream;
    
	text = what;
	stream = [searchMe stream];
	if (!stream) {
		DEBUG7("TextParser:find:stream is nil\n");
		return -1;
	}
	NXSeek(stream, 0, NX_FROMEND);
	count = NXTell(stream);
	NXSeek(stream, 0, NX_FROMSTART);
	textStart = (char *)malloc(count + 1);
	NXRead(stream, textStart, count);
	*(textStart + count) = '\0';
	match = textInString(text, textStart+start, NO);
	newStart = match - textStart;
	free(textStart);
	if (!match) {
		DEBUG7("TextParser:find does not match\n");
		return -1;
	}
	
	return newStart;
}

@end
