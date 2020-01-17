#import <appkit/Button.h>
#import <appkit/Matrix.h>
#import <appkit/ScrollView.h>
#import <appkit/TextField.h>

#import "dart/fieldvaluekit.h"
#import "dart/debug.h"

#import "AddressItem.h"
#import "AngebotItem.h"
#import "AngebotItemList.h"
#import "AngebotsDocument.h"
#import "ArtikelItemList.h"
#import "ArtikelSelector.h"
#import "AuftragItem.h"
#import "AuftragItemList.h"
#import "AuftragsArtikelDocument.h"
#import "AuftragsArtikelList.h"
#import "AuftragsSelector.h"
#import "ErrorManager.h"
#import "FileItem.h"
#import "IconListView.h"
#import "KundeItem.h"
#import "KundeItemList.h"
#import "KundenSelector.h"
#import "LayoutManager.h"
#import "LieferscheinDocument.h"
#import "LieferscheinItem.h"
#import "PrintRTFItem.h"
#import "PrintoutDocument.h"
#import "RechnungItem.h"
#import "RechnungsDocument.h"
#import "StringManager.h"
#import "TextParser.h"
#import "TheApp.h"

#import "AuftragsDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation AuftragsDocument:MasterDocument
{
	id	kundennrField;
	id	kundennameField;
	id	kundenkategorieField;
	
	id	datumField;
	id	betreuernrPopup;
	id	bestelldatumField;
	id	bestellnrField;
	id	lieferdatumField;
	id	lieferdatumBackgroundField;
	
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
	id	skontoTageBGField;
	id	skontoProzentBG1Field;
	id	skontoProzentBG2Field;
	id	mahnzeit1Field;
	id	mahnzeit2Field;
	id	mahnzeit3Field;
	id	adactaSwitch;	
	
	id	artikelButton;
	id	kundenButton;
	
	id	neueRechnungButton;
	id	neuerLieferscheinButton;
	
	id	artikelView;
	id	iconListGroupView;
	
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
	
	int	shownAddressIndex;
	BOOL	savingDisabled;
	BOOL	keineRechOderLief;
}

- itemClass { return [AuftragItem class]; }

- initNib
{
	[super initNib];

	beschreibungText = [[beschreibungText docView] setDelegate:self];
	artikelController = [[AuftragsArtikelDocument alloc] initOwner:self];
	
	[artikelView removeFromSuperview];
	[iconListGroupView removeFromSuperview];
	[splitView addSubview:artikelView];
	[splitView addSubview:iconListGroupView];

	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];

	shownAddressIndex = 0;
	savingDisabled = NO;
	keineRechOderLief = NO;
	gnubbleMinY = 200;

	return self;
}

- createNewItem
{
	item = [[AuftragItem alloc] initNew];
	keineRechOderLief = [item keineRechOderLief];
	shownAddressIndex = 0;
	return self;
}

- createIdentityItem:identity
{
	item = [[AuftragItem alloc] initIdentity:identity];
	keineRechOderLief = [item keineRechOderLief];
	shownAddressIndex = 0;
	return self;
}

- free
{
	artikelController = [artikelController free];
	return [super free];
}

- (BOOL)iWannaUpdate
{
	return [self isReadOnly] || [self savingDisabled];
}

