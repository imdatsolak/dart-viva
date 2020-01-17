#import <c.h>
#import <string.h>
#import <stdlib.h>

#import <objc/List.h>
#import <objc/typedstream.h>
#import <appkit/Window.h>
#import <appkit/ScrollView.h>

#import "dart/PaletteView.h"
#import "dart/fieldvaluekit.h"

#import "MasterItemList.h"
#import "DefaultsDatabase.h"
#import "TheApp.h"
#import "DPasteBoard.h"

#pragma .h #import "MasterDocument.h"
					
@implementation DPasteBoard:MasterDocument
{
	id	pbList;
	id	selectedItem;
	id	scrollView;
	id	trash;
}

- itemClass
{
	return [self class];
}

- init
{
	[super init];
	selectedItem = nil;
	minSize.height = -1;
	[NXApp unregisterDocument:self];
	pbList = nil;
	
	[self readDefaults];
	if (!pbList) {
		pbList = [[List alloc] initCount:0];
	}

	return self;
}


- writeDefaults
{
	NXStream	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
	if(stream) {
		NXTypedStream *typedStream = NXOpenTypedStream(stream, NX_WRITEONLY);
		if (typedStream) {
			id			def = [String str:""];
			NXRect		wFrame;
			NXRect		contentFrame;
			id			iAmVisible = [Integer int:[window isVisible]];
			unsigned 	index = [pbList indexOf:selectedItem];
			float		scrollerValue = [[scrollView horizScroller] floatValue];

			[window getFrame:&wFrame];
			[[window contentView] getFrame:&contentFrame];
			NXWriteTypes(typedStream,"ffffi", &wFrame.origin.x,&wFrame.origin.y,&(contentFrame.size.width), &scrollerValue, &index);
			NXWriteObject(typedStream, iAmVisible);
			NXWriteObject(typedStream, pbList);
			NXCloseTypedStream(typedStream);
			NXSeek(stream, 0, NX_FROMSTART);
			[def readHexFromStream:stream];
			[[NXApp defaultsDB] setValue:def forKey:"pasteBoard"];
			[def free];
			[iAmVisible free];
		}
		NXCloseMemory(stream, NX_FREEBUFFER);
	}
	return self;
}

- readDefaults
{
	NXRect		contentFrame;
	unsigned 	index;
	id			iWasVisible;
	float		scrollerValue;
	id			def = [[NXApp defaultsDB] valueForKey:"pasteBoard"];
	
	if(def) {
		NXStream	*stream = NXOpenMemory(NULL, 0, NX_READWRITE);
		if(stream) {
			NXTypedStream *typedStream;
			[def writeHexToStream:stream];
			NXSeek(stream, 0, NX_FROMSTART);
			typedStream = NXOpenTypedStream(stream, NX_READONLY);
			if (typedStream) {
				float x,y;
				[[window contentView] getFrame:&contentFrame];
				NXReadTypes(typedStream,"ffffi",&x,&y,&(contentFrame.size.width), &scrollerValue, &index);
				iWasVisible = NXReadObject(typedStream);
				pbList = NXReadObject(typedStream);
				NXCloseTypedStream(typedStream);
				selectedItem = [pbList objectAt:index];
				[window disableFlushWindow];
				[self updateWindow];
				[window moveTo:x:y];
				[window sizeWindow:contentFrame.size.width :contentFrame.size.height];
				[[scrollView horizScroller] setFloatValue:scrollerValue];
				[[[scrollView horizScroller] target] perform:
						[[scrollView horizScroller] action] with:[scrollView horizScroller]];
				[window reenableFlushWindow];
				[window flushWindow];
				if ([iWasVisible int]) {
					[self makeActive:self];
				}
				[iWasVisible free];
			}
			NXCloseMemory(stream, NX_FREEBUFFER);
		}
	}
	return self;
}

- free
{
	[self writeDefaults];
	[pbList free];
	return [super free];
}

