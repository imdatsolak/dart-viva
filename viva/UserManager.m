#import <appkit/graphics.h>
#import <appkit/TextField.h>
#import <appkit/Panel.h>
#include <strings.h>

#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"
#import "dart/Localizer.h"

#import "StringManager.h"
#import "ErrorManager.h"
#import "TheApp.h"

#import "UserManager.h"

#pragma .h #import <objc/Object.h>

#define DBNAME		"viva2DB"
#define	DBDEVICE	"Viva2Database"
#define TRANDEVICE	"Viva2Transaction"

#define DBPATH		"/usr/sybase/database/Viva2Database"
#define TRANPATH	"/usr/sybase/database/Viva2Transaction"

#define DBDEVNO		6
#define TRANDEVNO	7

#define DBSIZE		10000
#define	TRANSIZE	5000


@implementation UserManager:Object
{
	id	currentUserID;
	id	nameField;
	id	pwField;
	id	loginPanel;
	id	newLoginPanel;
	id	currentUserName;
	id	userPrivileg;
	id	zugriffe;
	
	id	instDBPanel;
	id	instDBMsgField;
}

- init
{
	NXRect	aFrame;
	id		content;
	[super init];
	[[NXApp localizer] loadLocalNib:[self name] owner:self];
	currentUserID = [Integer int:1];
	currentUserName = [String str:""];
	userPrivileg = [Integer int:0];
	content = [loginPanel contentView];
	[content getFrame:&aFrame];
	newLoginPanel = [[Window alloc] initContent:&aFrame
								   style:NX_PLAINSTYLE
								   backing:NX_BUFFERED
								   buttonMask:0
								   defer:YES];
	[content removeFromSuperview];
	[[newLoginPanel setContentView:content] free];
	return self;
}

- initIdentity:identity
{
	return [self init];
}

- free
{
	if (zugriffe) {
		zugriffe = [zugriffe free];
	}
	[currentUserID free];
	[currentUserName free];
	[userPrivileg free];
	return [super free];
}

