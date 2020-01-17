#import <string.h>
#import <appkit/Text.h>
#import <appkit/NXBrowser.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/NiftyMatrix.h"
#import "dart/fieldvaluekit.h"
#import "dart/debug.h"

#import "AngebotItem.h"
#import "AngebotsDocument.h"
#import "ArtikelItemList.h"
#import "AuftragsArtikelItem.h"
#import "AuftragsArtikelList.h"
#import "AuftragsDocument.h"
#import "ImageManager.h"
#import "TheApp.h"

#import "AuftragsArtikelDocument.h"

#pragma .h #import <objc/Object.h>

static const char * const iconNames[] = {"","ecke_ru","ecke_lo","ecke_komplett"};

@implementation AuftragsArtikelDocument:Object
{
	id	owner;
	id	browser;
}

- initOwner:theOwner
{
	[super init];
	
	[[NXApp imageMgr] iconFor:iconNames[1]];
	[[NXApp imageMgr] iconFor:iconNames[2]];
	[[NXApp imageMgr] iconFor:iconNames[3]];
	
	owner = theOwner;
	browser = [owner browser];
	[browser setMatrixClass:[NiftyMatrix class]];
	[browser setDelegate:self];
	[browser setTarget:self];
	[browser setAction:@selector(browserClicked:)];
	[browser setDoubleAction:@selector(browserDoubleClicked:)];
	[browser setCellClass:[ColumnBrowserCell class]];

	return self;
}

- setReadOnly
{
	[[owner konditionenAnpassenButton] setEnabled:NO];
	[[owner beschreibungRadio] setEnabled:NO];
	[[owner mwstberechnenSwitch] setEnabled:NO];
	[[owner nurgesamtpreisSwitch] setEnabled:NO];
	return self;
}

- writeIntoWindow
{
	[[owner window] disableFlushWindow];
	[browser loadColumnZero];
	[[browser matrixInColumn:0] setDelegate:self];
	[self setFieldsNr:nil vk:nil anzahl:nil mwst:nil rabatt:nil gesamtNetto:nil
			beschreibung:nil gesamtpreisSel:nil];
	[self switchOnVk:NO anzahl:NO rabatt:NO beschreibung:NO deleteButton:NO okButton:NO];
	[self setGesamtFields];
	[[owner window] reenableFlushWindow];
	[[owner window] flushWindow];
	return self;
}

- readFromWindow
{
	return self;
}

- mwstberechnenSwitchClicked:sender
{
	return [self writeIntoWindow];
}

- nurgesamtpreisSwitchClicked:sender
{
	[self writeIntoWindow];
	return self;
}

- beschreibunganzeigenSwitchClicked:sender
{
	return self;
}

- deleteButtonClicked:sender
{
	id	list = [self copySelectedItemsList:NO];
	int	i, count = [list count];

	for(i=count-1; i>=0; i--) {
		[[[[owner item] artikel] removeObjectAt:[[list objectAt:i] tag]] free];
	}
	[[list empty] free];
	
	[[[[owner item] artikel] sort] renumber];
	[self writeIntoWindow];
	
	return self;
}

- enterPressed:sender
{
	[self okButtonClicked:sender];
	if(!([owner respondsTo:@selector(gesamtnettoField)] && (sender == [owner gesamtnettoField]))) {
		if([[browser matrixInColumn:0] selectedCell]) {
			int	row = [[[browser matrixInColumn:0] selectedCell] tag];
			if((++row)>=[[[owner item] artikel] count]) row = 0;
			[[browser matrixInColumn:0] selectCellAt:row:0];
			[[browser matrixInColumn:0] scrollCellToVisible:row :0];
			[self browserClicked:self];
		}
	}
	[sender selectText:self];
	return self;
}

