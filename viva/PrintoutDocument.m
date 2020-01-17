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

#import "dart/fieldvaluekit.h"
#import "dart/Localizer.h"

#import "TheApp.h"
#import "ErrorManager.h"
#import "StringManager.h"
#import "PrintRTFItem.h"

#import "PrintoutDocument.h"

#pragma .h #import "RTFEditor.h"

@implementation PrintoutDocument:RTFEditor
{
	int	numberOfCells;
}

- initItem:anItem
{
	[super initItem:anItem];
	iamNew = NO;
	return self;
}

- createNewItem
{
	return [self doesNotRecognize:_cmd];
}

- createIdentityItem:identity
{ 
	return [self doesNotRecognize:_cmd];
}

- setWindowTitle
{
	id	aString = [String str:""];
	
	[aString concat:[item description]];
	[aString concatSTR:" Ð "];
	[aString concat:[item supplDescription]];
	if(iamReadOnly) {
		[aString concatSTR:[[NXApp stringMgr] stringFor:"READONLY"]];
	}
	[window setTitle:[aString str]];
	[aString free];
	
	return self;
}

- resetIconButton
{
	return self;
}

- setReadOnly
{
	[[self textView] setEditable:NO];
	return self;
}

- writeIntoWindow
{
	[[item data] writeRTFIntoText:[self textView]];
	numberOfCells = [self numOfProtectedCellsIn:[self textView]];

	return self;
}

- readFromWindow
{
	[[item data] readRTFFromText:[self textView]];
	return self;
}

- (BOOL)save
{
	if (numberOfCells != [self numOfProtectedCellsIn:[self textView]]) {
		[NXApp beep:"YouCannotDeleteProtectedCells"];
		[self reloadItem];
		return NO;
	} else {
		return [super save];
	}
}

- print:sender
{
	if (numberOfCells != [self numOfProtectedCellsIn:[self textView]]) {
		[NXApp beep:"YouCannotDeleteProtectedCells"];
		[self reloadItem];
		return self;
	} else {
		return [super print:sender];
	}
}

- (BOOL)reloadItem
{
	[item reloadData];

	[self updateWindow];
	[self setWindowTitle];
	[self resetIconButton];
	[window setDocEdited:NO];
	return YES;
}

@end
