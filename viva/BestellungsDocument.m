#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/ScrollView.h>
#import <appkit/TextField.h>

#import "dart/fieldvaluekit.h"

#import "AddressItem.h"
#import "AngebotItemList.h"
#import "ArtikelItemList.h"
#import "ArtikelSelector.h"
#import "AuftragItemList.h"
#import "AuftragsArtikelDocument.h"
#import "AuftragsArtikelList.h"
#import "BestellungItem.h"
#import "BestellungItemList.h"
#import "BestellungsSelector.h"
#import "FileItem.h"
#import "IconListView.h"
#import "KundeItem.h"
#import "KundeItemList.h"
#import "KundenSelector.h"
#import "LayoutManager.h"
#import "PrintRTFItem.h"
#import "PrintoutDocument.h"
#import "StringManager.h"
#import "TextParser.h"
#import "TheApp.h"

#import "BestellungsDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation BestellungsDocument:MasterDocument
{
	id	kundennrField;
	id	kundenNameField;
	id	kundenKategorieField;
	
	id	datumField;
	id	betreuernrPopup;
	
	id	name1Field;
	id	name2Field;
	id	name3Field;
	id	strasseField;
	id	plzortField;
	id	landnrPopup;
	id	faxField;
	id	emailField;
	id	adrBackgroundField;
	
	id	adresseEinsetzenPopup;
	
	id	skontoprozentField;
	id	skontotageField;
	id	zahlungszielField;
	id	tageBackgroundField;
	id	prozentBackgroundField;
	id	adactaSwitch;
	
	id	artikelButton;
	id	kundenButton;
		
	id	artikelView;
	
	id	artikelController;
	
	id	browser;
	id	anrField;
	id	vkField;
	id	anzahlField;
	id	mwstField;
	id	rabattField;
	id	rabattBG1Field;
	id	rabattBG2Field;
	id	endpreisField;
	id	gesamtnettoField;
	id	gesamtnettoBGField;
	id	gesamtbruttoField;
	id	gesamtmwstField;
	id	gesamtpreisSelectedField;
	id	deleteButton;
	id	okButton;
	id	beschreibungText;
	
	id	beschreibungRadio;
	id	beschreibunganzeigenSwitch;
	
	id	mwstberechnenSwitch;
	id	nurgesamtpreisSwitch;
	
	id	kundenName;
	id	kundenKategorie;
}

- itemClass { return [BestellungItem class]; }

- initNib
{
	[super initNib];

	beschreibungText = [[beschreibungText docView] setDelegate:self];
	artikelController = [[AuftragsArtikelDocument alloc] initOwner:self];
	
	[artikelView removeFromSuperview];
	[iconListView removeFromSuperview];
	[splitView addSubview:artikelView];
	[splitView addSubview:iconListView];

	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];
	gnubbleMinY = 199;

	return self;
}

