#import <string.h>
#import <appkit/SavePanel.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>

#import "dart/PaletteView.h"
#import "dart/NiftyMatrix.h"
#import "dart/HeadButton.h"
#import "dart/Localizer.h"
#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "Timer.h"
#import "UserManager.h"
#import "ImageManager.h"
#import "StringManager.h"
#import "TheApp.h"
#import "MasterDocument.h"

#import "SlaveSelector.h"

#define Master_Identity		32000

#pragma .h #import <appkit/graphics.h>
#pragma .h #import "MasterObject.h"

@implementation SlaveSelector:MasterObject
{
    id			countField;
    id			browser;
    id			countSelectedField;
    id			headButton;
    id			browserGroupBox;

	id			theEntryList;
	id			selectedRows;
	
	id			identity;
	id			owner;
	int			tmpCount;
	NXSize		minSize;
	float		maxWidth;
	float		browserInsideOffset;
	NXStream	*exportStream;
	id			theTimer;
	int			currentSortTag;
	BOOL		iamReadOnly;
}

+ (BOOL)canHaveMultipleInstances
{
	return YES;
}

- initForWindow:aWindow browser:aBrowser headButton:aHeadButton iconButton:anIconButton countField:aCountField countSelectedField:aCountSelectedField anIdentity:anIdentity andOwner:anObject
{
	window = aWindow;
	browser = aBrowser;
	countField = aCountField;
	countSelectedField = aCountSelectedField;
	headButton = aHeadButton;
	iconButton = anIconButton;
	return [self initForIdentity:anIdentity andOwner:anObject];
}

- initForIdentity:anIdentity andOwner:anObject
{
	NXRect	aFrame;
	
	[super init];
	
	owner = anObject;
	identity = [anIdentity copy];
	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	[browser setTarget:self];
	[browser setDelegate:self];
	[browser setAction:@selector(browserClicked:)];
	[browser setDoubleAction:@selector(browserDoubleClicked:)];
	[browser setCellClass:[ColumnBrowserCell class]];
	[browser acceptArrowKeys:YES];
	[browser allowBranchSel:NO];
	[[[browser allowMultiSel:YES] setTitled:NO] setLastColumn:0];
	
	[headButton setTarget:self];
	[headButton setAction:@selector(headButtonClicked:)];
	
	[[window contentView] getFrame:&aFrame];
	browserInsideOffset = aFrame.size.width;
	[browser getFrame:&aFrame ofInsideOfColumn:0];
	browserInsideOffset -= aFrame.size.width-17.5;

	[[window contentView] getFrame:&aFrame];
	minSize.width = aFrame.size.width;
	minSize.height = aFrame.size.height;
	
	[[iconButton setDoubleTarget:self] setDoubleAction:@selector(open:)];

	selectedRows = nil;
	currentSortTag = 1;
	iamReadOnly = NO;
	return self;
}


- free
{
	identity = [identity free];
	theEntryList = [theEntryList free];
	selectedRows = [selectedRows free];
	return [super free];
}


- documentClass
{
	return [self subclassResponsibility:_cmd];
}


- itemClass
{
	return [self subclassResponsibility:_cmd];
}


- itemListClass
{
	return [self subclassResponsibility:_cmd];
}

- (BOOL)needsOwnTitle
{ return NO; }

- setWindowTitle
{
	if ([self needsOwnTitle]) {
		id	aString = [String str:""];
		[[aString concat:identity] concatSTR:" Ð "];
		[aString concatSTR:[[NXApp stringMgr] windowTitleFor:[self name]]];
		
		if(iamReadOnly) {
			[aString concatSTR:[[NXApp stringMgr] stringFor:"READONLY"]];
		}
		[window setTitle:[aString str]];
		[aString free];
	}
	return self;
}

- makeActive:sender
{
	[self updateBrowserWithCurrentSelection];
	return self;
}

- selectAll:sender
{
	[[browser matrixInColumn:0] selectAll:sender];
	[self browserClicked:browser];
	return self;
}

- updateAll
{
	[self updateBrowserWithCurrentSelection];
	return self;
}


