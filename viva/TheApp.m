#import <appkit/Listener.h>
#import <appkit/NXImage.h>
#import <appkit/Panel.h>
#import <appkit/Speaker.h>
#import <appkit/Text.h>
#import <appkit/publicWraps.h>
#import <appkit/Menu.h>
#import <defaults.h>
#import <stdlib.h>
#import <string.h>
#import <sys/message.h>

#import "dart/DateField.h"
#import "dart/HeadButton.h"
#import "dart/Localizer.h"
#import "dart/PaletteView.h"
#import "dart/dartlib.h"
#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "dart/smartkit/SmarterFields.h"

#import "dart/smartkit/SmarterTFCell.h"
#import "VivaObjectTypes.m"		// For RunTime Binding

#import "AbspannView.h"
#import "DPasteBoard.h"
#import "DartPageLayout.h"
#import "DefaultsDatabase.h"
#import "ErrorManager.h"
#import "ImageManager.h"
#import "InfoPanelManager.h"
#import "NetworkManager.h"
#import "PictCell.h"
#import "PreferencesManager.h"
#import "ProtectedValueCell.h"
#import "StringManager.h"
#import "TableManager.h"
#import "UserManager.h"


#import "AngebotsSelector.h"
#import "ArtikelSelector.h"
#import "AuftragsSelector.h"
#import "BankenSelector.h"
#import "BenutzerSelector.h"
#import "BestellungsSelector.h"
#import "KonditionenSelector.h"
#import "KundenSelector.h"
#import "LagerSelector.h"
#import "LagerUmbuchController.h"
#import "LayoutManager.h"
#import "LayoutSelector.h"
#import "LieferscheinSelector.h"
#import "RechnungsSelector.h"
#import "LagerVorgangsSelector.h"
#import "VariablenManager.h"
#import "VariablenPanel.h"
#import	"Zugriffsrechte.h"
#import "Dumper.h"

#import "KundenDocument.h"
#import "BankenDocument.h"
#import "ArtikelDocument.h"
#import "KonditionenDocument.h"
#import "LagerDocument.h"
#import "BenutzerDocument.h"
#import "AngebotsDocument.h"
#import "AuftragsDocument.h"
#import "BestellungsDocument.h"
#import "RechnungsDocument.h"
#import "LieferscheinDocument.h"
#import "LayoutDocument.h"

#import "TheApp.h"

#pragma .h #import <appkit/Application.h>

@implementation TheApp:Application
{
	id	zugriffeButton;
	id	backupButton;
	id	newButton;
	id	openButton;
	id	saveButton;
	id	saveAllButton;
	id	revertButton;
	id	exportButton;
	id	closeButton;
	id	destroyButton;
	id	destroySelectionButton;
	
	id	selectAllButton;
	
	id	copySpecialButton;
	id	pasteSpecialButton;
	
	id	newEditorButton;
	id	findButton;
	id	printButton;
	id	preferencesButton;
	id	showListingButton;
	id	showIconsButton;
	
	id	kundenButton;
	id	bankenButton;
	id	artikelButton;
	id	konditionenButton;
	id	lagerButton;
	id	benutzerButton;
	id	angeboteButton;
	id	auftraegeButton;
	id	bestellungenButton;
	id	rechnungenButton;
	id	lieferscheineButton;
	id	layoutButton;
	
	id	beepString;
	id	documentList;
	id	activeDocument;
	
	id	localizer;
	id	stringMgr;
	id	errorMgr;
	id	imageMgr;
	id	pasteBoard;
	id	networkMgr;
	id	userMgr;
	id	popupMgr;
	id	layoutMgr;
	id	defaultsDB;
	id	defaultQuery;
	
	id	pageMarginView;
	id	abspann;
	id	infoButton;
	id	currentListeningWindow;
	
	BOOL netSelfInitatedMsg;
	BOOL dyingMode;
	
	id	toolsMenu;
	id	runtimeLoadedClasses;
}