- createNewItem
{
	kundenName = [String str:""];
	kundenKategorie = [String str:""];
	item = [[BestellungItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[BestellungItem alloc] initIdentity:identity];
	[self setKundenNameUndKategorie];
	return self;
}

- free
{
	artikelController = [artikelController free];
	kundenName = [kundenName free];
	kundenKategorie = [kundenKategorie free];
	return [super free];
}

/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	if (![self isReadOnly]) {
		[name1Field selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(datumField);
	SETDISABLED(betreuernrPopup);
	
	SETREADONLYFIELD(name1Field);
	SETREADONLYFIELD(name2Field);
	SETREADONLYFIELD(name3Field);
	SETREADONLYFIELD(strasseField);
	SETREADONLYFIELD(plzortField);
	SETDISABLED(landnrPopup);
	SETREADONLYFIELD(faxField);
	SETREADONLYFIELD(emailField);
	[adrBackgroundField setBackgroundGray:NX_LTGRAY];
	SETDISABLED(adresseEinsetzenPopup);
	
	SETREADONLYFIELD(skontoprozentField);
	SETREADONLYFIELD(skontotageField);
	SETREADONLYFIELD(zahlungszielField);
	[prozentBackgroundField setBackgroundGray:NX_LTGRAY];
	[tageBackgroundField setBackgroundGray:NX_LTGRAY];
	SETDISABLED(adactaSwitch);
	
	SETDISABLED(artikelButton);
	SETDISABLED(kundenButton);
	
	[artikelController setReadOnly];

	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,kundennr,kundennrField);
	WRITEINTOCELL(self,kundenName,kundenNameField);
	WRITEINTOCELL(self,kundenKategorie,kundenKategorieField);
	WRITEINTOCELL(item,datum,datumField);
	WRITEINTOCELL(item,betreuernr,betreuernrPopup);
	WRITEINTOCELL(item,skontoprozent,skontoprozentField);
	WRITEINTOCELL(item,skontotage,skontotageField);
	WRITEINTOCELL(item,zahlungsziel,zahlungszielField);
	WRITEINTOSWITCH(item,mwstberechnen,mwstberechnenSwitch);
	WRITEINTOSWITCH(item,nurgesamtpreis,nurgesamtpreisSwitch);
	WRITEINTORADIO(item,beschreibung,beschreibungRadio);
	WRITEINTOSWITCH(item,beschreibunganzeigen,beschreibunganzeigenSwitch);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	
	[self writeAddressIntoWindow];
	[artikelController writeIntoWindow];
	[iconListView reload];
	
	return self;
}

- writeAddressIntoWindow
{
	id	address = [item adresse];
	
	WRITEINTOCELL(address,name1,name1Field);
	WRITEINTOCELL(address,name2,name2Field);
	WRITEINTOCELL(address,name3,name3Field);
	WRITEINTOCELL(address,strasse,strasseField);
	WRITEINTOCELL(address,plzort,plzortField);
	WRITEINTOCELL(address,landnr,landnrPopup);
	WRITEINTOCELL(address,fax,faxField);
	WRITEINTOCELL(address,email,emailField);
	
	return self;
}

- readFromWindow
{
	READFROMCELL(item,datum,datumField);
	READFROMCELL(item,betreuernr,betreuernrPopup);
	READFROMCELL(item,skontoprozent,skontoprozentField);
	READFROMCELL(item,skontotage,skontotageField);
	READFROMCELL(item,zahlungsziel,zahlungszielField);
	READFROMSWITCH(item,adacta,adactaSwitch);
	
	[self readAddressFromWindow];
	[artikelController readFromWindow];
	
	return self;
}

- readAddressFromWindow
{
	id	address = [item adresse];
	
	READFROMCELL(address,name1,name1Field);
	READFROMCELL(address,name2,name2Field);
	READFROMCELL(address,name3,name3Field);
	READFROMCELL(address,strasse,strasseField);
	READFROMCELL(address,plzort,plzortField);
	READFROMCELL(address,landnr,landnrPopup);
	READFROMCELL(address,fax,faxField);
	READFROMCELL(address,email,emailField);
	
	return self;
}

/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{ 
	return	([anItem isKindOf:[ArtikelItemList class]]) 
		 ||	([anItem isKindOf:[FileItem class]]) 
		 ||	([anItem isKindOf:[BestellungItemList class]] && [anItem isSingle]) 
		 ||	([anItem isKindOf:[AuftragItemList class]] && [anItem isSingle]) 
		 ||	([anItem isKindOf:[AngebotItemList class]] && [anItem isSingle]) 
		 ||	([anItem isKindOf:[KundeItemList class]] && [anItem isSingle]); 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[ArtikelItemList class]]) {
		return [self pasteArtikel:anItem];
	} else if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else if([anItem isKindOf:[BestellungItemList class]] && [anItem isSingle]) {
		return [self pasteBestellung:anItem];
	} else if([anItem isKindOf:[AuftragItemList class]] && [anItem isSingle]) {
		return [self pasteArtikelListOf:anItem];
	} else if([anItem isKindOf:[AngebotItemList class]] && [anItem isSingle]) {
		return [self pasteArtikelListOf:anItem];
	} else if([anItem isKindOf:[KundeItemList class]] && [anItem isSingle]) {
		return [self pasteKunde:anItem];
	} else {
		return nil;
	}
}

- pasteArtikelListOf:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[self readFromWindow];
		[[newItem artikel] reloadEKs];
		[item addAuftragsArtikelList:[newItem artikel]];
		[newItem free];
		[self updateWindow];
		[window setDocEdited:YES];
	} else {
		[NXApp beep:"EmptyItem"];
	}
	
	return self;
}

- pasteBestellung:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[newItem setNr:[item nr]];
		[newItem setAttachmentList:[item attachmentList]];
		[item free];
		item = newItem;
		[newItem setIsNew:iamNew];
		[self setKundenNameUndKategorie];
		[self updateWindow];
		[window setDocEdited:YES];
	} else {
		[NXApp beep:"EmptyItem"];
	}
	
	return self;
}

- pasteKunde:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[self readFromWindow];
		[item setKundennr:[newItem nr]];
		[kundenName free];
		[kundenKategorie free];
		kundenName = [[newItem kname] copy];
		kundenKategorie = [[newItem kategorieStr] copy];
		[item setMwstberechnen:[newItem mwstberechnen]];
		[item setZahlungsziel:[newItem zahlungsziel]];
		[item setSkontotage:[newItem skontotage]];
		[item setSkontoprozent:[newItem skontoprozent]];
		[item setAdresse:[[newItem adressen] objectAt:0]];
		[newItem free];
		[self updateWindow];
		[window setDocEdited:YES];
	} else {
		[NXApp beep:"EmptyItem"];
	}
	
	return self;
}

