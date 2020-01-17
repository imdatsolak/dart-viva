#import <libc.h>
#import <string.h>
#import <sys/dir.h>
#import <streams/streams.h>
#import <sys/param.h>
#import <sys/file.h>
#import <defaults.h>
#import <objc/objc-load.h>
#import <objc/NXStringTable.h>
#import <objc/List.h>
#import <appkit/defaults.h>
#import <appkit/nextstd.h>
#import <appkit/Application.h>
#import <appkit/Panel.h>
#import <appkit/NXImage.h>

#import <dart/String.h>
#import <dart/debug.h>

#import "Localizer.h"

#import "dart/String.h"

#pragma .h #import <objc/Object.h>

id	classList;

void load_module(Class newClass, Category newCategory)
{
    if ([(id)newClass respondsTo:@selector(publicname)]) {
		[classList addObject:(id)newClass];
		DEBUG10("Loaded class: [%s]\n",[(id)newClass publicname]);
		DEBUG10("       copyright:\n%s\n",[(id)newClass copyright]);
	}
}

static BOOL isOk(const char *s)
{
    return (!s[0] || s[0] == '.') ? NO : YES;
}

@implementation Localizer:Object
{
	id	localizedPath;
	id	localLanguage;
	id	appLaunchDir;
}

- init
{
    const char *const 	*languages;
    char 				path[MAXPATHLEN+1];
   	BOOL				found = NO;
	int					i;

	[super init];
	
	strcpy(path, NXArgv[0]);
	for (i=strlen(path)-1;i>=0 && path[i] != '/'; i--) {
		path[i] = '\0';
	}
	appLaunchDir = [String str:path];
	[appLaunchDir concatSTR:"."];
	
    languages = [NXApp systemLanguages];
	if ( !languages ) {
		static const char *german[] = {"German",NULL};
		languages = german;
	}
	
	while (!found && *languages) {
		sprintf(path, "%s/%s.lproj", [appLaunchDir str], *languages);
		if (0 == access(path, R_OK | X_OK)) {
			localLanguage = [String str:*languages];
			found = YES;
		}
		languages++;
	}
	[self checkFatal:(id)found resource:"Language Directories"];
	
	localizedPath = [appLaunchDir copy];
	[localizedPath concatSTR:"/"];
	[localizedPath concat:localLanguage];
	[localizedPath concatSTR:".lproj/"];
	
	return self;
}

- free
{
	[localizedPath free];
	[localLanguage free];
	[appLaunchDir free];
	return [super free];
}


- checkFatal:result resource:(const char *)resourceName
{
	if (!result) {
		NXRunAlertPanel("Fatal","Could not find language resource ª%sº.","Terminate",NULL,NULL, resourceName);
		[self error:"Could not find language resource ª%sº.", resourceName];
	}
	return self;
} 


- appLaunchDir
{ return appLaunchDir; }

- localLanguage
{ return localLanguage; }

- localizedPath
{ return localizedPath; }


- loadLocalNib:(const char *)nibFile owner:owner
{
	id retVal;
	id path = [[[localizedPath copy] concatSTR:nibFile] concatSTR:".nib"];
	
	retVal =  [NXApp loadNibFile:[path str] owner:owner withNames:YES];
	[self checkFatal:retVal resource:[path str]];
	[path free];
	return retVal;
}

	

- loadLocalImage:(const char *)imageName
{
	id image=nil;
	FILE	*fp;
	id path= [[[[localizedPath copy] concatSTR:"TIFFS/"] concatSTR:imageName] concatSTR:".eps"];

	DEBUG10("Alternate Path for img: [%s]\n",[path str]);
	if ((fp = fopen([path str],"r")) != NULL) {
		fclose(fp);
		image = [[NXImage alloc] initFromFile:[path str]];
	}
	if (image == nil) {
		[path free];
		path = [[[[localizedPath copy] concatSTR:"TIFFS/"] concatSTR:imageName] concatSTR:".tiff"];
		DEBUG10("Default Path for img: [%s]\n",[path str]);
		image = [[NXImage alloc] initFromFile:[path str]];
	}
	[self checkFatal:image resource:[path str]];
	[path free];
	
    return image;
}


- loadLocalStringTable:(const char *)stringTableName
{
	id stringTable;
	id path = [[[[localizedPath copy] concatSTR:"STRINGS/"] concatSTR:stringTableName] concatSTR:".strings"];
	
	stringTable = [[[NXStringTable alloc] init] readFromFile:[path str]];
	[self checkFatal:stringTable resource:[path str]];
	[path free];

	return stringTable;
}


- loadLocalSound:(const char *)soundfileName
{
	return self;
}

- loadLocalClasses
{
	int			i, count;
    const char	*moduleList[2];
    NXStream	*errorStream;
    long 		basep;
    char 		*buf;
    struct 		direct *dp;
    int 		cc, fd;
    char 		dirbuf[8192];
	BOOL		wasError = NO;
	id			nameList = [[List alloc] initCount:0];
	id 			path = [[localizedPath copy] concatSTR:"EXTENDS/"];

    if ((fd = open([path str] , O_RDONLY, 0644)) > 0) {
		cc = getdirentries(fd, (buf = dirbuf), 8192, &basep);
		while (cc) {
			dp = (struct direct *)buf;
			if (isOk(dp->d_name)) {
				id	newName = [String str:[path str]];
				[newName concatSTR:dp->d_name];
				[nameList addObject:newName];
				DEBUG10("Found external object:[%s]\n", dp->d_name);
			}
			buf += dp->d_reclen;
			if (buf >= dirbuf + cc) {
				cc = getdirentries(fd, (buf = dirbuf), 8192, &basep);
			}
		}
		close(fd);
    }
	
	count = [nameList count];
	classList = [[List alloc] initCount:count];

	errorStream = NXOpenMemory(NULL, 0, NX_WRITEONLY);
	for (i=count-1;i>=0;i--) {
		moduleList[0] = [[nameList objectAt:i] str];
		moduleList[1] = NULL;
		if (objc_loadModules(moduleList, errorStream, load_module, 0, 0)){
			wasError = YES;
		}
	}
	[[nameList freeObjects] free];

	if (wasError) {
		char	*errorstring;
		int		length, max;
		
		NXGetMemoryBuffer(errorStream, &errorstring, &length, &max);	    
		if (NXRunAlertPanel("Fatal",errorstring, "Terminate", "Continue", NULL)) {
			[self error:errorstring];
		} else {
			[[classList freeObjects] free];
			classList = nil;
		}
	}
	NXClose(errorStream);
	[path free];
	return classList;
}

@end

@interface Object(LinkObject)
- (const char *)publicname;
- (const char *)copyright;
@end
