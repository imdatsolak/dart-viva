#import <libc.h>
#import <strings.h>
#import <appkit/publicWraps.h>
#import <streams/streams.h>
#import <appkit/Form.h>
#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/Text.h>
#import <appkit/Window.h>

#import "dart/Localizer.h"
#import "TheApp.h"

#import "cUtils.h"
#import "TextFinder.h"

#pragma .h #import <objc/Object.h>
#pragma .h #define TEXT 0
#pragma .h #define MATRIX 1
#pragma .h #define FORWARD 1
#pragma .h #define BACKWARD -1

@implementation TextFinder:Object
{
	id		findPanel;
	id		findForm;
	id		ignoreCaseButton;
	id		findNextButton;
	id		searchMe;
	BOOL	ignoreCase;
}

- init
{
	[super init];
	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	return self;
}

- free
{
	[findPanel orderOut:self];
	return [super free];
}

- setSearchMe:object
{
	searchMe = object;
	return self;
}

- makeActive:sender
{
	[findPanel makeKeyAndOrderFront:NULL];
	[findForm selectTextAt:0];
	return self;
}

- findNextReturn:sender
{
	[findNextButton performClick:NULL];
	[findPanel orderOut:NULL];
	return self;
}

- findNext:sender
{
	const char *findStr =  [findForm stringValueAt:0];
	if (!strlen(findStr) || !searchMe) {
		NXBeep();
		return self;
	}
	ignoreCase = [ignoreCaseButton state];

	[self findInText:FORWARD];
	return self;
}

- findPrevious:sender
{
	const char *findStr =  [findForm stringValueAt:0];

	if (!strlen(findStr) || !searchMe) {
		NXBeep();
		return self;
	}
	[self findInText:BACKWARD];
	return self;
}

- findInText:(int)direction
{
	char	*text, *textStart, *match;
	NXSelPt	start, end;
	int		count, newStart;
	NXStream	*stream;
    
	text = (char *)[findForm stringValueAt:0];

	[searchMe getSel:&start :&end];
	if (start.cp == end.cp) start.cp = end.cp = 0;

	stream = [searchMe stream];
	if (!stream) {
		NXBeep();
		return self;
	}

	NXSeek(stream, 0, NX_FROMEND);
	count = NXTell(stream);
	NXSeek(stream, 0, NX_FROMSTART);
	textStart = (char *)malloc(count + 1);
	NXRead(stream, textStart, count);
	*(textStart + count) = '\0';
	
	if (direction == FORWARD)
		match = textInString(text, textStart + end.cp, ignoreCase);
	else
		match = textInStringReverse(text, textStart + start.cp + strlen(text) - 1,
				textStart, ignoreCase);
				
	if (!match) {
		if (direction == FORWARD)
			match = textInString(text, textStart, ignoreCase);
		else
			match = textInStringReverse(text, textStart + strlen(textStart), textStart, ignoreCase);
	}

	newStart = match - textStart;
	free(textStart);
	if (!match || (newStart == start.cp && (end.cp - start.cp) == strlen(text))) {
		NXBeep();
		return self;
	}

	[[searchMe setSel:newStart :newStart + strlen(text)]
    							scrollSelToVisible];
    
	return self;
}

- orderFront:sender
{ [findPanel makeKeyAndOrderFront:NULL]; return self; }

- orderOut:sender
{ [findPanel orderOut:sender]; return self; }

- (BOOL)isVisible
{ return [findPanel isVisible]; }

@end
