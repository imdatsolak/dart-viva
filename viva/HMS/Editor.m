#import "Editor.h"
		
@implementation Editor

- init
{
	return [super init];
}


- initPreText:aString postText:bString title:(const char *)aTitle dataItem:theItem
{
	return [self initPreText:aString artList:nil postText:bString title:aTitle dataItem:theItem mahnung:NO];
}


- initPreText:aString artList:aList postText:bString title:(const char *)aTitle dataItem:theItem
{
	return [self initPreText:aString artList:aList postText:bString title:aTitle dataItem:theItem mahnung:NO];
}

- initMahnung:aString title:(const char *)aTitle dataItem:theItem
{
	return [self initPreText:aString artList:nil postText:nil title:aTitle dataItem:theItem mahnung:YES];
}


- initPreText:aString artList:aList postText:bString title:(const char*)aTitle dataItem:theItem mahnung:(BOOL)flag
{
	[self init];
	[NXApp loadNibFile:"Editor.nib" owner:self];

	preTextStr = [aString copy];
	postTextStr = [bString copy];
	articleList = aList;
	dataItem = [theItem copy];
	editingMahnung = flag;

	[listofarticlesBrowser setCellClass:[ColumnBrowserCell class]];
	[listofarticlesBrowser setDelegate:self];
	[listofarticlesBrowser setTarget:self];
	[listofarticlesBrowser setAction:@selector(selectItem:)];
	withArticles = (aList != nil);
	if (withArticles) {
		usedprologue = prologue;
		usedepilogue = epilogue;
		usedfinishbutton = finishbutton;
		usedWindow = firstWindow;
	} else if (!editingMahnung) {
		usedprologue = prologueOhne;
		usedepilogue = epilogueOhne;
		usedfinishbutton = finishbuttonOhne;
		usedWindow = secondWindow;
	} else {
		usedprologue = mahntext;
		usedepilogue = nil;
		usedfinishbutton = mahnfinishbutton;
		usedWindow = thirdWindow;
	}
	if (myTitle) {
		[myTitle free];
	}
	myTitle = [String str:aTitle];
	if (!preTextStr) {
		preTextStr = [String str:""];
	}
	if (!postTextStr) {
		postTextStr = [String str:""];
	}
	return self;
}


- free
{
	if (dataItem) {
		[dataItem free];
	}
	if (myTitle) {
		[myTitle free];
	}
	if (postTextStr) {
		[postTextStr free];
	}
	if (preTextStr) {
		[preTextStr free];
	}
	return [super free];
}

- run
{
	id 	retVal = nil;
	id	stringParser;
	id	retStr;
	
	if (myTitle) {
		stringParser = [[[StringParser alloc] init] setOwner:self];
		[[usedprologue docView] setDelegate:self];
		[[usedepilogue docView] setDelegate:self];

		[usedWindow setTitle:[myTitle str]];
		retStr = [stringParser parseString:preTextStr];
		if (retStr) {
			[retStr writeIntoText:[usedprologue docView]];
			[retStr free];
		}
		if (postTextStr) {
			retStr = [stringParser parseString:postTextStr];
			if (retStr) {
				[retStr writeIntoText:[usedepilogue docView]];
				[retStr free];
			}
		}
		if (withArticles) {
			[listofarticlesBrowser loadColumnZero];
			[[listofarticlesBrowser matrixInColumn:0] selectCellAt:0:0];
			[self selectItem:self];
			[okbutton setEnabled:NO];
			[upbutton setEnabled:NO];
			[downbutton setEnabled:NO];
			actPos = 0;
		}
		[usedfinishbutton setEnabled:YES];
		if (!(NX_RUNSTOPPED == [NXApp runModalFor:usedWindow])) {
			retVal = self;
		}
		[usedWindow orderOut:self];
		[preTextStr readFromText:[usedprologue docView]];
		if (postTextStr) {
			[postTextStr readFromText:[usedepilogue docView]];
		}
		[stringParser free];
	}		
	return retVal;
}

/* ======================== */
- bruttoForAuftrag
{
	return [dataItem objectWithTag:rech_brutto];
}

- numberForAuftrag
{
	return [dataItem objectWithTag:auf_nr];
}

- dateForAuftrag
{
	return [dataItem objectWithTag:auf_datum];
}

- dateForRechnung
{
	return [dataItem objectWithTag:rech_datum];
}

- numberForRechnung
{
	return [dataItem objectWithTag:print_rechnr];
}

- bruttoForRechnung
{
	return [dataItem objectWithTag:rech_brutto];
}

- skontoProzent
{
	return [dataItem objectWithTag:auf_skontoprozent];
}

- skontoTage
{
	return [dataItem objectWithTag:auf_skontotage];
}

- nettoTage
{
	return [dataItem objectWithTag:auf_nettotage];
}

- bestellNr
{
	return [dataItem objectWithTag:auf_bestellnr];
}

- bestellDatum
{
	return [dataItem objectWithTag:auf_bestelldatum];
}
/* ======================== */


- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	return [articleList count];
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id theRow;
	
	theRow =  [articleList objectAt:row];
	[cell setColumnCount:2];
	[cell setLength:15 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:50 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[[theRow objectWithTag:100]  writeIntoCell:cell inColumn:0];
	[[theRow objectWithTag:200]  writeIntoCell:cell inColumn:1];
	[cell setTag:row];
	return self;
}

- selectItem:sender
{
	actPos = [[sender matrixInColumn:0] selectedRow];
	[downbutton setEnabled:(actPos < [articleList count])];
	[upbutton setEnabled:(actPos >= 0)];
	return self;
}

- selectiondown:sender
{
	[articleList swapObjectAt:actPos+1 withObjectAt:actPos];
	actPos++;
	[downbutton setEnabled:(actPos < [articleList count])];
	[listofarticlesBrowser loadColumnZero];
	[[listofarticlesBrowser matrixInColumn:0] selectCellAt:actPos :0];
    return self;
}

- selectionup:sender
{
	[articleList swapObjectAt:actPos-1 withObjectAt:actPos];
	actPos--;
	[upbutton setEnabled:(actPos >= 0)];
	[listofarticlesBrowser loadColumnZero];
	[[listofarticlesBrowser matrixInColumn:0] selectCellAt:actPos :0];
    return self;
}

- selectionok:sender
{
	[listofarticlesBrowser loadColumnZero];
	actPos = 0;
    return self;
}

- finished:sender
{
	[NXApp stopModal];
    return self;
}

- cancelled:sender
{
	[NXApp abortModal];
	return self;
}

- setPreText:aString
{
	if (preTextStr) {
		[preTextStr free];
	}
	preTextStr = aString;
	return self;
}

- preText
{
	return preTextStr;
}

- setPostText:aString
{
	if (postTextStr) {
		[postTextStr free];
	}
	postTextStr = aString;
	return self;
}

- postText
{
	return postTextStr;
}

- text
{
	return [self preText];
}

- articleList
{
	return articleList;
}


- (BOOL)mahnstufeErhoehen
{
	return [mahnstufeerhoehenSwitch state];
}


- textDidGetKeys:sender isEmpty:(BOOL)flag
{
	[usedfinishbutton setEnabled:YES];
	return self;
}
@end
