/*
  File: OTSmartField.h
  Authors: Alex B. Cone
  Modification History:
  
  Created ?? 2.0 version: 12/19/90
  
  Copyright (c) 1990 Objective Technologies, Inc.
  All Rights Reserved.
*/

#import <appkit/TextField.h>
#import "OTSmartCell.h"

#define OTSMARTFIELD_CURRENT_VERSION 10


@interface OTSmartField:TextField
{
	id	errorDelegate; // could we just use the cell to keep this info?
}
/* factory method */
+ initialize;

- initFrame:(const NXRect *) frameRect;

/* the Error Delegate */
- setErrorDelegate:aDelegate;
- errorDelegate;

/* bad entry handling */
- (BOOL) errorDidOccur:(int)errorNum from:anObject;
- showError:(const char *)errorMessage;

/* entry processing */
- text:textObject isEmpty:(BOOL)flag;
- (BOOL)textWillEnd:textObject;
- (BOOL)isValid;

/* the Inspector General */
- (const char*)inspectorName;

@end