- okButtonClicked:sender
{
	id	list = [self copySelectedItemsList:NO];
	int	count = [list count];
	
	if(count==1) {
		int	row = [[list objectAt:0] tag];
		id	artikel = [[[owner item] artikel] objectAt:row];
		if([owner respondsTo:@selector(beschreibungText)]) {
			[[artikel beschreibung] readFromText:[owner beschreibungText]];
		}
		if([owner respondsTo:@selector(anzahlField)]) {
			[[artikel anzahl] readFromCell:[owner anzahlField]];
		}
		if(![[[owner item] nurgesamtpreis] int]) {
			if([owner respondsTo:@selector(vkField)]) {
				[[artikel vk] readFromCell:[owner vkField]];
			}
			if([owner respondsTo:@selector(rabattField)]) {
				[[artikel rabatt] readFromCell:[owner rabattField]];
			}
		}
		[[[browser matrixInColumn:0] cellAt:row:0] setLoaded:NO];
		[self browserClicked:self];
	} else if(count > 1) {
		id	anzahl = nil, rabatt = nil;
		if([owner respondsTo:@selector(anzahlField)]) {
			if(0<strlen([[owner anzahlField] stringValue])) {
				anzahl = [Integer int:0];
				[anzahl readFromCell:[owner anzahlField]];
			}
		}
		if((![[[owner item] nurgesamtpreis] int]) && [owner respondsTo:@selector(rabattField)]) {
			if(0<strlen([[owner rabattField] stringValue])) {
				rabatt = [Double double:0.0];
				[rabatt readFromCell:[owner rabattField]];
			}
		}
		if((rabatt!=nil) || (anzahl!=nil)) {
			int	i;
			for(i=0; i<count; i++) {
				id	artikel = [[[owner item] artikel] objectAt:[[list objectAt:i] tag]];
				if(rabatt) [artikel setRabatt:rabatt];
				if(anzahl) [artikel setAnzahl:anzahl];
				[[[browser matrixInColumn:0] cellAt:[[list objectAt:i] tag]:0] setLoaded:NO];
			}
		}
		[rabatt free];
		[anzahl free];
	}
	
	if([[[owner item] nurgesamtpreis] int]) {
		[[[owner item] gesamtpreis] readFromCell:[owner gesamtnettoField]];
	}
	
	[[list empty] free];
	[browser displayColumn:0];
	[self setGesamtFields];
	return self;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	DEBUG10("AuftragsArtikelDocument:browser:fillMatrix:inColumn: --> %d\n",[[[owner item] artikel] count]);
	return [[[owner item] artikel] count];
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id		artikel = [[[owner item] artikel] objectAt:row];
	int		iconNr = 0;
	
	DEBUG10("AuftragsArtikelDocument:browser:loadCell:atRow:%d inColumn:%d\n",row,column);
	
	[cell setColumnCount:7];
	[cell setDistance:0.0];
	[cell setLength:16 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:8 alignment:NX_RIGHTALIGNED andNumeric:NO ofColumn:1];
	[cell setLength:3 alignment:NX_CENTERED andNumeric:NO ofColumn:2];
	[cell setLength:4 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:3];
	[cell setLength:4 alignment:NX_RIGHTALIGNED andNumeric:NO ofColumn:4];
	[cell setLength:4 alignment:NX_RIGHTALIGNED andNumeric:NO ofColumn:5];
	[cell setLength:9 alignment:NX_RIGHTALIGNED andNumeric:NO ofColumn:6];

	if([artikel istInRechnungGestellt]) iconNr += 2;
	if([artikel istGeliefert]) iconNr += 1;
	if(iconNr) [cell setIcon:iconNames[iconNr]];

	if([[[owner item] nurgesamtpreis] int]) {
		[[artikel nr] writeIntoCell:cell inColumn:0];
		[[artikel vk] writeIntoCell:cell inColumn:1];
		[[artikel anzahl] writeIntoCell:cell inColumn:2];
		[[artikel mengeneinheitstr] writeIntoCell:cell inColumn:3];
	} else {
		[[artikel nr] writeIntoCell:cell inColumn:0];
		[[artikel vk] writeIntoCell:cell inColumn:1];
		[[artikel anzahl] writeIntoCell:cell inColumn:2];
		[[artikel mengeneinheitstr] writeIntoCell:cell inColumn:3];
		[[artikel rabatt] writeIntoCell:cell inColumn:4];
		if([[[owner item] mwstberechnen] int]) {
			[[artikel mwst] writeIntoCell:cell inColumn:5];
		}
		[cell setDoubleValue:[artikel nettoPreisDouble] ofColumn:6];
	}
	
	[cell setTag:row];
	[cell setLoaded:YES];

	return self;
}

- copySelectedItemsList:(BOOL)allCells
{
	id	list = [[List alloc] init];
	[[browser matrixInColumn:0] sendAction:@selector(addObject:) to:list forAllCells:allCells];
	return list;
}

