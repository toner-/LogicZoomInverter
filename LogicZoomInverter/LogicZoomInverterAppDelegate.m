//
//  LogicZoomInverterAppDelegate.m
//  LogicZoomInverter
//
//  Created by Tony Freggiaro on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LogicZoomInverterAppDelegate.h"
#include <ApplicationServices/ApplicationServices.h>
#include <unistd.h>

@implementation LogicZoomInverterAppDelegate

@synthesize window, objQue, chkInvertHorizontalZoom, chkInvertVerticalZoom, chkInvertMultiZoom, chkInvertHorizontalScroll, sldFactorHorizontalZoom, sldFactorVerticalZoom, sldFactorMultiZoom, sldFactorHorizontalScroll;

- (id)init
{
	/*Create the operation que*/
    NSOperationQueue *objQueue = [[NSOperationQueue alloc] init];
    self.objQue = objQueue;
    [objQueue release];
	
    [super init];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], @"HorizontalZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"MultiZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"VerticalZoomEnabled",
                                 [NSNumber numberWithBool:NO], @"HorizontalScrollEnabled",
                                 [NSNumber numberWithDouble:1.0], @"HorizontalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"VerticalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"HorizontalScrollFactor",
                                 [NSNumber numberWithDouble:1.0], @"MultiZoomFactor",
                                 nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppSettingsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
	ZoomInverter *objZoomInv;
	objZoomInv = [[ZoomInverter alloc] init];
	if(!objZoomInv)
		return;
    
	[self.objQue addOperation:objZoomInv];
    
	[objZoomInv release];
    
    [self UpdateZoomInverterSettings];
    
//    /*Open Logic Pro*/
//	NSWorkspace *obj;
//	obj = [[NSWorkspace alloc] init];
//	[obj launchApplication:@"Logic Pro.app"];
//	[obj release];

}

- (void) AppSettingsChanged:(NSNotification*)notification
{
    [self UpdateZoomInverterSettings];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)LogicZoomInverterAppDelegate
{
	return true;
}

- (void)dealloc 
{
    [self.objQue release];
    [super dealloc];
}

- (void) UpdateZoomInverterSettings
{
    ZoomInverter *objZoomInv = [self.objQue.operations objectAtIndex:0];
    
    if(!objZoomInv)
        return;
    
    objZoomInv.InvertHorizontalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"HorizontalZoomEnabled"];
    objZoomInv.InvertVerticalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"VerticalZoomEnabled"];
    objZoomInv.InvertMultiZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"MultiZoomEnabled"];
    objZoomInv.InvertHorizontalScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"HorizontalScrollEnabled"];
    objZoomInv.FactorHorizontalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"HorizontalZoomFactor"];
    objZoomInv.FactorVerticalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"VerticalZoomFactor"];
    objZoomInv.FactorHorizontalScroll = [[NSUserDefaults standardUserDefaults] doubleForKey:@"HorizontalScrollFactor"];
    objZoomInv.FactorMultiZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"MultiZoomFactor"];
}

@end
