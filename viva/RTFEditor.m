#import <libc.h>
#import <string.h>
#import <stdlib.h>

#import <objc/List.h>
#import <appkit/ScrollView.h>
#import <appkit/Text.h>
#import <appkit/Window.h>
#import <appkit/PrintInfo.h>
#import <appkit/NXBrowser.h>
#import <appkit/NXBrowserCell.h>
#import <appkit/Matrix.h>
#import <appkit/Font.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"
#import "dart/Localizer.h"

#import "cUtils.h"

#import "TheApp.h"
#import "DefaultsDatabase.h"
#import "TextFinder.h"
#import "FileItem.h"
#import "TextParser.h"
#import "ErrorManager.h"
#import "StringManager.h"
#import "MasterItemList.h"

#import "RTFEditor.h"

#pragma .h #import "MasterDocument.h"

@implementation RTFEditor:MasterDocument
{
	id		textView;
	id		finder;
	BOOL	findPanelWasVisible;
}

- initNib
{
	[super initNib];
	[[[NXApp printInfo] setHorizCentered:NO] setVertCentered:NO];
	[[[NXApp printInfo] setHorizPagination:NX_AUTOPAGINATION] setVertPagination:NX_AUTOPAGINATION];
	textView = [self textView];
	[textView setDelegate:self];
	finder = nil;
	findPanelWasVisible = NO;
	return self;
}

- free
{
	[finder free];
	return [super free];
}

- textView
{
	if ([textView isKindOf:[ScrollView class]]) {
		textView = [textView docView];
	}
	return textView;
}

- checkMenus
{
	[[NXApp printButton] setEnabled:YES];
	[[NXApp findButton] setEnabled:YES];
	return self;
}

- print:sender
{
	id		aMarg;
	const NXRect *aRect = [[NXApp printInfo] paperRect];
	NXRect	tFrame;
	NXCoord	topMargin, bottomMargin, leftMargin, rightMargin;
	NXCoord	tMargin, bMargin, lMargin, rMargin;

	aMarg = [[NXApp defaultsDB] valueForKey:"LeftMargin"];
	if (aMarg == nil) {
		leftMargin = 0.0;
	} else {
		leftMargin = [aMarg double];
	}
	aMarg = [[NXApp defaultsDB] valueForKey:"RightMargin"];
	if (aMarg == nil) {
		rightMargin = 0.0;
	} else {
		rightMargin = [aMarg double];
	}
	aMarg = [[NXApp defaultsDB] valueForKey:"TopMargin"];
	if (aMarg == nil) {
		topMargin = 0.0;
	} else {
		topMargin = [aMarg double];
	}
	aMarg = [[NXApp defaultsDB] valueForKey:"BottomMargin"];
	if (aMarg == nil) {
		bottomMargin = 0.0;
	} else {
		bottomMargin = [aMarg double];
	}
	
	[[[self textView] window] disableFlushWindow];
	[[NXApp printInfo] setMarginLeft:0 right:0 top:topMargin bottom:bottomMargin];
	[[self textView] getFrame:&tFrame];
	[[self textView] getMarginLeft:&lMargin right:&rMargin top:&tMargin bottom:&bMargin];
	[[self textView] sizeTo:aRect->size.width :tFrame.size.height];
	[[self textView] setMarginLeft:leftMargin right:rightMargin top:0 bottom:0];
	[[self textView] printPSCode:self];
	[[self textView] sizeTo:tFrame.size.width :tFrame.size.height];
	[[self textView] setMarginLeft:lMargin right:rMargin top:tMargin bottom:bMargin];
	[[[self textView] window] reenableFlushWindow];
	[[self textView] display];
	return self;
}

- find:sender
{
	if (!finder) {
		finder = [[[TextFinder alloc] init] setSearchMe:textView];
	}
	[finder makeActive:self];
	findPanelWasVisible = YES;
	return self;
}

	
/* ===== OTHER STUFF ================================================================= */
- (int)numOfProtectedCellsIn:searchMe
{
	return 0;
/*
	char		*textStart, *match;
	int			count, fnd=0;
	NXStream	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
	int			newStart = 0;
	char		text[64];
    
	[searchMe writeRichText:stream];
	strcpy(text,"dARTProtectedValue");
	NXSeek(stream, 0, NX_FROMEND);
	count = NXTell(stream);
	NXSeek(stream, 0, NX_FROMSTART);
	textStart = (char *)malloc(count + 1);
	NXRead(stream, textStart, count);
	*(textStart + count) = '\0';
	do {
		match = textInString(text, textStart+newStart, NO);
		if (match) {
			fnd++;
		}
		newStart = (match - textStart)+1;
	} while (match && (newStart > 1));
	free(textStart);
	NXCloseMemory(stream, NX_FREEBUFFER);
	return fnd;
*/
}

- close:sender
{
	[window orderOut:self];
	return [self free];
}

- (BOOL)acceptsItem:anItem
{ 
	return [anItem isKindOf:[FileItem class]] || ([anItem isSingle]); 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else if ([anItem isSingle]) {
		return [self parseAndPaste:anItem];
	} else {
		return nil;
	}
}

- parseAndPaste:anItem
{
	id	newParser  = [[TextParser alloc] init];
	id	newItem = [anItem copyLoadedFirstObject];
	if ((newItem != nil) && (newParser != nil)) {
		[newParser parseTextObject:[self textView] withItem:newItem];
		[window setDocEdited:YES];
	}
	if (newItem != nil) {
		[newItem free];
	}
	if (newParser != nil) {
		[newParser free];
	}
	return self;
}

- pasteFile:anItem
{
	NXStream	*stream;
	stream = NXOpenMemory(NULL,0,NX_READWRITE);
	if (stream) {
		NXPrintf(stream,"{{\\NeXTGraphic %s\n}\n¬}", [[anItem identity] str]);
		NXSeek(stream,0,NX_FROMSTART);
		[[self textView] replaceSelWithRichText:stream];
		NXCloseMemory(stream, NX_FREEBUFFER);
	}
	[window setDocEdited:YES];
	return self;
}
/* ===== WINDOW I/O STUFF =================================== */

- hideFindPanel
{
	if( finder ) {
		findPanelWasVisible = [finder isVisible];
		[finder orderOut:self];
	}
	return self;
}

- restoreFindPanel
{
	if( finder && findPanelWasVisible ) {
		[finder orderFront:self];
	}
	return self;
}

- windowDidBecomeMain:sender
{
	[self restoreFindPanel];
	return self;
}


- windowDidDeminiaturize:sender
{
	[super windowDidDeminiaturize:sender];
	[self restoreFindPanel];
	return self;
}


- windowDidMiniaturize:sender
{
	[self hideFindPanel];
	return self;
}


- windowDidResignMain:sender
{
	[self hideFindPanel];
	return self;
}

@end