- appDidInit:sender
{
	if(NXArgc == 2) {
		SetDebug(atoi(NXArgv[1]));
	} else {
		SetDebug(5);
	}
	dyingMode = NO;
	[[SmarterFields new] free];
	[[SmarterTFCell new] free];

	[[DateField new] free];
	[[PaletteView new] free];
	[[HeadButton new] free];

	beepString = [String str:"viva! 2.0 didn't beep yet!"];
	documentList =	[[List alloc] init];
	
	localizer = [[Localizer alloc] init];
	stringMgr = [[StringManager alloc] init];
	errorMgr = [[ErrorManager alloc] init];
	imageMgr = [[ImageManager alloc] init];
	networkMgr = [[NetworkManager alloc] init];
	[self checkinViva];
	
	[Date setDateFormat:[stringMgr stringFor:"DateFormat"]];
	[Double setDoubleFormat:[stringMgr stringFor:"CurrencyFormat"]];

	[Query initSybase];
	[Query setTimeout:atoi([stringMgr stringForNetworkKey:"QUERYTIMEOUT"])];
	DEBUG("timeout = %d\n",[Query timeout]);
	userMgr = [[UserManager alloc] init];
	defaultQuery = [userMgr checkLogin];

	popupMgr = [[TableManager alloc] init];
	defaultsDB = [[DefaultsDatabase alloc] init];
	layoutMgr = [[LayoutManager alloc] init];
	pasteBoard = [[DPasteBoard alloc] init];
	
	[[[DartPageLayout new] setMarginView:pageMarginView] setAccessoryView:pageMarginView];
	
	[self checkAndAdjustUserPrivilegs];

	[Text registerDirective:"NeXTGraphic" forClass:[PictCell class]];
	[Text registerDirective:"dARTProtectedValue" forClass:[ProtectedValueCell class]];
	runtimeLoadedClasses = [localizer loadLocalClasses];
	[self addToolsIfNecessery];
	return self;
}

- checkinViva
{
	if (![networkMgr netCheckin:[stringMgr stringForNetworkKey:"PASSWORD"]]) {
		// password wrong
	}
	if (![networkMgr netCheckUserCount]) {
		// licenCountError
	}
	if (![networkMgr netCheckExpiration]) {
		// expirationError
	}
	return self;
}


- addToolsIfNecessery
{
	id	toolsList = [self getToolObjects];
	if (toolsList != nil) {
		int i, count = [toolsList count];
		for (i=0;i<count;i++) {
			[[[toolsMenu target] 
				addItem:[[toolsList objectAt:i] publicname] 
				action:@selector(doTool:) 
				keyEquivalent:0] setTarget:self];
		}
		[[toolsList empty] free];
	}
	return self;
}

- doTool:sender
{
	const char *aTitle = [[sender selectedCell] title];
	id	aClass = [self classForString:aTitle];
	if (aClass != nil) {
		id	newTool = [[aClass alloc] init];
		if ([newTool respondsTo:@selector(makeActive:)]) {
			[newTool makeActive:self];
		} else {
			[self beep:"IrritatingToolInactivating"];
			[[sender selectedCell] setEnabled:NO];
			[newTool free];
		}
	}
	return self;
}

- free
{
	[localizer free];
	[stringMgr free];
	[errorMgr free];
	[imageMgr free];
	[pasteBoard free];
	[networkMgr free];
	[userMgr free];
	[popupMgr free];
	[defaultsDB free];
	[defaultQuery free];
	[documentList free];
	[layoutMgr free];
	[beepString free];
	[[runtimeLoadedClasses freeObjects] free];
	[Query exitSybase];
	return [super free];
}

- reLoginUser:sender
{
	while([documentList count]) {
		int	count = [documentList count];
		if (dyingMode) {
			[[[documentList lastObject] window] setDocEdited:NO];
		}
		[[documentList lastObject] close:sender];
		if([documentList count] == count) {
			return nil;
		}
	}
	activeDocument = nil;
	pasteBoard=[pasteBoard free];
	userMgr = [userMgr free];
	popupMgr=[popupMgr free];
	defaultsDB=[defaultsDB free];
	layoutMgr=[layoutMgr free];
	[Query initSybase];
	userMgr = [[UserManager alloc] init];
	defaultQuery = [userMgr checkLogin];
	popupMgr = [[TableManager alloc] init];
	defaultsDB = [[DefaultsDatabase alloc] init];
	layoutMgr = [[LayoutManager alloc] init];
	pasteBoard = [[DPasteBoard alloc] init];
	[self checkAndAdjustUserPrivilegs];
	dyingMode = NO;
	return self;
}

