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

@synthesize window, operationQueue, invertHorizontalScrollCheckBox, invertHorizontalZoomCheckBox, invertMultiZoomCheckBox, invertVerticalZoomCheckBox, deviceTypeSelectionBox, horizontalZoomFactorStepper, horizontalZoomFactorInput, verticalZoomFactorInput, verticalZoomFactorStepper, multiZoomFactorInput, multiZoomFactorStepper, horizontalScrollFactorInput, horizontalScrollFactorStepper;

- (id)init {
    self.operationQueue = [[NSOperationQueue alloc] init];
    [super init];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], @"NonPidDeviceHorizontalZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"NonPidDeviceMultiZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"NonPidDeviceVerticalZoomEnabled",
                                 [NSNumber numberWithBool:NO], @"NonPidDeviceHorizontalScrollEnabled",
                                 [NSNumber numberWithDouble:1.0], @"NonPidDeviceHorizontalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"NonPidDeviceVerticalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"NonPidDeviceHorizontalScrollFactor",
                                 [NSNumber numberWithDouble:1.0], @"NonPidDeviceMultiZoomFactor",
                                 [NSNumber numberWithBool:YES], @"PidDeviceHorizontalZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"PidDeviceMultiZoomEnabled",
                                 [NSNumber numberWithBool:YES], @"PidDeviceVerticalZoomEnabled",
                                 [NSNumber numberWithBool:NO], @"PidDeviceHorizontalScrollEnabled",
                                 [NSNumber numberWithDouble:1.0], @"PidDeviceHorizontalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"PidDeviceVerticalZoomFactor",
                                 [NSNumber numberWithDouble:1.0], @"PidDeviceHorizontalScrollFactor",
                                 [NSNumber numberWithDouble:1.0], @"PidDeviceMultiZoomFactor",
                                 nil];

    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appSettingsChanged:) name:NSUserDefaultsDidChangeNotification object:nil];
    
	ZoomInverter *zoomInverter;
    
	zoomInverter = [[ZoomInverter alloc] init];
    
	if(!zoomInverter)
		return;
    
	[self.operationQueue addOperation:zoomInverter];

	[zoomInverter release];
    
    [self updateControlBindings];
    
    [self updateZoomInverterSettings];
    
}

- (void) appSettingsChanged:(NSNotification*)notification {
    [self updateZoomInverterSettings];
}

- (IBAction)deviceTypeSelected:(id)sender {
    [self updateControlBindings];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)LogicZoomInverterAppDelegate {
	return true;
}

- (void)dealloc {
    [self.operationQueue release];
    [super dealloc];
}

