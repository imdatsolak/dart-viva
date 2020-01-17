#import <appkit/TextField.h>
#import <appkit/Matrix.h>
#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"

#import "AddressItem.h"
#import "BankItemList.h"
#import "BankVerbindungen.h"
#import "FileItem.h"
#import "IconListView.h"
#import "KundeItem.h"
#import "KundeItemList.h"
#import "KundenKontoDocument.h"
#import "KundenSelector.h"
#import "TheApp.h"
#import "UserManager.h"

#import "KundenDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation KundenDocument:MasterDocument
{
	id	nrField;
	id	knameField;
	id	zahlungszielField;
	id	kreditlimitField;
	id	mahnzeit1Field;
	id	mahnzeit2Field;
	id	mahnzeit3Field;
	id	skontotageField;
	id	skontoprozentField;
	id	adactaSwitch;

	id	liefersperreSwitch;
	id	mwstberechnenSwitch;
	id	einstufungPopup;
	id	kategoriePopup;
	id	groessePopup;
	id	sammelrechnungPopup;
	id	betreuernrPopup;

	id	adrName1Field;
	id	adrName2Field;
	id	adrName3Field;
	id	adrStrasseField;
	id	adrPlzOrtField;
	id	adrTelField;
	id	adrFaxField;
	id	adrTelexField;
	id	adrEmailField;
	id	adrLandPopup;
	
	id	adrBackgroundField;
	id	skontoBackgroundField;
	id	skontoPercentBackgroundField;
	
	id	kontoButton;
	id		bankverbindungen;
	BOOL	bankverbindungenActive;
	
	int	shownAddressIndex;
}


- itemClass { return [KundeItem class]; }

- createNewItem
{
	item = [[KundeItem alloc] initNew];
	shownAddressIndex = 0;
	return self;
}

- createIdentityItem:identity
{
	item = [[KundeItem alloc] initIdentity:identity];
	shownAddressIndex = 0;
	return self;
}

- initNib
{
	[super initNib];
	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];
	[kontoButton setEnabled:NO];
	bankverbindungenActive = NO;
	return self;
}

- free
{
	if (bankverbindungenActive) {
		[bankverbindungen close:self];
	}
	return [super free];
}

/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	SETREADONLYFIELD(nrField);
	if (![self isReadOnly]) {
		[knameField selectText:self];
	}
	return self;
}

- setReadOnly
{
	SETREADONLYFIELD(nrField);
	SETREADONLYFIELD(knameField);
	SETREADONLYFIELD(zahlungszielField);
	SETREADONLYFIELD(kreditlimitField);
	SETREADONLYFIELD(mahnzeit1Field);
	SETREADONLYFIELD(mahnzeit2Field);
	SETREADONLYFIELD(mahnzeit3Field);
	SETREADONLYFIELD(skontotageField);
	SETREADONLYFIELD(skontoprozentField);
	SETDISABLED(liefersperreSwitch);
	SETDISABLED(mwstberechnenSwitch);
	SETDISABLED(einstufungPopup);
	SETDISABLED(kategoriePopup);
	SETDISABLED(groessePopup);
	SETDISABLED(sammelrechnungPopup);
	SETDISABLED(betreuernrPopup);
	SETDISABLED(adactaSwitch);

	SETREADONLYFIELD(adrName1Field);
	SETREADONLYFIELD(adrName2Field);
	SETREADONLYFIELD(adrName3Field);
	SETREADONLYFIELD(adrStrasseField);
	SETREADONLYFIELD(adrPlzOrtField);
	SETREADONLYFIELD(adrTelField);
	SETREADONLYFIELD(adrFaxField);
	SETREADONLYFIELD(adrTelexField);
	SETREADONLYFIELD(adrEmailField);
	SETDISABLED(adrLandPopup);
	
	SETREADONLYFIELD(adrBackgroundField);
	SETREADONLYFIELD(skontoBackgroundField);
	SETREADONLYFIELD(skontoPercentBackgroundField);
	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,nr,nrField);
	WRITEINTOCELL(item,kname,knameField);
	WRITEINTOCELL(item,zahlungsziel,zahlungszielField);
	WRITEINTOCELL(item,kreditlimit,kreditlimitField);
	WRITEINTOCELL(item,mahnzeit1,mahnzeit1Field);
	WRITEINTOCELL(item,mahnzeit2,mahnzeit2Field);
	WRITEINTOCELL(item,mahnzeit3,mahnzeit3Field);
	WRITEINTOCELL(item,skontotage,skontotageField);
	WRITEINTOCELL(item,skontoprozent,skontoprozentField);
	WRITEINTOSWITCH(item,liefersperre,liefersperreSwitch);
	WRITEINTOSWITCH(item,mwstberechnen,mwstberechnenSwitch);
	WRITEINTOCELL(item,einstufung,einstufungPopup);
	WRITEINTOCELL(item,kategorie,kategoriePopup);
	WRITEINTOCELL(item,groesse,groessePopup);
	WRITEINTOCELL(item,sammelrechnung,sammelrechnungPopup);
	WRITEINTOCELL(item,betreuernr,betreuernrPopup);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	[self writeAddressIntoWindow];
	[iconListView reload];
	[kontoButton setEnabled:!iamNew];
	return self;
}

