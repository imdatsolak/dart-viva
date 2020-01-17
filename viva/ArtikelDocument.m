#import <appkit/ScrollView.h>
#import <appkit/TextField.h>
#import <appkit/Button.h>

#import "dart/fieldvaluekit.h"

#import "ArtikelItem.h"
#import "ArtikelItemList.h"
#import "ArtikelLieferanten.h"
#import "ArtikelSelector.h"
#import "ErrorManager.h"
#import "FileItem.h"
#import "CommentItem.h"
#import "IconListView.h"
#import "KundeItemList.h"
#import "KonditionenItemList.h"
#import "KonditionenItem.h"
#import "KonditionenDocument.h"
#import "StueckListe.h"
#import "TheApp.h"
#import "UserManager.h"

#import "ArtikelDocument.h"

#pragma .h #import "MasterDocument.h"

@implementation ArtikelDocument:MasterDocument
{
	id		nrField;
	id		anameField;
	id		vkField;
	id		ekField;
	id		mindestbestandField;
	id		beschreibungText;
	id		kategoriePopup;
	id		mengeneinheitPopup;
	id		mwstsatzPopup;
	id		betreuernrPopup;
	id		lagerhaltungSwitch;
	id		lieferbarSwitch;
	id		stuecklisteSwitch;
	id		gewichtField;
	id		konditionenField;
	id		adactaSwitch;

	id		vkBackgroundField;
	id		ekBackgroundField;
	
	id		stuecklisteZeigenButton;
	id		stueckliste;
	BOOL	stuecklisteActive;

	id		artikelLieferantenZeigenButton;
	id		artikelLieferanten;
	BOOL	artikelLieferantenActive;
	
	id		konditionenZeigenButton;
}

- (BOOL)wantsNewComments { return ![self isReadOnly]; }
- itemClass { return [ArtikelItem class]; }

- initNib
{
	[super initNib];
	if ([beschreibungText isKindOf:[ScrollView class]]) {
		beschreibungText = [beschreibungText docView];
	}
	[iconListView setDelegate:self];
	[[iconListView setDoubleTarget:self] setDoubleAction:@selector(iconListViewDoubleClicked:)];
	stuecklisteActive = NO;
	artikelLieferantenActive = NO;
	return self;
}

- createNewItem
{
	item = [[ArtikelItem alloc] initNew];
	return self;
}

- createIdentityItem:identity
{
	item = [[ArtikelItem alloc] initIdentity:identity];
	return self;
}

- checkMenus
{ 
	[super checkMenus];
	[[NXApp newEditorButton] setEnabled:YES];
	return self;
}

- free
{
	if (stuecklisteActive) {
		[stueckliste close:self];
	}
	if (artikelLieferantenActive) {
		[artikelLieferanten close:self];
	}
	return [super free];
}
/* ===== WINDOW I/O METHODS ============================================================== */

- protectFieldsAndSelectText
{
	SETREADONLYFIELD(nrField);
	[stuecklisteZeigenButton setEnabled:[[item stueckliste] int] != 0];
	if (![self isReadOnly]) {
		[anameField selectText:self];
	}
	return self;
}

- setReadOnly
{
	if ([beschreibungText isKindOf:[ScrollView class]]) {
		beschreibungText = [beschreibungText docView];
	}
	SETREADONLYFIELD(nrField);
	SETREADONLYFIELD(anameField);
	SETREADONLYFIELD(vkField);
	SETREADONLYFIELD(ekField);
	SETREADONLYFIELD(mindestbestandField);
	SETREADONLYFIELD(beschreibungText);
	SETDISABLED(kategoriePopup);
	SETDISABLED(mengeneinheitPopup);
	SETDISABLED(mwstsatzPopup);
	SETDISABLED(betreuernrPopup);
	SETDISABLED(lagerhaltungSwitch);
	SETDISABLED(lieferbarSwitch);
	SETDISABLED(stuecklisteSwitch);
	SETREADONLYFIELD(gewichtField);
	SETREADONLYFIELD(vkBackgroundField);
	SETREADONLYFIELD(ekBackgroundField);
	SETDISABLED(adactaSwitch);
	return self;
}

