#import <objc/NXStringTable.h>

#import "dart/debug.h"
#import "dart/Localizer.h"
#import "dart/fieldvaluekit.h"

#import "TheApp.h"

#import "StringManager.h"

#pragma .h #import <objc/Object.h>

@implementation StringManager:Object
{
	id	defaultStringTable;
	id	errorStringTable;
	id	windowTitleStringTable;
	id	publicClassNameStringTable;
	id	networkStringTable;
	id	miniWindowIconNameStringTable;
	id	variableStringTable;
}


- init
{
	id	fileName;

	[super init];
	
	fileName = [[[[NXApp localizer] appLaunchDir] copy] concatSTR:"/.NetConfig.strings"];
	networkStringTable = [[[NXStringTable alloc] init] readFromFile:[fileName str]];
	fileName = [fileName free];
	
	errorStringTable = [[NXApp localizer] loadLocalStringTable:"Errors"];
	windowTitleStringTable = [[NXApp localizer] loadLocalStringTable:"WindowTitles"];
	publicClassNameStringTable = [[NXApp localizer] loadLocalStringTable:"PublicClass"];
	miniWindowIconNameStringTable = [[NXApp localizer] loadLocalStringTable:"MiniWindowIconName"];
	defaultStringTable = [[NXApp localizer] loadLocalStringTable:"Viva"];
	variableStringTable = [[NXApp localizer] loadLocalStringTable:"Variables"];
	return self;
}

- free
{
	[defaultStringTable free];
	[errorStringTable free];
	[windowTitleStringTable free];
	[publicClassNameStringTable free];
	[networkStringTable free];
	[miniWindowIconNameStringTable free];
	[variableStringTable free];

	return [super free];
}

- (const char *)valueForKey:(const char *)key fromTable:theStringTable
{
	const char *value = [theStringTable valueForStringKey:key];

	IFDEBUG5 {
		if (theStringTable == defaultStringTable) {
			DEBUG5("stringFor:");
		} else if (theStringTable == errorStringTable){
			DEBUG5("textForErrCode:");
		} else if (theStringTable == windowTitleStringTable){
			DEBUG5("windowTitleFor:");
		} else if (theStringTable == publicClassNameStringTable){
			DEBUG5("publicClassNameFor:");
		} else if (theStringTable == networkStringTable){
			DEBUG5("stringForNetworkKey:");
		} else if (theStringTable == miniWindowIconNameStringTable){
			DEBUG5("miniWindowIconName:");
		}
		DEBUG5("\"%s\"==\"%s\"\n", key, value);
	}

	return value? value:key;
}
	
- (const char *)miniWindowIconNameFor:(const char *)key
{ return [self valueForKey:key fromTable:miniWindowIconNameStringTable]; }

- (const char *)stringFor:(const char *)key
{ return [self valueForKey:key fromTable:defaultStringTable]; }

- (const char *)textForErrCode:(const char *)anErrCode
{ return [self valueForKey:anErrCode fromTable:errorStringTable]; }

- (const char *)windowTitleFor:(const char *)windowClass
{ return [self valueForKey:windowClass fromTable:windowTitleStringTable]; }

- (const char *)publicClassNameFor:(const char *)classname
{ return [self valueForKey:classname fromTable:publicClassNameStringTable]; }

- (const char *)stringForNetworkKey:(const char *)networkKey
{ return [self valueForKey:networkKey fromTable:networkStringTable]; }

- (const char *)stringForVariableKey:(const char *)variableKey
{ return [self valueForKey:variableKey fromTable:variableStringTable]; }

- defaultStringTable { return defaultStringTable; }
- errorStringTable { return errorStringTable; }
- windowTitleStringTable { return windowTitleStringTable; }
- publicClassNameStringTable { return publicClassNameStringTable; }
- networkStringTable { return networkStringTable; }
- miniWindowIconNameStringTable { return miniWindowIconNameStringTable; }
- variableStringTable { return variableStringTable; }
@end
