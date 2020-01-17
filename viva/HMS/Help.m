/* 
 * Help.m, a help object to manage and display RTF help files.
 * The help object owns its own nib section "Help.nib" which has a
 * Help panel - with an NXBrowser to display the help topics, and
 * a scrolling text view to display the help files.  The help files are
 * all stored as RTF text files in a directory called Help within the
 * app wrapper.  At init time, the Help object loads the browser with 
 * names of all the files found in the Help directory.  When a name is
 * chosen from the browser, the help object opens a stream on that file
 * and read the rich text into the text object. The help object also
 * responds to request for context-sensitive help, by trying to find an
 * appropriate help file for the view that was moused down in.  See the
 * helpForObject: method for more detailed explanation of that.
 * This object is a useful addition to any program, because all users
 * appreciate help!
 *
 * Author: Julie Zelenski, NeXT Developer Support
 * You may freely copy, distribute and reuse the code in this example.  
 * NeXT disclaims any warranty of any kind, expressed or implied, as to 
 * its fitness for any particular use.
 */
 
#import <appkit/Button.h>
#import <appkit/Cell.h>
#import <appkit/Matrix.h>
#import <appkit/MenuCell.h>
#import <appkit/NXBrowser.h>
#import <appkit/NXBrowserCell.h>
#import <appkit/ScrollView.h>
#import <appkit/Text.h>
#import <dpsclient/wraps.h>
#import <sys/dir.h> //for getdirentries()
#import <libc.h>     

#import "Localizer.h"
#import "TheApp.h"
//#import "PictCell.h"

#import "Help.h"


@implementation Help:Object


- init 
{
    sprintf(helpDirectory,"%s/%s",[[NXApp localizer] makeFullPath:"Help"]);
    sprintf(noHelpFile,"%s/%s",helpDirectory,"No Help.rtf");
    helpPanel = [NXApp loadNibFile:"Help.nib" owner:self];
//	[Text registerDirective:"NeXTGraphic" forClass:[PictCell class]];
    return self;
}

- setHelpBrowser:anObject;
{
    helpBrowser = anObject;
    [helpBrowser setDelegate:self];
    [helpBrowser loadColumnZero];
    return self;
}

/* TARGET/ACTION METHODS */

- generalHelp:sender;
{
    [self showHelpFile:"Allgemeine Hinweise"];
    return self;
}

- browserHit:sender
{   
    [self showHelpFile:[[[sender matrixInColumn:0] selectedCell] stringValue]];
    return self;
}


- print:sender;
{
    [[helpScrollView docView] printPSCode:sender];
    return self;
}


/* HELP METHODS */

- helpForWindow:window;
{
    char filename[MAXPATHLEN];

    if (window == [NXApp mainMenu])
        sprintf(filename,"Hauptmenue");
    else {
		if (strstr([window title],"Ð")) {
			sprintf(filename,"%s",strstr([window title],"Ð")+2);
		} else {
	        sprintf(filename,"%s",[window title]);
		}
	}
    [self showHelpFile:filename];
    return self;
}

- helpForView:view atPoint:(NXPoint *)aPt;
{  
    int row,column;
    NXRect b;
    NXPoint p;
    id cell = nil;

    [view getBounds:&b];
    if ([view isKindOf:[Matrix class]]) {
        p = *aPt;
	[view convertPoint:&p fromView:nil];
	if (cell = [view getRow:&row andCol:&column forPoint:&p])
	    [view getCellFrame:&b at:row :column];
    }
    [view lockFocus];
    PSnewinstance();
    PSsetinstance(YES);
    PSsetgray(NX_DKGRAY);
    NXFrameRectWithWidth(&b,1.0);
    [[view window] flushWindow];
    PSsetinstance(NO);
    if (cell) 
    	[self helpForObject:cell];
    else if ([[view window] contentView] == view) 
    	[self helpForWindow:[view window]];
    else
    	[self helpForObject:view];
    PSnewinstance();
    [view unlockFocus];
    return self;
}


- helpForObject:object;
{
    char filename[MAXPATHLEN];
    char *suffix;
    int len;

    sprintf(filename,"%s",[object name]);
    if ([object isKindOf:[Button class]] || [object isKindOf:[Cell class]]) {
	 if ([object icon]) 
	     sprintf(filename,"%s %s",[object icon],[object name]);
	 if ([object isKindOf:[Cell class]]) {
	     len = strlen(filename);
	     suffix = filename + (len-4)*sizeof(char);
	     if (strcmp("Cell",suffix)==0) {
		 filename[len-4] = '\0';
	    }
	}
    }
    if ([object isKindOf:[MenuCell class]]) {
        if ([object icon] && (strcmp([object icon],"menuArrow")==0))
	    sprintf(filename,"%s %s",[object title],"Menu");
	else {
	    return [self helpForWindow:[[object controlView] window]];
	}
    }
    [self showHelpFile:filename];
    return self;
}