- interrupt:sender
{
	if ([errorMgr showDialog:"ReallyInterrupt" yesButton:"YES" noButton:"NO"] == EHYES_BUTTON) {
		[self reLoginUser:self];
	}
	return self;
}

- beep:(const char *)whyTheBeep
{
	id	value;
	[beepString str:whyTheBeep];
	value = [defaultsDB valueForKey:"showDialogsInsteadBeep"];
	if (value && [value isTrue]) {
		[self whytheFuckingBeep:self];
	} else {
		NXBeep();
	}
	return self;
}

- classForString:(const char *)string
{
	if (runtimeLoadedClasses != nil) {
		int 	i, count = [runtimeLoadedClasses count];
		BOOL	found = NO;
		id		fndClass = nil;
		for (i=0;i<count;i++) {
			if (strcmp([[runtimeLoadedClasses objectAt:i] publicname],string) == 0) {
				fndClass = [runtimeLoadedClasses objectAt:i];
				found = YES;
			}
		}
		return fndClass;
	} else {
		return nil;
	}
}

- getExportObjects
{
	if (runtimeLoadedClasses != nil) {
		int 	i, count = [runtimeLoadedClasses count];
		BOOL	found = NO;
		id		fndClasses = [[List alloc] initCount:0];
		for (i=0;i<count;i++) {
			if ([[runtimeLoadedClasses objectAt:i] vivaObjectType] == VIVA_EXPORTOBJECT) {
				[fndClasses addObject:[runtimeLoadedClasses objectAt:i]];
				found = YES;
			}
		}
		return fndClasses;
	} else {
		return nil;
	}
}

- getToolObjects
{
	if (runtimeLoadedClasses != nil) {
		int 	i, count = [runtimeLoadedClasses count];
		BOOL	found = NO;
		id		fndClasses = [[List alloc] initCount:0];
		for (i=0;i<count;i++) {
			if ([[runtimeLoadedClasses objectAt:i] vivaObjectType] == VIVA_TOOLOBJECT) {
				[fndClasses addObject:[runtimeLoadedClasses objectAt:i]];
				found = YES;
			}
		}
		return fndClasses;
	} else {
		return nil;
	}
}

- showInfoPanel:sender
{
	[[[InfoPanelManager alloc] init] showInfoPanel:sender];
	return self;
}

- gameInfoPanel:sender
{
	NXEvent *anEvent;

	anEvent = [NXApp currentEvent];
	if ( (anEvent->flags & NX_CONTROLMASK) &&
	   	 (anEvent->flags & NX_ALTERNATEMASK) &&
	     (anEvent->flags & NX_COMMANDMASK) ) {
		 [abspann do:sender copyBack:infoButton];
	}
	return self;
}

- sendEvent:(NXEvent *)event
{
	[super sendEvent:event];
	[self checkMenus];
    return self;
}


- appWillTerminate:sender
{
	while([documentList count]) {
		int	count = [documentList count];
		[[documentList lastObject] close:sender];
		if([documentList count] == count) {
			return nil;
		}
	}
	return self;
}


/* */
- new:sender
{
	[activeDocument new:sender];
	return self;
}

- open:sender
{
	[activeDocument open:sender];
	return self;
}

- close:sender
{
	[activeDocument close:sender];
	return self;
}

- revertToSaved:sender
{
	[activeDocument revertToSaved];
	return self;
}

- save:sender
{
	[activeDocument save];
	return self;
}

- saveAll:sender
{
	int i;
	int count = [documentList count];
	
	for (i=0;i<count;i++) {
		if ([[documentList objectAt:i] respondsTo:@selector(save:)]) {
			[[documentList objectAt:i] save:self];
		}
	}
	return self;
}

- destroy:sender
{
	[activeDocument destroy];
	return self;
}

