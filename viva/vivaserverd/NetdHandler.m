#import <libc.h>
#import <stdio.h>
#import <string.h>
#import <mach_interface.h>
#import <mach_init.h>
#import <objc/Storage.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/NetworkSpeaker.h"
#import "dart/NetworkListener.h"

#import "OpensList.h"
#import "NetdHandler.h"

typedef struct speakerstruct {
	port_t		thePort;
	id			theSpeaker;
	char		theRemoteHostName[MAXHOSTNAMELEN+1];
} SPEAKERSTRUCT;


char *mkpw (char *hostid) 
{
	char 			a[32],b[32];
	static 	char	c[32];
	int				x;
	
	strcpy(b,"initNewPasteBoardItem");
	strcpy(a, hostid);
	for (x=0;x<8;x++) {
		a[x] ^= b[x];
	}
	strcpy(c,crypt(a,"qS"));
	for (x=0;x<strlen(c);x++) {
		c[x] ^= b[x];
	}
	return c;
}

BOOL checkpw(const char *pw)
{
	char	actualpw[64];
	char	theHost[32];
	char	hex[3];
	char	*aPw;
	int		i;
	
	actualpw[0]=0;
	sprintf(theHost,"0x%x",gethostid());
	aPw = mkpw(theHost);
	for (i=0;i<strlen(aPw);i++) {
		sprintf(hex,"%02X", aPw[i]);
		strcat(actualpw,hex);
	}
	return (strcmp(pw,actualpw)==0);	
}

BOOL expired(int date)
{
	id	today = [Date today];
	if([today long]!=date) {
		return YES;
	}
	if(VALID_UNTIL<date) {
		return YES;
	}
	return NO;
}

#pragma .h #import <objc/Object.h>
#pragma .h #import <sys/param.h>

@implementation NetdHandler:Object
{
    id		myListener;
	id		opens;
	id		allSpeakers;
	
	char	me[MAXHOSTNAMELEN+1];
	long	myId;
	char	thePortName[MAXPATHLEN+1];
	char	theRemotePortName[MAXPATHLEN+1];
}

- initPortname:(const char *)portname remotePortname:(const char *)remotePortname
{
	[super init];
	
	strncpy(thePortName,portname,sizeof(thePortName));
	strncpy(theRemotePortName,remotePortname,sizeof(theRemotePortName));
	if(gethostname(me,sizeof(me))) {
		[self error:"cannot detect hostname"];
	}

	if((myId = gethostid()) == 0) {
		[self error:"cannot detect hostname"];
	}
	
	allSpeakers = [[Storage new] initCount:0 elementSize:sizeof(SPEAKERSTRUCT) description:NULL];
	opens = [[OpensList alloc] initCount:0];
	
	myListener = [NetworkListener new];
	[myListener setDelegate:self];
	[myListener checkInAs:thePortName];
	[myListener addPort];
	
	DEBUG("viva2serverd: my hostname is \"%s\"\n",me);
	DEBUG("viva2serverd: localport is \"%s\"\n",portname);
	DEBUG("viva2serverd: remoteport is \"%s\"\n",remotePortname);
	
	return self;
}


- free
{
	[myListener free];
	[self removeAllSpeakers];
	[allSpeakers free];
	[opens free];
	return [super free];
}


- addSpeakerFor:(const char *)remoteHostName
{
	SPEAKERSTRUCT	sp;
	if(PORT_NULL != (sp.thePort = NXPortNameLookup(theRemotePortName,remoteHostName))) {
		sp.theSpeaker = [NetworkSpeaker new];
		[sp.theSpeaker setSendPort:sp.thePort];
		strcpy(sp.theRemoteHostName,remoteHostName);
		[allSpeakers addElement:&sp];
	}
	return self;
}


- removeSpeakerFor:(const char *)remoteHostName
{
	int	i = 0;
	
	while( i<[allSpeakers count] ) {
		SPEAKERSTRUCT	*sp = (SPEAKERSTRUCT *)[allSpeakers elementAt:i];
		if( 0 == strcmp(remoteHostName,sp->theRemoteHostName) ) {
			[sp->theSpeaker free];
			port_deallocate(task_self(),sp->thePort);
			[allSpeakers removeAt:i];
		} else {
			i++;
		}
	}
	return self;
}


- removeAllSpeakers
{
	while( [allSpeakers count] ) {
		SPEAKERSTRUCT	*sp = (SPEAKERSTRUCT *)[allSpeakers elementAt:0];
		[sp->theSpeaker free];
		port_deallocate(task_self(),sp->thePort);
		[allSpeakers removeAt:0];
	}
	return self;
}