- (void) updateControlBindings {
    [invertHorizontalZoomCheckBox unbind:@"value"];
    [invertHorizontalScrollCheckBox unbind:@"value"];
    [invertMultiZoomCheckBox unbind:@"value"];
    [invertVerticalZoomCheckBox unbind:@"value"];
    [horizontalZoomFactorInput unbind:@"value"];
    [horizontalZoomFactorStepper unbind:@"value"];
    [verticalZoomFactorInput unbind:@"value"];
    [verticalZoomFactorStepper unbind:@"value"];
    [multiZoomFactorInput unbind:@"value"];
    [multiZoomFactorStepper unbind:@"value"];
    [horizontalScrollFactorInput unbind:@"value"];
    [horizontalScrollFactorStepper unbind:@"value"];
    
    if(self.deviceTypeSelectionBox.indexOfSelectedItem == 0)
    {
        [invertHorizontalZoomCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceHorizontalZoomEnabled" options:nil];
        [invertHorizontalScrollCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceHorizontalScrollEnabled" options:nil];
        [invertMultiZoomCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceMultiZoomEnabled" options:nil];
        [invertVerticalZoomCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceVerticalZoomEnabled" options:nil];
        [horizontalZoomFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceHorizontalZoomFactor" options:nil];
        [horizontalZoomFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceHorizontalZoomFactor" options:nil];
        [verticalZoomFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceVerticalZoomFactor" options:nil];
        [verticalZoomFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceVerticalZoomFactor" options:nil];
        [multiZoomFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceMultiZoomFactor" options:nil];
        [multiZoomFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceMultiZoomFactor" options:nil];
        [horizontalScrollFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceHorizontalScrollFactor" options:nil];
        [horizontalScrollFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.NonPidDeviceHorizontalScrollFactor" options:nil];
    }
    else
    {
        [invertHorizontalZoomCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceHorizontalZoomEnabled" options:nil];
        [invertHorizontalScrollCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceHorizontalScrollEnabled" options:nil];
        [invertMultiZoomCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceMultiZoomEnabled" options:nil];
        [invertVerticalZoomCheckBox bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceVerticalZoomEnabled" options:nil];
        [horizontalZoomFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceHorizontalZoomFactor" options:nil];
        [horizontalZoomFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceHorizontalZoomFactor" options:nil];
        [verticalZoomFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceVerticalZoomFactor" options:nil];
        [verticalZoomFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceVerticalZoomFactor" options:nil];
        [multiZoomFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceMultiZoomFactor" options:nil];
        [multiZoomFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceMultiZoomFactor" options:nil];
        [horizontalScrollFactorInput bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceHorizontalScrollFactor" options:nil];
        [horizontalScrollFactorStepper bind:@"value" toObject:[NSUserDefaultsController sharedUserDefaultsController] withKeyPath:@"values.PidDeviceHorizontalScrollFactor" options:nil];
    }
}

- (void) updateZoomInverterSettings {
    ZoomInverter *zoomInverter = [self.operationQueue.operations objectAtIndex:0];
    
    if(!zoomInverter)
        return;

    struct DeviceSettings deviceSettings;

    deviceSettings = zoomInverter.nonPidDeviceSettings;
    deviceSettings.invertHorizontalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"NonPidDeviceHorizontalZoomEnabled"];
    deviceSettings.invertVerticalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"NonPidDeviceVerticalZoomEnabled"];
    deviceSettings.invertMultiZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"NonPidDeviceMultiZoomEnabled"];
    deviceSettings.invertHorizontalScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"NonPidDeviceHorizontalScrollEnabled"];
    deviceSettings.factorHorizontalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"NonPidDeviceHorizontalZoomFactor"];
    deviceSettings.factorVerticalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"NonPidDeviceVerticalZoomFactor"];
    deviceSettings.factorHorizontalScroll = [[NSUserDefaults standardUserDefaults] doubleForKey:@"NonPidDeviceHorizontalScrollFactor"];
    deviceSettings.factorMultiZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"NonPidDeviceMultiZoomFactor"];
    zoomInverter.nonPidDeviceSettings = deviceSettings;
    
    deviceSettings = zoomInverter.pidDeviceSettings;
    deviceSettings.invertHorizontalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"PidDeviceHorizontalZoomEnabled"];
    deviceSettings.invertVerticalZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"PidDeviceVerticalZoomEnabled"];
    deviceSettings.invertMultiZoom = [[NSUserDefaults standardUserDefaults] boolForKey:@"PidDeviceMultiZoomEnabled"];
    deviceSettings.invertHorizontalScroll = [[NSUserDefaults standardUserDefaults] boolForKey:@"PidDeviceHorizontalScrollEnabled"];
    deviceSettings.factorHorizontalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"PidDeviceHorizontalZoomFactor"];
    deviceSettings.factorVerticalZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"PidDeviceVerticalZoomFactor"];
    deviceSettings.factorHorizontalScroll = [[NSUserDefaults standardUserDefaults] doubleForKey:@"PidDeviceHorizontalScrollFactor"];
    deviceSettings.factorMultiZoom = [[NSUserDefaults standardUserDefaults] doubleForKey:@"PidDeviceMultiZoomFactor"];
    zoomInverter.pidDeviceSettings = deviceSettings;
}

@end
