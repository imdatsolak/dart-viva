#import <appkit/Speaker.h>
@interface NetworkSpeaker : Speaker
{}
-(int)netGetHostName : (char **) hname
	andId : (char **) hid;
-(int)netHereIam : (char *) me;
-(int)netCheckinHost : (char *) host
	password : (char *) password
	ok : (int *) ok;
-(int)netCheckUserCount : (int *) ok;
-(int)netIsDemo : (int *) flag;
-(int)netIsExpired : (int *) flag
	date : (int) date;
-(int)netByeBye : (char *) host;
-(int)netAddedHost : (char *) host
	class : (char *) className
	identity : (char *) identity;
-(int)netChangedHost : (char *) host
	class : (char *) className
	identity : (char *) identity;
-(int)netDeletedHost : (char *) host
	class : (char *) className
	identity : (char *) identity;
-(int)netLockHost : (char *) host
	class : (char *) class
	identity : (char *) identity
	ok : (int *) ok;
-(int)netUnlockHost : (char *) host
	class : (char *) class
	identity : (char *) identity;
-(int)AreYouStillAlive;
@end