- destroySelection:sender
{
	[activeDocument destroySelection:sender];
	return self;
}

- import:sender
{
	[activeDocument import:sender];
	return self;
}

- export:sender
{
	[activeDocument export:sender];
	return self;
}

- newEditor:sender
{
	[activeDocument newEditor:self];
	return self;
}

- find:sender
{
	[activeDocument find:sender];
	return self;
}

- print:sender
{
	if (activeDocument) 
		[activeDocument print:self];
	return self;
}

- copySpecial:sender
{
	if (![activeDocument copySpecial:sender]) {
		NXBeep();
	}
	return self;
}

- pasteSpecial:sender
{
	if (![activeDocument pasteSpecial:sender]) {
		NXBeep();
	}
	return self;
}

- showPasteboard:sender
{ 
	[pasteBoard makeActive:self];
	return self;
}

- showListing:sender
{
	if ([activeDocument respondsTo:@selector(showListing:)]) {
		[activeDocument showListing:sender];
	}
	return self;
}

- showIcons:sender
{
	if ([activeDocument respondsTo:@selector(showIcons:)]) {
		[activeDocument showIcons:sender];
	}
	return self;
}

/*************************** MENU STUFF **************************/
- docustomer:sender
{ return [[KundenSelector newInstance] makeActive:self]; }

- doarticles:sender
{ return [[ArtikelSelector newInstance] makeActive:self]; }

- dosupplier:sender
{ return [[BankenSelector newInstance] makeActive:self]; }

- dobanks:sender
{ return [[BankenSelector newInstance] makeActive:self]; }

- dostore:sender
{ return [[LagerSelector newInstance] makeActive:self]; }

- doAuftraege:sender
{ return [[AuftragsSelector newInstance] makeActive:self]; }

- doAngebote:sender
{ return [[AngebotsSelector newInstance] makeActive:self]; }

- doRechnungen:sender
{ return [[RechnungsSelector newInstance] makeActive:self]; }

- doBestellungen:sender
{ return [[BestellungsSelector newInstance] makeActive:self]; }

- doLieferscheine:sender
{ return [[LieferscheinSelector newInstance] makeActive:self]; }

- douser:sender
{ return [[BenutzerSelector newInstance] makeActive:self]; }

- dopreferences:sender
{ return [[PreferencesManager newInstance] makeActive:self]; }

- doumbuch:sender
{ return [[LagerUmbuchController newInstance] makeActive:self]; }

- dovariablen:sender
{ return [[VariablenManager newInstance] makeActive:self]; }

- showVariablenPanel:sender
{ return [[VariablenPanel newInstance] makeActive:self]; }

- dolayouts:sender
{ return [[LayoutSelector newInstance] makeActive:self]; }

- doKonditionen:sender
{ return [[KonditionenSelector newInstance] makeActive:self]; }

- dozugriffe:sender
{ return [[Zugriffsrechte newInstance] makeActive:self]; }

- dobackup:sender
{ return [[Dumper newInstance] makeActive:self]; }

- dolagervorgang:sender
{ return [[LagerVorgangsSelector newInstance] makeActive:self]; }

- setActiveDocument:aDocument
{
	activeDocument = aDocument;
	
	[newButton setEnabled: NO];
	[openButton setEnabled: NO];
	[revertButton setEnabled: NO];
	[exportButton setEnabled: NO];
	[destroyButton setEnabled: NO];

	[copySpecialButton setEnabled: NO];
	[pasteSpecialButton setEnabled: NO];

	[findButton setEnabled: NO];
	[printButton setEnabled: NO];

	[newEditorButton setEnabled: NO];
	
	[showListingButton setEnabled:[activeDocument respondsTo:@selector(showListing:)]];
	[showIconsButton setEnabled:[activeDocument respondsTo:@selector(showIcons:)]];
	
	[destroySelectionButton setEnabled:NO];
	
	[self checkMenus];
	[pasteBoard checkPasteSpecialButton];
	return self;
}

- checkMenus
{
	[saveButton setEnabled:[activeDocument respondsTo:@selector(save)]];
	[activeDocument checkMenus];
	return self;
}