- browserClicked:sender
{
	id	list = [self copySelectedItemsList:NO];
	int	count = [list count];
	
	DEBUG1("AuftragsArtikelDocument:browserClicked:(entry)\n");
	
	[[owner window] disableFlushWindow];
	
	if( count == 0 ) {
		[self setFieldsNr:nil vk:nil anzahl:nil mwst:nil rabatt:nil gesamtNetto:nil
			  beschreibung:nil gesamtpreisSel:nil];
		[self switchOnVk:NO anzahl:NO rabatt:NO beschreibung:NO deleteButton:NO okButton:NO];
	} else if( count == 1 ) {
		id	artikel = [[[owner item] artikel] objectAt:[[list objectAt:0] tag]];
		id	nettoPreis = [Double double:[artikel nettoPreisDouble]];
		[self setFieldsNr:[artikel nr] vk:[artikel vk] anzahl:[artikel anzahl]
			  mwst:[artikel mwst] rabatt:[artikel rabatt]
			  gesamtNetto:nettoPreis beschreibung:[artikel beschreibung]
			  gesamtpreisSel:nettoPreis];
		[self switchOnVk:YES anzahl:YES rabatt:YES beschreibung:YES deleteButton:YES okButton:YES];
		[nettoPreis free];
	} else {
		id	d = [Double double:0.0];
		int	i;
		for(i=0; i<count; i++) {
			id	artikel = [[[owner item] artikel] objectAt:[[list objectAt:i] tag]];
			[d addDouble:[artikel nettoPreisDouble]];
		}
		[self setFieldsNr:nil vk:nil anzahl:nil mwst:nil rabatt:nil gesamtNetto:nil
			  beschreibung:nil gesamtpreisSel:d];
		[d free];
		[self switchOnVk:NO anzahl:YES rabatt:YES beschreibung:NO deleteButton:YES okButton:YES];
	}
	
	[[list empty] free];
	
	DEBUG1("AuftragsArtikelDocument:browserClicked:(reenableFlushWindow)\n");
	[[owner window] reenableFlushWindow];
	DEBUG1("AuftragsArtikelDocument:browserClicked:(flushWindow)\n");
	[[owner window] flushWindow];
	DEBUG1("AuftragsArtikelDocument:browserClicked:(exit)\n");
	
	return self;
}

- browserDoubleClicked:sender
{
	int	i;
	id	list = [self copySelectedItemsList:NO];
	id	artikelitemlist = [[ArtikelItemList alloc] init];
	DEBUG1("AuftragsArtikelDocument:browserDoubleClicked:(entry)\n");
	for(i=0; i<[list count]; i++) {
		id	artikel = [[[owner item] artikel] objectAt:[[list objectAt:0] tag]];
		[artikelitemlist addObject:[[artikel nr] copy]];
	}
	[[list empty] free];
	if([artikelitemlist count]>0) {
		[artikelitemlist open:self];
	}
	[artikelitemlist free];
	return self;
}

- cellMovedFrom:(unsigned)oldPos to:(unsigned)newPos
{
	int	i, count = [[browser matrixInColumn:0] cellCount];
	for(i=0; i<count; i++) {
		[[[browser matrixInColumn:0] cellAt:i:0] setTag:i];
	}
	
	[[[owner item] artikel] moveObjectFrom:oldPos to:newPos];

	return self;
}

- setFieldsNr:nr vk:vk anzahl:anzahl mwst:mwst rabatt:rabatt gesamtNetto:gesamtNetto beschreibung:beschreibung gesamtpreisSel:gesamtpreisSel
{
	if([owner respondsTo:@selector(anrField)]) {
		if(nr) [nr writeIntoCell:[owner anrField]];
		else [[owner anrField] setStringValue:""];
	}
	if([owner respondsTo:@selector(anzahlField)]) {
		if(anzahl) [anzahl writeIntoCell:[owner anzahlField]];
		else [[owner anzahlField] setStringValue:""];
	}
	if([owner respondsTo:@selector(beschreibungText)]) {
		if(beschreibung) [beschreibung writeIntoText:[owner beschreibungText]];
		else [[owner beschreibungText] setText:""];
	}
	if([owner respondsTo:@selector(vkField)]) {
		if(vk && (![[[owner item] nurgesamtpreis] int])) {
			[vk writeIntoCell:[owner vkField]];
		} else {
			[[owner vkField] setStringValue:""];
		}
	}
	if([owner respondsTo:@selector(mwstField)]) {
		if(mwst && ![[[owner item] nurgesamtpreis] int] && [[[owner item] mwstberechnen] int]) {
			[mwst writeIntoCell:[owner mwstField]];
		} else {
			[[owner mwstField] setStringValue:""];
		}
	}
	if([owner respondsTo:@selector(rabattField)]) {
		if(rabatt && (![[[owner item] nurgesamtpreis] int])) {
			[rabatt writeIntoCell:[owner rabattField]];
		} else {
			[[owner rabattField] setStringValue:""];
		}
	}
	if([owner respondsTo:@selector(endpreisField)]) {
		if(gesamtNetto && (![[[owner item] nurgesamtpreis] int])) {
			[gesamtNetto writeIntoCell:[owner endpreisField]];
		} else {
			[[owner endpreisField] setStringValue:""];
		}
	}
	if([owner respondsTo:@selector(gesamtpreisSelectedField)]) {
		if(gesamtpreisSel && (![[[owner item] nurgesamtpreis] int])) {
			[gesamtpreisSel writeIntoCell:[owner gesamtpreisSelectedField]];
		} else {
			[[owner gesamtpreisSelectedField] setStringValue:""];
		}
	}
	return self;
}
	
