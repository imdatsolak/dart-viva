 /*
  * Nib - The NeXT Interface Builder
  *
  *	InterfaceBuilder.h
  *	Written by Jean-Marie Hullot
  *	Copyright 1990 NeXT, Inc.
  *
  */

#import <objc/Object.h>

void NIBInit(char *appName);
void NIBLoadPalette(char *name, char *iconName, char *altIconName);
void NIBRun();

void NIBDidLoadClass(id class, struct mach_header *mh);
void NIBWillUnloadClass(id class);

@interface Inspector:Object {
    id		controller;
    id		object;
    id		editor;
    id		window;
    id		owner;
    id		okButton;
    id		revertButton;
}

- ok:sender;
- revert:sender;
- performClick:sender;

@end

