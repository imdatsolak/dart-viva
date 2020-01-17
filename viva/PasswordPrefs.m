#import <stdio.h>
#import <appkit/TextField.h>

#import "dart/fieldvaluekit.h"
#import "dart/querykit.h"

#import "TheApp.h"
#import "StringManager.h"
#import "ErrorManager.h"

#import "PasswordPrefs.h"

#pragma .h #import "MasterPrefs.h"

@implementation PasswordPrefs:MasterPrefs
{
	id	pwTitleField;
	id	pwEnterField;
	
	id	oldPw;
	id	newPw;
	id	newPwDcheck;
	int	status;
}

- init
{
	[super init];
	oldPw			= [String str:""];
	newPw			= [String str:""];
	newPwDcheck		= [String str:""];
	return self;
}

- free
{
	[oldPw free];
	[newPw free];
	[newPwDcheck free];
	return [super free];
}

- redisplay:sender
{
	status = 0;
	[pwTitleField setStringValue:[[NXApp stringMgr] stringFor:"EnterOldPassword"]];
	[[[pwEnterField setTextGray:NX_WHITE] setStringValue:""] selectText:self];
	return self;
}

- enterPressed:sender
{
	status++;
	if (status == 3) {
		[newPwDcheck readFromCell:pwEnterField];
		[self changePassword];
		[self redisplay:self];
	} else if (status == 1) {
		[oldPw readFromCell:pwEnterField];
		[pwTitleField setStringValue:[[NXApp stringMgr] stringFor:"EnterNewPassword"]];
	} else if (status == 2) {
		[newPw readFromCell:pwEnterField];
		[pwTitleField setStringValue:[[NXApp stringMgr] stringFor:"Re-EnterNewPassword"]];
	}
	[[[pwEnterField setTextGray:NX_WHITE] setStringValue:""] selectText:self];
	return self;
}

- changePassword
{
	id	queryString;
	if ([newPw compare:newPwDcheck] == 0) {
		queryString = [QueryString str:"sp_password "];
		[queryString concatFieldComma:oldPw];
		[queryString concatField:newPw];
		[[[NXApp defaultQuery] performQuery:queryString] free];
		[queryString free];
		if ([[NXApp defaultQuery] lastError] == NOERROR) {
			[[NXApp errorMgr] showDialog:"PwChanged"];
		} else {
			[[NXApp errorMgr] showDialog:"PwNotChanged"];
		}
	} else {
		[NXApp beep:"PwDoubleCheckWrong"];
	}
	return self;
}

- reloadPrefs:sender
{ return self; }

- savePrefs:sender
{ return self; }

@end
