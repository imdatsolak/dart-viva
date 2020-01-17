@implementation RegisterBruellen:Object
{
	id	registerPanel;
	id	helpPanel;

	id	companyField;
	id	passwordField;
	id	hostidField;
	id	numberUsersField;
	id	expiresField;
	id	demoReleaseField;
	
	id	company;
	id	password;
}

- init
{
	[super init];
	[[NXApp localizer] loadLocalNib:[[self class] name] owner:self];
	return self;
}

- makeActive:self
{
	id	result;
	id	qStr = [QueryString str:"select company,password from register"];
	
	result = [[NXApp defaultQuery] performQuery:qStr];
	if ([[NXApp defaultQuery] lastError] == NOERROR) {
		company = [[[result objectAt:0] objectAt:0] copy];
		password = [[[result objectAt:0] objectAt:1] copy];
		[result free];
	} else {
		[result free];
		return nil;
	}
	[registerPanel makeKeyAndOrderFront:self];
	[NXApp runModalFor:registerPanel];
	[self free];
	return (id)1;
}


- dd
{
daemonHostID

- okButtonPressed:sender
{
}

- cancelButtonPressed:sender
{
	[NXApp stopModal:0];
	[NXApp terminate:self];
	return self;
}


@end
