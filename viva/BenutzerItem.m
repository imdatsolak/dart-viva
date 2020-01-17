#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "AttachmentList.h"
#import "BenutzerItemList.h"

#import "BenutzerItem.h"

#pragma .h #import "MasterItem.h"

const char *tablenames[] = {"adressen","angebot","maxangebot","artikel","artikellieferanten","attachments","bindata","maxbindataid","auftrag","maxauftrag","auftragsartikel","banken","benutzer","benutzerpopupview","bestellung","maxbestellung","konditionen","kunden","lagervorgang","lager","lagerartikel","lagerpopupview","layout","maxlayout","lieferschein","maxlieferschein","preferences","rechnung","maxrechnung","seriennummern","stuecklisten","subkonditionen","artikelkategorien","kundeneinstufung","kundengroesse","kundenkategorien","mengeneinheiten","sammelrechnungen","mwstsaetze","laender","layoutkategorien","janein","zugriffsrechte","variablen","kundenkonto","maxbuchung","zugriffe","vivadumps","bankverbindung",NULL};

@implementation BenutzerItem:MasterItem
{
	id	uid;
	id	bname;
	id	vollername;
	id	provision;
	id	zugriff;

	id	attachmentList;
}

+ (BOOL)exists:identity
{
	return YES;
}

- itemListClass
{ return [BenutzerItemList class]; }

- initIdentity:identity
{
	id	queryResult, benutzer;

	[self init];
	
	queryString = [QueryString str:"select convert(varchar(12), master.dbo.syslogins.suid), master.dbo.syslogins.name, benutzer.vollername, benutzer.provision, benutzer.zugriff from master.dbo.syslogins, benutzer where master.dbo.syslogins.suid > 1 and benutzer.uid=convert(varchar(12), master.dbo.syslogins.suid) and convert(varchar(12), master.dbo.syslogins.suid)="];
	[queryString concatField:identity];
	queryResult = [self selectAndFreeQueryString];
	
	benutzer = [queryResult objectAt:0];
	if(benutzer) {
		[self setUid:[benutzer objectAt:0]];
		[self setBname:[benutzer objectAt:1]];
		[self setVollername:[benutzer objectAt:2]];
		[self setProvision:[benutzer objectAt:3]];
		[self setZugriff:[benutzer objectAt:4]];

		attachmentList	= [[AttachmentList alloc] initForBenutzer:[self identity]];

		isNew = NO;
		[queryResult free];
		return self;
	} else {
		[queryResult free];
		return [self free];
	}
}

- initNew
{
	[self init];
	uid				= [String str:""];
	bname			= [String str:""];
	vollername		= [String str:""];
	provision		= [Double double:0.0];
	zugriff			= [Integer int:0];
	attachmentList	= [[AttachmentList alloc] initNew];
	return self;
}


- free
{
	[uid free];
	[bname free];
	[vollername free];
	[provision free];
	[zugriff free];
	[attachmentList free];
	
	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	uid				= [uid copy];
	bname			= [bname copy];
	vollername		= [vollername copy];
	provision		= [provision copy];
	zugriff			= [zugriff copy];
	attachmentList	= [attachmentList copy];
	
	return theCopy;
}


- (BOOL)update
{
	queryString = [QueryString str:"update benutzer set "];
	[[queryString concatSTR:"vollername="] concatFieldComma:vollername];
	[[queryString concatSTR:"provision="] concatFieldComma:provision];
	[[queryString concatSTR:"zugriff="] concatField:zugriff];
	[[queryString concatSTR:" where uid="] concatField:uid];
	
	return [self updateAndFreeQueryString] && [attachmentList saveForBenutzer:[self identity]];
}
	
- grant
{
	int	i = 0;
	id	aQstr = [QueryString str:""];
	while (tablenames[i]) {
		[aQstr str:"grant all on "];
		[aQstr concatSTR:tablenames[i]];
		[aQstr concatSTR:" to "];
		[aQstr concatSTR:[bname str]];
		[[NXApp defaultQuery] performQuery:aQstr];
		i++;
	}
	[aQstr free];
	return self;
}

- (BOOL)insert
{
	return YES;
}

- (BOOL)delete
{
	BOOL	deleted;
	queryString = [QueryString str:"delete from benutzer where uid="];
	[queryString concatField:uid];
	deleted = [self deleteAndFreeQueryString] && [attachmentList destroyForBenutzer:[self identity]];
	if (deleted) {
		queryString = [QueryString str:"sp_dropuser "];
		[queryString concatField:bname];
		[[[NXApp defaultQuery] performQuery:queryString] free];
		queryString=[queryString free];
	}
	return deleted;
}

- addAttachment:attachment
{
	[attachmentList addAttachment:attachment];
	return self;
}

- identity
{
	return [self uid];
}

- uid { return uid; }
- setUid:anObject { [uid free]; uid = [anObject copy]; return self; }
- bname { return bname; }
- setBname:anObject { [bname free]; bname = [anObject copy]; return self; }
- vollername { return vollername; }
- setVollername:anObject { [vollername free]; vollername = [anObject copy]; return self; }
- provision { return provision; }
- setProvision:anObject { [provision free]; provision = [anObject copy]; return self; }
- zugriff { return zugriff; }
- setZugriff:anObject { [zugriff free]; zugriff = [anObject copy]; return self; }
- attachmentList { return attachmentList; }
- setAttachmentList:anObject { [attachmentList free]; attachmentList = [anObject copy]; return self; }
@end

#if 0
BEGIN TABLE DEFS
create table benutzer
(
	uid			varchar(12),
	vollername	varchar(40),
	provision	float,
	zugriff		int
)
create unique clustered index benutzerindex on benutzer(uid)
go
/*create view benutzerpopupview(key,value) as select suid, name from master.dbo.syslogins where suid in (*/
/*select convert(int,uid ) from benutzer)*/
create view benutzerpopupview(key,value) as select sysusers.suid, sysusers.name from sysusers
go
END TABLE DEFS
#endif

