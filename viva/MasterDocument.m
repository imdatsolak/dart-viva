#import <c.h>
#import <string.h>
#import <objc/List.h>
#import <appkit/TextField.h>
#import <appkit/View.h>
#import <appkit/Window.h>
#import <appkit/NXSplitView.h>

#import "dart/Localizer.h"
#import "dart/PaletteView.h"
#import "dart/debug.h"
#import "dart/fieldvaluekit.h"

#import "AttachmentList.h"
#import "DPasteBoard.h"
#import "DefaultsDatabase.h"
#import "ErrorManager.h"
#import "ImageManager.h"
#import "MasterItem.h"
#import "CommentItem.h"
#import "FileItem.h"
#import "PrintoutDocument.h"
#import "StringManager.h"
#import "IconListView.h"
#import "TheApp.h"
#import "UserManager.h"

#import "MasterDocument.h"

#pragma .h #import "MasterObject.h"

/*
#pragma .h #define SETREADONLYFIELD(aField)	[[[aField setEditable:NO] setSelectable:YES] setBackgroundGray:NX_LTGRAY]
#pragma .h #define SETDISABLED(aControl)		[aControl setEnabled:NO]
#pragma .h #define WRITEINTOSWITCH(anItem,anOutlet,aControl)	[aControl setState:[[anItem anOutlet] int]? 1:0]
#pragma .h #define WRITEINTOCELL(anItem,anOutlet,aControl)	[[anItem anOutlet] writeIntoCell:aControl]
#pragma .h #define WRITEINTOTEXT(anItem,anOutlet,aText)	[[anItem anOutlet] writeIntoText:aText]
#pragma .h #define WRITEINTORADIO(anItem,anOutlet,aRadio)	[aRadio selectCellWithTag:([[anItem anOutlet] int]?1:0)]
#pragma .h #define READFROMCELL(anItem,anOutlet,aControl)	[[anItem anOutlet] readFromCell:aControl]
#pragma .h #define READFROMTEXT(anItem,anOutlet,aText)		[[anItem anOutlet] readFromText:aText]
#pragma .h #define READFROMRADIO(anItem,anOutlet,aRadio)	[[anItem anOutlet] setInt:[[aRadio selectedCell] tag]]
#pragma .h #define READFROMSWITCH(anItem,anOutlet,aControl)	[[anItem anOutlet] setInt:[aControl state]]
*/


@implementation MasterDocument:MasterObject
{
	NXSize	minSize;
	NXSize	maxSize;
	NXCoord	gnubbleMinY;
	NXCoord	gnubbleMaxY;
	BOOL	iamReadOnly;
	BOOL	iamNew;
	id		item;
	id		currentSelectedField;
	id		iconListView;
	id		splitView;
}

+ enableButton:aButton
{
	[aButton setEnabled:[[NXApp userMgr] canSelect:[[self class] name]]];
	return self;
}

- (BOOL)isRegisterable { return [[self window] windowNum] > 0; }
- (BOOL)wantsNewComments { return iconListView != nil; }

- itemClass
{
	return self;
}

- new:sender
{
	return [[[[self class] alloc] initNew] makeActive:sender];
}

- init
{
	[super init];
	minSize.width = minSize.height = 300.0;
	maxSize.width = maxSize.height = 800.0;
	return [self initNib];
}