- checkSpeakers
{
	int	i;
	for(i=[allSpeakers count]-1; i>=0; i--) {
		SPEAKERSTRUCT	*sp = (SPEAKERSTRUCT *)[allSpeakers elementAt:i];
		int				result;

		result = [sp->theSpeaker AreYouStillAlive];
		DEBUG("viva2serverd: checkSpeakers\n");
		if(result==SEND_INVALID_PORT) {
			DEBUG("\t removing speaker because of dead\n");
			[sp->theSpeaker free];
			port_deallocate(task_self(),sp->thePort);
			[opens removeOpensFor:sp->theRemoteHostName];
			[allSpeakers removeAt:i];
		}
	}
	return self;
}


- netHereIam:(const char *)host
{
	DEBUG("viva2serverd: netHereIam:\"%s\"\n",host);
	[self checkSpeakers];
	[self addSpeakerFor:host];
	return 0;
}


- netByeBye:(const char *)host
{
	DEBUG("viva2serverd: netByeBye:\"%s\"\n", host);
	[self removeSpeakerFor:host];
	[opens removeOpensFor:host];
	return 0;
}


- netCheckinHost:(const char *)host password:(const char *)password ok:(int *)ok
{
	DEBUG("viva2serverd: netCheckinHost:\"%s\" password:\"%s\" ",host,password);
	*ok = checkpw(password) || DEMO_RELEASE;
	DEBUG("ok:%d\n",*ok);
	return 0;
}

- netCheckUserCount:(int *)ok
{
	DEBUG("viva2serverd: netCheckUserCount:");
	*ok = ([allSpeakers count] <= NUMBER_OF_LICENCES) ;
	DEBUG("ok:%d\n",*ok);
	return 0;	
}

- netIsDemo:(int *)flag
{
	DEBUG("viva2serverd: netIsDemo:");
	*flag = DEMO_RELEASE;
	DEBUG("%d\n",*flag);
	return 0;	
}

- netIsExpired:(int *)flag date:(int)date
{
	DEBUG("viva2serverd: netIsExpired:");
	*flag = DEMO_RELEASE && expired(date);
	DEBUG("%d\n",*flag);
	return 0;	
}

- netGetHostName:(char **)hostname andId:(char **)hostid
{
	static char h_name[MAXHOSTNAMELEN];
	static char h_id[MAXHOSTNAMELEN];
	strcpy(h_name, me);
	sprintf(h_id,"0x%x",myId);
	*hostname = h_name;
	*hostid = h_id;
	return 0;
}

- netAddedHost:(const char *)host class:(const char *)className identity:(const char *)identity
{
	[self netPerformSel:"netAddedHost:class:identity:" host:host class:className identity:identity];
	return 0;
}

- netChangedHost:(const char *)host class:(const char *)className identity:(const char *)identity
{
	[self netPerformSel:"netChangedHost:class:identity:" host:host class:className identity:identity];
	return 0;
}

- netDeletedHost:(const char *)host class:(const char *)className identity:(const char *)identity
{
	[self netPerformSel:"netDeletedHost:class:identity:" host:host class:className identity:identity];
	return 0;
}

- netPerformSel:(const char *)sel host:(const char *)host class:(const char *)className identity:(const char *)identity
{
	int	i;
	
	for(i=[allSpeakers count]-1; i>=0; i--) {
		SPEAKERSTRUCT	*sp = (SPEAKERSTRUCT *)[allSpeakers elementAt:i];
		int				result;

		result = [sp->theSpeaker selectorRPC:sel paramTypes:"ccc",host,className,identity];
		DEBUG("viva2serverd: send %s to %s with:\"%s\":\"%s\" --> %d\n",
			  sel,host,className,identity,result);
		if(result==SEND_INVALID_PORT) {
			DEBUG("\t removing speaker because of SEND_INVALID_PORT\n");
			[sp->theSpeaker free];
			port_deallocate(task_self(),sp->thePort);
			[opens removeOpensFor:sp->theRemoteHostName];
			[allSpeakers removeAt:i];
		}
	}
	return 0;
}


- netLockHost:(const char *)host class:(const char *)className identity:(const char *)identity ok:(int *)ok
{
	if([opens isLockedClass:className identity:identity]) {
		*ok = NO;
	} else {
		[opens lockHost:host class:className identity:identity];
		*ok = YES;
	}
	DEBUG("netLockHost:\"%s\" class:\"%s\" identity:\"%s\" ok:%d\n",
			host, className, identity, *ok);
	return 0;
}


- netUnlockHost:(const char *)host class:(const char *)className identity:(const char *)identity
{
	[opens unlockHost:host class:className identity:identity];
	return 0;
}


@end