- writeAddressIntoWindow
{
	id	address = [[item adressen] objectAt:shownAddressIndex];
	WRITEINTOCELL(address,name1,adrName1Field);
	WRITEINTOCELL(address,name2,adrName2Field);
	WRITEINTOCELL(address,name3,adrName3Field);
	WRITEINTOCELL(address,strasse,adrStrasseField);
	WRITEINTOCELL(address,plzort,adrPlzOrtField);
	WRITEINTOCELL(address,tel,adrTelField);
	WRITEINTOCELL(address,fax,adrFaxField);
	WRITEINTOCELL(address,telex,adrTelexField);
	WRITEINTOCELL(address,email,adrEmailField);
	WRITEINTOCELL(address,landnr,adrLandPopup);
	return self;
}

- readFromWindow
{
	READFROMCELL(item,nr,nrField);
	READFROMCELL(item,kname,knameField);
	READFROMCELL(item,zahlungsziel,zahlungszielField);
	READFROMCELL(item,kreditlimit,kreditlimitField);
	READFROMCELL(item,mahnzeit1,mahnzeit1Field);
	READFROMCELL(item,mahnzeit2,mahnzeit2Field);
	READFROMCELL(item,mahnzeit3,mahnzeit3Field);
	READFROMCELL(item,skontotage,skontotageField);
	READFROMCELL(item,skontoprozent,skontoprozentField);
	READFROMSWITCH(item,liefersperre,liefersperreSwitch);
	READFROMSWITCH(item,mwstberechnen,mwstberechnenSwitch);
	READFROMCELL(item,einstufung,einstufungPopup);
	READFROMCELL(item,kategorie,kategoriePopup);
	READFROMCELL(item,groesse,groessePopup);
	READFROMCELL(item,sammelrechnung,sammelrechnungPopup);
	READFROMCELL(item,betreuernr,betreuernrPopup);
	READFROMSWITCH(item,adacta,adactaSwitch);
	
	[self readAddressFromWindow];
	
	return self;
}

- readAddressFromWindow
{
	id	address = [[item adressen] objectAt:shownAddressIndex];
	READFROMCELL(address,name1,adrName1Field);
	READFROMCELL(address,name2,adrName2Field);
	READFROMCELL(address,name3,adrName3Field);
	READFROMCELL(address,strasse,adrStrasseField);
	READFROMCELL(address,plzort,adrPlzOrtField);
	READFROMCELL(address,tel,adrTelField);
	READFROMCELL(address,fax,adrFaxField);
	READFROMCELL(address,telex,adrTelexField);
	READFROMCELL(address,email,adrEmailField);
	READFROMCELL(address,landnr,adrLandPopup);
	return self;
}

- (BOOL)save
{
	if ([super save]) {
		[kontoButton setEnabled:YES];
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)reloadItem
{
	if ([super reloadItem]) {
		if (bankverbindungenActive) {
			[bankverbindungen updateBrowserWithCurrentSelection];
		}
		return YES;
	} else {
		return NO;
	}
}
/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{ 
	return ([anItem isKindOf:[KundeItemList class]] && [anItem isSingle])
			||	([anItem isKindOf:[FileItem class]]) ||	([anItem isKindOf:[BankItemList class]]); 
}

- pasteItem:anItem
{
	if ([anItem isKindOf:[KundeItemList class]] && [anItem isSingle]) {
		return [self pasteKunde:anItem];
	} else if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else if([anItem isKindOf:[BankItemList class]]) {
		return [self pasteBank:anItem];
	} else {
		return nil;
	}
}

- pasteKunde:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[self readFromWindow];
		[newItem setNr:[item nr]];
		[newItem setKname:[item kname]];
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

- pasteBank:anItem
{
	BOOL	hasChanged = NO;
	BOOL	doBreak = NO;
	int 	i, count = [anItem count];
	
	[self showBankverbindungen:self];
	for (i=0;(i<count) && !doBreak;i++) {
		if ([bankverbindungen addBankverbindungIdentity:[anItem objectAt:i]] != nil) {
			hasChanged = YES;
		} else {
			doBreak = YES;
		}
	}
	if (hasChanged) {
		[self sendChanged:[item identity]];
	}
	return (id)hasChanged;
}

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[KundenSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */
- showKundenKonto:sender
{
	id kundenKonto = [[KundenKontoDocument newInstance] initForKundennr:[item nr] andKundenname:[item kname]];
	[kundenKonto makeActive:self];
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

- showBankverbindungen:sender
{
	if (bankverbindungen == nil) {
		bankverbindungen = [[BankVerbindungen alloc] initForIdentity:[item identity] andOwner:self];
	}
	[bankverbindungen setReadOnly:[self isReadOnly]];
	[bankverbindungen makeActive:self];
	bankverbindungenActive = YES;
	return self;
}

- windowDidBecomeMain:sender
{
	if (bankverbindungenActive) {
		[[bankverbindungen window] orderFront:self];
	}
	return self;
}


- windowDidResignMain:sender
{
	if (bankverbindungenActive) {
		[[bankverbindungen window] orderOut:self];
	}
	return self;
}

- bankverbindungenClosed:sender
{
	bankverbindungenActive = NO;
	bankverbindungen = nil;
	return self;
}

- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource
{
	id	dsWin = [dragSource window];
	if ((dsWin != window) && (dsWin != [bankverbindungen window])) {
		return [super windowEntered:mouseLocation fromSource:dragSource];
	} else {
		return NO;
	}
}


- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	id	sWin = [source window];
	if ((sWin != window) && (sWin != [bankverbindungen window])) {
		return [super windowDropped:mouseLocation fromSource:source];
	} else {
		return NO;
	}
}
@end
