#import <appkit/appkit.h>
#import "NetworkSpeaker.h"
#import <mach.h>
#import <sys/message.h>
#import <servers/netname.h>
extern port_t name_server_port;
extern id NXResponsibleDelegate();
@implementation  NetworkSpeaker :Speaker
{}
-(int)netGetHostName : (char **) hname
	andId : (char **) hid
/* */
{
return [self selectorRPC:"netGetHostName:andId:"
	paramTypes:"CC",
		hname,
		hid];
}
-(int)netHereIam : (char *) me
/* */
{
return [self selectorRPC:"netHereIam:"
	paramTypes:"c",
		me];
}
-(int)netCheckinHost : (char *) host
	password : (char *) password
	ok : (int *) ok
/* */
{
return [self selectorRPC:"netCheckinHost:password:ok:"
	paramTypes:"ccI",
		host,
		password,
		ok];
}
-(int)netCheckUserCount : (int *) ok
/* */
{
return [self selectorRPC:"netCheckUserCount:"
	paramTypes:"I",
		ok];
}
-(int)netIsDemo : (int *) flag
/* */
{
return [self selectorRPC:"netIsDemo:"
	paramTypes:"I",
		flag];
}
-(int)netIsExpired : (int *) flag
	date : (int) date
/* */
{
return [self selectorRPC:"netIsExpired:date:"
	paramTypes:"Ii",
		flag,
		date];
}
-(int)netByeBye : (char *) host
/* */
{
return [self selectorRPC:"netByeBye:"
	paramTypes:"c",
		host];
}
-(int)netAddedHost : (char *) host
	class : (char *) className
	identity : (char *) identity
/* */
{
return [self selectorRPC:"netAddedHost:class:identity:"
	paramTypes:"ccc",
		host,
		className,
		identity];
}
-(int)netChangedHost : (char *) host
	class : (char *) className
	identity : (char *) identity
/* */
{
return [self selectorRPC:"netChangedHost:class:identity:"
	paramTypes:"ccc",
		host,
		className,
		identity];
}
-(int)netDeletedHost : (char *) host
	class : (char *) className
	identity : (char *) identity
/* */
{
return [self selectorRPC:"netDeletedHost:class:identity:"
	paramTypes:"ccc",
		host,
		className,
		identity];
}
-(int)netLockHost : (char *) host
	class : (char *) class
	identity : (char *) identity
	ok : (int *) ok
/* */
{
return [self selectorRPC:"netLockHost:class:identity:ok:"
	paramTypes:"cccI",
		host,
		class,
		identity,
		ok];
}
-(int)netUnlockHost : (char *) host
	class : (char *) class
	identity : (char *) identity
/* */
{
return [self selectorRPC:"netUnlockHost:class:identity:"
	paramTypes:"ccc",
		host,
		class,
		identity];
}
-(int)AreYouStillAlive
/* */
{
return [self selectorRPC:"AreYouStillAlive"
	paramTypes:""];
}
@end
