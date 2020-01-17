#import "TheApp.h"

#import "RegisterBruellen.h"

@implementation RegisterBruellen

- init
{
	[super init];
	[NXApp loadNibFile:"RegisterBruellen.nib" owner:self];
	return self;
}

- free
{
	[thePanel free];
	return [super free];
}

- checkRegistrationAndLicences
{
	return self;
}


@end
