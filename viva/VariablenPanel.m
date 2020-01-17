#import <stdio.h>
#import <string.h>

#import <objc/HashTable.h>
#import <appkit/Font.h>
#import <appkit/NXBrowser.h>
#import <appkit/NXBrowserCell.h>
#import <appkit/Matrix.h>
#import <appkit/TextFieldCell.h>
#import <appkit/TextField.h>
#import <appkit/Text.h>
#import <appkit/Window.h>

#import "dart/debug.h"
#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"
#import "TheApp.h"
#import "StringManager.h"
#import "UserManager.h"

#import "VariablenManager.h"
#import "VariablenPanel.h"

#pragma .h #import "MasterDocument.h"

#define TBS_SHOWALL	1
#define TBS_SHOWOWN	2
#define TBS_SHOWSYS	3

@implementation VariablenPanel:MasterDocument
{
	id		variableBrowser;
	id		variables;
	BOOL	expansionMode;
	int		displayState;
}

+ (BOOL)canHaveMultipleInstances
{
	return NO;
}

- itemClass
{
	return [self class];
}

- setReadOnly
{ return self; }

- init
{
	NXRect	aFrame;
	[super init];
	[NXApp registerDocument:self];
	[variableBrowser setDelegate:self];
	[[variableBrowser setTarget:self] setDoubleAction:@selector(variableBrowserClicked:)];
	[[[variableBrowser allowMultiSel:NO] setTitled:NO] setLastColumn:0];
	[self loadAllVariables];
	[[window contentView] getFrame:&aFrame];
	maxSize.width = aFrame.size.width * 1.5;
	maxSize.height = 832;
	minSize.width = aFrame.size.width;
	minSize.height = aFrame.size.height;
	[variableBrowser loadColumnZero];
	[window orderFront:self];
	expansionMode = YES;
	displayState = TBS_SHOWALL;
	return self;
}

- free
{
	[NXApp unregisterDocument:self];
	return [super free];
}

- checkMenus
{ return self; }

- (BOOL)acceptsItem:anItem
{ return NO; }

- close:sender
{
	[window orderOut:self];
	return [self free];
}

- windowDidBecomeKey:sender
{ return self; }

- windowWillClose:sender
{
	[window setDelegate:nil];
	[self free];
	return (id )YES;
}


/* ===== BROWSER READ/WRITE METHODS ===== */
- loadAllVariables
{
	int row, count;
	id	result;
	id	queryString = [QueryString str:"select key, value, isviva from variablen"];
	if (displayState == TBS_SHOWOWN) {
		[queryString concatSTR:" where userid = "];
		[queryString concatField:[[NXApp userMgr] currentUserID]];
		[queryString concatSTR:" and isviva = 0"];
	} else if (displayState == TBS_SHOWSYS) {
		[queryString concatSTR:" where isviva = 1"];
	} else {
		[queryString concatSTR:" where userid = "];
		[queryString concatField:[[NXApp userMgr] currentUserID]];
		[queryString concatSTR:" or isviva = 1"];
	}
	result = [[NXApp defaultQuery] performQuery:queryString];
	if (result && ([[NXApp defaultQuery] lastError] == NOERROR)) {
		variables = result;
		[variables sort];
		count = [variables count];
		for (row=0;row<count;row++) {
			if ([[[variables objectAt:row] objectAt:2] isEqualInt:1]) {
				id 			theKey = [[variables objectAt:row] objectAt:0];
				const void 	*key, *value;
				id			table = [[NXApp stringMgr] variableStringTable];
				NXHashState state = [table initState];
				BOOL		found=NO;
				DEBUG2("LoadVariables:isViva:YES\n");
				while ([table nextState:&state key:&key value:&value] && !found) {
					DEBUG2("\tcurrent key=%s value=%s\n",(const char *)key, (const char *)value);
					if ([theKey compareSTR:(const char *)value]==0) {
						found = YES;
						[theKey str:(const char *)key];
					}
				}
			}
		}
	} else {
		variables = nil;
		result = [result free];
	}
	return self;
}


- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{ return [variables count]; }


- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{ 
	[[[variables objectAt:row] objectAt:0] writeIntoCell:cell];
	[cell setLeaf:YES];
	[cell setLoaded:YES];
	if (![[[variables objectAt:row] objectAt:2] isEqualInt:1]) {
		[cell setFont:[Font newFont:"Helvetica-Bold" size:12.0]];
	}
	[cell setTag:row];
	return self;
}

- variableBrowserClicked:sender
{
	id		mainWindow = [NXApp mainWindow];
	id		theField = [mainWindow firstResponder];
	id		textView;
	char	aKey[1024];
	int		row = [[sender matrixInColumn:0] selectedRow];
	id		key = [[variables objectAt:row] objectAt:0];
	id		value = [[variables objectAt:row] objectAt:1];

	if ([theField isKindOf:[Text class]]) {
		textView = theField;
	} else if (([theField isKindOf:[TextFieldCell class]]) || ([theField isKindOf:[TextField class]])) {
		textView = [theField currentEditor];
	} else {
		return self;
	}
	if (!expansionMode || [[[variables objectAt:row] objectAt:2] isEqualInt:1]) {
		sprintf(aKey,"«%s»",[key str]);
		[textView replaceSel:aKey];
	} else {
		NXStream 	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
		NXWrite(stream, [value str], [value length]);
		NXSeek(stream, 0, NX_FROMSTART);
		[textView replaceSelWithRichText:stream];
		NXCloseMemory(stream, NX_FREEBUFFER);
	}
	[mainWindow makeKeyAndOrderFront:self];
	return self;
}

- showSystemOnly:sender
{
	displayState = TBS_SHOWSYS;
	[self loadAllVariables];
	[variableBrowser loadColumnZero];
	return self;
}

- showOwnOnly:sender
{
	displayState = TBS_SHOWOWN;
	[self loadAllVariables];
	[variableBrowser loadColumnZero];
	return self;
}

- showAll:sender
{
	displayState = TBS_SHOWALL;
	[self loadAllVariables];
	[variableBrowser loadColumnZero];
	return self;
}

- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[VariablenManager class] name])) {
		[self loadAllVariables];
		[variableBrowser loadColumnZero];
	}
	return self;
}

@end
