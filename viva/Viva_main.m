#import "dart/Localizer.h"
#import "TheApp.h"

int main(int argc, char *argv[]) {
	id	localizer;
    NXApp = [TheApp new];
	[NXApp setDelegate:NXApp];
	localizer = [[Localizer alloc] init];
    [localizer loadLocalNib:"viva" owner:NXApp];
	[localizer free];
    [NXApp run];
    [NXApp free];
    return 0;
}
