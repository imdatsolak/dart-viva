#import <stdlib.h>
#import <string.h>

#import <appkit/ScrollView.h>
#import <appkit/Button.h>
#import <appkit/Text.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>
#import <appkit/NXBrowserCell.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "PictCell.h"
#import "UserManager.h"
#import "FileItem.h"
#import "VariablenManager.h"

#pragma .h #import "MasterDocument.h"

@implementation VariablenManager:MasterDocument
{
	id	keyBrowser;
	id	keyField;
	id	valueField;
	id	okButton;
	id	deleteButton;
	id	variablen;
	int	selectedRow;
}

+ (BOOL)canHaveMultipleInstances
{ return NO; }

- itemClass
{ return [self class]; }

- init
{
	[super init];
	if(![self loadVariables]) {
		return [self free];
	}
	valueField = [valueField docView];
	[keyField setNextText:valueField];
	[valueField setDelegate:self];
	selectedRow = -1;
	[deleteButton setEnabled:NO];
	[Text registerDirective:"NeXTGraphic" forClass:[PictCell class]];
	return self;
}

- free
{
	if (variablen) {
		variablen = [variablen free];
	}
	return [super free];
}


- (BOOL)loadVariables
{
	id	queryString;
	id	result;
	
	if (variablen) {
		variablen = [variablen free];
	}
	queryString = [QueryString str:"select key, value from variablen where userid ="];
	[queryString concatField:[[NXApp userMgr] currentUserID]];
	[queryString concatSTR:" and isviva=0"];
	result = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	if (result && ([[NXApp defaultQuery] lastError] == NOERROR)) {
		variablen = result;
		[variablen sort];
	} else {
		[result free];
		[NXApp beep:"CouldNotAccesAnyVariables"];
		return NO;
	}
	[[[keyBrowser setDelegate:self] setTarget:self] setAction:@selector(browserClicked:)];
	[keyBrowser loadColumnZero];
	return YES;
}

- saveVariables
{
	BOOL	isOk = YES;
	id	queryString = [QueryString str:"delete from variablen where userid="];
	[queryString concatField:[[NXApp userMgr] currentUserID]];
	[queryString concatSTR:" and isviva=0"];
	
	[[NXApp defaultQuery] beginTransaction];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	queryString = [queryString free];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		int 	i, count = [variablen count];
		for (i=0;(i<count)&& isOk;i++) {
			queryString = [QueryString str:"insert into variablen values("];
			[queryString concatFieldComma:[[variablen objectAt:i] objectAt:0]];
			[queryString concatFieldComma:[[variablen objectAt:i] objectAt:1]];
			[queryString concatSTR:"0,0,0,"];
			[queryString concatField:[[NXApp userMgr] currentUserID]];
			[queryString concatSTR:")"];
			[queryString translateRTF];
			[[[NXApp defaultQuery] performQuery:queryString] free];
			[queryString free];
			if ([[NXApp defaultQuery] lastError] != NOERROR) {
				isOk = NO;
			}
		}
	} else {
		isOk = NO;
	}
	if (!isOk) {
		[[NXApp defaultQuery] rollbackTransaction];
		return nil;
	} else {
		[[NXApp defaultQuery] commitTransaction];
		return self;
	}
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{ return [variablen count]; }


- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{ 
	[[[variablen objectAt:row] objectAt:0] writeIntoCell:cell];
	[cell setLeaf:YES];
	[cell setLoaded:YES];
	return self;
}

- browserClicked:sender
{
	int row = [[sender matrixInColumn:0] selectedRow];
	if (selectedRow >= 0) {
		[self checkAndAddEntry];
	}
	[window disableFlushWindow];
	[[[variablen objectAt:row] objectAt:0] writeIntoCell:keyField];
	[[[variablen objectAt:row] objectAt:1] writeRTFIntoText:valueField];
	[window reenableFlushWindow];
	[window display];
	selectedRow = row;
	[deleteButton setEnabled:(selectedRow >= 0)];
	[keyField selectText:self];
	return self;
}

- (BOOL)save
{
	[self okButtonClicked:self];
	if ([self saveVariables]) {
		id	fake = [String str:""];
		[window setDocEdited:NO];
		[self sendChanged:fake];
		[fake free];
		return YES;
	}
	return NO;
}

