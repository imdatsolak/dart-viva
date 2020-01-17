#import <appkit/Speaker.h>
@interface NetworkSpeaker : Speaker
{}
-(int)netHereIam : (char *) str;
-(int)netByeBye : (char *) str;
-(int)netNotify : (char *) str;
@end