- initNib
{
	NXRect	aFrame;

	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	[[NXApp imageMgr] iconFor:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
	[window setMiniwindowIcon:[[NXApp stringMgr] miniWindowIconNameFor:[self name]]];
	[window setDelegate:self];

	[[window contentView] getFrame:&aFrame];
	minSize.width = aFrame.size.width;
	minSize.height = aFrame.size.height;
	gnubbleMinY = 0;
	gnubbleMaxY = aFrame.size.height;
	maxSize.height = 832;
	maxSize.width = minSize.width;
//	[NXApp getNewCoordForFrame:&aFrame];
//	[aWindow moveTo:aFrame.origin.x :aFrame.origin.y];
	
	[iconButton setOwner:self];
	
	if((![[NXApp userMgr] canChange:[[self class] name]]) || (![[NXApp userMgr] canChange:[[self itemClass] name]])) {
		iamReadOnly = YES;
		[self setReadOnly];
	} else {
		iamReadOnly = NO;
	}

	[[NXApp registerDocument:self] setActiveDocument:self];
	currentSelectedField = nil;	
	return self;
}

- initNew
{
	[self init];
	[self createNewItem];
	if(item == nil) {
		//Error could not open new item
		return [self free];
	} else {
		iamNew = YES;
		[self updateWindow];
		[self setWindowTitle];
		[window setDocEdited:YES];
		return self;
	}
}

- initIdentity:identity
{
	[self init];
	iamNew = NO;
	[self createIdentityItem:identity];
	if(item == nil) {
		//Error could not open item
		return [self free];
	} else {
		if(!iamReadOnly) {
			if(![NXApp lockClass:[self itemClass] identity:[item identity]]) {
				iamReadOnly = YES;
				[self setReadOnly];
			}
		}	
		[self updateWindow];
		[self resetIconButton];
		[self protectFieldsAndSelectText];
		[self setWindowTitle];
		[window setDocEdited:NO];
		return self;
	}
}

- initItem:anItem
{
	[self init];
	item = anItem;
	iamNew = NO;
	if(item == nil) {
		[NXApp beep:"CouldNotOpenItem"];
		return [self free];
	} else {
		if(!iamReadOnly) {
			if(![NXApp lockClass:[self itemClass] identity:[item identity]]) {
				iamReadOnly = YES;
				[self setReadOnly];
			}
		}	
		[self updateWindow];
		[self resetIconButton];
		[self protectFieldsAndSelectText];
		[self setWindowTitle];
		[window setDocEdited:NO];
		return self;
	}
}

- createNewItem
{
	return self;
}

- createIdentityItem:identity
{
	return self;
}

- free
{
	if(item) {
		if(!iamReadOnly) {
			[NXApp unlockClass:[self itemClass] identity:[item identity]];
		}
	}
	[window orderOut:self];
	[NXApp unregisterDocument:self];
	[item free];
	return [super free];
}

- protectFieldsAndSelectText
{
	return self;
}


- (BOOL)isReadOnly
{
	return iamReadOnly;
}

- (BOOL)iWannaUpdate
{
	return iamReadOnly;
}

- checkMenus
{
	int	selAtPos = -1;
	if ([iconListView selectedEntry] != nil) {
		selAtPos = [[iconListView selectedEntry] tag];
	}
	[super checkMenus];
	if(!iamNew) [[NXApp copySpecialButton] setEnabled:YES];
	[[NXApp newEditorButton] setEnabled:!([self isReadOnly] || ![self wantsNewComments])];
	[[NXApp showListingButton] setEnabled:(iconListView != nil)];
	[[NXApp showIconsButton] setEnabled:(iconListView != nil)];
	if ((selAtPos >= 0) && [[self item] respondsTo:@selector(attachmentList)]) {
		id	anItem = [[[self item] attachmentList] objectAt:selAtPos];
		if (anItem && ([anItem isKindOf:[CommentItem class]]||[anItem isKindOf:[FileItem class]]) && ![self isReadOnly]) {
			[[NXApp destroySelectionButton] setEnabled:YES];
		}
	}
	return self;
}


- destroySelection:sender
{
	int	selAtPos = -1;
	if ([iconListView selectedEntry] != nil) {
		selAtPos = [[iconListView selectedEntry] tag];
	}
	if ((selAtPos >= 0) && [[self item] respondsTo:@selector(attachmentList)]) {
		id	anItem = [[[self item] attachmentList] objectAt:selAtPos];
		if (anItem && ([anItem isKindOf:[CommentItem class]]||[anItem isKindOf:[FileItem class]]) && ![self isReadOnly]) {
			[[[self item] attachmentList] removeAttachmentAt:selAtPos];
			[window setDocEdited:YES];
			[iconListView display];
		}
	}
	return self;
}

- setReadOnly
{
	return self;
}

- writeIntoWindow
{
	return self;
}

- updateWindow
{
	[self saveCurrentSelection];
	[window disableFlushWindow];
	[self writeIntoWindow];
	[window reenableFlushWindow];
	[self restoreCurrentSelection];
	[window display];
	return self;
}

- readFromWindow;
{
	return self;
}

- (BOOL)acceptsItem:anItem;
{
	return NO;
}

- setWindowTitle
{
	id	aString = [String str:""];
	
	if(iamNew) {
		[aString concatSTR:[[NXApp stringMgr] stringFor:"UNTITLED"]];
	} else {
		[aString concat:[item identity]];
	}
	
	[aString concatSTR:" Ð "];
	[aString concatSTR:[[NXApp stringMgr] windowTitleFor:[self name]]];
	
	if(iamReadOnly) {
		[aString concatSTR:[[NXApp stringMgr] stringFor:"READONLY"]];
	}
	
	[window setTitle:[aString str]];
	[aString free];
	
	return self;
}

- resetIconButton
{
	id	content = [item copyAsItemList];
	[iconButton setContent:content];
	[content free];
	return self;
}


- (BOOL)save
{	
	[self saveCurrentSelection];
	[self readFromWindow];
	if([item isSaveable]) {
		if([item save]) {
			if(iamNew) {
				if(![NXApp lockClass:[self itemClass] identity:[item identity]]) {
					iamReadOnly = YES;
					[self setReadOnly];
				}
			}
			[self resetIconButton];
			[self protectFieldsAndSelectText];
			[window setDocEdited:NO];
			if(iamNew) {
				[self sendAdded:[item identity]];
			} else {
				[self sendChanged:[item identity]];
			}
			iamNew = NO;
			[self setWindowTitle];
			[self restoreCurrentSelection];
			return YES;
		} else {
			// error during save
			[self restoreCurrentSelection];
			return NO;
		}
	} else {
		//error could not save because of lacking identity
		[self restoreCurrentSelection];
		return NO;
	}
}

- (BOOL)reloadItem
{
	BOOL	retVal;
	id	newItem = [[[item class] alloc] initIdentity:[item identity]];
	[window disableFlushWindow];
	if(newItem != nil) {
		[item free];
		item = newItem;
		[self updateWindow];
		[self setWindowTitle];
		[self resetIconButton];
		[window setDocEdited:NO];
		retVal = YES;
	} else {
		retVal = NO;
	}
	[window reenableFlushWindow];
	[window display];
	return retVal;
}

- (BOOL)revertToSaved
{
	return !iamNew && [[NXApp errorMgr] discardChanges:window] && [self reloadItem];
}

- (BOOL)destroy
{	
	if (!iamNew) {
		id	value = [[NXApp defaultsDB] valueForKey:"alwaysWarnDeletes"];
		if ((value && [value isFalse]) || [[NXApp errorMgr] showDialog:"ReallyDelete" 
							  yesButton:"NO" 
							  noButton:"YES" explain:"DeleteExp"] == EHNO_BUTTON) {
			id	identity = [[item identity] copy];
			if([item deleteAndFree]) {
				[NXApp unregisterDocument:self];
				item = nil;
				[NXApp unlockClass:[self itemClass] identity:identity];
				[self sendDeleted:identity];
				[identity free];
				[self free];
				return YES;
			} else {
				[identity free];
				return NO;
			}
		} else {
			return NO;
		}
	} else {
		[self error:"cannot destroy myself"];
		return NO;
	}
}

- copySpecial:sender
{
	id theCopy;
	if ((item) && [item identity]) {
		theCopy = [item copyAsItemList];
		[[NXApp pasteBoard] pasteItem:theCopy];
	}
	return self;
}


- pasteSpecial:sender
{
	return [self pasteItem:[[NXApp pasteBoard] selectedItem]];
}

- saveCurrentSelection
{
	currentSelectedField = [window firstResponder];
	if ([currentSelectedField respondsTo:@selector(delegate)]) {
		currentSelectedField = [currentSelectedField delegate];
		if (![currentSelectedField isKindOf:[TextField class]]) {
			currentSelectedField = nil;
		}
	} else {
		currentSelectedField = nil;
	}
	return self;
}

- restoreCurrentSelection
{
	if ((currentSelectedField != nil) && ([[currentSelectedField cell] isSelectable]) ){
		[currentSelectedField selectText:self];
	}
	return self;
}

- sendDeleted:identity
{
	[NXApp sendDeletedClass:[[self itemClass] name] identity:[identity str]];
	return self;
}

- sendAdded:identity
{
	[NXApp sendAddedClass:[[self itemClass] name] identity:[identity str]];
	return self;
}

- sendChanged:identity
{
	[NXApp sendChangedClass:[[self itemClass] name] identity:[identity str]];
	return self;
}

- changed:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		if((([[item identity] compareSTR:identitySTR] == 0) || (strcmp(identitySTR,"*")==0)) && [self iWannaUpdate]){
			[self reloadItem];
		}
	}
	return self;
}