- checkAndAdjustUserPrivilegs
{
	[KundenDocument enableButton:kundenButton];
	[BankenDocument enableButton:bankenButton];
	[ArtikelDocument enableButton:artikelButton];
	[KonditionenDocument enableButton:konditionenButton];
	[LagerDocument enableButton:lagerButton];
	[BenutzerDocument enableButton:benutzerButton];
	[AngebotsDocument enableButton:angeboteButton];
	[AuftragsDocument enableButton:auftraegeButton];
	[BestellungsDocument enableButton:bestellungenButton];
	[RechnungsDocument enableButton:rechnungenButton];
	[LieferscheinDocument enableButton:lieferscheineButton];
	[LayoutDocument enableButton:layoutButton];
	[zugriffeButton setEnabled:[userMgr isSuperuser]];
	return self;
}

- registerDocument:theDocument
{ 
	[documentList addObject:theDocument];
	if ([theDocument respondsTo:@selector(isRegisterable)] && [theDocument isRegisterable]) {
		[self registerDocumentInWorkspace:theDocument];
	}
	return self;
}

- unregisterDocument:theDocument
{
	if (activeDocument == theDocument) {
		[self setActiveDocument:nil];
	}
	[documentList removeObject:theDocument];
	if ([theDocument respondsTo:@selector(isRegisterable)] && [theDocument isRegisterable]) {
		[self unregisterDocumentInWorkspace:theDocument];
	}
	return self;
}

- registerDocumentInWorkspace:aDocument
{
    unsigned int	windowNum;
    
    NXConvertWinNumToGlobal([[aDocument window] windowNum], &windowNum);
    [[self appSpeaker] setSendPort:NXPortFromName(NX_WORKSPACEREQUEST, NULL)];
    [[self appSpeaker] registerWindow:windowNum toPort:[[self appListener] listenPort]];
    return self;
}

- unregisterDocumentInWorkspace:aDocument
{
    unsigned int	windowNum;
    
    NXConvertWinNumToGlobal([[aDocument window] windowNum], &windowNum);
    [[self appSpeaker] setSendPort:NXPortFromName(NX_WORKSPACEREQUEST, NULL)];
    [[self appSpeaker] unregisterWindow:windowNum];
    return self;
}

- performSelector:(const char *)sel class:(const char *)classNameSTR identity:(const char *)identitySTR
{
	SEL		aSelector;
	char 	selSTR[MSG_SIZE_MAX];
	int 	i, count = [documentList count];

	strncpy0(selSTR, sel, sizeof(selSTR));
	aSelector = sel_getUid(selSTR);	
	for (i=count-1;i>=0;i--) {
		if ([[documentList objectAt:i] respondsTo:aSelector]) {
			[[documentList objectAt:i] perform:aSelector with:(id)classNameSTR with:(id)identitySTR];
		}
	}
	if ([pasteBoard respondsTo:aSelector]) {
		[pasteBoard perform:aSelector with:(id)classNameSTR with:(id)identitySTR];
	}
	if ([popupMgr respondsTo:aSelector]) {
		[popupMgr perform:aSelector with:(id)classNameSTR with:(id)identitySTR];
	}
	return self;
}
	

- netAddedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{ return [self performSelector:"added::" class:classNameSTR identity:identitySTR]; }

- netChangedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{ return [self performSelector:"changed::" class:classNameSTR identity:identitySTR]; }

- netDeletedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{ return [self performSelector:"deleted::" class:classNameSTR identity:identitySTR]; }

- sendAddedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{
	[networkMgr netSendAddedClass:classNameSTR identity:identitySTR];
	[self performSelector:"added::" class:classNameSTR identity:identitySTR]; 
	return self;
}

- sendChangedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{
	[networkMgr netSendChangedClass:classNameSTR identity:identitySTR];
	[self performSelector:"changed::" class:classNameSTR identity:identitySTR];
	return self;
}

- sendDeletedClass:(const char *)classNameSTR identity:(const char *)identitySTR
{	
	[networkMgr netSendDeletedClass:classNameSTR identity:identitySTR];
	[self performSelector:"deleted::" class:classNameSTR identity:identitySTR]; 
	return self;
}

