#import <objc/List.h>
#import <appkit/Matrix.h>
#import <appkit/Text.h>

#import "dart/debug.h"
#import "dart/ColumnBrowserCell.h"
#import "dart/PaletteView.h"
#import "dart/fieldvaluekit.h"
#import "FileItem.h"
#import "CommentItem.h"

#import "IconListView.h"

#pragma .h #import <appkit/ScrollView.h>

@implementation IconListView:ScrollView
{
	id		selectedEntry;
	id		delegate;
	id		target;
	id		doubleTarget;
	SEL		action;
	SEL		doubleAction;
	BOOL	isListing;
}

- initFrame:(NXRect *)aFrame
{
	[super initFrame:aFrame];
	[self setVertScrollerRequired:YES];
	[self setCopyOnScroll:YES];
	[self setDisplayOnScroll:YES];
	[self setDynamicScrolling:YES];
	[self setBorderType:NX_BEZEL];
	[self setAutoresizeSubviews:YES];
	selectedEntry = nil;
	return self;
}

- drawSelf:(const NXRect *)rects :(int)count
{
	[super drawSelf:rects :count];
	if(delegate != nil) {
		if([delegate respondsTo:@selector(contentList:)]) {
			id	list = [delegate contentList:self];
			
			if(list != nil) {
				if([self showsListing]) {
					[self reloadAsListing:list];
				} else {
					[self reloadAsIcons:list];
				}
			}
		}
	}
	return self;
}

- showListing
{
	isListing = YES;
	[self reload];
	return self;
}

- showIcons
{
	isListing = NO;
	[self reload];
	return self;
}

- (BOOL)showsListing
{
	return isListing;
}

- (BOOL)showsIcons
{
	return ! isListing;
}

- reload
{
	[self display];
	return self;
}

- reloadAsListing:list
{
	NXRect	aFrame;
	id		matrix;
	int		i;
	
	selectedEntry = nil;
	aFrame.origin.x = aFrame.origin.y = 0.0;
	[self getContentSize:&aFrame.size];
	matrix = [[Matrix alloc] initFrame:&aFrame mode:NX_RADIOMODE
							 cellClass:[ColumnBrowserCell class]
							 numRows:[list count] numCols:1];
							 
	for(i=0; i<[list count]; i++) {
		id	cell = [matrix cellAt:i:0];
		[cell setIcon:[[list objectAt:i] miniIcon]];
		[cell setColumnCount:2];
		[cell setLength:16 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
		[cell setLength:128 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
		[cell setTag:i];
		[[[list objectAt:i] description] writeIntoCell:cell inColumn:0];
		if([[list objectAt:i] respondsTo:@selector(supplDescription)]) {
			[[[list objectAt:i] supplDescription] writeIntoCell:cell inColumn:1];
		}
	}
	
	[matrix sizeToFit];
	[matrix sizeToCells];
	[matrix setAutoscroll:YES];
	[matrix setAction:@selector(clicked:)];
	[[matrix setTarget:self] setDoubleAction:@selector(doubleClicked:)];
	[[self setDocView:matrix] free];

	return self;
}

- reloadAsIcons:list
{
	NXSize	size;
	NXRect	aFrame;
	int		i, numRows, numCols;
	float	width, height;
	NXRect	bFrame;
	
	selectedEntry = nil;
	width = height = 80.0;
	
	if ([self docView] == nil) {
		[self getContentSize:&size];
		aFrame.origin.x = aFrame.origin.y = 0.0;
		aFrame.size.width = size.width;
		aFrame.size.height = size.height;
	} else {
		[[self docView] getFrame:&aFrame];
	}
	[[self setDocView:[[[View alloc] initFrame:&aFrame] setAutosizing:NX_HEIGHTSIZABLE|NX_WIDTHSIZABLE]] free];
	DEBUG2("DocFrame:x:%f y:%f w:%f h:%f\n",aFrame.origin.x,aFrame.origin.y,aFrame.size.width,aFrame.size.height);
	size.width = aFrame.size.width;
	size.height = aFrame.size.height;
//	[self getContentSize:&size];
	numCols = (int)((size.width+10.0) / (width+10.0));
	numRows = ([list count] / numCols) + (([list count] % numCols)? 1:0);
	
	[[self docView] getFrame:&bFrame];
	[[self docView] sizeTo:bFrame.size.width :(numRows * height)+10];
	
	aFrame.size.width = width;
	aFrame.size.height = height;

	for(i=0; i<[list count]; i++) {
		id	newView;
		aFrame.origin.x = ((i % numCols) * width)+10.0;
		aFrame.origin.y = (size.height-((numRows-1)* height)) + ((((numRows-1)-(i / numCols)) * height)) - height;
		DEBUG5("origin=(%f,%f)\n",aFrame.origin.x,aFrame.origin.y);
		newView = [[PaletteView alloc] initFrame:&aFrame];
		[newView setOwner:self];
		[[newView setContent:[list objectAt:i]] setTag:i];
		[[newView setTarget:self] setAction:@selector(clicked:)];
		[[newView setDoubleTarget:self] setDoubleAction:@selector(doubleClicked:)];
		[newView setTitled:YES];
		if ([[list objectAt:i] respondsTo:@selector(descriptionEditable)]) {
			[newView setEditable:[[list objectAt:i] descriptionEditable]];
		}
		[[self docView] addSubview:newView];
	}

	return self;
}

- doubleClicked:sender
{
	if([[self doubleTarget] respondsTo:[self doubleAction]]) {
		if ([sender isKindOf:[Matrix class]]) {
			return [[self doubleTarget] perform:[self doubleAction] with:[sender selectedCell]];
		} else {
			return [[self doubleTarget] perform:[self doubleAction] with:sender];
		}
	} else {
		return self;
	}
}

- clicked:sender
{
	[selectedEntry setSelected:NO];
	if ([sender isKindOf:[Matrix class]]) {
		selectedEntry = [sender selectedCell];
	} else {
		selectedEntry = sender;
	}
	[selectedEntry setSelected:YES];
	if([[self target] respondsTo:[self action]]) {
		return [[self target] perform:[self action] with:sender];
	} else {
		return self;
	}
}


- setDelegate:anObject
{ delegate = anObject; return self; }

- delegate
{ return delegate; }

- setDoubleTarget:anObject
{ doubleTarget = anObject; return self; }

- doubleTarget
{ return doubleTarget; }

- setTarget:anObject
{ target = anObject; return self; }

- target
{ return target; }

- setAction:(SEL)sel
{ action = sel; return self; }

- (SEL)action
{ return action; }

- setDoubleAction:(SEL)sel
{ doubleAction = sel; return self; }

- (SEL)doubleAction
{ return doubleAction; }

- titleChanged:sender to:(const char *)newTitle
{
	if ([delegate respondsTo:@selector(attachmentTitleAt:changedTo:)]) {
		if( [delegate attachmentTitleAt:[sender tag] changedTo:newTitle] != nil) {
			[sender setContent:[[delegate contentList:self] objectAt:[sender tag]]];
		} else {
			[sender display];
		}
	}
	return self;
}

- selectedEntry { return selectedEntry; }
@end

@interface Object(Delegate)
- contentList:sender;
- attachmentTitleAt:(int)index changedTo:(const char *)newTitle;
@end
