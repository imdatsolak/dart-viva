#import <stdlib.h>
#import <string.h>
#import <ctype.h>

#import <objc/NXStringTable.h>
#import <appkit/Text.h>
#import <appkit/TextField.h>
#import <appkit/Matrix.h>
#import <appkit/NXBrowser.h>

#import "dart/ColumnBrowserCell.h"
#import "dart/dartlib.h"
#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/Localizer.h"
#import "dart/querykit.h"
#import "dart/smartkit/SmarterFields.h"
#import "dart/smartkit/SmarterTFCell.h"

#import "TheApp.h"
#import "ErrorManager.h"

#import "TableEditor.h"

#pragma .h #import <dpsclient/event.h>
#pragma .h #import <objc/Object.h>

@implementation TableEditor:Object
{
    id	editWindow;
    id	browserView;
    id	valueField;
    id	keyField;
    id	saveButton;
    id	revertButton;
	id	deleteButton;
	
	NXSize	minWindowSize;
	id		table;
	id		prototypeValue;
	id		tableNameString;
}



- init
{
	NXRect	winRect;
	
	[super init];
	[[NXApp localizer] loadLocalNib:"TableEditor" owner:self];
	
	[editWindow setDelegate:self];
	
	[editWindow getFrame:&winRect];
	minWindowSize = winRect.size;
	
	[browserView setDelegate:self];
	[browserView setTarget:self];
	[browserView setAction:@selector(browserViewClicked:)];
	[browserView setCellClass:[ColumnBrowserCell class]];
	tableNameString = nil;
	return self;
}


- free
{
	if(prototypeValue) [prototypeValue free];
	tableNameString = [tableNameString free];
	return [super free];
}

- setValueFieldFormat
{
	if([prototypeValue isKindOf:[Integer class]]) {
		[[valueField cell] setFieldType:SMTFC_NUMERIC];
	} else if([prototypeValue isKindOf:[Double class]]) {
		[[valueField cell] setFieldType:SMTFC_CURRENCY];
	} else if([prototypeValue isKindOf:[String class]]) {
		[[[[valueField cell] setFieldType:SMTFC_ALNUM] setAlnumMaxLength:30] setAlnumMinLength:1];
	}
	return self;
}


- editTable:(const char *)tableName
{	
	char	*newTableName;
	
	tableNameString = [String str:tableName];
	
	newTableName = malloc(strlen(tableName)+1);
	strcpy(newTableName,tableName);
	if ((newTableName[0] >= 'a') && (newTableName[0] <= 'z')) {
		newTableName[0] = newTableName[0]-32;
	}
		
	[self unchangedDialog];
	[[editWindow setTitle:newTableName] makeKeyAndOrderFront:self];
	[keyField selectText:self];
	
	[NXApp runModalFor:editWindow];
	
	if(table) [table free];
	free(newTableName);

	return self;
}


- copyOriginalTable
{
	id	originalTable,
		queryString = [[QueryString str:"select key, value from "] concat:tableNameString];

	originalTable = [[NXApp defaultQuery] performQuery:queryString];
	[queryString free];
	
	return originalTable; 
}


- loadTable
{
	if(table) [[table freeObjects] free];
	table = [self copyOriginalTable];
	[table sort];
	if([table count]==0) {
		[self error:"loadTable:table (%s) was empty.", [tableNameString str]];
	}
	if(prototypeValue) [prototypeValue free];
	prototypeValue = [[[table objectAt:0] objectAt:1] copy];	
	[[table removeObjectAt:0] free];
	[self setValueFieldFormat];
	
	return self; 
}

- refreshDialogWindow
{
	[table sort];
	[browserView loadColumnZero];
	[valueField setStringValue:""];
	[keyField setStringValue:""];
	[keyField selectText:self];
	[deleteButton setEnabled:NO];
	return self;
}

- unchangedDialog
{
	[self loadTable];
	[self refreshDialogWindow];
	[revertButton setEnabled:NO];
	[saveButton setEnabled:NO];
	[editWindow setDocEdited:NO];
	return self;
}
	

