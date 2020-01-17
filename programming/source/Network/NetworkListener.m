#import <appkit/appkit.h>
#import "NetworkListener.h"
#import <mach.h>
#import <sys/message.h>
#import <servers/netname.h>
extern port_t name_server_port;
extern id NXResponsibleDelegate();
@implementation  NetworkListener :Listener
{}
static NXRemoteMethod *remoteMethods = NULL;
#define REMOTEMETHODS 13
+ (void)initialize 
/* */
{
    if (!remoteMethods) {
	remoteMethods =
	(NXRemoteMethod *) malloc((REMOTEMETHODS+1)*sizeof(NXRemoteMethod));
	remoteMethods[0].key = 
	@selector(netGetHostName:andId:);
	remoteMethods[0].types = "CC";
	remoteMethods[1].key = 
	@selector(netHereIam:);
	remoteMethods[1].types = "c";
	remoteMethods[2].key = 
	@selector(netCheckinHost:password:ok:);
	remoteMethods[2].types = "ccI";
	remoteMethods[3].key = 
	@selector(netCheckUserCount:);
	remoteMethods[3].types = "I";
	remoteMethods[4].key = 
	@selector(netIsDemo:);
	remoteMethods[4].types = "I";
	remoteMethods[5].key = 
	@selector(netIsExpired:date:);
	remoteMethods[5].types = "Ii";
	remoteMethods[6].key = 
	@selector(netByeBye:);
	remoteMethods[6].types = "c";
	remoteMethods[7].key = 
	@selector(netAddedHost:class:identity:);
	remoteMethods[7].types = "ccc";
	remoteMethods[8].key = 
	@selector(netChangedHost:class:identity:);
	remoteMethods[8].types = "ccc";
	remoteMethods[9].key = 
	@selector(netDeletedHost:class:identity:);
	remoteMethods[9].types = "ccc";
	remoteMethods[10].key = 
	@selector(netLockHost:class:identity:ok:);
	remoteMethods[10].types = "cccI";
	remoteMethods[11].key = 
	@selector(netUnlockHost:class:identity:);
	remoteMethods[11].types = "ccc";
	remoteMethods[12].key = 
	@selector(AreYouStillAlive);
	remoteMethods[12].types = "";
	remoteMethods[REMOTEMETHODS].key = NULL;
    }
}
-(int)netGetHostName : (char **) hname
	andId : (char **) hid
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netGetHostName:andId:)))
	return [_NXd netGetHostName : hname
		andId : hid];
    return -1;
}

-(int)netHereIam : (char *) me
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netHereIam:)))
	return [_NXd netHereIam : me];
    return -1;
}

-(int)netCheckinHost : (char *) host
	password : (char *) password
	ok : (int *) ok
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netCheckinHost:password:ok:)))
	return [_NXd netCheckinHost : host
		password : password
		ok : ok];
    return -1;
}

-(int)netCheckUserCount : (int *) ok
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netCheckUserCount:)))
	return [_NXd netCheckUserCount : ok];
    return -1;
}

-(int)netIsDemo : (int *) flag
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netIsDemo:)))
	return [_NXd netIsDemo : flag];
    return -1;
}

-(int)netIsExpired : (int *) flag
	date : (int) date
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netIsExpired:date:)))
	return [_NXd netIsExpired : flag
		date : date];
    return -1;
}

-(int)netByeBye : (char *) host
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netByeBye:)))
	return [_NXd netByeBye : host];
    return -1;
}

-(int)netAddedHost : (char *) host
	class : (char *) className
	identity : (char *) identity
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netAddedHost:class:identity:)))
	return [_NXd netAddedHost : host
		class : className
		identity : identity];
    return -1;
}

-(int)netChangedHost : (char *) host
	class : (char *) className
	identity : (char *) identity
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netChangedHost:class:identity:)))
	return [_NXd netChangedHost : host
		class : className
		identity : identity];
    return -1;
}

-(int)netDeletedHost : (char *) host
	class : (char *) className
	identity : (char *) identity
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netDeletedHost:class:identity:)))
	return [_NXd netDeletedHost : host
		class : className
		identity : identity];
    return -1;
}

-(int)netLockHost : (char *) host
	class : (char *) class
	identity : (char *) identity
	ok : (int *) ok
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netLockHost:class:identity:ok:)))
	return [_NXd netLockHost : host
		class : class
		identity : identity
		ok : ok];
    return -1;
}

-(int)netUnlockHost : (char *) host
	class : (char *) class
	identity : (char *) identity
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(netUnlockHost:class:identity:)))
	return [_NXd netUnlockHost : host
		class : class
		identity : identity];
    return -1;
}

-(int)AreYouStillAlive
/* */
{
    id _NXd;
    if (_NXd = NXResponsibleDelegate(self,
	@selector(AreYouStillAlive)))
	return [_NXd AreYouStillAlive];
    return -1;
}

- (int) performRemoteMethod : (NXRemoteMethod *) method
                  paramList : (NXParamValue *) paramList {
/* */
    switch (method - remoteMethods) {
    case 0:
	return [self netGetHostName : &paramList[0].bval.p
		andId : &paramList[1].bval.p];
    case 1:
	return [self netHereIam : paramList[0].bval.p];
    case 2:
	return [self netCheckinHost : paramList[0].bval.p
		password : paramList[1].bval.p
		ok : &paramList[2].ival];
    case 3:
	return [self netCheckUserCount : &paramList[0].ival];
    case 4:
	return [self netIsDemo : &paramList[0].ival];
    case 5:
	return [self netIsExpired : &paramList[0].ival
		date : paramList[1].ival];
    case 6:
	return [self netByeBye : paramList[0].bval.p];
    case 7:
	return [self netAddedHost : paramList[0].bval.p
		class : paramList[1].bval.p
		identity : paramList[2].bval.p];
    case 8:
	return [self netChangedHost : paramList[0].bval.p
		class : paramList[1].bval.p
		identity : paramList[2].bval.p];
    case 9:
	return [self netDeletedHost : paramList[0].bval.p
		class : paramList[1].bval.p
		identity : paramList[2].bval.p];
    case 10:
	return [self netLockHost : paramList[0].bval.p
		class : paramList[1].bval.p
		identity : paramList[2].bval.p
		ok : &paramList[3].ival];
    case 11:
	return [self netUnlockHost : paramList[0].bval.p
		class : paramList[1].bval.p
		identity : paramList[2].bval.p];
    case 12:
	return [self AreYouStillAlive];
    default:
	return [super performRemoteMethod : method paramList : paramList];
    }
}
- (NXRemoteMethod *) remoteMethodFor: (SEL) aSel {
/* */
    NXRemoteMethod *rm;
    if (rm = NXRemoteMethodFromSel(aSel,remoteMethods))
        return rm;
    return [super remoteMethodFor : aSel];
}
@end
