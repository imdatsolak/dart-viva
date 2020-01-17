#import <appkit/Cell.h>
#import <appkit/Button.h>
#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "BankItem.h"
#import "BankItemList.h"
#import "BankenDocument.h"
#import "BankenSelector.h"

#pragma .h #import "MasterSelector.h"

@implementation BankenSelector:MasterSelector
{
	id	blzField;
	id	nameField;
	id	kurznameField;
	id	nameSwitch;
	id	kurznameSwitch;

	id	blzStr;
	id	nameStr;
	id	kurznameStr;
	id	nameSwitchState;
	id	kurznameSwitchState;
}

- init
{
	[super init];
	CREATEFIELD(blzStr,String,blzField);
	CREATEFIELD(nameStr,String,nameField);
	CREATEFIELD(kurznameStr,String,kurznameField);
	CREATESWITCHSTATE(nameSwitchState,nameSwitch);
	CREATESWITCHSTATE(kurznameSwitchState,kurznameSwitch);
	[self writeFindPanel];
	return self;
}

- free
{
	[blzStr free];
	[nameStr free];
	[kurznameStr free];
	[nameSwitchState free];
	[kurznameSwitchState free];
	return [super free];
}

- readFields:(NXTypedStream *)typedStream
{
	[super readFields:typedStream];
	blzStr = NXReadObject(typedStream);
	nameStr = NXReadObject(typedStream);
	kurznameStr = NXReadObject(typedStream);
	nameSwitchState = NXReadObject(typedStream);
	kurznameSwitchState = NXReadObject(typedStream);
	return self;
}

- writeFields:(NXTypedStream *)typedStream
{
	[super writeFields:typedStream];
	NXWriteObject(typedStream,blzStr);
	NXWriteObject(typedStream,nameStr);
	NXWriteObject(typedStream,kurznameStr);
	NXWriteObject(typedStream,nameSwitchState);
	NXWriteObject(typedStream,kurznameSwitchState);
	return self;
}

- readFindPanel
{
	READFINDPANELCELL(blzStr,blzField);
	READFINDPANELCELL(nameStr,nameField);
	READFINDPANELCELL(kurznameStr,kurznameField);
	READFINDPANELSWITCH(nameSwitchState,nameSwitch);
	READFINDPANELSWITCH(kurznameSwitchState,kurznameSwitch);
	return self;
}

- writeFindPanel
{
	WRITEFINDPANELCELL(blzStr,blzField);
	WRITEFINDPANELCELL(nameStr,nameField);
	WRITEFINDPANELCELL(kurznameStr,kurznameField);
	WRITEFINDPANELSWITCH(nameSwitchState,nameSwitch);
	WRITEFINDPANELSWITCH(kurznameSwitchState,kurznameSwitch);
	return self;
}

- performQuery
{
	id		aQueryResult, queryString;
	
	queryString = [QueryString str:"select blz BLZ"];
	if([kurznameSwitchState isTrue]) [queryString concatSTR:",kurzbezeichnung Kurzbezeichnung"];
	if([nameSwitchState isTrue]) [queryString concatSTR:",bezeichnung Name"];
	[queryString concatSTR:" from banken"];
	[queryString concatSTR:" where blz like "];
	[queryString concatField:blzStr];
	[queryString concatSTR:" and kurzbezeichnung like "];
	[queryString concatField:kurznameStr];
	[queryString concatSTR:" and bezeichnung like "];
	[queryString concatField:nameStr];

	aQueryResult = [[NXApp defaultQuery] performQuery:queryString];
	
	[queryString free];
	
	if(theEntryList) [theEntryList free];
	[self localizeColumnNamesIn:aQueryResult];
	theEntryList = aQueryResult;
	return self;
}

- documentClass
{ return [BankenDocument class]; }

- itemClass
{ return [BankItem class]; }

- itemListClass
{ return [BankItemList class]; }

- copyObjectIdentityAtRow:(int)row
{ return [[[theEntryList objectAt:row] objectWithTag:1] copy]; }

- objectIdentityAtRow:(int)row
{ return [[theEntryList objectAt:row] objectWithTag:1]; }

@end
