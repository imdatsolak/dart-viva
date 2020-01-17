#import <string.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>
#import <objc/Storage.h>

#import "dart/debug.h"
#import "dart/PaletteView.h"
#import "dart/HeadButton.h"
#import "dart/Localizer.h"
#import "dart/ColumnBrowserCell.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "Timer.h"
#import "UserManager.h"
#import "DefaultsDatabase.h"
#import "ExportManager.h"
#import "ImageManager.h"
#import "StringManager.h"
#import "TheApp.h"
#import "MasterDocument.h"
#import "ExportManager.h"

#import "MasterSelector.h"


#pragma .h #import <appkit/Matrix.h>
#pragma .h #import <appkit/graphics.h>
#pragma .h #import "MasterObject.h"
/*
#pragma .h #define CREATEFIELD(anObj,aClass,aField)	\
#pragma .h if(anObj==nil)anObj=[[[aClass alloc]init]readFromCell:aField]
#pragma .h #define CREATESWITCHSTATE(anObj,aSwitch)	\
#pragma .h if(anObj==nil)anObj=[Integer int:[aSwitch state]]
#pragma .h #define CREATERADIOSTATE(anObj,aRadio)	\
#pragma .h if(anObj==nil)anObj=[Integer int:[[aRadio selectedCell] tag]]
#pragma .h #define CREATEPOPUPSTATE(anObj, aPopup)	\
#pragma .h if(anObj==nil)anObj=[String str:[aPopup title]]
#pragma .h #define WRITEFINDPANELSWITCH(anOutlet,aControl)	\
#pragma .h [aControl setState:[anOutlet int]? 1:0]
#pragma .h #define WRITEFINDPANELCELL(anOutlet,aControl)	\
#pragma .h [anOutlet writeIntoCell:aControl]
#pragma .h #define WRITEFINDPANELTEXT(anOutlet,aText)	\
#pragma .h [anOutlet writeIntoText:aText]
#pragma .h #define WRITEFINDPANELRADIO(anOutlet,aRadio)	\
#pragma .h [aRadio selectCellWithTag:[anOutlet int]]
#pragma .h #define WRITEFINDPANELPOPUP(anOutlet,aPopup)	\
#pragma .h [aPopup setTitle:[anOutlet str]]
#pragma .h #define READFINDPANELCELL(anOutlet,aControl)	\
#pragma .h [anOutlet readFromCell:aControl]
#pragma .h #define READFINDPANELTEXT(anOutlet,aText)	\
#pragma .h [anOutlet readFromText:aText]
#pragma .h #define READFINDPANELRADIO(anOutlet,aRadio)	\
#pragma .h [anOutlet setInt:[[aRadio selectedCell] tag]]
#pragma .h #define READFINDPANELSWITCH(anOutlet,aControl)	\
#pragma .h [anOutlet setInt:[aControl state]]
#pragma .h #define READFINDPANELPOPUP(anOutlet, aPopup)	\
#pragma .h [anOutlet str:[aPopup title]]
*/

@implementation MasterSelector:MasterObject
{
    id		countField;
    id		browser;
    id		countSelectedField;
	id		autoUpdateSwitch;
    id		headButton;
    id		browserGroupBox;
	id		findPanel;
	id		inspectorPanel;
	id		firstFindPanelField;

	id		theEntryList;
	id		selectedRows;
	
	id		exportManager;
	
	id		needsUpdateButton;
	BOOL	findPanelWasVisible;
	BOOL	inspectorPanelWasVisible;
	NXSize	minSize;
	float	maxWidth;
	float	browserInsideOffset;
	id		sortOrder;
	id		defaultKey;
	BOOL	deletingItems;
	BOOL	doAutoUpdate;
}


+ (BOOL)canHaveMultipleInstances
{
	return NO;
}

