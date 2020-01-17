#import <objc/Object.h>

@interface Localizer:Object
{
	id	localizedPath;
	id	localLanguage;
	id	appLaunchDir;
}

- init;
- free;
- checkFatal:result resource:(const char *)resourceName;
- appLaunchDir;
- localLanguage;
- localizedPath;
- loadLocalNib:(const char *)nibFile owner:owner;
- loadLocalImage:(const char *)imageName;
- loadLocalStringTable:(const char *)stringTableName;
- loadLocalSound:(const char *)soundfileName;
- loadLocalClasses;

@end


@interface Object(LinkObject)
- (const char *)publicname;
- (const char *)copyright;

@end

