#import <appkit/Control.h>

@interface PaletteView:Control
{
	id	   	icon;
	id		myOwner;
	id		target;
	id		doubleTarget;
	id		content;
	id		supportFont;
	id		titleField;
	SEL		action;
	SEL		doubleAction;
	NXRect  hotRect;
	NXEvent	*anEvent;
	BOOL	dissolve;
	BOOL	selected;
	BOOL	isTitled;
	BOOL	editable;
}

- initFrame:(NXRect *)frameRect;
- setOwner:owner;
- owner;
- (BOOL)acceptsFirstMouse;
- setImageObject:anImageObject;
- imageObject;
- mouseDown:(NXEvent *)theEvent;
- drawSelf:(NXRect *)rects :(int)count		/*n*/;
- setEditable:(BOOL)flag;
- (BOOL)isEditable;
- setTitled:(BOOL)flag;
- (BOOL)isTitled;
- setGhost:(BOOL )flag;
- (BOOL)ghost;
- setSelected:(BOOL)flag;
- (BOOL) selected;
- setTarget:anObject;
- setAction:(SEL )aSelector;
- target;
- (SEL )action;
- (long )getMask;
- setContent:anObject;
- content;
- setDoubleTarget:anObject;
- setDoubleAction:(SEL )anAction;
- doubleTarget;
- (SEL)doubleAction;
- free;
- textDidEnd:textObject endChar:(unsigned short)whyEnd;

@end


@interface Object(PaletteViewOwner)
- titleChanged:sender to:(const char *)newTitle;
- copySpecial:sender;

@end


@interface Object(PaletteViewContent)
- imageObject;
- description;

@end


@interface Object(ImageMgr)
- iconFor:(const char *)iconName;

@end


@interface Object(TheApplication)
- imageMgr;

@end