- checkMenus
{
	[[NXApp destroySelectionButton] setEnabled:([self selectedItem] != nil)];
	[[NXApp openButton] setEnabled:([self selectedItem] != nil)];
	[[NXApp saveButton] setEnabled:NO];
	[[NXApp newButton] setEnabled:NO];
	[[NXApp revertButton] setEnabled:NO];
	[[NXApp destroyButton] setEnabled:NO];
	[[NXApp findButton] setEnabled:NO];
	return self;
}


- checkPasteSpecialButton
{
	if ([NXApp activeDocument] != self) {
		[[NXApp pasteSpecialButton] setEnabled:[[NXApp activeDocument] acceptsItem:selectedItem]];
	}
	return self;
}

- setReadOnly
{ return self; }

- updateWindow
{
	NXRect	aFrame;
	int		i,count, selectedItemIndex=0;
		
	[window disableFlushWindow];
	
	count = [[[scrollView docView] subviews] count];
	for (i=count-1;i>=0;i--) {
		[[[[[scrollView docView] subviews] objectAt:i] removeFromSuperview] free];
	}
	
	aFrame.origin.x = aFrame.origin.y = 8.0;
	aFrame.size.width = aFrame.size.height = 80.0;

	count = [pbList count];
	for(i=0;i<count;i++) {
		id	newView = [[[[[[[[[[PaletteView alloc] initFrame:&aFrame] 
									  setOwner:self] 
									  setContent:[pbList objectAt:i]]
									  setTag:i]
									  setTarget:self]
									  setAction:@selector(selectItem:)]
									  setDoubleTarget:self]
									  setDoubleAction:@selector(open:)]
									  setTitled:YES];
		[[scrollView docView] addSubview:newView];
		if (selectedItem == [pbList objectAt:i]) {
			[newView setSelected:YES];
			selectedItemIndex = i;
		}
		aFrame.origin.x += 80.0;
	}
	[[scrollView docView] sizeTo:MAX(aFrame.origin.x,1.0) :80.0];
	[[scrollView horizScroller] setFloatValue:(float)selectedItemIndex/(float)(MAX(count-1,1))];
	[[[scrollView horizScroller] target] perform:[[scrollView horizScroller] action] with:[scrollView horizScroller]];
	[window reenableFlushWindow];
	[window display];
	return self;
}


- destroySelection:sender
{
	if (selectedItem) {
		int	index = [pbList indexOf:selectedItem];
		[pbList removeObject:selectedItem];
		selectedItem = [selectedItem free];
		if ([pbList count]) {
			selectedItem = [pbList objectAt:MIN(index,[pbList count]-1)];
		}
		[self updateWindow];
	} else {
		[NXApp beep:"NothingSelectedInPB"];
	}
	
	return self;
}

- (BOOL)acceptsItem:item
{ return YES; }

- pasteItem:anItem
{
	selectedItem = [anItem copy];
	[pbList addObject:selectedItem];
	[self updateWindow];
	return self;
}

- open:sender
{
	[selectedItem open:sender];
	return self;
}

- selectItem:sender
{
	int	index = [pbList indexOf:selectedItem];
	
	[[[[scrollView docView] subviews] objectAt:index] setSelected:NO];
	selectedItem = [pbList objectAt:[sender tag]];
	[sender setSelected:YES];
	
	return self;
}
	
- deleted:(const char *)classname :(const char *)identitySTR
{
	int	i;
	
	for (i=0;i<[pbList count];i++) {
		id	theItem = [pbList objectAt:i];
		if ((0==strcmp(classname,[[theItem itemClass] name])) &&
			([theItem removeAndFreeObjectWithIdentitySTR:identitySTR ]) &&  ([theItem count]==0)) {
			if (selectedItem == theItem) {
				[self destroySelection:self];
				i--;
			} else {
				[pbList removeObject:theItem];
				i--;
			}
		}
	}
	[self updateWindow];
	return self;
}


- windowWillResize:sender toSize:(NXSize *)frameSize
{	
	if (minSize.height <= 0) {
		minSize.height = frameSize->height;
	} else { 
		frameSize->height = minSize.height;
	}
	return self;
}

- selectedItem
{ return selectedItem; }

- windowWillClose:sender
{
	[NXApp unregisterDocument:self];
	return self;
}

@end
