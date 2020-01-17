#import <stdlib.h>
#import <stdio.h>
#import <libc.h>

#import "dart/debug.h"
#import "dart/fieldvaluekit.h"
#import "dart/NetworkListener.h"

#import "NetdHandler.h"

int DoDaemon(const char *local,const char *remote)
{
	DEBUG("DebugLevel: %d\n",debug);
	[NetworkListener initialize];
	[[NetdHandler alloc] initPortname:local remotePortname:remote];
	return (int)[NetworkListener run];
}


void PrintReport(void)
{
	printf("\nviva2serverd\n");
	printf("\tDEMO_RELEASE:       %s\n", DEMO_RELEASE? "YES":"NO");
	printf("\tVALID_UNTIL:        %d\n", VALID_UNTIL * 786);
	printf("\tNUMBER_OF_LICENCES  %d\n", NUMBER_OF_LICENCES);
	printf("\n");
}


void PrintUsage(const char *progname)
{
	fprintf(stderr,"usage: %s [-v] -l local_portname -r remote_portname\n",progname);
}


int main(int argc, char *argv[]) {
	BOOL	report = NO;
	id		localPortName = nil;
	id		remotePortName = nil;
	char	c;
	int		result = 0;
	
	while((c = getopt(argc, argv, "vd:l:r:")) != EOF) {
		switch(c) {
			case 'v':
				report = YES;
				break;
			case 'd':
				SetDebug(atoi(optarg));
				break;
			case 'l':
				localPortName = [String str:optarg];
				break;
			case 'r':
				remotePortName = [String str:optarg];
				break;
			default:
				if (!result) {
					PrintUsage(argv[0]);
					result = 1;
				}
				break;
		}
	}
	
	if((optind<argc) && !result) {
		PrintUsage(argv[0]);
		result = 1;
	}
	
	if(!result) {
		if(report) PrintReport();
		if((localPortName == nil) || (remotePortName == nil)) {
			PrintUsage(argv[0]);
			result = 1;
		}
		
		if(!result) {
			result = DoDaemon([localPortName str],[remotePortName str]);
			[localPortName free];
			[remotePortName free];
		}
	}
	
	return result;
}