/* MasterSelector's own methods */
- copyObjectAtRow:(int)row
{
	id	anIdentity = [self copyObjectIdentityAtRow:row];
	id	copiedItem = [[[self itemClass] alloc] initIdentity:anIdentity];
	[anIdentity free];
	return copiedItem;
}

- copyObjectIdentityAtRow:(int)row
{ return [[self objectIdentityAtRow:row] copy]; }

- objectIdentityAtRow:(int)row
{ return [self subclassResponsibility:_cmd]; }


- (const char *)titleForColumn:(int)column
{
	return [theEntryList titleOfColumn:column];
}


- getLength:(int *)length alignment:(int *)alignment numeric:(BOOL *)numeric andTag:(int *)tag ofColumn:(int)i
{
	char	*title;
	[theEntryList getTitle:&title length:length alignment:alignment numeric:numeric andTag:tag ofColumn:i];
	return self;
}



- (int)columnCount
{
	return [theEntryList columnCount];
}


- loadCell:cell atRow:(int)row
{
//	[cell setFont:[Font newFont:"Times-Roman" size:12]];
	[cell setTag:row];
	return [theEntryList loadCell:cell withRow:row];
}


- performQuery
{
	return [self subclassResponsibility:_cmd];
}

- localizeColumnNamesIn:aQueryResult
{
	int i;
	for (i=0;i<[aQueryResult columnCount];i++) {
		[aQueryResult setTitle:[[NXApp stringMgr] stringFor:[aQueryResult titleOfColumn:i]] 
					  ofColumn:i];
	}
	return self;
}

- performDoubleActionWith:theObject
{
	return [[[[self documentClass] alloc] initIdentity:theObject] makeActive:self];
}



- updateHeadButton
{
	int		i, columns = [self columnCount];
	id		cell = [[ColumnBrowserCell new] setColumnCount:columns];
	NXRect	aFrame;
	
	[window disableFlushWindow];
	[headButton clear:[cell offsetOfFirstColumn]];
	for(i=0; i<columns; i++) {
		int		length;
		int		alignment;
		int		tag;
		BOOL	numeric;
		[self getLength:&length alignment:&alignment numeric:&numeric andTag:&tag ofColumn:i];
		[cell setLength:length alignment:alignment numeric:numeric andStringValue:"" ofColumn:i];
		[headButton addButtonWithTitle:[self titleForColumn:i]
		            tag:tag
		            andWidth:[cell widthOfColumn:i]];
	}
	
	maxWidth = [cell width] + browserInsideOffset;
	[[window contentView] getFrame:&aFrame];
	if( aFrame.size.width > maxWidth ) {
		if(maxWidth < minSize.width) maxWidth = minSize.width;
		[window sizeWindow:maxWidth :aFrame.size.height];
		[window display];
	}
	[cell free];
	[headButton update];
	[window reenableFlushWindow];
	return self;
}


- updateBrowserWithCurrentSelection
{
	[window disableFlushWindow];
	[iconButton setContent:nil];
	[self performQuery];
	[theEntryList sortByTag:currentSortTag];
	[browser loadColumnZero];
	[self updateHeadButton];
	[headButton moveToLeft:currentSortTag];
	[self updateSelectionInBrowser];
	[window reenableFlushWindow];
	[window display];
	if ([[browser matrixInColumn:0] isKindOf:[NiftyMatrix class]]) {
		[[browser matrixInColumn:0] setDelegate:self];
	}
	return self;
}


- updateSelectionInBrowser
{
	int	i, count = [selectedRows count];
	int j, jcount = [theEntryList count];
	
	for (i=0;i<count;i++) {
		for (j=0;j<jcount;j++) {
			if ([[selectedRows objectAt:i] compare:[self objectIdentityAtRow:j]] == 0) {
				[[[browser matrixInColumn:0] findCellWithTag:j] setSelected:YES];
			} 
		}
	}
	[self browserClicked:browser];
	return self;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	int	count = [theEntryList count];
	[countField setIntValue:count];
	[countSelectedField setIntValue:0];
	return count;
}


- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	[self loadCell:cell atRow:row];
	return self;
}