- deleted:(const char *)classname :(const char *)identitySTR
{
	if(0==strcmp(classname,[[self itemClass] name])) {
		if([[item identity] compareSTR:identitySTR] == 0){
			[window makeKeyAndOrderFront:self];
			[[NXApp errorMgr] showDialog:"DocumentDeleted"];
			[window setDelegate:nil];
			[window orderOut:self];
			return [self free];
		}
	}
	return self;
}

/* ================================ WINDOW DELEGATE METHODS =============================== */
- windowDidBecomeKey:sender
{
	[NXApp setActiveDocument:self];
	if ([[NXApp userMgr] canDelete:[[self class] name]]) [[NXApp destroyButton] setEnabled: YES];
	if ([[NXApp userMgr] canAdd:[[self class] name]]) [[NXApp newButton] setEnabled:YES];
	
	if ([[NXApp userMgr] canChange:[[self class] name]] || [[NXApp userMgr] canAdd:[[self class] name]] && ![self isReadOnly]) {
		[[NXApp saveButton] setEnabled:YES];
		[[NXApp revertButton] setEnabled:YES];
	}

	[[NXApp findButton] setEnabled:YES];
	return self;
}


- windowWillResize:sender toSize:(NXSize *)frameSize
{
	frameSize->width = MAX((MIN(frameSize->width,maxSize.width)),minSize.width);
	frameSize->height = MAX(MIN(frameSize->height,maxSize.height),minSize.height);
	return self;
}