- browserViewClicked:sender
{
	if( [[sender matrixInColumn:0] selectedCell] ) {
		id	theRow = [table objectAt:[[sender matrixInColumn:0] selectedRow]];
		[[theRow objectAt:0] writeIntoCell:keyField];
		[[theRow objectAt:1] writeIntoCell:valueField];
		[valueField selectText:self];
		[deleteButton setEnabled:YES];
	} else {
		[keyField setStringValue:""];
		[valueField setStringValue:""];
		[keyField selectText:self];
		[deleteButton setEnabled:NO];
	}
	return self;
}

- revertButtonClicked:sender
{
	[self unchangedDialog];
	return self;
}

- saveButtonClicked:sender
{
	int	j, i, found;
	id	string, key, value;
	id	notUsedKeysTable, originalTable = [self copyOriginalTable];
	
	for(i=0; i<[table count]; i++) {
		key = [[table objectAt:i] objectAt:0];
		value = [[table objectAt:i] objectAt:1];
		
		for(j=0, found = 0; !found && (j<[originalTable count]); j++) {
			if(0 == [key compare:[[originalTable objectAt:j] objectAt:0]]) {
				found = 1;
				[[originalTable removeObjectAt:j] free];
			}
		}
		
		if(found) {
			string = [[QueryString str:"update "] concat:tableNameString];
			[[string concatSTR:" set value="] concatField:value];
			[[string concatSTR:" where key="] concatField:key];
		} else {
			string = [[QueryString str:"insert into "] concat:tableNameString];
			[string concatSTR:" values("];
			[string concatFieldComma:key];
			[string concatField:value];
			[string concatSTR:")"];
		}
		
		[[[NXApp defaultQuery] performQuery:string] free];
		[string free];
	}
	
	notUsedKeysTable = [self copyNotUsedKeysTable];
	
	while( [originalTable count] ) {
		key = [[originalTable objectAt:0] objectAt:0];
		
		for(j=0, found = 0; !found && (j<[notUsedKeysTable count]); j++) {
			if(0 == [key compare:[[notUsedKeysTable objectAt:j] objectAt:0]]) {
				found = 1;
				[[notUsedKeysTable removeObjectAt:j] free];
			}
		}
		
		if(found) {
			string = [[QueryString str:"delete from "] concat:tableNameString];
			[[string concatSTR:" where key="] concatField:key];
			[[[NXApp defaultQuery] performQuery:string] free];
			[string free];
		}
		
		[[originalTable removeObjectAt:0] free];
	}
	
	[[originalTable freeObjects] free];
	[[notUsedKeysTable freeObjects] free];
	
	[self unchangedDialog];
	[NXApp sendChangedClass:[[NXApp popupMgr] name] identity:[tableNameString str]];
    return self;
}

- deleteButtonClicked:sender
{
	if([[browserView matrixInColumn:0] selectedCell]) {
		[[table removeObjectAt:[[[browserView matrixInColumn:0] selectedCell] tag]] free];
		[self refreshDialogWindow];
		[editWindow setDocEdited:YES];
		[saveButton setEnabled:YES];
		[revertButton setEnabled:YES];
	}
	
	return self;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	return [table count];
}


- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	theRow = [table objectAt:row];
	[cell setColumnCount:2];
	[cell setTag:row];
	[cell setLength:5 alignment:NX_CENTERED andNumeric:YES ofColumn:0];
	[cell setLength:50 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:1];
	[[theRow objectAt:0] writeIntoCell:cell inColumn:0];
	[[theRow objectAt:1] writeIntoCell:cell inColumn:1];
	[cell setLoaded:YES];
	return self;
}


- clearSelection
{
	[[browserView matrixInColumn:0] selectCellAt:-1 :-1];
	[deleteButton setEnabled:NO];
	return self;
}


- selectInBrowser
{
	int	key = [keyField intValue];
	int	i, count = [table count];
	
	for(i=0; (i<count) && [[[table objectAt:i] objectAt:0] compareInt:key]; i++);

	if( i<count ) {
		[[[browserView matrixInColumn:0] selectCellAt:i :0] scrollCellToVisible:i :0];
		[[[table objectAt:i] objectAt:1] writeIntoCell:valueField];
		[deleteButton setEnabled:YES];
	} else {
		[self clearSelection];
	}
	
	return self;
}


