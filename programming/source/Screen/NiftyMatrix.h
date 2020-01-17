#import <appkit/Matrix.h>

@interface NiftyMatrix:Matrix
{
    id	matrixCache;
	id	cellCache;
	id	activeCell;
	id	delegate;
}

- free;
- mouseDown:(NXEvent *)theEvent;
- drawSelf:(NXRect *)rects :(int)count;
- setupCacheWindows;
- sizeCacheWindow:cacheWindow to:(NXSize *)windowSize;
- setDelegate:anObject;
- delegate;

@end

@interface Object(TheTarget)
- cellMovedFrom:(unsigned)from to:(unsigned)to;
@end