- windowWillClose:sender
{
	if (![[NXApp errorMgr] discardChanges:window]) {
		return nil;
	}
	[window setDelegate:nil];
	[self free];
	return (id )YES;
}

/* ================================= TEXT DELEGATE METHODS ================================ */
- controlDidChange:sender
{
	IFDEBUG5 {
		if([sender respondsTo:@selector(tag)]) {
			DEBUG5("controlDidChange: senders tag=%d\n",[sender tag]);
		}
	}
	[window setDocEdited:YES];
	return self;
}


- textDidGetKeys:sender isEmpty:(BOOL)flag
{
	[window setDocEdited:YES];
	return self;
}


- item { return item; }

- pasteFile:anItem
{
	if ([item respondsTo:@selector(addAttachment:)]) {
		[item addAttachment:anItem];
		[self updateWindow];
		[window setDocEdited:YES];
		return self;
	} else {
		return nil;
	}
}

- newEditor:sender
{
	if ([self wantsNewComments]) {
		id			printitem;
		id			identity;
		id			today = [Date today];
		id			supplDescription = [today copyAsString];
		id			description = [String str:[[NXApp stringMgr] stringFor:"Comment"]];
		id			data = [String str:""];
	
		identity = [String str:[[self itemClass] name]];
		[identity concatSTR:":Attach:"];
		[identity concatINT:[[item attachmentList] count]];
		[supplDescription concatSTR:" ("];
		[supplDescription concat:[item identity]];
		[supplDescription concatSTR:")"];
		printitem = [[CommentItem alloc] initIdentity:identity 
										  description:description 
										  supplDescription:supplDescription 
										  data:data];
		[item addAttachment:printitem];
		[self save];
		[self reloadItem];
		[[[PrintoutDocument alloc] initItem:[[[item attachmentList] lastObject] copy]] makeActive:self];		
		[today free];
		[printitem free];
		[identity free];
		[description free];
		[supplDescription free];
		[data free];
//		[iconListView reload];
	}
	return self;
}

- attachmentTitleAt:(int)index changedTo:(const char *)newTitle
{
	if ([self wantsNewComments]) {
		id	obj = [[self contentList:self] objectAt:index];
		if ([obj respondsTo:@selector(descriptionEditable)]) {
			if ([obj descriptionEditable]) {
				id	descr = [String str:newTitle];
				[obj setDescription:descr];
				[window setDocEdited:YES];
				return self;
			} else {
				return nil;
			}
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}

- contentList:sender
{
	if ([item respondsTo:@selector(attachmentList)]) {
		return [item attachmentList];
	} else {
		return nil;
	}
}

- showIcons:sender
{
	[iconListView showIcons];
	return self;
}

- showListing:sender
{
	[iconListView showListing];
	return self;
}

- iconListViewDoubleClicked:sender
{
	if ([item respondsTo:@selector(attachmentList)]) {
		[[[item attachmentList] objectAt:[sender tag]] open:self];
		return self;
	} else {
		return nil;
	}
}

- splitView:sender getMinY:(NXCoord *)minY maxY:(NXCoord *)maxY ofSubviewAt:(int)offset
{
	NXRect	splRect;
	[sender getFrame:&splRect];
	*minY = splRect.size.height - gnubbleMinY;
//	*minY = gnubbleMinY;
	gnubbleMaxY = splRect.size.height;
	*maxY = splRect.size.height;
	return self;
}

- windowDidResize:sender
{
	[[splitView adjustSubviews]display];
	[window flushWindow];
	return self;
}

@end

@interface Object(CommentAcceptorItem)
- attachmentList;
- addAttachment:anAttachmentItem;
@end