/* --- INSTALLATION STUFF --- */
- createDBOn:(const char *)dbPath andTransactionLog:(const char *)transactionPath dbSize:(int)dbSize andTranLogSize:(int)tranLogSize withQuery:theQuery
{
	id	qStr;
	id	aQuery = theQuery;
	int	oldTO= [Query timeout];
	
	if ([[NXApp errorMgr] showDialog:"CreateDB" yesButton:"OK" noButton:"CANCEL"] == EHYES_BUTTON) {
		[Query setTimeout:0];
		
		[instDBPanel makeKeyAndOrderFront:self];
		[[instDBMsgField setStringValue:[[NXApp stringMgr] stringFor:"dbDriveCreation"]] display];
		[instDBPanel display];
		NXPing();
		qStr = [QueryString str:"DISK INIT NAME = \""];
		[qStr concatSTR:DBDEVICE];
		[qStr concatSTR:"\",PHYSNAME = \""];
		[qStr concatSTR:dbPath];
		[qStr concatSTR:"\", VDEVNO = "];
		[qStr concatINT:DBDEVNO];
		[qStr concatSTR:", SIZE = "];
		[qStr concatINT:(int)(dbSize / 2)+10];
		[aQuery performQuery:qStr];
		if ([aQuery lastError] != NOERROR) {
			[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
			[instDBPanel orderOut:self];
			return self;
		}	
	
		[[instDBMsgField setStringValue:[[NXApp stringMgr] stringFor:"tranDriveCreation"]] display];
		[instDBPanel display];
		NXPing();
		[qStr str:"DISK INIT NAME = \""];
		[qStr concatSTR:TRANDEVICE];
		[qStr concatSTR:"\",PHYSNAME = \""];
		[qStr concatSTR:transactionPath];
		[qStr concatSTR:"\", VDEVNO = "];
		[qStr concatINT:TRANDEVNO];
		[qStr concatSTR:", SIZE = "];
		[qStr concatINT:(int)(tranLogSize/2)+10];
		[aQuery performQuery:qStr];
		if ([aQuery lastError] != NOERROR) {
			[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
			[instDBPanel orderOut:self];
			return self;
		}	
	
		[[instDBMsgField setStringValue:[[NXApp stringMgr] stringFor:"dbCreation"]] display];
		[instDBPanel display];
		NXPing();
	
		[qStr str:"create database "];
		[qStr concatSTR:DBNAME];
		[qStr concatSTR:" on "];
		[qStr concatSTR:DBDEVICE];
		[qStr concatSTR:"="];
		[qStr concatINT:dbSize];
		[qStr concatSTR:" log on "];
		[qStr concatSTR:TRANDEVICE];
		[qStr concatSTR:"="];
		[qStr concatINT:tranLogSize];
		[aQuery performQuery:qStr];
		if ([aQuery lastError] != NOERROR) {
			[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
			[instDBPanel orderOut:self];
			return self;
		}	
		
		[[instDBMsgField setStringValue:[[NXApp stringMgr] stringFor:"dbLoad"]] display];
		[instDBPanel display];
		NXPing();
		[qStr str:"sp_addumpdevice \"disk\",vivaDBDev,\""];
		[qStr concatSTR:[[[NXApp localizer] localizedPath] str]];
		[qStr concatSTR:"viva2DBBackup.dsqldmp\",2"];
		[aQuery performQuery:qStr];
		if ([aQuery lastError] != NOERROR) {
			[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
			[instDBPanel orderOut:self];
			return self;
		}	
		
		[qStr str:"load database "];
		[qStr concatSTR:DBNAME];
		[qStr concatSTR:" from vivaDBDev"];
		[aQuery performQuery:qStr];
		if ([aQuery lastError] != NOERROR) {
			[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
			[instDBPanel orderOut:self];
			return self;
		}	
		
		[[instDBMsgField setStringValue:[[NXApp stringMgr] stringFor:"dbFinish"]] display];
		[instDBPanel display];
		NXPing();
		[qStr str:"sp_dropdevice vivaDBDev"];
		[aQuery performQuery:qStr];
		[Query setTimeout:oldTO];
		[instDBPanel orderOut:self];
	}
	[[NXApp errorMgr] showDialog:"DBCreated"];
	return self;
}


- checkLogin
{
	id		theQuery;
	BOOL	loggedIn = NO;

	while (!loggedIn) {
		[pwField setTextGray:NX_WHITE];
		[pwField setBackgroundGray:NX_WHITE];
		[nameField setStringValue:""];
		[pwField setStringValue:""];
		[nameField selectText:self];
		[NXApp runModalFor:newLoginPanel];
		[currentUserName readFromCell:nameField];
		theQuery = [[BulkQuery alloc] initUser:[currentUserName str]
											password:[pwField stringValue]
											program:"viva2"];
		loggedIn = (theQuery != nil);
		if (loggedIn) {
			id	result;
			id	qStr;
			[theQuery useLog:YES];
			[theQuery useDatabase:"viva2DB"];
			if ([theQuery lastError] == NOERROR) {
				[theQuery setTextSize:1024000 andLimit:1024000];
				qStr=[QueryString str:"select s.suid,b.zugriff from master.dbo.syslogins s,benutzer b where s.name="];
				[qStr concatField:currentUserName];
				[qStr concatSTR:" and b.uid=convert(varchar(12),s.suid)"];
				result = [theQuery performQuery:qStr];
				[qStr free];
				if (([theQuery lastError] == NOERROR) && (result!=nil) && ([result objectAt:0]!=nil)){
					[currentUserID free];
					currentUserID = [[[result objectAt:0] objectAt:0] copy];
					userPrivileg = [[[result objectAt:0] objectAt:1] copy];
				} else {
					[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
					loggedIn = NO;
				}
				[result free];
			} else {
				if (([theQuery lastError] == 911) && ([currentUserName compareSTR:"sa"]==0)) {
					if ([[NXApp errorMgr] showDialog:"MissingDB" yesButton:"YES" noButton:"NO"]==EHYES_BUTTON) {
						[self createDBOn:DBPATH 
								andTransactionLog:TRANPATH 
								dbSize:DBSIZE 
								andTranLogSize:TRANSIZE
								withQuery:theQuery];
					}
				} else {
					[[NXApp errorMgr] showLastSybaseErrorFrom:theQuery];
				}
				loggedIn = NO;
			}
		}
		if (!loggedIn) {
			theQuery = [theQuery free];
		} else {
			[newLoginPanel orderOut:self];
		}
	}
	[self loadZugriffe:theQuery];
	return theQuery;
}

- (BOOL)loadZugriffe:theQuery
{
	id	queryString;
	id	result;
	
	if (zugriffe) {
		zugriffe = [zugriffe free];
	}	
	queryString = [QueryString str:"select klassenname, permissions from zugriffe"];
	[queryString concatSTR:" where privileg="];
	[queryString concatField:userPrivileg];
	result = [theQuery performQuery:queryString];
	[queryString free];
	if (result && ([theQuery lastError] == NOERROR)) {
		zugriffe = result;
		[zugriffe sort];
	} else {
		[result free];
		return NO;
	}
	return YES;
}

- currentUserID
{
	return currentUserID;
}

- (BOOL)isSuperuser
{
	return ([currentUserName compareSTR:"sa"] == 0);
}

- (BOOL)canAdd:(const char *)vivaclass
{
	return [self isSuperuser] || [self object:[self findZugriffsrechtFor:vivaclass] containsKey:'A'];
}

- (BOOL)canChange:(const char *)vivaclass
{
	return [self isSuperuser] || [self object:[self findZugriffsrechtFor:vivaclass] containsKey:'C'];
}

- (BOOL)canRead:(const char *)vivaclass
{
	return [self isSuperuser] || [self object:[self findZugriffsrechtFor:vivaclass] containsKey:'R'];
}

- (BOOL)canDelete:(const char *)vivaclass
{
	return [self isSuperuser] || [self object:[self findZugriffsrechtFor:vivaclass] containsKey:'D'];
}

- (BOOL)canExport:(const char *)vivaclass
{
	return [self isSuperuser] || [self object:[self findZugriffsrechtFor:vivaclass] containsKey:'E'];
}

- (BOOL)canSelect:(const char *)vivaclass
{
	return [self isSuperuser] || [self object:[self findZugriffsrechtFor:vivaclass] containsKey:'S'];
}

- (BOOL)object:anObject containsKey:(char)aKey
{
	if (anObject == nil) {
		return YES;
	}
	return (index([anObject str],aKey)!=NULL);
}

- findZugriffsrechtFor:(const char *)aClassName
{
	if (aClassName != NULL) {
		int i, count = [zugriffe count];
		for (i=0;i<count;i++) {
			if ([[[zugriffe objectAt:i] objectAt:0] compareSTR:aClassName] == 0) {
				return [[zugriffe objectAt:i] objectAt:1];
			}
		}
	} 
	return nil;
}

- login:sender
{
	[NXApp stopModal:1];
	return self;
}

- cancel:sender
{
	[NXApp stopModal:0];
	[newLoginPanel orderOut:self];
	return [NXApp terminate:self];
}


@end