- browserClicked:sender
{
	int	i, count;
	
	if (selectedRows) {
		selectedRows = [selectedRows free];
	}
	selectedRows = [[[self itemListClass] alloc] initCount:0];
	[[sender matrixInColumn:0] sendAction:@selector(addObject:) to:selectedRows forAllCells:NO];
	count = [selectedRows count];
	[countSelectedField setIntValue:count];
	
	for(i=0; i<count; i++) {
		[selectedRows replaceObjectAt:i 
			  with:[self copyObjectIdentityAtRow:[[selectedRows objectAt:i] tag]]];
	}
	
	if( count == 0 ) {
		[iconButton setContent:nil];
	} else {
		[iconButton setContent:selectedRows];
	}
	
	return self;
}


- doDoubleAction:sender
{
	[self performDoubleActionWith:[self copyObjectIdentityAtRow:[sender tag]]];
	return self;
}


- browserDoubleClicked:sender
{
	[[sender matrixInColumn:0] sendAction:@selector(doDoubleAction:) to:self forAllCells:NO];
	return self;
}

- sendAction:(SEL)anAction to:anObject forAllCells:(BOOL)flag
{
	[[browser matrixInColumn:0] sendAction:anAction to:anObject forAllCells:flag];
	return self;
}


- selectFirstEntryInBrowser
{
	[[browser matrixInColumn:0] selectCellAt:0 :0];
	[self browserClicked:browser];
	return self;	
}

- headButtonClicked:sender
{
	currentSortTag = [sender tag];
	[window disableFlushWindow];
	[iconButton setContent:nil];
	[theEntryList sortByTag:currentSortTag];
	[browser loadColumnZero];
	[headButton moveToLeft:currentSortTag];
	[self updateSelectionInBrowser];
	[window reenableFlushWindow];
	[window display];
	return self;
}


- open:sender
{
	[[browser matrixInColumn:0] sendAction:@selector(doDoubleAction:) to:self forAllCells:NO];
   return self;
}

- export:sender
{
	return self;
}

/* delete & destroy methods */

- added:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		[self updateBrowserWithCurrentSelection];
	}
	return self;
}

- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		[self updateBrowserWithCurrentSelection];
	}
	return self;
}

- deleted:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		[self updateBrowserWithCurrentSelection];
	}
	return self;
}


/* delegates methods */

- windowWillClose:sender
{
	[self free];
	return (id)YES;
}

- windowDidBecomeKey:sender
{
	[NXApp setActiveDocument:self];
	[[NXApp findButton] setEnabled:NO];
	[[NXApp copySpecialButton] setEnabled:NO];

	[[NXApp newButton] setEnabled: NO];
	[[NXApp printButton] setEnabled: NO];

	return self;
}


- windowWillResize:sender toSize:(NXSize *)frameSize
{
	frameSize->width = MAX((MIN(frameSize->width,maxWidth)),minSize.width);
	frameSize->height = MAX(frameSize->height,minSize.height);
	return self;
}

- moveSelectionBy:(int)count
{
	int	selectedRow=0;
	id	matrix = [browser matrixInColumn:0];
	selectedRow = [matrix selectedRow] + count;
	if (selectedRow < 0) {
		selectedRow = 0;
	} else if(selectedRow >= [[matrix cellList] count]) {
		selectedRow = [[matrix cellList] count]-1;
	}
	[matrix selectCellAt:selectedRow :0];
	[matrix scrollCellToVisible:selectedRow :0];
	[self browserClicked:browser];
	return self;
}

- selectCellWithBeginChar:(char )aChar
{
	id		list = [[browser matrixInColumn:0] cellList];
	int		i, count = [list count];
	BOOL	found = NO;
	
	for (i=0;(i<count) && !found;i++) {
		if ((found = ([[list objectAt:i] compareFirstCharacter:aChar] == 0)==YES)) {
			[[browser matrixInColumn:0] selectCellAt:i :0];
			[[browser matrixInColumn:0] scrollCellToVisible:i :0];
			[self browserClicked:browser];
		}
	}
	if (!found) {
		[NXApp beep:"noMatches"];
	}
	return self;
}


-(float)maxWidth
{ return maxWidth; }
@end