- writeIntoWindow
{
	WRITEINTOCELL(item,nr,nrField);
	WRITEINTOCELL(item,aname,anameField);
	WRITEINTOCELL(item,vk,vkField);
	WRITEINTOCELL(item,ek,ekField);
	WRITEINTOCELL(item,mindestbestand,mindestbestandField);
	WRITEINTOTEXT(item,beschreibung,beschreibungText);
	WRITEINTOCELL(item,kategorie,kategoriePopup);
	WRITEINTOCELL(item,mengeneinheit,mengeneinheitPopup);
	WRITEINTOCELL(item,mwstsatz,mwstsatzPopup);
	WRITEINTOCELL(item,betreuernr,betreuernrPopup);
	WRITEINTOSWITCH(item,lagerhaltung,lagerhaltungSwitch);
	WRITEINTOSWITCH(item,lieferbar,lieferbarSwitch);
	WRITEINTOSWITCH(item,stueckliste,stuecklisteSwitch);
	WRITEINTOCELL(item,gewicht,gewichtField);
	WRITEINTOSWITCH(item,adacta,adactaSwitch);
	WRITEINTOCELL(item,konditionen,konditionenField);
	if ([item konditionen] && [[item konditionen] length] && ([[item konditionen] compareSTR:" "]!=0)) {
		[konditionenZeigenButton setEnabled:YES];
	} else {
		[konditionenZeigenButton setEnabled:NO];
	}
	[iconListView reload];
	return self;
}

- readFromWindow
{
	READFROMCELL(item,nr,nrField);
	READFROMCELL(item,aname,anameField);
	READFROMCELL(item,vk,vkField);
	READFROMCELL(item,ek,ekField);
	READFROMCELL(item,mindestbestand,mindestbestandField);
	READFROMTEXT(item,beschreibung,beschreibungText);
	READFROMCELL(item,kategorie,kategoriePopup);
	READFROMCELL(item,mengeneinheit,mengeneinheitPopup);
	READFROMCELL(item,mwstsatz,mwstsatzPopup);
	READFROMCELL(item,betreuernr,betreuernrPopup);
	READFROMSWITCH(item,lagerhaltung,lagerhaltungSwitch);
	READFROMSWITCH(item,lieferbar,lieferbarSwitch);
	READFROMSWITCH(item,stueckliste,stuecklisteSwitch);
	READFROMCELL(item,gewicht,gewichtField);
	READFROMSWITCH(item,adacta,adactaSwitch);
	return self;
}


- (BOOL)save
{
	BOOL	wasStueckliste = [[item stueckliste] int] != 0;
	[self readFromWindow];
	if (wasStueckliste && ([[item stueckliste] int] == 0)) {
		if (stueckliste == nil) {
			stueckliste = [[StueckListe alloc] initForIdentity:[item identity] andOwner:self];
		}
		[stueckliste destroyAll:self];
		if (stuecklisteActive) {
			[stueckliste close:self];
			stueckliste = nil;
		} else {
			stueckliste = [stueckliste free];
		}
		stuecklisteActive = NO;
	}
	return [super save];
}


- (BOOL)reloadItem
{
	if ([super reloadItem]) {
		if (stuecklisteActive) {
			if ([[item stueckliste] int] != 0) {
				[stueckliste updateBrowserWithCurrentSelection];
			} else {
				stueckliste = [stueckliste close:self];
			}
		}
		if (artikelLieferantenActive) {
			[artikelLieferanten updateBrowserWithCurrentSelection];
		}
		return YES;
	} else {
		return NO;
	}
}

- stueckListeSwitchClicked:sender
{
	if ([sender state] != [[item stueckliste] int]) {
		if ([[NXApp errorMgr] showDialog:"ReallyChangePL" 
						yesButton:"NO"
						noButton:"YES"
						explain:"ReallyChangePL_EXP"] == EHYES_BUTTON) {
			WRITEINTOSWITCH(item,stueckliste,stuecklisteSwitch);
		} else {
			[self controlDidChange:sender];
		}
	}
	return self;
}

-(BOOL)iWannaUpdate { return YES; }

/* ===== COPY/PASTE METHODS ============================================================== */

- (BOOL)acceptsItem:anItem
{ 
	return	([anItem isKindOf:[ArtikelItemList class]] && [anItem isSingle]) 
		 ||	([anItem isKindOf:[FileItem class]]) 
		 ||	([anItem isKindOf:[KonditionenItemList class]] && [anItem isSingle]) 
		 || ([anItem isKindOf:[ArtikelItemList class]] && ([[item stueckliste] int] != 0) && ![item isNew])
		 || ([anItem isKindOf:[KundeItemList class]] && ![item isNew]);
}

- pasteItem:anItem
{
	if(([[item stueckliste] int] != 0) && [anItem isKindOf:[ArtikelItemList class]] && ![item isNew]) {
		return [self pasteStueckliste:anItem];
	} else if([anItem isKindOf:[ArtikelItemList class]] && [anItem isSingle]) {
		return [self pasteArtikel:anItem];
	} else if([anItem isKindOf:[KonditionenItemList class]] && [anItem isSingle]) {
		return [self pasteKonditionen:anItem];
	} else if([anItem isKindOf:[FileItem class]]) {
		return [self pasteFile:anItem];
	} else if ([anItem isKindOf:[KundeItemList class]] && ![item isNew]) {
		return [self pasteLieferant:anItem];
	} else {
		return nil;
	}
}