- showHelpFile:(const char*)filename;
{
   NXStream *stream;
   char helpFile[MAXPATHLEN];
   static NXPoint origin = {0.0,0.0};

    if (![self browser:helpBrowser selectCell:filename inColumn:0])
        [self browser:helpBrowser selectCell:"No Help" inColumn:0];
    sprintf(helpFile,"%s/%s.rtf",helpDirectory,filename);
    if ((stream = NXMapFile(helpFile,NX_READONLY)) == NULL)
        stream = NXMapFile(noHelpFile,NX_READONLY);
    if (stream != NULL) {
    	[helpPanel disableFlushWindow];
        [[helpScrollView docView] readRichText:stream]; 
	[[helpScrollView docView] scrollPoint:&origin];
	[[helpPanel reenableFlushWindow] flushWindow];
    	NXCloseMemory(stream,NX_FREEBUFFER);
    }
    [helpPanel orderFront:self];
    return self;
}


/* BROWSER DELEGATE METHODS */


#define CHUNK 127
static char **addFile(const char *file, int length, char **list, int count)
{
    char *suffix;
    
    if (!list) list = (char **)malloc(CHUNK*sizeof(char *));
	if (suffix = rindex(file,'.')) 
   	  *suffix  = '\0'; 	/* strip rtf suffix */


    list[count] = (char *)malloc((length+1)*sizeof(char));
    strcpy(list[count], file);
	
    count++;
    if (!(count% CHUNK)) {
	list = (char **)realloc(list,(((count/CHUNK)+1)*CHUNK)*sizeof(char *));
    }
    list[count] = NULL;
    return list;
}

static void freeList(char **list)
 {
    char **strings;

    if (list) {
	strings = list;
	while (*strings) free(*strings++);
	free(list);
    }
}

static BOOL isOk(const char *s)
{
    return (!s[0] || s[0] == '.') ? NO : YES;
}

static int caseInsensitiveCompare(void *arg1, void *arg2)
{
    char *string1, *string2;

    string1 = *((char **)arg1);
    string2 = *((char **)arg2);
    return strcasecmp(string1,string2);
}

static char **fileList;

- (int)browser:sender fillMatrix:matrix inColumn:(int)column
{
    long basep;
    char *buf;
    struct direct *dp;
    char **list = NULL;
    int cc, fd, fileCount = 0;
    char dirbuf[8192];

    if ((fd = open(helpDirectory, O_RDONLY, 0644)) > 0) {
	cc = getdirentries(fd, (buf = dirbuf), 8192, &basep);
	while (cc) {
	    dp = (struct direct *)buf;
	    if (isOk(dp->d_name)) {
		list = addFile(dp->d_name, dp->d_namlen, list, fileCount++);
	    }
	    buf += dp->d_reclen;
	    if (buf >= dirbuf + cc) {
		cc = getdirentries(fd, (buf = dirbuf), 8192, &basep);
	    }
	}
	close(fd);
	if (list) qsort(list,fileCount,sizeof(char *),caseInsensitiveCompare);
    }
    freeList(fileList);
    fileList = list;
    return fileCount;
}

- browser:sender loadCell:cell atRow:(int)row inColumn:(int)column
{
    if (fileList) {
		[cell setStringValueNoCopy:fileList[row]];
		[cell setLeaf:YES];
    }
    return self;
}


- (BOOL)browser:sender selectCell:(const char *)title inColumn:(int)column
{
    int row;
    id matrix;

    if (title) {
	matrix = [sender matrixInColumn:column];
	if (!fileList) return NO;
	for (row = [matrix cellCount]-1; row >= 0; row--) {
	    if (fileList[row] && !strcmp(title, fileList[row])) {
		[sender getLoadedCellAtRow:row inColumn:column];
		[matrix selectCellAt:row :0];
		[matrix scrollCellToVisible:row :0];
		return YES;
	    }
	}
    }
    return NO;
}


/* WINDOW DELEGATE METHODS */

- windowWillResize:sender toSize:(NXSize *)frameSize;
{
    frameSize->width = MAX(frameSize->width,400.0);
    frameSize->height = MAX(frameSize->height,350.0);
    return self;
}
@end