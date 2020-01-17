#import "dart/querykit.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"
#import "TableManager.h"
#import "AddressItem.h"

#pragma .h #import "MasterItem.h"

@implementation AddressItem:Object
{
	id	position;
	id	name1;
	id	name2;
	id	name3;
	id	strasse;
	id	plzort;
	id	landnr;
	id	tel;
	id	fax;
	id	telex;
	id	email;
}

- initPosition:aPosition name1:aName1 name2:aName2 name3:aName3 strasse:aStrasse plzort:aPlzort landnr:aLandnr tel:aTel fax:aFax telex:aTelex email:anEmail
{
	[self init];
	position = [aPosition copy];
	name1 = [aName1 copy];
	name2 = [aName2 copy];
	name3 = [aName3 copy];
	strasse = [aStrasse copy];
	plzort = [aPlzort copy];
	landnr = [aLandnr copy];
	tel = [aTel copy];
	fax = [aFax copy];
	telex = [aTelex copy];
	email = [anEmail copy];
	return self;
}			

- initNewPosition:(int)pos
{
	[self init];
	
	position	= [Integer int:pos];
	name1		= [String str:""];
	name2		= [String str:""];
	name3		= [String str:""];
	strasse		= [String str:""];
	plzort		= [String str:""];
	landnr		= [Integer int:0];
	tel			= [String str:""];
	fax			= [String str:""];
	telex		= [String str:""];
	email		= [String str:""];
	
	return self;
}


- free
{
	[position free];
	[name1 free];
	[name2 free];
	[name3 free];
	[strasse free];
	[plzort free];
	[landnr free];
	[tel free];
	[fax free];
	[telex free];
	[email free];

	return [super free];
}


- copy
{
	id	theCopy = [super copy];
	
	position	= [position copy];
	name1		= [name1 copy];
	name2		= [name2 copy];
	name3		= [name3 copy];
	strasse		= [strasse copy];
	plzort		= [plzort copy];
	landnr		= [landnr copy];
	tel			= [tel copy];
	fax			= [fax copy];
	telex		= [telex copy];
	email		= [email copy];
	
	return theCopy;
}

- appendFieldsToQueryString:queryString
{
	[queryString concatFieldComma:position];
	[queryString concatFieldComma:name1];
	[queryString concatFieldComma:name2];
	[queryString concatFieldComma:name3];
	[queryString concatFieldComma:strasse];
	[queryString concatFieldComma:plzort];
	[queryString concatFieldComma:landnr];
	[queryString concatFieldComma:tel];
	[queryString concatFieldComma:fax];
	[queryString concatFieldComma:telex];
	[queryString concatField:email];
	
	return self;
}

- (int)compare:anotherObject
{
	return [position compare:[anotherObject position]];
}


- landStr
{
	return [[NXApp popupMgr] valueFor:[landnr int] inTable:"laender"];
}
- position { return position; }
- setPosition:anObject { [position free]; position = [anObject copy]; return self; }
- name1 { return name1; }
- setName1:anObject { [name1 free]; name1 = [anObject copy]; return self; }
- name2 { return name2; }
- setName2:anObject { [name2 free]; name2 = [anObject copy]; return self; }
- name3 { return name3; }
- setName3:anObject { [name3 free]; name3 = [anObject copy]; return self; }
- strasse { return strasse; }
- setStrasse:anObject { [strasse free]; strasse = [anObject copy]; return self; }
- plzort { return plzort; }
- setPlzort:anObject { [plzort free]; plzort = [anObject copy]; return self; }
- landnr { return landnr; }
- setLandnr:anObject { [landnr free]; landnr = [anObject copy]; return self; }
- tel { return tel; }
- setTel:anObject { [tel free]; tel = [anObject copy]; return self; }
- fax { return fax; }
- setFax:anObject { [fax free]; fax = [anObject copy]; return self; }
- telex { return telex; }
- setTelex:anObject { [telex free]; telex = [anObject copy]; return self; }
- email { return email; }
- setEmail:anObject { [email free]; email = [anObject copy]; return self; }


@end