- (BOOL) revertToSaved
{ 
	[self loadVariables];
	[window setDocEdited:NO];
	return YES; 
}

- checkAndAddEntry
{
	id		newKey = [[String str:""] readFromCell:keyField];
	id		newValue = [[String str:""] readRTFFromText:valueField];
	BOOL	found = NO;
	int 	foundPos=-1, i, count = [variablen count];
	for (i=0;(i<count) && !found;i++) {
		if ([[[variablen objectAt:i] objectAt:0] compare:newKey] == 0) {
			found = YES;
			foundPos = i;
		}
	}
	if (found) {
		[[[variablen objectAt:foundPos] replaceObjectAt:1 with:newValue] free];
		[newKey free];
	} else if ([newKey length] && ([newKey charAt:0] != ' ')) {
		id newRow = [[QueryResultRow alloc] initCount:2];
		[newRow addObject:newKey];
		[newRow addObject:newValue];
		[variablen addObject:newRow];
		selectedRow = [[keyBrowser matrixInColumn:0] cellCount];
		[window setDocEdited:YES];
	}
	return self;
}


- okButtonClicked:sender
{
	[self checkAndAddEntry];
	[keyBrowser loadColumnZero];
	[[keyBrowser matrixInColumn:0] selectCellAt:selectedRow :0];
	return self;
}

- deleteButtonClicked:sender
{ 
	if (selectedRow>= 0) {
		[[[variablen removeObjectAt:selectedRow] freeObjects] free];
		selectedRow = -1;
		[keyBrowser loadColumnZero];
		[[keyBrowser matrixInColumn:0] selectCellAt:selectedRow :0];
		[window setDocEdited:YES];
	}
	return self; 
}


- checkMenus
{
	[[NXApp saveButton] setEnabled:YES];
	[[NXApp revertButton] setEnabled:[window isDocEdited]];
	[[NXApp findButton] setEnabled:NO];
	return self;
}


- textDidGetKeys:sender isEmpty:(BOOL)flag
{
	[super textDidGetKeys:sender isEmpty:flag];
	if (sender != valueField) {
		id		newKey = [[String str:""] readFromCell:keyField];
		BOOL	found = NO;
		int 	foundPos=-1, i, count = [variablen count];
	
		for (i=0;(i<count) && !found;i++) {
			if ([[[variablen objectAt:i] objectAt:0] compare:newKey] == 0) {
				found = YES;
				foundPos = i;
			}
		}
		[newKey free];
		if (!found) {
			[[keyBrowser matrixInColumn:0] selectCellAt:-1 :-1];
			selectedRow = -1;
			[deleteButton setEnabled:NO];
		} else {
			[[keyBrowser matrixInColumn:0] selectCellAt:foundPos :0];
			[window disableFlushWindow];
			[[[variablen objectAt:foundPos] objectAt:1] writeRTFIntoText:valueField];
			[window reenableFlushWindow];
			[window display];
			selectedRow = foundPos;
			[deleteButton setEnabled:(selectedRow >= 0)];
		}
	}
	return self;
}

- (BOOL)acceptsItem:anItem
{ 
	return [anItem isKindOf:[FileItem class]]; 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else {
		return nil;
	}
}

- pasteFile:anItem
{
	NXStream	*stream;
	stream = NXOpenMemory(NULL,0,NX_READWRITE);
	if (stream) {
		NXPrintf(stream,"{{\\NeXTGraphic %s\n}\n¬}", [[anItem identity] str]);
		NXSeek(stream,0,NX_FROMSTART);
		[valueField replaceSelWithRichText:stream];
		NXCloseMemory(stream, NX_FREEBUFFER);
	}
	[window setDocEdited:YES];
	return self;
}


@end
#if 0
BEGIN TABLE DEFS

create table variablen
( 
	key varchar(40), 
	value text,
	isviva int,
	protected	int,
	special	int,
	userid	int
)
go
create unique clustered index varindex on variablen(userid,key)
create index variablenindex2 on variablen(userid,isviva)
go


END TABLE DEFS
#endif
