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
    NSOperationQueue *objQue;
}

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSOperationQueue *objQue;

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)LogicZoomInverterAppDelegate;
- (void) UpdateZoomInverterSettings:(int) zoomInverterIndex;
- (void) AppSettingsChanged:(NSNotification*)notification;

@end
