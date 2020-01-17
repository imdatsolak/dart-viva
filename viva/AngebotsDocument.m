#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/ScrollView.h>
#import <appkit/TextField.h>

#import "dart/fieldvaluekit.h"

#import "AddressItem.h"
#import "AngebotItem.h"
#import "AngebotItemList.h"
#import "AngebotsSelector.h"
#import "ArtikelItemList.h"
#import "ArtikelSelector.h"
#import "AuftragItem.h"
#import "AuftragItemList.h"
#import "AuftragsArtikelDocument.h"
#import "AuftragsArtikelList.h"
#import "AuftragsDocument.h"
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

#import "AngebotsDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation AngebotsDocument:MasterDocument
{
	id	kundennrField;
	id	kundennameField;
	id	kundenkategorieField;
	
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
	id	konditionenAnpassenButton;
	
	id	beschreibungRadio;
	id	beschreibunganzeigenSwitch;
	
	id	mwstberechnenSwitch;
	id	nurgesamtpreisSwitch;
}

- itemClass { return [AngebotItem class]; }

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
	item = [[AngebotItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[AngebotItem alloc] initIdentity:identity];
	return self;
}

- free
{
	artikelController = [artikelController free];
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
	WRITEINTOCELL(item,kundenname,kundennameField);
	WRITEINTOCELL(item,kundenkategorie,kundenkategorieField);
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
	[self setKonditionenAnpassenButton];
	
	return self;
}

- setKonditionenAnpassenButton
{
	if([self isReadOnly]) {
		[konditionenAnpassenButton setEnabled:NO];
	} else {
		[konditionenAnpassenButton setEnabled:[[item  nurgesamtpreis] isFalse]];
	}
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
		 ||	([anItem isKindOf:[AngebotItemList class]] && [anItem isSingle]) 
		 ||	([anItem isKindOf:[AuftragItemList class]] && [anItem isSingle]) 
		 ||	([anItem isKindOf:[KundeItemList class]] && [anItem isSingle]); 
}

- pasteItem:anItem
{
	if([anItem isKindOf:[ArtikelItemList class]]) {
		return [self pasteArtikel:anItem];
	} else if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else if([anItem isKindOf:[AngebotItemList class]] && [anItem isSingle]) {
		return [self pasteAngebot:anItem];
	} else if([anItem isKindOf:[AuftragItemList class]] && [anItem isSingle]) {
		return [self pasteAuftrag:anItem];
	} else if([anItem isKindOf:[KundeItemList class]] && [anItem isSingle]) {
		return [self pasteKunde:anItem];
	} else {
		return nil;
	}
}

- pasteAngebot:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[newItem setNr:[item nr]];
		[newItem setAttachmentList:[item attachmentList]];
		[item free];
		item = newItem;
		[newItem setIsNew:iamNew];
		[self updateWindow];
		[window setDocEdited:YES];
	} else {
		[NXApp beep:"EmptyItem"];
	}
	
	return self;
}

- pasteAuftrag:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[self readFromWindow];
		[item setKundennr:[newItem kundennr]];
		[item setSkontotage:[newItem skontotage]];
		[item setSkontoprozent:[newItem skontoprozent]];
		[item setZahlungsziel:[newItem zahlungsziel]];
		[item setGesamtpreis:[newItem gesamtpreis]];
		[item setNurgesamtpreis:[newItem nurgesamtpreis]];
		[item setMwst:[newItem mwst]];
		[item setMwstberechnen:[newItem mwstberechnen]];
		[item setArtikel:[newItem artikel]];
		[item setAdresse:[newItem rechnungsAdresse]];
		[[item artikel] clearRechLiefStatus];
		[newItem free];
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
	[item addArtikelListVK:anItem];
	[artikelController writeIntoWindow];
	[window setDocEdited:YES];
	return self;
}

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[AngebotsSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */

- checkMenus
{
	[super checkMenus];
	[[NXApp printButton] setEnabled:!iamNew];
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
		[self controlDidChange:self];
	} else {
		[NXApp beep:"NoCustomer"];
	}
		
	return self;
}

- print:sender
{
	id			printitem;
	id			newParser;
	id			identity = [String str:"AngebotItem:Attach:"];
	id			supplDescription = [String str:[[NXApp stringMgr] stringFor:"OfferPrintNr"]];
	id			today = [Date today];
	id			description = [today copyAsString];
	id			data = [[[NXApp layoutMgr] defaultLayoutForAngebot] copy];
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
	[artikelController mwstberechnenSwitchClicked:sender];
	[self controlDidChange:self];
	return self;
}


- nurgesamtpreisSwitchClicked:sender
{
	[item gesamtpreisUebernehmen];
	READFROMSWITCH(item,nurgesamtpreis,nurgesamtpreisSwitch);
	[self setKonditionenAnpassenButton];
	[artikelController nurgesamtpreisSwitchClicked:sender];
	[self controlDidChange:self];
	return self;
}

- beschreibungRadioClicked:sender
{
	READFROMRADIO(item,beschreibung,beschreibungRadio);
	[self controlDidChange:self];
	return self;
}

- beschreibunganzeigenSwitchClicked:sender
{
	READFROMSWITCH(item,beschreibunganzeigen,beschreibunganzeigenSwitch);
	[artikelController beschreibunganzeigenSwitchClicked:sender];
	[self controlDidChange:self];
	return self;
}

- deleteButtonClicked:sender
{
	[artikelController deleteButtonClicked:sender];
	[self controlDidChange:self];
	return self;
}

- enterPressed:sender
{
	[artikelController enterPressed:sender];
	return self;
}


- okButtonClicked:sender
{
	[artikelController okButtonClicked:sender];
	return self;
}

- konditionenAnpassenButtonClicked:sender
{
	[item konditionenAnpassen];
	[artikelController writeIntoWindow];
	[self controlDidChange:self];
	return self;
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
- konditionenAnpassenButton { return konditionenAnpassenButton; }
- beschreibungRadio { return beschreibungRadio; }
- beschreibunganzeigenSwitch { return beschreibunganzeigenSwitch; }
- mwstberechnenSwitch { return mwstberechnenSwitch; }
- nurgesamtpreisSwitch { return nurgesamtpreisSwitch; }

@end
