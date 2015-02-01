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
	NSButton *chkInvertHorizontalZoom;
	NSButton *chkInvertVerticalZoom;
	NSButton *chkInvertMultiZoom;
	NSButton *chkInvertHorizontalScroll;
    NSSlider *sldFactorHorizontalZoom;
    NSSlider *sldFactorVerticalZoom;
    NSSlider *sldFactorMultiZoom;
    NSSlider *sldFactorHorizontalScroll;
}

@property (assign) IBOutlet NSButton *chkInvertHorizontalZoom;
@property (assign) IBOutlet NSButton *chkInvertVerticalZoom;
@property (assign) IBOutlet NSButton *chkInvertMultiZoom;
@property (assign) IBOutlet NSButton *chkInvertHorizontalScroll;
@property (assign) IBOutlet NSSlider *sldFactorHorizontalZoom;
@property (assign) IBOutlet NSSlider *sldFactorVerticalZoom;
@property (assign) IBOutlet NSSlider *sldFactorMultiZoom;
@property (assign) IBOutlet NSSlider *sldFactorHorizontalScroll;
@property (assign) IBOutlet NSWindow *window;
@property (retain) NSOperationQueue *objQue;

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)LogicZoomInverterAppDelegate;
- (void) UpdateZoomInverterSettings;
- (void) AppSettingsChanged:(NSNotification*)notification;

@end