- insertOrUpdate
{
	int	key = [keyField intValue];
	int	i, count = [table count];
	
	for(i=0; (i<count) && [[[table objectAt:i] objectAt:0] compareInt:key]; i++);
	if( i<count ) {
		[[[table objectAt:i] objectAt:1] readFromCell:valueField];
	} else {
		id	newRow = [[QueryResultRow alloc] initCount:2];
		[newRow addObject:[Integer int:key]];
		[newRow addObject:[[prototypeValue copy] readFromCell:valueField]];
		[table addObject:newRow];
	}
	[self refreshDialogWindow];
	[editWindow setDocEdited:YES];
	[saveButton setEnabled:YES];
	[revertButton setEnabled:YES];

	return self;
}


- windowWillResize:sender toSize:(NXSize *)newSize
{
	newSize->width	= MAX(newSize->width,  minWindowSize.width);
	newSize->height	= MAX(newSize->height, minWindowSize.height);
	return self;
}

- windowWillClose:sender
{
	if( ! [self isDocEditedAndWontDiscard] ) {
		[editWindow setDocEdited:NO];
		[NXApp stopModal];
		return self;
	} else {
		return NO;
	}
}


- controlDidChange:sender
{
	DEBUG("controlDidChange\n");
	
	if(sender==[keyField cell]) [self selectInBrowser];
	
	return self;
}

- enterPressed:sender
{
	DEBUG("enterPressed\n");
	
	return [self insertOrUpdate];
}

- (BOOL)isDocEditedAndWontDiscard
{
	return    [editWindow isDocEdited] 
		   && ([[NXApp errorMgr] showDialog:"DISCARD CHANGES" yesButton:"YES" noButton:"NO"]
		        == EHNO_BUTTON);
}


- copyNotUsedKeysTable
{
	id	notUsedTable, string;
	
	DEBUG("copyNotUsedKeysTable\n");
	
	string = [[QueryString str:"select key from "] concat:tableNameString];
	[string concatSTR:" where key!=0"];

	if(0 == [tableNameString compareSTR:"artikelkategorien"]) {
		[string concatSTR:" and key not in (select kategorie from artikel)"];
	} else if(0 == [tableNameString compareSTR:"mwstsaetze"]) {
		[string concatSTR:" and key not in (select mwstsatz from artikel)"];
		[string concatSTR:" and key not in (select mwstsatz from auftragsartikel)"];
	} else if(0 == [tableNameString compareSTR:"mengeneinheiten"]) {
		[string concatSTR:" and key not in (select mengeneinheit from artikel)"];
	} else if(0 == [tableNameString compareSTR:"zugriffsrechte"]) {
		[string concatSTR:" and key not in (select privileg from zugriffe)"];
		[string concatSTR:" and key not in (select zugriff from benutzer)"];
	} else if(0 == [tableNameString compareSTR:"laender"]) {
		[string concatSTR:" and key not in (select landnr from adressen)"];
	} else if(0 == [tableNameString compareSTR:"kundengroesse"]) {
		[string concatSTR:" and key not in (select groesse from kunden)"];
	} else if(0 == [tableNameString compareSTR:"kundenkategorien"]) {
		[string concatSTR:" and key not in (select kategorie from kunden)"];
		[string concatSTR:" and key not in (select kdkategorie from subkonditionen)"];
	} else if(0 == [tableNameString compareSTR:"kundeneinstufung"]) {
		[string concatSTR:" and key not in (select einstufung from kunden)"];
	} else if(0 == [tableNameString compareSTR:"sammelrechnungen"]) {
		[string concatSTR:" and key not in (select sammelrechung from kunden)"];
	} else if(0 == [tableNameString compareSTR:"layoutkategorien"]) {
		[string concatSTR:" and key not in (select kategorie from layout)"];
	} else {
		[self error:"copyNotUsedKeysTable:dubious tableName"];
	}

	notUsedTable = [[NXApp defaultQuery] performQuery:string];
	[string free];
	
	IFDEBUG5 {
		int	i;
		id	string;
		
		printf("copyNotUsedKeysTable:notUsedKeys={");
		for(i=0; i<[notUsedTable count]; i++) {
			string = [[QueryString str:""] concatField:[[notUsedTable objectAt:i] objectAt:0]];
			printf("%s%s",i?",":"",[string str]);
			[string free];
		}
		printf("}\n");
	}
	
	return notUsedTable;
}

@end

