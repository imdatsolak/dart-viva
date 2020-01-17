#import <libc.h>
#import <mach_interface.h>
#import <mach_init.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/NetworkListener.h"
#import "dart/NetworkSpeaker.h"

#import "StringManager.h"
#import "ErrorManager.h"
#import "TheApp.h"

#import "NetworkManager.h"

#pragma .h #import <objc/Object.h>
#pragma .h #import <sys/param.h>

@implementation NetworkManager:Object
{
    id		myListener;
	id		mySpeaker;
	
	id		daemonHostname;
	id		daemonHostID;
	char	me[MAXHOSTNAMELEN+1];
}

- init
{
	char *hname, *hid;
	
	[super init];
	
	if(gethostname(me,sizeof(me))) {
		[[NXApp errorMgr] showDialog:"Can not detect hostname"];
		[self error:"Can not detect hostname"];
	}
	
	DEBUG("NetworkManager: my hostname is \"%s\"\n",me);
	
	if(PORT_NULL != NXPortNameLookup([[NXApp stringMgr] stringForNetworkKey:"LISTENERNAME"],NULL)) {
		[[NXApp errorMgr] showDialog:"Cannot run twice"];
		[self error:"Cannot run twice"];
	}
	
	myListener = [NetworkListener new];
	[myListener setDelegate:self];
	[myListener checkInAs:[[NXApp stringMgr] stringForNetworkKey:"LISTENERNAME"]];
	[myListener addPort];
	
	[self addSpeakerForServer:[[NXApp stringMgr] stringForNetworkKey:"SERVERNAME"]
	      portName:[[NXApp stringMgr] stringForNetworkKey:"SENDNAME"]];
	[self netSendHereIam];

	[mySpeaker netGetHostName:&hname andId:&hid];
	daemonHostname = [String str:hname];
	daemonHostID = [String str:hid];

	DEBUG("NetworkManager: daemonHostname is \"%s\"\n", hname);
	DEBUG("NetworkManager: daemonHostID is \"%s\"\n", hid);
	
	return self;
}

- free
{
	[self netSendByeBye];
	port_deallocate(task_self(),[mySpeaker sendPort]);
	[mySpeaker free];
	[myListener free];
	[daemonHostname free];
	[daemonHostID free];
	return [super free];
}


- addSpeakerForServer:(const char *)serverName portName:(const char *)sendName
{
	port_t	sendport = NXPortNameLookup(sendName,serverName);
	
	if(PORT_NULL != sendport) {
		mySpeaker = [NetworkSpeaker new];
		if(mySpeaker) {
			[mySpeaker setSendPort:sendport];
		} else {
			[[NXApp errorMgr] showDialog:"Can not create speaker"];
			[self error:"Can not create speaker"];
		}
	} else {
		[[NXApp errorMgr] showDialog:"Can not open sendport"];
		[self error:"Can not open sendport \"%s\" at server \"%s\"",sendName,serverName];
	}
	return self;
}

- checkResult:(int)result
{
	if(result==SEND_INVALID_PORT) {
		[[NXApp errorMgr] fatalError:"SEND_INVALID_PORT"];
	}
	return self;
}

- netSendHereIam
{
	return [self checkResult:[mySpeaker netHereIam:me]];
}

- netSendByeBye
{
	return [self checkResult:[mySpeaker netByeBye:me]];
}


- (BOOL )netCheckin:(const char *)password
{
	int		result;
	[self checkResult:[mySpeaker netCheckinHost:me password:(char *)password ok:&result]];
	return result;
}

- daemonHostname
{
	return daemonHostname;
}

- daemonHostID
{
	return daemonHostID;
}

- (BOOL)netCheckUserCount
{
	int result;
	
	[self checkResult:[mySpeaker netCheckUserCount:&result]];
	DEBUG("netCheckUserCount:%d\n",result);
	return result;	
}

- (BOOL)netCheckExpiration
{
	int result;
	id	aDate = [Date today];
	int	aLong = [aDate long];
	[aDate free];
	[self checkResult:[mySpeaker netIsExpired:&result date:aLong]];
	DEBUG("netCheckUserCount:%d\n",result);
	return !result;	
}



- netSendAddedClass:(const char *)className identity:(const char *)identity
{
	DEBUG("netSendAddedClass:\"%s\" identity:\"%s\"\n",className,identity);
	return [self checkResult:[mySpeaker netAddedHost:me
										class:(char *)className
										identity:(char *)identity]];
}

- netSendChangedClass:(const char *)className identity:(const char *)identity
{
	DEBUG("netSendChangedClass:\"%s\" identity:\"%s\"\n",className,identity);
	return [self checkResult:[mySpeaker netChangedHost:me
	                                    class:(char *)className
										identity:(char *)identity]];
}

- netSendDeletedClass:(const char *)className identity:(const char *)identity
{
	DEBUG("netSendDeletedClass:\"%s\" identity:\"%s\"\n",className,identity);
	return [self checkResult:[mySpeaker netDeletedHost:me
										class:(char *)className
										identity:(char *)identity]];
}

- (int)netAddedHost:(char *)host class:(char *)className identity:(char *)identity
{
	DEBUG("netAddedHost:\"%s\" class:\"%s\" identity:\"%s\"\n",host,className,identity);
	if(strcmp(host,me)) {
		[NXApp netAddedClass:className identity:identity];
	}
	return 0;
}

- (int)netChangedHost:(char *)host class:(char *)className identity:(char *)identity
{
	DEBUG("netChangedHost:\"%s\" class:\"%s\" identity:\"%s\"\n",host,className,identity);
	if(strcmp(host,me)) {
		[NXApp netChangedClass:className identity:identity];
	}
	return 0;
}

- (int)netDeletedHost:(char *)host class:(char *)className identity:(char *)identity
{
	DEBUG("netDeletedHost:\"%s\" class:\"%s\" identity:\"%s\"\n",host,className,identity);
	if(strcmp(host,me)) {
		[NXApp netDeletedClass:className identity:identity];
	}
	return 0;
}


- (BOOL)lockClassName:(const char *)classname identity:(const char *)identitySTR 
{
	int result;
	[self checkResult:[mySpeaker netLockHost:me
								 class:(char *)classname
								 identity:(char *)identitySTR
								 ok:&result]];
	DEBUG("lockClassName:\"%s\" identity:\"%s\" --> %d\n",classname,identitySTR,result);
	return result;
}

- (BOOL)unlockClassName:(const char *)classname identity:(const char *)identitySTR
{
	[self checkResult:[mySpeaker netUnlockHost:me
	                             class:(char *)classname
								 identity:(char *)identitySTR]];
	DEBUG("unlockClassName:\"%s\" identity:\"%s\"\n", classname,identitySTR);
	return YES;
}

@end
