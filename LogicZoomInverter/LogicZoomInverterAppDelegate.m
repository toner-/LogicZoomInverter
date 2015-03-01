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

@synthesize window, objQue;

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
                                 [NSNumber numberWithBool:YES], @"Device1HorizontalZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"Device1MultiZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"Device1VerticalZoomEnabled",
                                 [NSNumber numberWithBool:NO], @"Device1HorizontalScrollEnabled",
                                 [NSNumber numberWithDouble:1.0], @"Device1HorizontalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"Device1VerticalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"Device1HorizontalScrollFactor",
                                 [NSNumber numberWithDouble:1.0], @"Device1MultiZoomFactor",
                                 [NSNumber numberWithBool:YES], @"Device2HorizontalZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"Device2MultiZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"Device2VerticalZoomEnabled",
                                 [NSNumber numberWithBool:NO], @"Device2HorizontalScrollEnabled",
                                 [NSNumber numberWithDouble:1.0], @"Device2HorizontalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"Device2VerticalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"Device2HorizontalScrollFactor",
                                 [NSNumber numberWithDouble:1.0], @"Device2MultiZoomFactor",
                                 nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppSettingsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
	ZoomInverter *objZoomInv;
	objZoomInv = [[ZoomInverter alloc] init];
	if(!objZoomInv)
		return;
    
	[self.objQue addOperation:objZoomInv];

	[objZoomInv release];
   
    [self UpdateZoomInverterSettings:0];
    
    objZoomInv = [[ZoomInverter alloc] init];
    if(!objZoomInv)
        return;
    objZoomInv.ForDeviceWithProcessId = true;
    
    [self.objQue addOperation:objZoomInv];
    
    [objZoomInv release];
    
    [self UpdateZoomInverterSettings:1];
    
    
//    /*Open Logic Pro*/
//	NSWorkspace *obj;
//	obj = [[NSWorkspace alloc] init];
//	[obj launchApplication:@"Logic Pro.app"];
//	[obj release];

}

- (void) AppSettingsChanged:(NSNotification*)notification
{
    [self UpdateZoomInverterSettings:0];
    [self UpdateZoomInverterSettings:1];
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

- (void) UpdateZoomInverterSettings:(int) zoomInverterIndex
{
    ZoomInverter *objZoomInv = [self.objQue.operations objectAtIndex:zoomInverterIndex];
    
    if(!objZoomInv)
        return;
    
    objZoomInv.InvertHorizontalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"Device1HorizontalZoomEnabled"];
    objZoomInv.InvertVerticalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"Device1VerticalZoomEnabled"];
    objZoomInv.InvertMultiZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"Device1MultiZoomEnabled"];
    objZoomInv.InvertHorizontalScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"Device1HorizontalScrollEnabled"];
    objZoomInv.FactorHorizontalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Device1HorizontalZoomFactor"];
    objZoomInv.FactorVerticalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Device1VerticalZoomFactor"];
    objZoomInv.FactorHorizontalScroll = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Device1HorizontalScrollFactor"];
    objZoomInv.FactorMultiZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"Device1MultiZoomFactor"];
}

@end