- switchOnVk:(BOOL)vk anzahl:(BOOL)anzahl rabatt:(BOOL)rabatt beschreibung:(BOOL)beschreibung deleteButton:(BOOL)deleteButton okButton:(BOOL)okButton
{
	BOOL	gesamtnetto;
	
	if([owner isReadOnly] || [owner savingDisabled]) {
		vk = anzahl = rabatt = beschreibung = deleteButton = okButton = gesamtnetto = NO;
	} else {
		if([[[owner item] nurgesamtpreis] int]) {
			vk = rabatt = NO;
			okButton = YES;
			gesamtnetto = YES;
		} else {
			gesamtnetto = NO;
		}
	}
	
	if([owner respondsTo:@selector(vkField)]) {
		[[owner vkField] setEditable:vk];
		[[owner vkField] setBackgroundGray:vk?NX_WHITE:NX_LTGRAY];
	}
	if([owner respondsTo:@selector(rabattBG1Field)]) {
		[[owner rabattBG1Field] setBackgroundGray:rabatt?NX_WHITE:NX_LTGRAY];
	}
	if([owner respondsTo:@selector(rabattBG2Field)]) {
		[[owner rabattBG2Field] setBackgroundGray:rabatt?NX_WHITE:NX_LTGRAY];
	}
	if([owner respondsTo:@selector(rabattField)]) {
		[[owner rabattField] setEditable:rabatt];
		[[owner rabattField] setBackgroundGray:rabatt?NX_WHITE:NX_LTGRAY];
	}
	if([owner respondsTo:@selector(beschreibungText)]) {
		[[owner beschreibungText] setEditable:beschreibung];
		[[owner beschreibungText] setBackgroundGray:beschreibung?NX_WHITE:NX_LTGRAY];
		[[owner beschreibungText] display];
	}
	if([owner respondsTo:@selector(deleteButton)]) {
		[[owner deleteButton] setEnabled:deleteButton];
	}
	if([owner respondsTo:@selector(okButton)]) {
		[[owner okButton] setEnabled:okButton];
	}
	if([owner respondsTo:@selector(gesamtnettoBGField)]) {
		[[owner gesamtnettoBGField] setBackgroundGray:gesamtnetto?NX_WHITE:NX_LTGRAY];
	}
	if([owner respondsTo:@selector(gesamtnettoField)]) {
		[[owner gesamtnettoField] setEditable:gesamtnetto];
		[[owner gesamtnettoField] setBackgroundGray:gesamtnetto?NX_WHITE:NX_LTGRAY];
	}
	if([owner respondsTo:@selector(anzahlField)]) {
		[[owner anzahlField] setEditable:anzahl];
		[[owner anzahlField] setBackgroundGray:anzahl?NX_WHITE:NX_LTGRAY];
		if(anzahl) [[owner anzahlField] selectText:self];
	}
	return self;
}

- setGesamtFields
{
	if([owner respondsTo:@selector(gesamtmwstField)]) {
		[[owner gesamtmwstField] setDoubleValue:[[owner item] mwstDouble]];
	}
	if([owner respondsTo:@selector(gesamtbruttoField)]) {
		[[owner gesamtbruttoField] setDoubleValue:[[owner item] bruttoPreisDouble]];
	}
	if([owner respondsTo:@selector(gesamtnettoField)]) {
		[[owner gesamtnettoField] setDoubleValue:[[owner item] nettoPreisDouble]];
		if([[[owner item] nurgesamtpreis] int] && ![owner isReadOnly] && ![owner savingDisabled]) {
			[[owner gesamtnettoField] selectText:self];
		}
	}
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

- copySelectedArtikelList
{
	id	list = [self copySelectedItemsList:NO];
	int	i;
	id	alist = [[AuftragsArtikelList alloc] initNew];
	
	for(i=0; i<[list count]; i++) {
		[alist addAuftragsArtikel:[[[owner item] artikel] objectAt:[[list objectAt:i] tag]]];
	}
	[list free];
	return alist;
}

@end

