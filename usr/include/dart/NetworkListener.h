#import <appkit/Listener.h>
@interface NetworkListener : Listener
{}
-(int)netHereIam : (char *) str;
-(int)netByeBye : (char *) str;
-(int)netNotify : (char *) str;
@end