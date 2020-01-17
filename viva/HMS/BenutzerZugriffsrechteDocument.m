#import "BenutzerZugriffsrechteDocument.h"

@implementation BenutzerZugriffsrechteDocument

- (BOOL)canHaveMultipleInstances
{
	return NO;
}


- init
{
	[super init];
	[self loadNib];
	actPrivileg = 0;
	[self performQueryFor:[privilegPopup intValue]];
	[[NXApp documentHandler] registerDocument:self];
	return self;
}


- free
{
	[[NXApp documentHandler] unregisterDocument:self];
	return [super free];
}

	
- loadNib
{
	[NXApp loadNibFile:"BenutzerZugriffsrechteDocument.nib" owner:self];
	[window setDelegate:self];
	[window setMiniwindowIcon:"acces_privs"];
	[[[privilegPopup setTag:ben_privileg] setTableName:"benutzerprivileg" expandable:YES] 
		performQuery];
	[window setDocEdited:NO];
	return self;
}

- matrixDidChange:sender
{
	[window setDocEdited:YES];
	return self;
}

- popUpDidChange:sender
{
	return self;
}

- controlDidChange:sender
{
	int anInt; 
	if ([window isDocEdited]) {
		if ([[NXApp errorHandler] showDialog:"Einstellungen Sichern?" yesButton:"YES"
			 	noButton:"NO"] == EHYES_BUTTON) {
				[self save:sender];
				[self saveFor:actPrivileg];
		}
	}
	anInt = [sender intValue];
	[self performQueryFor:anInt];
	[window setDocEdited:NO];
	return self;
}

- windowWillClose:sender
{
	if ([window isDocEdited]) {
		if ([[NXApp errorHandler] showDialog:"Einstellungen Sichern?" yesButton:"YES"
			 	noButton:"NO"] == EHYES_BUTTON) {
			[self saveFor:actPrivileg];
		}
	}
	[window setDelegate:nil];
	[self free];
	return (id )YES;
}

- save:sender
{
	[self saveFor:actPrivileg];
	[window setDocEdited:NO];
	return self;
}

- saveFor:(int)thePrivileg
{
	char	privileg[5];
	int		i;
	id		saveString, queryResult;
	id		anInt = [Integer int:thePrivileg];
	
	saveString = [QueryString str:"delete from zugriffsrechte where bp_privileg="];
	[saveString concatField:anInt];
	[[[NXApp defaultQuery] performQuery:[saveString str]] free];
	[saveString free];
	
	for (i=KUNDEN; i<=MAXPRIVILEGS;i++) {
		id className = [String str:[self vivanameForStartTag:i]];
		
		strcpy(privileg,"");	
		if (![[zugriffsMatrix cellAt:0 :i] state]) {
			strcat(privileg,"C");
		}
		if (![[zugriffsMatrix cellAt:1 :i] state]) {
			strcat(privileg,"R");
		}
		if (![[zugriffsMatrix cellAt:2 :i] state]) {
			strcat(privileg,"D");
		}
		if (![[zugriffsMatrix cellAt:3 :i] state]) {
			strcat(privileg,"E");
		}

		saveString = [QueryString str:"insert into zugriffsrechte values("];
		[saveString concatFieldComma:anInt];
		[saveString concatFieldComma:className];
		[saveString concatSTR:"\""];
		[saveString concatSTR:privileg];
		[saveString concatSTR:"\")"];
		[className free];

		queryResult = [[NXApp defaultQuery] performQuery:[saveString str]];
		[saveString free];
		if(queryResult) {
			[queryResult free];
		}
	}	
	[anInt free];
	return self;
}


- performQueryFor:(int)aValue
{
	id		queryResult;
	id		queryString;
	id		anInt = [Integer int:aValue];
	int		i, startTag;
	BOOL	changeP, readP, deleteP, exportP;
	id		zugriff;

	
	actPrivileg = aValue;
	queryString = [QueryString str:"select zr_klassenname, zr_privilegien from zugriffsrechte where bp_privileg="];
	[queryString concatField:anInt];
	queryResult = [[NXApp defaultQuery] performQuery:[queryString str]];
	[queryString free];
	
	if(queryResult) {
		for (i=0;i<[queryResult count];i++) {
			zugriff = [queryResult objectAt:i];
			if(zugriff) {
				startTag= [self startTagFromVivaname:[[zugriff objectAt:0] str]];
				
				changeP = (index([[zugriff objectAt:1] str], PRIV_CHANGE) != NULL);
				readP	= (index([[zugriff objectAt:1] str], PRIV_READ) != NULL);
				deleteP = (index([[zugriff objectAt:1] str], PRIV_DELETE) != NULL);
				exportP	= (index([[zugriff objectAt:1] str], PRIV_EXPORT) != NULL);
				
				[[zugriffsMatrix cellAt:0 :startTag] setIntValue:!changeP];
				[[zugriffsMatrix cellAt:1 :startTag] setIntValue:!readP];
				[[zugriffsMatrix cellAt:2 :startTag] setIntValue:!deleteP];
				[[zugriffsMatrix cellAt:3 :startTag] setIntValue:!exportP];
			}
		}
		[queryResult free];
	}
	[anInt free];
	return self;
}

- (int)startTagFromVivaname:(const char *)vivaname
{
	if (strcmp(vivaname, [KundenDocument vivaname])==0) {
		return KUNDEN;
	} else if (strcmp(vivaname, [ArtikelDocument vivaname])==0) {
		return ARTIKEL;
	} else if (strcmp(vivaname, [AuftragsDocument vivaname])==0) {
		return AUFTR;
	} else if (strcmp(vivaname, [AngebotsDocument vivaname])==0) {
		return ANGEB;
	} else if (strcmp(vivaname, [BankenDocument vivaname])==0) {
		return BANKEN;
	} else if (strcmp(vivaname, [LieferantenDocument vivaname])==0) {
		return LIEFER;
	} else if (strcmp(vivaname, [LagerDocument vivaname])==0) {
		return LAGER;
	} else if (strcmp(vivaname, [BenutzerDocument vivaname])==0) {
		return BENUTZER;
	} 		
	return -1;
}


- (char *)vivanameForStartTag:(int)aTag
{
	switch(aTag) {
		case KUNDEN:	return [KundenDocument vivaname];
		case ARTIKEL:	return [ArtikelDocument vivaname];
		case AUFTR:		return [AuftragsDocument vivaname];
		case ANGEB:		return [AngebotsDocument vivaname];
		case BANKEN:	return [BankenDocument vivaname];
		case LIEFER:	return [LieferantenDocument vivaname];
		case LAGER:		return [LagerDocument vivaname];
		case BENUTZER:	return [BenutzerDocument vivaname];
		default:		return "";
	}
}
@end