/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	if (![self isReadOnly] && ![self savingDisabled]) {
		[name1Field selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETDISABLED(betreuernrPopup);
	SETREADONLYFIELD(bestelldatumField);
	SETREADONLYFIELD(bestellnrField);
	SETREADONLYFIELD(lieferdatumField);
	[lieferdatumBackgroundField setBackgroundGray:NX_LTGRAY];
	
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
	[skontoTageBGField setBackgroundGray:NX_LTGRAY];
	[skontoProzentBG1Field setBackgroundGray:NX_LTGRAY];
	[skontoProzentBG2Field setBackgroundGray:NX_LTGRAY];
	SETREADONLYFIELD(mahnzeit1Field);
	SETREADONLYFIELD(mahnzeit2Field);
	SETREADONLYFIELD(mahnzeit3Field);
	SETDISABLED(adactaSwitch);
	
	[artikelController setReadOnly];
	return self;
}

- setReadOnlyIfRechnungOderLieferschein
{
	if([self isReadOnly]) {
		[neueRechnungButton setEnabled:NO];
		[neuerLieferscheinButton setEnabled:NO];	
	} else {
		if([[item artikel] existiertRechnungOderLieferschein]) {
			[self setReadOnly];
			savingDisabled = YES;
		} else {
			savingDisabled = NO;
		}
		[neueRechnungButton setEnabled:YES];
		[neuerLieferscheinButton setEnabled:YES];	
	}
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

- writeIntoWindow
{
	WRITEINTOCELL(item,kundennr,kundennrField);
	WRITEINTOCELL(item,kundenname,kundennameField);
	WRITEINTOCELL(item,kundenkategorie,kundenkategorieField);
	
	WRITEINTOCELL(item,datum,datumField);
	WRITEINTOCELL(item,betreuernr,betreuernrPopup);
	WRITEINTOCELL(item,bestelldatum,bestelldatumField);
	WRITEINTOCELL(item,bestellnr,bestellnrField);
	WRITEINTOCELL(item,lieferdatum,lieferdatumField);
	
	WRITEINTOCELL(item,skontoprozent,skontoprozentField);
	WRITEINTOCELL(item,skontotage,skontotageField);
	WRITEINTOCELL(item,zahlungsziel,zahlungszielField);
	WRITEINTOCELL(item,mahnzeit1,mahnzeit1Field);
	WRITEINTOCELL(item,mahnzeit2,mahnzeit2Field);
	WRITEINTOCELL(item,mahnzeit3,mahnzeit3Field);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	
	WRITEINTORADIO(item,beschreibung,beschreibungRadio);
	WRITEINTOSWITCH(item,beschreibunganzeigen,beschreibunganzeigenSwitch);
	WRITEINTOSWITCH(item,mwstberechnen,mwstberechnenSwitch);
	WRITEINTOSWITCH(item,nurgesamtpreis,nurgesamtpreisSwitch);
	
	[self writeAddressIntoWindow];
	[artikelController writeIntoWindow];
	[iconListView reload];
	
	[self setReadOnlyIfRechnungOderLieferschein];
	
	return self;
}

- writeAddressIntoWindow
{
	id	address = [[item adressen] objectAt:shownAddressIndex];
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
	READFROMCELL(item,bestelldatum,bestelldatumField);
	READFROMCELL(item,bestellnr,bestellnrField);
	READFROMCELL(item,lieferdatum,lieferdatumField);
	
	READFROMCELL(item,skontoprozent,skontoprozentField);
	READFROMCELL(item,skontotage,skontotageField);
	READFROMCELL(item,zahlungsziel,zahlungszielField);
	READFROMCELL(item,mahnzeit1,mahnzeit1Field);
	READFROMCELL(item,mahnzeit2,mahnzeit2Field);
	READFROMCELL(item,mahnzeit3,mahnzeit3Field);
	READFROMSWITCH(item,adacta,adactaSwitch);
	
	[self readAddressFromWindow];
	[artikelController readFromWindow];
	return self;
}

- readAddressFromWindow
{
	id	address = [[item adressen] objectAt:shownAddressIndex];
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
	return	([anItem isKindOf:[FileItem class]])
		||	(	!savingDisabled
			&&	(		([anItem isKindOf:[ArtikelItemList class]]) 
					||	([anItem isKindOf:[AuftragItemList class]] && [anItem isSingle]) 
					||	([anItem isKindOf:[AngebotItemList class]] && [anItem isSingle]) 
					||	([anItem isKindOf:[KundeItemList class]] && [anItem isSingle])));
}

- pasteItem:anItem
{
	if([anItem isKindOf:[ArtikelItemList class]]) {
		return [self pasteArtikel:anItem];
	} else if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else if([anItem isKindOf:[AuftragItemList class]] && [anItem isSingle]) {
		return [self pasteAuftrag:anItem];
	} else if([anItem isKindOf:[AngebotItemList class]] && [anItem isSingle]) {
		return [self pasteAngebot:anItem];
	} else if([anItem isKindOf:[KundeItemList class]] && [anItem isSingle]) {
		return [self pasteKunde:anItem];
	} else {
		return nil;
	}
}

- pasteAuftrag:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[newItem setNr:[item nr]];
		[newItem setAttachmentList:[item attachmentList]];
		[[newItem artikel] clearRechLiefStatus];
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

- pasteAngebot:anItem
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
		[item setRechnungsAdresse:[newItem adresse]];
		[item setLieferAdresse:[newItem adresse]];
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
		[item setRechnungsAdresse:[[newItem adressen] objectAt:0]];
		[item setLieferAdresse:[[newItem adressen] objectAt:0]];
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
	[[AuftragsSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */

- checkMenus
{
	[super checkMenus];
	[[NXApp printButton] setEnabled:!iamNew];
	[[NXApp saveButton] setEnabled:!savingDisabled];
	[[NXApp destroyButton] setEnabled:keineRechOderLief];
	return self;
}

- adresseEinsetzenPopupClicked:sender
{
	int	adrNr = [[sender selectedCell] tag];
	id	kunde = [[KundeItem alloc] initIdentity:[item kundennr]];
	
	if(kunde) {
		if([[kunde adressen] objectAt:adrNr]) {
			if(shownAddressIndex==0) {
				[item setRechnungsAdresse:[[kunde adressen] objectAt:adrNr]];
			} else {
				[item setLieferAdresse:[[kunde adressen] objectAt:adrNr]];
			}
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
	id			identity = [String str:"AuftragItem:Attach:"]; 
	id			supplDescription = [String str:[[NXApp stringMgr] stringFor:"InvDSMasterPrintNr"]];
	id			today = [Date today];
	id			description = [today copyAsString];
	id			data = [[[NXApp layoutMgr] defaultLayoutForAuftrag] copy];
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

- addressPopupClicked:sender
{
	BOOL docWasEdited = [window isDocEdited];
	if(docWasEdited) [self readAddressFromWindow];
	shownAddressIndex = [[sender selectedCell] tag];
	[self writeAddressIntoWindow];
	[window setDocEdited:docWasEdited];
	return self;
}

- (BOOL)checkIfKundeDa
{
	if(![KundeItem exists:[item kundennr]]) {
		[[NXApp errorMgr] showDialog:"NoCustomerSelected"];
		return NO;
	} else {
		return YES;
	}
}

- neueRechnungButtonClicked:sender
{
	id	artikellist;
	double	netto, mwst;
	
	if(!savingDisabled && [window isDocEdited]) {
		if(![self save]) return self;
	}
	
	if(![self checkIfKundeDa]) {
		return self;
	}
	
	if([[item nurgesamtpreis] int]) {
		artikellist = [[item artikel] copy];
		netto = [item nettoPreisDouble];
		mwst = [item mwstDouble];
	} else {
		artikellist = [artikelController copySelectedArtikelList];
		netto = [artikellist nettoPreisDouble];
		mwst = [artikellist mwstDouble];
	}
	
	if([artikellist count]) {
		if([artikellist alleNochNichtInRechnung]) {
			id	rech = [RechnungItem neueRechnung:artikellist auftrag:item netto:netto mwst:mwst];
			if(rech != nil) {
				[[[[RechnungsDocument alloc] initItem:rech]
											makeActive:self]
											sendChanged:[rech identity]];
				[self sendChanged:[item identity]];
				[NXApp sendChangedClass:"Kundenkonto" identity:[[item kundennr] str]];
				[self reloadItem];
			} else {
				[[NXApp errorMgr] showDialog:"ErrorOnInvoiceCreation"];
			}
		} else {
			[[NXApp errorMgr] showDialog:"ArticleAlreadyInInvoice"];
		}
	} else {
		[[NXApp errorMgr] showDialog:"NoArticlesSelected"];
	}
	[artikellist free];
	return self;
}

- neuerLieferscheinButtonClicked:sender
{
	id	artikellist;
	
	if(!savingDisabled && [window isDocEdited]) {
		if(![self save]) return self;
	}
	
	if(![self checkIfKundeDa]) {
		return self;
	}
	
	artikellist = [artikelController copySelectedArtikelList];
	
	if([artikellist count]) {
		if([artikellist alleNochNichtGeliefert]) {
			id	lief = [LieferscheinItem neuerLieferschein:artikellist auftrag:item];
			if(lief != nil) {
				[self sendChanged:[item identity]];
				[self reloadItem];
				[[[[LieferscheinDocument alloc] initItem:lief]
												makeActive:self]
												sendChanged:[lief identity]];
			} else {
				[[NXApp errorMgr] showDialog:"ErrorOnDSCreation"];
			}
		} else {
			[[NXApp errorMgr] showDialog:"ArticleAlreadyDelivered"];
		}
	} else {
		[[NXApp errorMgr] showDialog:"NoArticlesSelected"];
	}
	[artikellist free];
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
	return [artikelController enterPressed:sender];
}


- okButtonClicked:sender
{
	return [artikelController okButtonClicked:sender];
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

- (BOOL)savingDisabled { return savingDisabled; }

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


