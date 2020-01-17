#import "ArtikelKondDocument.h"


@implementation ArtikelKondDocument


- (int)tag
{
	return rab_menge;
}

- initOwner:theOwner readOnly:(BOOL)readOnly
{
	[super init];
	owner = theOwner;
	browserView = [owner kondBrowser];
	kategoriePopUp = [owner kondKundenKategoriePopUp];
	mengenField = [owner kondMengenField];
	gesamtRadio = [owner kondGesamtRadio];
	rabattRadio = [owner kondRabattRadio];
	rabattField = [owner kondRabattField];
	deleteButton = [owner kondDeleteButton];
	okButton = [owner kondOkButton];

	[browserView setDelegate:self];
	[browserView setTarget:self];
	[browserView setAction:@selector(browserViewClicked:)];
	[browserView setCellClass:[ColumnBrowserCell class]];
	
	konditionen = [[ArtikelKonditionenItem alloc] init];
	
	[gesamtRadio setEnabled:NO];
	
	iamReadOnly = readOnly;
		
	[self refreshDialogWindow];
	return self;
}


- free
{
	[konditionen free];
	return [super free];
}


- konditionen
{
	DEBUG10("ArtikelKondDocument:konditionen\n");
	return konditionen;
}

- setKonditionen:theConds
{
	DEBUG10("ArtikelKondDocument:setKonditionen\n");
	[konditionen free];
	konditionen = [theConds copy];
	[self refreshDialogWindow];
	return self;
}

- clearFields
{
	[kategoriePopUp setIntValue:0];
	[mengenField  setIntValue:0];
	[gesamtRadio selectCellWithTag:(int)'J'];
	[rabattRadio selectCellWithTag:(int)'N'];
	[rabattField setStringValue:"0,0"];
	[deleteButton setEnabled:NO];
	
	if(iamReadOnly) {
		[kategoriePopUp setEnabled:NO];
		[[[mengenField  setEditable:NO] setSelectable:YES] setBackgroundGray:NX_LTGRAY];
		[rabattRadio setEnabled:NO];
		[[[rabattField setEditable:NO] setSelectable:YES] setBackgroundGray:NX_LTGRAY];
		[okButton setEnabled:NO];
	}
	return self;
}


- refreshDialogWindow
{
	[konditionen sort];
	[browserView loadColumnZero];
	[self clearFields];
	return self;
}


- browserViewClicked:sender
{
	if( [[sender matrixInColumn:0] selectedCell] ) {
		id	theRow = [konditionen itemAt:[[sender matrixInColumn:0] selectedRow]];
		[[theRow objectWithTag:kd_kategorie] writeIntoCell:kategoriePopUp];
		[[theRow objectWithTag:rab_menge] writeIntoCell:mengenField];
		[gesamtRadio selectCellWithTag:[[theRow objectWithTag:rab_proauftrag] charAt:0]];
		[[theRow objectWithTag:rab_rabatt] writeIntoCell:rabattField];
		[rabattRadio selectCellWithTag:[[theRow objectWithTag:rab_istsonderpreis] charAt:0]];
		[mengenField selectText:self];
		[deleteButton setEnabled:!iamReadOnly];
	} else {
		[self clearFields];
	}
	return self;
}


- deleteButtonClicked:sender
{
	if([[browserView matrixInColumn:0] selectedCell]) {
		[[konditionen removeItemAt:[[[browserView matrixInColumn:0] selectedCell] tag]] free];
		[self refreshDialogWindow];
		[owner controlDidChange:self];
	}
	
	return self;
}

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
	DEBUG10("ArtikelKondDocument:browser:fillMatrix:inColumn:\n");
	DEBUG10("[konditionen itemCount] == %d\n",[konditionen itemCount]);
	return [konditionen itemCount];
}


- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
	id	theRow = [konditionen itemAt:row];

	DEBUG10("ArtikelKondDocument:browser:loadCell:atRow:%d inColumn:\n",row);
	
	[cell setColumnCount:5];
	[cell setTag:row];
	[cell setLength:16 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:0];
	[cell setLength:7 alignment:NX_CENTERED andNumeric:YES ofColumn:1];
	[cell setLength:10 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:2];
	[cell setLength:8 alignment:NX_LEFTALIGNED andNumeric:NO ofColumn:3];
	[cell setLength:12 alignment:NX_RIGHTALIGNED andNumeric:YES ofColumn:4];
	[[theRow objectWithTag:rab_menge] writeIntoCell:cell inColumn:1];
	[[theRow objectWithTag:rab_rabatt] writeIntoCell:cell inColumn:4];
	[cell setStringValue:[[theRow objectWithTag:rab_istsonderpreis] charAt:0]=='J'?
							[[NXApp stringHandler] stringFor:"Sonderpreis DM"] :
							[[NXApp stringHandler] stringFor:"Rabatt %"]
			ofColumn:3];
	[cell setStringValue:[[theRow objectWithTag:rab_proauftrag] charAt:0]=='J'?
							[[NXApp stringHandler] stringFor:"pro Auftrag"] :
							[[NXApp stringHandler] stringFor:"insgesamt"]
			ofColumn:2];
	[cell setStringValue:[kategoriePopUp titleForInt:[[theRow objectWithTag:kd_kategorie] int]]
			ofColumn:0];

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
	int	row = [konditionen indexOfKondForKategorie:[kategoriePopUp intValue] menge:[mengenField intValue]];
	id	theRow;
	
	if(row != -1) {
		[[[browserView matrixInColumn:0] selectCellAt:row :0] scrollCellToVisible:row :0];
		theRow = [konditionen itemAt:[[browserView matrixInColumn:0] selectedRow]];
		[[theRow objectWithTag:kd_kategorie] writeIntoCell:kategoriePopUp];
		[[theRow objectWithTag:rab_menge] writeIntoCell:mengenField];
		[gesamtRadio selectCellWithTag:[[theRow objectWithTag:rab_proauftrag] charAt:0]];
		[[theRow objectWithTag:rab_rabatt] writeIntoCell:rabattField];
		[gesamtRadio selectCellWithTag:[[theRow objectWithTag:rab_istsonderpreis] charAt:0]];
		[deleteButton setEnabled:!iamReadOnly];
	} else {
		[self clearSelection];
	}
	
	return self;
}


- insertOrUpdate
{
	[konditionen insertOrUpdateKategorie:[kategoriePopUp intValue]
	             menge:[mengenField intValue]
				 proAuftrag:[[gesamtRadio selectedCell] tag]
				 istSonderPreis:[[rabattRadio selectedCell] tag]
				 rabatt:[rabattField doubleValue]];

	[self refreshDialogWindow];
	[owner controlDidChange:self];

	return self;
}


- okButtonClicked:sender
{
	DEBUG1("konditionenController:okButtonClicked\n");
	
	return [self insertOrUpdate];
}

@end

