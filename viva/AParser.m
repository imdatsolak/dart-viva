#import <stdlib.h>
#import <string.h>

#import <appkit/Text.h>

#import "dart/debug.h"
#import "dart/dartlib.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "VariableHolder.h"
#import "AuftragItem.h"

#import "AParser.h"

#pragma .h #import "TextParser.h"

@implementation AParser:TextParser
{
	id	requestObj;
}

- setRequestObj:anObject
{
	requestObj = anObject;
	return self;
}

- pasteVariable:whichOne intoText:aTextObject
{
	id 			finalValue = nil;
	BOOL		isProtected = [whichOne isProtected];
	NXStream 	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
	BOOL		isViva = NO;
	id			varVal = [whichOne variablevalue];
	BOOL		mwstVar=NO, vkVar=NO, rabattVar = NO, copyBruttoVar= NO;
	
	mwstVar = (strstr([varVal str],"mwst") != NULL);
	vkVar = (strstr([varVal str],"vk") != NULL);
	rabattVar = (strstr([varVal str],"rabatt") != NULL);
	copyBruttoVar = (strstr([varVal str],"copyBruttoPreis") != NULL);
	
	if ((requestObj == nil) || (!mwstVar && !vkVar && !rabattVar && !copyBruttoVar)) {
		return [super pasteVariable:whichOne intoText:aTextObject];
	}
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
			if (mwstVar && (
				(([requestObj respondsTo:@selector(mwstberechnen)]) && ([[requestObj mwstberechnen] int]==0)) || 
				(([requestObj respondsTo:@selector(nurgesamtpreis)]) && ([[requestObj nurgesamtpreis] int]==1))) ) {
				NXPrintf(stream, " ");
			} else if ((vkVar || rabattVar || copyBruttoVar) && 
						(([requestObj respondsTo:@selector(nurgesamtpreis)]) && 
						 ([[requestObj nurgesamtpreis] int]==1)) ) {
				NXPrintf(stream, " ");
			} else {
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
			}
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

@end
