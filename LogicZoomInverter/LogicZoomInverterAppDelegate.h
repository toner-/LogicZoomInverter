//
//  LogicZoomInverterAppDelegate.h
//  LogicZoomInverter
//
//  Created by Tony Freggiaro on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZoomInverter.h"

@interface LogicZoomInverterAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSOperationQueue *operationQueue;
    NSPopUpButton *deviceTypeSelectionBox;
    NSButton *invertHorizontalZoomCheckBox;
    NSButton *invertVerticalZoomCheckBox;
    NSButton *invertMultiZoomCheckBox;
    NSButton *invertHorizontalScrollCheckBox;
    NSTextField *horizontalZoomFactorInput;
    NSStepper *horizontalZoomFactorStepper;
    NSTextField *verticalZoomFactorInput;
    NSStepper *verticalZoomFactorStepper;
    NSTextField *multiZoomFactorInput;
    NSStepper *multiZoomFactorStepper;
    NSTextField *horizontalScrollFactorInput;
    NSStepper *horizontalScrollFactorStepper;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSOperationQueue *operationQueue;
@property (assign) IBOutlet NSPopUpButton *deviceTypeSelectionBox;
@property (assign) IBOutlet NSButton *invertHorizontalZoomCheckBox;
@property (assign) IBOutlet NSButton *invertVerticalZoomCheckBox;
@property (assign) IBOutlet NSButton *invertMultiZoomCheckBox;
@property (assign) IBOutlet NSButton *invertHorizontalScrollCheckBox;
@property (assign) IBOutlet NSTextField *horizontalZoomFactorInput;
@property (assign) IBOutlet NSStepper *horizontalZoomFactorStepper;
@property (assign) IBOutlet NSTextField *verticalZoomFactorInput;
@property (assign) IBOutlet NSStepper *verticalZoomFactorStepper;
@property (assign) IBOutlet NSTextField *multiZoomFactorInput;
@property (assign) IBOutlet NSStepper *multiZoomFactorStepper;
@property (assign) IBOutlet NSTextField *horizontalScrollFactorInput;
@property (assign) IBOutlet NSStepper *horizontalScrollFactorStepper;

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)LogicZoomInverterAppDelegate;
- (void) updateZoomInverterSettings;
- (void) appSettingsChanged:(NSNotification*)notification;
- (void) updateControlBindings;
- (IBAction)deviceTypeSelected:(id)sender;


@end
