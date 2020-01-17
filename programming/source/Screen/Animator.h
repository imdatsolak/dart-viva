// Animator.h
// By R. E. Crandall
// You may freely copy, distribute and reuse the code in this example.
// NeXT disclaims any warranty of any kind, expressed or implied, as to its
// fitness for any particular use.

#import <objc/Object.h>
#import <sys/time.h>
#import <dpsclient/dpsclient.h>

@interface Animator:Object
{
    int			mask, ticking, passcounter;
    DPSTimedEntry	teNum;
    double		interval, synctime, adapteddt, desireddt, t0, howOften;
    struct timeval	entrytime;
    id			target;
    SEL			action;
}

- initChronon:(double)dt adaptation:(double)howoft target:(id)targ
  action:(SEL)act autoStart:(int)start eventMask:(int)eMask; 
- resetRealTime; 
- (double)getSyncTime; 
- (double)getDoubleEntryTime; 
- (double)getDoubleRealTime; 
- (double)getDouble; 
- adapt; 
- setBreakMask:(int)eventMask; 
- (int)getBreakMask; 
- (int)isTicking; 
- (int)shouldBreak; 
- setIncrement:(double)dt; 
- (double)getIncrement; 
- setAdaptation:(double)oft; 
- setTarget:(id)targ; 
- setAction:(SEL)aSelector; 
- startEntry; 
- stopEntry; 
- free; 

@end
