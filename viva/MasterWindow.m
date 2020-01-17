#import <appkit/Application.h>

#import "MasterWindow.h"

#pragma .h #import <appkit/Window.h>

@implementation MasterWindow:Window
{
}

- (BOOL)commandKey:(NXEvent *)theEvent
{
	BOOL	result = [super commandKey:theEvent];
	if (!result && ([NXApp keyWindow] == self)) {
		if (theEvent->data.key.charCode == 'a') {
			if ([self delegate] && [[self delegate] respondsTo:@selector(selectAll:)] ) {
				result = ([[self delegate] selectAll:self] != nil);
			}
		}
	}
	return result;
}

- sendEvent:(NXEvent *)theEvent
{

	if ( (theEvent->type == NX_KEYDOWN) && ([NXApp keyWindow] == self))  {
		switch(theEvent->data.key.charCode) {
			case 0xAD: 	if ([[self delegate] respondsTo:@selector(moveSelectionBy:)]) {
							[[self delegate] moveSelectionBy:-1];
							return self;
						} else {
							return [super sendEvent:theEvent];
						}
			case 0xAF: 	if ([[self delegate] respondsTo:@selector(moveSelectionBy:)]) {
							[[self delegate] moveSelectionBy:+1];
							return self;
							return self;
						} else {
							return [super sendEvent:theEvent];
						}
			case 0x0D:
			case 0x03:	if ([[self delegate] respondsTo:@selector(open:)]) {
							[[self delegate] open:self];
							return self;
						} else {
							return [super sendEvent:theEvent];
						}
			default: 	if ([[self delegate] respondsTo:@selector(selectCellWithBeginChar:)]) {
							[[self delegate] selectCellWithBeginChar:theEvent->data.key.charCode];
							return self;
						} else {
							return [super sendEvent:theEvent];
						}
		}
		return self;
	} else {
		return [super sendEvent:theEvent];
	}
}
	
@end

@interface Object(NewWindowDelegate)
- selectAll:sender;
- moveSelectionBy:(int)count;
- selectCellWithBeginChar:(char )aChar;
- open:sender;
@end