- pasteLieferant:anItem
{
	BOOL	hasChanged = NO;
	BOOL	doBreak = NO;
	int 	i, count = [anItem count];
	
	[self showArtikelLieferanten:self];
	for (i=0;(i<count) && !doBreak;i++) {
		if ([artikelLieferanten addLieferantIdentity:[anItem objectAt:i]] != nil) {
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

- pasteStueckliste:anItem
{
	BOOL	hasChanged = NO;
	BOOL	doBreak = NO;
	int 	i, count = [anItem count];
	
	[self showStueckliste:self];
	for (i=0;(i<count) && !doBreak;i++) {
		id	artIdentity = [anItem objectAt:i];
		if ([artIdentity compare:[item identity]] == 0) {
			[NXApp beep:"CannotDropMyselfIntoMeAsStueckliste"];
		} else if ([ArtikelItem istStueckliste:artIdentity]) {
			[NXApp beep:"CannotDropStuecklistIntoStueckliste"];
		} else {
			if ([stueckliste addArtikelIdentity:artIdentity] != nil) {
				hasChanged = YES;
			} else {
				doBreak = YES;
			}
		}
	}
	if (hasChanged) {
		[self sendChanged:[item identity]];
	}
	return (id)hasChanged;
}


- pasteKonditionen:anItem
{
	[item setKonditionen:[anItem objectAt:0]];
	[self updateWindow];
	[window setDocEdited:YES];
	return self;
}

- pasteArtikel:anItem
{
	id	newItem = [anItem copyLoadedFirstObject];
	
	if(newItem) {
		[self readFromWindow];
		[newItem setNr:[item nr]];
		[newItem setAname:[item aname]];
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

/* ===== FIND METHODS ==================================================================== */

- find:sender
{
	[[ArtikelSelector newInstance] find:sender];
	return self;
}

/* ===== DOCUMENT SPECIFIC METHODS ======================================================= */
- showKonditionen:sender
{
	if ([item konditionen] && [[item konditionen] length]) {
		[[[KonditionenDocument alloc] initIdentity:[item konditionen]] makeActive:self];
	}
	return self;
}
	
- showArtikelLieferanten:sender
{
	if (artikelLieferanten == nil) {
		artikelLieferanten = [[ArtikelLieferanten alloc] initForIdentity:[item identity] andOwner:self];
	}
	[artikelLieferanten setReadOnly:[self isReadOnly]];
	[artikelLieferanten makeActive:self];
	artikelLieferantenActive = YES;
	return self;
}

- stuecklisteUebernehmenButtonClicked:sender
{
	id	ek = [Double double:0.0];
	id	vk = [Double double:0.0];
	id	gewicht = [Double double:0.0];
	[stueckliste getGesamtEk:ek vk:vk undGewicht:gewicht];
	[[[item setEk:ek] setVk:vk] setGewicht:gewicht];
	[self updateWindow];
	[window setDocEdited:YES];
	[ek free];
	[vk free];
	[gewicht free];
	return self;
}

- showStueckliste:sender
{
	if (stueckliste == nil) {
		stueckliste = [[StueckListe alloc] initForIdentity:[item identity] andOwner:self];
	}
	[stueckliste setReadOnly:[self isReadOnly]];
	[stueckliste makeActive:self];
	stuecklisteActive = YES;
	return self;
}

- windowDidBecomeMain:sender
{
	if (stuecklisteActive) {
		[[stueckliste window] orderFront:self];
	}
	if (artikelLieferantenActive) {
		[[artikelLieferanten window] orderFront:self];
	}
	return self;
}


- windowDidResignMain:sender
{
	if (stuecklisteActive) {
		[[stueckliste window] orderOut:self];
	}
	if (artikelLieferantenActive) {
		[[artikelLieferanten window] orderOut:self];
	}
	return self;
}

- stuecklisteClosed:sender
{
	stuecklisteActive = NO;
	stueckliste = nil;
	return self;
}


- artikelLieferantenClosed:sender
{
	artikelLieferantenActive = NO;
	artikelLieferanten = nil;
	return self;
}

- (BOOL)windowEntered:(NXPoint *)mouseLocation fromSource:dragSource
{
	id	dsWin = [dragSource window];
	if ((dsWin != window) && (dsWin != [stueckliste window]) && (dsWin != [artikelLieferanten window])) {
		return [super windowEntered:mouseLocation fromSource:dragSource];
	} else {
		return NO;
	}
}


- (BOOL)windowDropped:(NXPoint *)mouseLocation fromSource:source
{
	id	sWin = [source window];
	if ((sWin != window) && (sWin != [stueckliste window]) && (sWin != [artikelLieferanten window])) {
		return [super windowDropped:mouseLocation fromSource:source];
	} else {
		return NO;
	}
}

@end
