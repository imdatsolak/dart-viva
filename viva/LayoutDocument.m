#import <appkit/Text.h>
#import <appkit/Window.h>

#import "dart/fieldvaluekit.h"
#import "dart/PaletteView.h"

#import "TheApp.h"
#import "StringManager.h"
#import "LayoutItemList.h"
#import "LayoutItem.h"

#import "LayoutDocument.h"

#pragma .h #import "RTFEditor.h"

@implementation LayoutDocument:RTFEditor
{
	id	beschreibungField;
	id	kategoriePopup;
	id	betreuernrPopup;
}

- itemClass { return [LayoutItem class]; }

- createNewItem
{
	item = [[LayoutItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[LayoutItem alloc] initIdentity:identity];
	return self;
}

- checkMenus
{
	[super checkMenus];
	[[NXApp revertButton] setEnabled:[window isDocEdited]];
	return self;
}

- protectFieldsAndSelectText
{
	if(!iamReadOnly) [beschreibungField selectText:self];
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(beschreibungField);
	SETDISABLED(kategoriePopup);
	SETDISABLED(betreuernrPopup);
	[textView setEditable:NO];
	return self;
}

- writeIntoWindow
{

	WRITEINTOCELL(item,beschreibung,beschreibungField);
	WRITEINTOCELL(item,kategorie,kategoriePopup);
	WRITEINTOCELL(item,betreuernr,betreuernrPopup);
	[[item content] writeRTFIntoText:textView];
	return self;
}

- readFromWindow
{
	READFROMCELL(item,beschreibung,beschreibungField);
	READFROMCELL(item,kategorie,kategoriePopup);
	READFROMCELL(item,betreuernr,betreuernrPopup);
	[[item content] readRTFFromText:textView];
	return self;
}

/* ===== OTHER STUFF ================================================================= */
- (BOOL)acceptsItem:anItem
{ 
	return ([super acceptsItem:anItem] ||  [anItem isKindOf:[LayoutItemList class]]); 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[LayoutItemList class]]) {
		return [self pasteLayout:anItem];
	} else if ([super pasteItem:anItem]) {
		return self;
	} else {
		return nil;
	}
}

- pasteLayout:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		WRITEINTOCELL(newItem,beschreibung,beschreibungField);
		WRITEINTOCELL(newItem,kategorie,kategoriePopup);
		WRITEINTOCELL(newItem,betreuernr,betreuernrPopup);
		[[[newItem attachmentList] objectAt:0] writeRTFIntoText:textView];
		[newItem free];
		[self readFromWindow];
		[window setDocEdited:YES];
	} else {
		[NXApp beep:"EmptyItem"];
	}
	
	return self;
}

@end