- init 
{
	NXRect	aFrame;
	
	[super init];
	
	findPanelWasVisible = NO;
	inspectorPanelWasVisible = NO;
	deletingItems = NO;
	doAutoUpdate = NO;
	defaultKey = [[String str:[self name]] concatSTR:"default"];
	
	[[NXApp localizer] loadLocalNib:"MasterSelector" owner:self];
	[NXApp registerDocument:self];
	
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
	minSize.width = 450.0;
	minSize.height = 300.0;

	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	
	[[NXApp imageMgr] iconFor:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
	[window setMiniwindowIcon:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
	[window setTitle:[[NXApp stringMgr] windowTitleFor:[self name]]];
	
	[[iconButton setDoubleTarget:self] setDoubleAction:@selector(open:)];

	selectedRows = nil;
	exportManager = [[ExportManager alloc] init];
	[self readDefaults];
	return self;
}


- free
{
	[NXApp unregisterDocument:self];
	findPanel = [findPanel free];
	inspectorPanel = [inspectorPanel free];
	theEntryList = [theEntryList free];
	selectedRows = [selectedRows free];
	sortOrder = [sortOrder free];
	[exportManager free];
	[defaultKey free];
	return [super free];
}

- readDefaults
{
	id	def = [[NXApp defaultsDB] valueForKey:[defaultKey str]];
	if(def) {
		NXStream	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
		if(stream) {
			NXTypedStream	*typedStream;
			[def writeHexToStream:stream];
			NXSeek(stream, 0, NX_FROMSTART);
			typedStream = NXOpenTypedStream(stream, NX_READONLY);
			if(typedStream) {
				[self readFields:typedStream];
				NXCloseTypedStream(typedStream);
			}
			NXCloseMemory(stream, NX_FREEBUFFER);
		}
	}
	return self;
}

- writeDefaults
{
	NXStream	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
	if(stream) {
		NXTypedStream	*typedStream = NXOpenTypedStream(stream, NX_WRITEONLY);
		if(typedStream) {
			id	def = [String str:""];
			[self writeFields:typedStream];
			NXCloseTypedStream(typedStream);
			NXSeek(stream, 0, NX_FROMSTART);
			[def readHexFromStream:stream];
			[[NXApp defaultsDB] setValue:def forKey:[defaultKey str]];
			[def free];
		}
		NXCloseMemory(stream, NX_FREEBUFFER);
	}
	return self;
}

- readFields:(NXTypedStream *)typedStream
{
	float	x, y, width, height;
	int		i;
	sortOrder = NXReadObject(typedStream);
	NXReadType(typedStream,"f",&x);
	NXReadType(typedStream,"f",&y);
	NXReadType(typedStream,"f",&width);
	NXReadType(typedStream,"f",&height);
	NXReadType(typedStream,"i",&i);
	doAutoUpdate = i;
	[autoUpdateSwitch setState:doAutoUpdate];
	[window moveTo:x:y];
	[window sizeWindow:width:height];
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	NXRect	frame;
	NXRect	wFrame;
	int		i;
	[[window contentView] getFrame:&frame];
	[window getFrame:&wFrame];
	i = doAutoUpdate;
	NXWriteObject(typedStream, sortOrder);
	NXWriteType(typedStream, "f", &wFrame.origin.x);
	NXWriteType(typedStream, "f", &wFrame.origin.y);
	NXWriteType(typedStream, "f", &frame.size.width);
	NXWriteType(typedStream, "f", &frame.size.height);
	NXWriteType(typedStream, "i", &i);
	return self;
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


- makeActive:sender
{
	[self updateBrowserWithCurrentSelection];
	return [super makeActive:sender];
}

- checkMenus
{
	const char *aName = [[self documentClass] name];
	
	if ([iconButton content]) {
		[[NXApp copySpecialButton] setEnabled: YES];
		if ([[NXApp userMgr] canRead:aName]) [[NXApp openButton] setEnabled: YES];
		if ([[NXApp userMgr] canExport:aName]) [[NXApp exportButton] setEnabled: YES];
		if ([[NXApp userMgr] canDelete:aName]) [[NXApp destroyButton] setEnabled: YES];
	}

	return self;
}

- find:sender
{
	[window makeKeyAndOrderFront:sender];
	[[self findPanel] makeKeyAndOrderFront:sender];
	[firstFindPanelField selectText:self];
	return self;
}


- selectAll:sender
{
	[[browser matrixInColumn:0] selectAll:sender];
	[self browserClicked:browser];
	return self;
}

- updateAll:sender
{
	[self updateBrowserWithCurrentSelection];
	return self;
}


/* MasterSelector's own methods */
- copyObjectAtRow:(int)row
{
	id	identity = [self copyObjectIdentityAtRow:row];
	id	copiedItem = [[[self itemClass] alloc] initIdentity:identity];
	[identity free];
	return copiedItem;
}

- copyObjectIdentityAtRow:(int)row
{ return [[self objectIdentityAtRow:row] copy]; }

- objectIdentityAtRow:(int)row
{ return [self subclassResponsibility:_cmd]; }


- new:sender
{
	return [[[[self documentClass] alloc] initNew] makeActive:sender];
}

- performDeleteWith:theObject
{
	if([[[[[self documentClass] alloc] initIdentity:theObject] makeActive:self] destroy]) {
		return self;
	} else {
		return nil;
	}
}


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

- readFindPanel
{
	return self;
}

- writeFindPanel
{
	return self;
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

- updateSortOrder
{
	int	i, columns = [self columnCount];
	[sortOrder free];
	sortOrder = [[Storage alloc] initCount:0 elementSize:sizeof(int) description:"i"];
	for(i=0; i<columns; i++) {
		int	theTag = [theEntryList tagOfColumn:i]; 
		[sortOrder addElement:&theTag];
	}
	return self;
}

- establishSortOrder
{
	if(sortOrder != nil) {
		int	i, columns = [sortOrder count];
		for(i=columns-1; i>=0; i--) {
			[theEntryList moveToLeftColumnWithTag:*(int *)[sortOrder elementAt:i]];
		}
		if (columns > 0) {
			[theEntryList sortByTag:*(int *)[sortOrder elementAt:0]];
		}
	}
	return self;
}

- updateBrowserWithCurrentSelection
{
	[window disableFlushWindow];
	[iconButton setContent:nil];
	[self performQuery];
	[self establishSortOrder];
	[browser loadColumnZero];
	[self updateHeadButton];
	[self updateSelectionInBrowser];
	[window reenableFlushWindow];
	[window display];
	[window setDocEdited:NO];
	[needsUpdateButton setImage:[[NXApp imageMgr] iconFor:"NoUpdate"]];
	return self;
}


- updateSelectionInBrowser
{
	int	i, count = [selectedRows count];
	int j, jcount = [theEntryList count];
	
	for (i=count-1;i>=0;i--) {
		for (j=0;j<jcount;j++) {
			if ([[selectedRows objectAt:i] compare:[self objectIdentityAtRow:j]] == 0) {
				[[[browser matrixInColumn:0] cellAt:j :0] setSelected:YES];
			} 
		}
		[[selectedRows removeObjectAt:i] free];
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

- selectFirstEntryInBrowser
{
	[[browser matrixInColumn:0] selectCellAt:0 :0];
	[self browserClicked:browser];
	return self;	
}

- findPanel
{
	return findPanel;
}

- autoUpdateSwitchClicked:sender
{
	doAutoUpdate = [autoUpdateSwitch state];
	return self;
}

- findPanelFindButtonClicked:sender
{
	[self readFindPanel];
	[self updateBrowserWithCurrentSelection];
	[self updateSortOrder];
	[self selectFirstEntryInBrowser];
	[self hideInspectorAndFindPanel:NO];
	return self;	
}


- inspectorPanel
{
	return inspectorPanel;
}


- headButtonClicked:sender
{
	int	currentSortTag = [sender tag];
	[window disableFlushWindow];
	[iconButton setContent:nil];
	[theEntryList sortByTag:currentSortTag];
	[browser loadColumnZero];
	[headButton moveToLeft:currentSortTag];
	[self updateSortOrder];
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
	[exportManager setNumRows:[countSelectedField intValue]];
	[exportManager setNumColumns:[[theEntryList objectAt:0] count]];
	[exportManager setSelectionMatrix:[browser matrixInColumn:0]];
	[exportManager setEntryList:theEntryList];
	[exportManager export:sender];
	return self;
}

- hideInspectorAndFindPanel:(BOOL)saveVisibleState
{
	if( [self findPanel] ) {
		findPanelWasVisible = saveVisibleState && [[self findPanel] isVisible];
		[[self findPanel] orderOut:self];
	}
	if( [self inspectorPanel] ) {
		inspectorPanelWasVisible = saveVisibleState && [[self inspectorPanel] isVisible];
		[[self inspectorPanel] orderOut:self];
	}
	return self;
}


- restoreInspectorAndFindPanel
{
	if( [self findPanel] && findPanelWasVisible ) {
		[[self findPanel] orderWindow:NX_BELOW relativeTo:[[self window] windowNum]];
	}
	if( [self inspectorPanel] && inspectorPanelWasVisible ) {
		[[self inspectorPanel] orderWindow:NX_BELOW relativeTo:[[self window] windowNum]];
	}
	
	return self;
}

/* delete & destroy methods */

- doDestroyAction:sender
{
	return [self performDeleteWith:[self copyObjectIdentityAtRow:[sender tag]]];
}


- (BOOL)destroy
{
	deletingItems = YES;
	[[browser matrixInColumn:0] sendAction:@selector(doDestroyAction:) to:self forAllCells:NO];
	[self updateBrowserWithCurrentSelection];
	[self checkMenus];
	deletingItems = NO;
	[self updateBrowserWithCurrentSelection];
	return YES;
}


- (BOOL)isSelectedAndOpenable
{
	return ([countSelectedField intValue] > 0);
}

- removeItemWithIdentitySTR:(const char *)identitySTR
{
	int i, count = [theEntryList count];
	
	for (i=count-1;i>=0;i--) {
		if ([[self objectIdentityAtRow:i] compareSTR:identitySTR] == 0) {
			[[theEntryList removeObjectAt:i] free];
		}
	}
	[window disableFlushWindow];
	[iconButton setContent:nil];
	[browser loadColumnZero];
	[self updateSelectionInBrowser];
	[window reenableFlushWindow];
	[window display];
	return self;
}


- added:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		if (doAutoUpdate) {
			[self updateBrowserWithCurrentSelection];
		} else {
			[window setDocEdited:YES];
			[needsUpdateButton setImage:[[NXApp imageMgr] iconFor:"NeedsUpdate"]];
		}
	}
	return self;
}

- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		if (doAutoUpdate) {
			[self updateBrowserWithCurrentSelection];
		} else {
			[window setDocEdited:YES];
			[needsUpdateButton setImage:[[NXApp imageMgr] iconFor:"NeedsUpdate"]];
		}
	}
	return self;
}

- deleted:(const char *)classname :(const char *)identitySTR
{
	if((0==strcmp(classname,[[self itemClass] name])) && !deletingItems) {
		[self removeItemWithIdentitySTR:identitySTR];
	}
	return self;
}

/* delegates methods */

- windowDidBecomeMain:sender
{
	[NXApp setActiveDocument:self];

	if ([[NXApp userMgr] canAdd:[[self documentClass] name]]) [[NXApp newButton] setEnabled: YES];
	[[NXApp findButton] setEnabled: YES];
	[[NXApp printButton] setEnabled: NO];

	[self restoreInspectorAndFindPanel];
	return self;
}


- windowDidDeminiaturize:sender
{
	[self restoreInspectorAndFindPanel];
	return self;
}


- windowDidMiniaturize:sender
{
	[self hideInspectorAndFindPanel:YES];
	return self;
}


- windowDidResignMain:sender
{
	[self hideInspectorAndFindPanel:YES];
	return self;
}


- windowWillClose:sender
{
	[self hideInspectorAndFindPanel:NO];
	[window setDelegate:nil];
	[self writeDefaults];
	[self free];
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
	int		i, count = [theEntryList count];
	BOOL	found = NO;
	
	for (i=0;(i<count) && !found;i++) {
		if ((found = ([[[theEntryList objectAt:i] objectAt:0] compareFirstCharWith:aChar] == 0)==YES)) {
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

- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource
{
	return NO;
}


- (BOOL)windowExited:dragSource
{
	return NO;
}


- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	return NO;
}

/* PasteBoard */
- copySpecial:sender
{
	id theCopy;
	if (iconButton && [iconButton content]) {
		theCopy = [[iconButton content] copy];
		[[NXApp pasteBoard] pasteItem:theCopy];
	}
	return self;
}

@end
