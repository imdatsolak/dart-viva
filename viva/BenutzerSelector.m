#import <appkit/Cell.h>
#import <appkit/Button.h>
#import "dart/querykit.h"

#import "TheApp.h"
#import "BenutzerItem.h"
#import "BenutzerItemList.h"
#import "BenutzerDocument.h"
#import "BenutzerSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation BenutzerSelector:MasterSelector
{
}

- performQuery
{
	id		aQueryResult, queryString;
	
	queryString = [QueryString str:"insert into benutzer select convert(varchar(12), master.dbo.syslogins.suid),\"\",0.0,0 from master.dbo.syslogins where convert(varchar(12), master.dbo.syslogins.suid) not in (select uid from benutzer)"];
	[[[NXApp defaultQuery] performQuery:queryString] free];
	[queryString free];
	queryString = [QueryString str:"select convert(varchar(12), master.dbo.syslogins.suid) Nr, master.dbo.syslogins.name Name, benutzer.vollername VollerName, benutzer.provision Provision, zugriffsrechte.value ZR from master.dbo.syslogins, benutzer,zugriffsrechte where master.dbo.syslogins.suid > 1 and benutzer.uid=convert(varchar(12), master.dbo.syslogins.suid) and zugriffsrechte.key=benutzer.zugriff"];
	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];	
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[self localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [BenutzerDocument class]; }

- itemClass
{ return [BenutzerItem class]; }

- itemListClass
{ return [BenutzerItemList class]; }

- copyObjectIdentityAtRow:(int)row
{ return [[[theEntryList objectAt:row] objectWithTag:1] copy]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