- pasteArtikel:anItem
{
	[item addArtikelListEK:anItem];
	[artikelController writeIntoWindow];
	[window setDocEdited:YES];
	return self;
}

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[BestellungsSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */

- checkMenus
{
	[super checkMenus];
	[[NXApp printButton] setEnabled:!iamNew];
	return self;
}

- setKundenNameUndKategorie
{
	id	kunde = [[KundeItem alloc] initIdentity:[item kundennr]];
	if(kunde) {
		[kundenName free];
		[kundenKategorie free];
		kundenName = [[kunde kname] copy];
		kundenKategorie = [[kunde kategorieStr] copy];
		[kunde free];
	}
	return self;
}

- adresseEinsetzenPopupClicked:sender
{
	int	adrNr = [[sender selectedCell] tag];
	id	kunde = [[KundeItem alloc] initIdentity:[item kundennr]];
	
	if(kunde) {
		if([[kunde adressen] objectAt:adrNr]) {
			[item setAdresse:[[kunde adressen] objectAt:adrNr]];
			[self writeAddressIntoWindow];
		}
		[kunde free];
	} else {
		[NXApp beep:"NoCustomer"];
	}
		
	return self;
}

- print:sender
{
	id			printitem;
	id			newParser;
	id			identity = [String str:"BestellungItem:Attach:"];
	id			supplDescription = [String str:[[NXApp stringMgr] stringFor:"OrderPrintNr"]];
	id			today = [Date today];
	id			description = [today copyAsString];
	id			data = [[[NXApp layoutMgr] defaultLayoutForBestellung] copy];
	[supplDescription concat:[item nr]];
	[identity concatINT:[[item attachmentList] count]];
		
	newParser = [[TextParser alloc] init];
	[newParser parseString:data withItem:item];

	printitem = [[PrintRTFItem alloc] initIdentity:identity description:description supplDescription:supplDescription data:data];
	
	[item addAttachment:printitem];
	[self save];
	[self updateWindow];
	
	[[[PrintoutDocument alloc]
		initItem:[[[item attachmentList] lastObject] copy]] makeActive:self];
	
	[newParser free];
	[today free];
	[printitem free];
	[identity free];
	[description free];
	[supplDescription free];
	[data free];
	return self;
}

- kundenButtonClicked:sender
{
	[[KundenSelector newInstance] find:sender];
	return self;
}

- artikelButtonClicked:sender
{
	[[ArtikelSelector newInstance] find:sender];
	return self;
}

- mwstberechnenSwitchClicked:sender
{
	READFROMSWITCH(item,mwstberechnen,mwstberechnenSwitch);
	[window setDocEdited:YES];
	return [artikelController mwstberechnenSwitchClicked:sender];
}


- nurgesamtpreisSwitchClicked:sender
{
	[item gesamtpreisUebernehmen];
	READFROMSWITCH(item,nurgesamtpreis,nurgesamtpreisSwitch);
	[window setDocEdited:YES];
	return [artikelController nurgesamtpreisSwitchClicked:sender];
}

- beschreibungRadioClicked:sender
{
	READFROMRADIO(item,beschreibung,beschreibungRadio);
	[window setDocEdited:YES];
	return self;
}

- beschreibunganzeigenSwitchClicked:sender
{
	READFROMSWITCH(item,beschreibunganzeigen,beschreibunganzeigenSwitch);
	return [artikelController beschreibunganzeigenSwitchClicked:sender];
}

- deleteButtonClicked:sender
{
	return [artikelController deleteButtonClicked:sender];
}

- enterPressed:sender
{
	return [artikelController enterPressed:sender];
}


- okButtonClicked:sender
{
	return [artikelController okButtonClicked:sender];
}

- moveSelectionBy:(int)count
{
	if ([artikelController respondsTo:@selector(moveSelectionBy:)]) {
		[artikelController moveSelectionBy:count];
	}
	return self;
}

- (BOOL)savingDisabled { return NO; }
- browser { return browser; }
- anrField { return anrField; }
- vkField { return vkField; }
- anzahlField { return anzahlField; }
- mwstField { return mwstField; }
- rabattField { return rabattField; }
- rabattBG1Field { return rabattBG1Field; }
- rabattBG2Field { return rabattBG2Field; }
- endpreisField { return endpreisField; }
- gesamtnettoField { return gesamtnettoField; }
- gesamtnettoBGField { return gesamtnettoBGField; }
- gesamtbruttoField { return gesamtbruttoField; }
- gesamtmwstField { return gesamtmwstField; }
- gesamtpreisSelectedField { return gesamtpreisSelectedField; }
- deleteButton { return deleteButton; }
- okButton { return okButton; }
- beschreibungText { return beschreibungText; }
- beschreibungRadio { return beschreibungRadio; }
- beschreibunganzeigenSwitch { return beschreibunganzeigenSwitch; }
- mwstberechnenSwitch { return mwstberechnenSwitch; }
- nurgesamtpreisSwitch { return nurgesamtpreisSwitch; }
- kundenName { return kundenName; }
- kundenKategorie { return kundenKategorie; }

@end