- (BOOL)lockClass:class identity:identity
{
	return [networkMgr lockClassName:[class name] identity:[identity str]];
}

- (BOOL)unlockClass:class identity:identity
{
	return [networkMgr unlockClassName:[class name] identity:[identity str]];
}


- (int)iconEntered:(int)windowNum at:(double)x :(double)y iconWindow:(int)iconWindowNum iconX:(double)iconX iconY:(double)iconY iconWidth:(double)iconWidth iconHeight:(double)iconHeight pathList:(char *)pathList
{
	unsigned currentListeningWindowNum;
	
	NXConvertGlobalToWinNum(windowNum, &currentListeningWindowNum);
	currentListeningWindow = [self findWindow:currentListeningWindowNum];
	return [[currentListeningWindow delegate] iconEntered:windowNum at:x :y iconWindow:iconWindowNum iconX:iconX iconY:iconY iconWidth:iconWidth iconHeight:iconHeight pathList:pathList];
}

- (int)iconExitedAt:(double)x :(double)y
{ return [[currentListeningWindow delegate] iconExitedAt:x :y]; }
   
- (int)iconReleasedAt:(double)x :(double)y ok:(int *)flag
{ return [[currentListeningWindow delegate] iconReleasedAt:x :y ok:flag]; }
    
/* ------------------------ END Network Communication stuff --------------------- */


- zugriffeButton { return zugriffeButton; }
- backupButton { return backupButton; }
- newButton { return newButton; }
- openButton { return openButton; }
- saveButton { return saveButton; }
- saveAllButton { return saveAllButton; }
- revertButton { return revertButton; }
- exportButton { return exportButton; }
- closeButton { return closeButton; }
- destroyButton { return destroyButton; }
- destroySelectionButton { return destroySelectionButton; }
- selectAllButton { return selectAllButton; }
- copySpecialButton { return copySpecialButton; }
- pasteSpecialButton { return pasteSpecialButton; }
- newEditorButton { return newEditorButton; }
- findButton { return findButton; }
- printButton { return printButton; }
- preferencesButton { return preferencesButton; }
- showListingButton { return showListingButton; }
- showIconsButton { return showIconsButton; }
- kundenButton { return kundenButton; }
- bankenButton { return bankenButton; }
- artikelButton { return artikelButton; }
- konditionenButton { return konditionenButton; }
- lagerButton { return lagerButton; }
- benutzerButton { return benutzerButton; }
- angeboteButton { return angeboteButton; }
- auftraegeButton { return auftraegeButton; }
- bestellungenButton { return bestellungenButton; }
- rechnungenButton { return rechnungenButton; }
- lieferscheineButton { return lieferscheineButton; }
- layoutButton { return layoutButton; }
- beepString { return beepString; }
- documentList { return documentList; }
- activeDocument { return activeDocument; }
- localizer { return localizer; }
- stringMgr { return stringMgr; }
- errorMgr { return errorMgr; }
- imageMgr { return imageMgr; }
- pasteBoard { return pasteBoard; }
- networkMgr { return networkMgr; }
- userMgr { return userMgr; }
- popupMgr { return popupMgr; }
- layoutMgr { return layoutMgr; }
- defaultsDB { return defaultsDB; }
- defaultQuery { return defaultQuery; }
- pageMarginView { return pageMarginView; }
- infoButton { return infoButton; }
- currentListeningWindow { return currentListeningWindow; }
- runtimeLoadedClasses { return runtimeLoadedClasses; }

- setDebugLevel:sender
{
	SetDebug(atoi([[sender selectedCell] title]));
	return self;
}


- whytheFuckingBeep:sender
{
	[errorMgr showDialog:[beepString str]];
	[beepString str:"viva! 2.0 didn't beep yet!"];
	return self;
}

- dbDead
{
	if (!dyingMode) {
		[errorMgr showDialog:"DBDEAD"];
		dyingMode = YES;
		[self perform:@selector(reLoginUser:) with:self afterDelay:1 cancelPrevious:YES];
	}
	return self;
}

@end

@interface Object(RegisterableWindowDocument)

- (BOOL)isRegisterable;

@end

