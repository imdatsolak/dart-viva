#import <stdio.h>

extern int debug;
extern int SetDebug(int newDebugLevel);

#define DEBUG12	if(debug>=12)printf
#define DEBUG11	if(debug>=11)printf
#define DEBUG10	if(debug>=10)printf
#define DEBUG9	if(debug>=9)printf
#define DEBUG8	if(debug>=8)printf
#define DEBUG7	if(debug>=7)printf
#define DEBUG6	if(debug>=6)printf
#define DEBUG5	if(debug>=5)printf
#define DEBUG4	if(debug>=4)printf
#define DEBUG3	if(debug>=3)printf
#define DEBUG2	if(debug>=2)printf
#define DEBUG1	if(debug)printf
#define DEBUG	if(debug)printf
#define IFDEBUG12	if(debug>=12)
#define IFDEBUG11	if(debug>=11)
#define IFDEBUG10	if(debug>=10)
#define IFDEBUG9	if(debug>=9)
#define IFDEBUG8	if(debug>=8)
#define IFDEBUG7	if(debug>=7)
#define IFDEBUG6	if(debug>=6)
#define IFDEBUG5	if(debug>=5)
#define IFDEBUG4	if(debug>=4)
#define IFDEBUG3	if(debug>=3)
#define IFDEBUG2	if(debug>=2)
#define IFDEBUG1	if(debug)
#define IFDEBUG		if(debug)
