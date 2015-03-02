//
//  ZoomInverter.h
//  LogicZoomInverter
//
//  Created by Tony Freggiaro on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

CGEventRef eventTapCallBack (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon);

@interface ZoomInverter : NSOperation{
    CFMachPortRef machPort;
}

@property (nonatomic) struct DeviceSettings nonPidDeviceSettings;
@property (nonatomic) struct DeviceSettings pidDeviceSettings;

- (void) enable;
- (void) disable;
- (int64_t) newInt64DeltaValue:(int64_t) currentValue factor: (double) factor invert:(BOOL) invert;
- (double) newDoubleDeltaValue:(double) currentValue factor: (double) factor invert:(BOOL) invert;

struct DeviceSettings
{
    BOOL invertHorizontalZoom;
    BOOL invertVerticalZoom;
    BOOL invertMultiZoom;
    BOOL invertHorizontalScroll;
    double factorHorizontalZoom;
    double factorHorizontalScroll;
    double factorVerticalZoom;
    double factorMultiZoom;
};

@end
