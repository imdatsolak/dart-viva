#import <appkit/Application.h>
#import <sys/time.h>
#import <objc/vectors.h>

#import "Animator.h"

@implementation Animator

void timerFunction(teNum, now, self)
DPSTimedEntry teNum;
double now;
Animator *self;
{
    gettimeofday(&self->entrytime, NULL);
    if (self->howOften > 0.0) {
	[self adapt];
    }
    
    [self->target perform:self->action with:self];
}

- initChronon:(double)dt	/* The time increment desired. */
  adaptation:(double)howoft	/* Adaptive time constant (0.deactivates).*/
  target:(id)targ		/* Target to whom proc belongs. */
  action:(SEL)act		/* The action. */
  autoStart:(int)start		/* Automatic start of timed entry? */
  eventMask:(int)eMask		/* Mask for optional check in "shouldBreak". */
{
    [super init];
    ticking = NO;
    desireddt = dt;
    [self setIncrement:dt];
    [self setAdaptation:howoft];
    [self setTarget:targ];
    [self setAction:act];
    
    if (start) {
	[self startEntry];
    }
    
    mask = eMask;
    [self resetRealTime];
    
    return self;
}

- resetRealTime
/* After this call, getDoubleRealTime is the real time that ensues. */
{ 
    struct timeval	realtime;
    
    gettimeofday(&realtime, NULL);
    synctime = realtime.tv_sec + realtime.tv_usec / 1000000.0;
    passcounter = 0;
    t0 = 0.0;
    
    return self;
}

- (double)getSyncTime
{
    return synctime;
}

- (double)getDoubleEntryTime
/* Returns real time since "resetrealTime". */
{
    return (- synctime + entrytime.tv_sec + entrytime.tv_usec / 1000000.0);
}

- (double)getDoubleRealTime
/* Returns real time since "resetrealTime". */
{
    struct timeval	realtime;
    struct timezone	tzone;
    
    gettimeofday(&realtime, &tzone);
    return (- synctime + realtime.tv_sec + realtime.tv_usec / 1000000.0);
}

- (double)getDouble
{
    return [self getDoubleRealTime];
}

- adapt
/* Adaptive time-step algorithm. */
{
    double t;
    
    if (!ticking) {
	return self;
    }
    
    ++passcounter;
    t = [self getDoubleEntryTime];
    
    if (t - t0 >= howOften) {  	
	adapteddt *= desireddt * passcounter / (t - t0);
	[self setIncrement:adapteddt];
	[self startEntry];
	passcounter = 0;
	t0 = t;
    }
    return self;
}
  
- setBreakMask:(int)eventMask
{
    mask = eventMask;
    return self;
}

- (int)getBreakMask
{
    return mask;
}

- (int)isTicking
{
    return ticking;
}
   
- (int)shouldBreak
/* Call this to see if you want to exit a loop in your action method. */
{
    NXEvent	*e, event;
    
    e = [NXApp peekNextEvent:mask
    	       into:&event
	       waitFor:0.0
	       threshold:NX_MODALRESPTHRESHOLD + 1];
	       
    return (e ? 1: 0);
}

- setIncrement:(double)dt
{
    adapteddt = dt;
    interval = dt;
  
    return self;
}

- (double)getIncrement
{
    return adapteddt;
}

- setAdaptation:(double)oft
{
    howOften = oft;
    return self;
}

- setTarget:(id)targ
{
    target = targ;
    return self;
}

- setAction:(SEL)aSelector
{
    action = aSelector;
    return self;
}

- startEntry
{ 
    [self stopEntry];
    teNum = DPSAddTimedEntry(interval, &timerFunction, self,
    			     NX_MODALRESPTHRESHOLD+1);
    ticking = YES;
    
    return self;
}

- stopEntry
{
    if (ticking) {
	DPSRemoveTimedEntry(teNum);
    }
    ticking = NO;
    
    return self;
}

- free
{
    if (ticking) {
	DPSRemoveTimedEntry(teNum);
    }
    
    return [super free];
}

@end	
