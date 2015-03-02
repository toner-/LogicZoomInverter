//
//  ZoomInverter.m
//  LogicZoomInverter
//
//  Created by Tony Freggiaro on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoomInverter.h"

@implementation ZoomInverter

@synthesize nonPidDeviceSettings, pidDeviceSettings;

- (id)init {
    [super init];
    return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void) disable {
    CGEventTapEnable(machPort, false);
}

- (void) enable {
    CGEventTapEnable(machPort, true);
}

- (void)main {
    CFRunLoopRef runLoopRef;
    CFRunLoopSourceRef runLoopSource;
    
    /*Create an event tap to watch for scroll events*/
    machPort = CGEventTapCreate (kCGSessionEventTap, kCGTailAppendEventTap, kCGEventTapOptionDefault, CGEventMaskBit(kCGEventScrollWheel), eventTapCallBack, self);

    runLoopSource = CFMachPortCreateRunLoopSource (NULL, machPort, 0);
    
    runLoopRef = CFRunLoopGetCurrent();
    
    CFRunLoopAddSource(runLoopRef, runLoopSource, kCFRunLoopCommonModes);
    
    CGEventTapEnable(machPort, true);
    
    /*Run the loop that checks for events*/
    CFRunLoopRun();
    
}

- (int64_t) newInt64DeltaValue:(int64_t) currentValue factor: (double) factor invert:(BOOL) invert {
    int64_t newValue;
    
    if(currentValue > 0)
        newValue = floor(((double)currentValue)*factor);
    else
        newValue = ceil(((double)currentValue)*factor);
    
    if(invert)
        newValue = -newValue;
    
    return newValue;
}

- (double) newDoubleDeltaValue:(double) currentValue factor: (double) factor invert:(BOOL) invert {
    double newValue;
    
    newValue = currentValue*factor;
    
    if(invert)
        newValue = -1.0*newValue;
    
    return newValue;
}

CGEventRef eventTapCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
    
	/*Make sure we have a scroll event and that we have a pointer to the zoom object*/
	if(type != kCGEventScrollWheel || !refcon)
        return event;
    
	/*
	 This is a list of all key combos for axis 1
	 
	 VERTICAL ZOOM
	 option
	 option + command + shift
	 
	 HORIZONTAL SCROLL
	 command
	 shift
	 control + shift
	 control + command
	 
	 MULTI ZOOM
	 option + control
	 option + control + command
	 
	 HORIZONTAL ZOOM
	 option + command
	 option + shift

     This is a list of all key combos for axis 2
     
     VERTICAL ZOOM
     shift + option + command
     option + command
     
     HORIZONTAL SCROLL
     control + shift
     shift
     
     HORIZONTAL ZOOM
     option
     shift + option
	*/
	
	ZoomInverter *zoomInverter = refcon;
    CGEventFlags eventFlags = CGEventGetFlags(event) & (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand | kCGEventFlagMaskShift | kCGEventFlagMaskControl);
    int64_t rawDelta1, rawDelta2, rawPointDelta1, rawPointDelta2;
    double fixedDelta1, fixedDelta2;
    struct DeviceSettings eventDeviceSettings;
    
    if(CGEventGetIntegerValueField(event, kCGEventSourceUnixProcessID) == 0)
        eventDeviceSettings = zoomInverter.nonPidDeviceSettings;
    else
        eventDeviceSettings = zoomInverter.pidDeviceSettings;
    
    rawDelta1 = CGEventGetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1);
    rawDelta2 = CGEventGetIntegerValueField(event, kCGScrollWheelEventDeltaAxis2);
    rawPointDelta1 = CGEventGetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis1);
    rawPointDelta2 = CGEventGetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis2);
    fixedDelta1 = CGEventGetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis1);
    fixedDelta2 = CGEventGetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis2);
    
    if(rawDelta1 != 0 || rawPointDelta1 != 0 || fixedDelta1 != 0)
    {
        /*Check if a horizontal zoom is active*/
        if((eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand) ||
            eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)))
        {
            rawDelta1 = [zoomInverter newInt64DeltaValue:rawDelta1 factor:eventDeviceSettings.factorHorizontalZoom invert:eventDeviceSettings.invertHorizontalZoom];
            rawPointDelta1 = [zoomInverter newInt64DeltaValue:rawPointDelta1 factor:eventDeviceSettings.factorHorizontalZoom invert:eventDeviceSettings.invertHorizontalZoom];
            fixedDelta1 = [zoomInverter newDoubleDeltaValue:fixedDelta1 factor:eventDeviceSettings.factorHorizontalZoom invert:eventDeviceSettings.invertHorizontalZoom];
        }
        /*Check if a multi zoom is active*/
        else if((eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskControl) ||
                 eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskControl | kCGEventFlagMaskCommand)))
        {
            rawDelta1 = [zoomInverter newInt64DeltaValue:rawDelta1 factor:eventDeviceSettings.factorMultiZoom invert:eventDeviceSettings.invertMultiZoom];
            rawPointDelta1 = [zoomInverter newInt64DeltaValue:rawPointDelta1 factor:eventDeviceSettings.factorMultiZoom invert:eventDeviceSettings.invertMultiZoom];
            fixedDelta1 = [zoomInverter newDoubleDeltaValue:fixedDelta1 factor:eventDeviceSettings.factorMultiZoom invert:eventDeviceSettings.invertMultiZoom];
        }
        /*Check if a vertical zoom is active*/
        else if((eventFlags == (kCGEventFlagMaskAlternate) ||
                 eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand | kCGEventFlagMaskShift)))
        {
            rawDelta1 = [zoomInverter newInt64DeltaValue:rawDelta1 factor:eventDeviceSettings.factorVerticalZoom invert:eventDeviceSettings.invertVerticalZoom];
            rawPointDelta1 = [zoomInverter newInt64DeltaValue:rawPointDelta1 factor:eventDeviceSettings.factorVerticalZoom invert:eventDeviceSettings.invertVerticalZoom];
            fixedDelta1 = [zoomInverter newDoubleDeltaValue:fixedDelta1 factor:eventDeviceSettings.factorVerticalZoom invert:eventDeviceSettings.invertVerticalZoom];
        }
        /*Check if a horizontal scroll is active*/
        else if((eventFlags == (kCGEventFlagMaskCommand) ||
                 eventFlags == (kCGEventFlagMaskShift) ||
                 eventFlags == (kCGEventFlagMaskControl | kCGEventFlagMaskShift) ||
                 eventFlags == (kCGEventFlagMaskControl | kCGEventFlagMaskCommand)))
        {
            rawDelta1 = [zoomInverter newInt64DeltaValue:rawDelta1 factor:eventDeviceSettings.factorHorizontalScroll invert:eventDeviceSettings.invertHorizontalScroll];
            rawPointDelta1 = [zoomInverter newInt64DeltaValue:rawPointDelta1 factor:eventDeviceSettings.factorHorizontalScroll invert:eventDeviceSettings.invertHorizontalScroll];
            fixedDelta1 = [zoomInverter newDoubleDeltaValue:fixedDelta1 factor:eventDeviceSettings.factorHorizontalScroll invert:eventDeviceSettings.invertHorizontalScroll];
        }
    }
    
    if(rawDelta2 != 0 || rawPointDelta2 != 0 || fixedDelta2 != 0)
    {
        /*Check if a horizontal zoom is active*/
        if((eventFlags == (kCGEventFlagMaskAlternate) ||
            eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)))
        {
            rawDelta2 = [zoomInverter newInt64DeltaValue:rawDelta2 factor:eventDeviceSettings.factorHorizontalZoom invert:eventDeviceSettings.invertHorizontalZoom];
            rawPointDelta2 = [zoomInverter newInt64DeltaValue:rawPointDelta2 factor:eventDeviceSettings.factorHorizontalZoom invert:eventDeviceSettings.invertHorizontalZoom];
            fixedDelta2 = [zoomInverter newDoubleDeltaValue:fixedDelta2 factor:eventDeviceSettings.factorHorizontalZoom invert:eventDeviceSettings.invertHorizontalZoom];
        }
        /*Check if a vertical zoom is active*/
        else if((eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift | kCGEventFlagMaskCommand) ||
                 eventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand)))
        {
            rawDelta2 = [zoomInverter newInt64DeltaValue:rawDelta2 factor:eventDeviceSettings.factorVerticalZoom invert:eventDeviceSettings.invertVerticalZoom];
            rawPointDelta2 = [zoomInverter newInt64DeltaValue:rawPointDelta2 factor:eventDeviceSettings.factorVerticalZoom invert:eventDeviceSettings.invertVerticalZoom];
            fixedDelta2 = [zoomInverter newDoubleDeltaValue:fixedDelta2 factor:eventDeviceSettings.factorVerticalZoom invert:eventDeviceSettings.invertVerticalZoom];
        }
        /*Check if a horizontal scroll is active*/
        else if((eventFlags == (kCGEventFlagMaskControl | kCGEventFlagMaskShift) ||
                 eventFlags == (kCGEventFlagMaskShift)))
        {
            rawDelta2 = [zoomInverter newInt64DeltaValue:rawDelta2 factor:eventDeviceSettings.factorHorizontalScroll invert:eventDeviceSettings.invertHorizontalScroll];
            rawPointDelta2 = [zoomInverter newInt64DeltaValue:rawPointDelta2 factor:eventDeviceSettings.factorHorizontalScroll invert:eventDeviceSettings.invertHorizontalScroll];
            fixedDelta2 = [zoomInverter newDoubleDeltaValue:fixedDelta2 factor:eventDeviceSettings.factorHorizontalScroll invert:eventDeviceSettings.invertHorizontalScroll];
        }
    }

    CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1, rawDelta1);
    CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis2, rawDelta2);
    CGEventSetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis1, fixedDelta1);
    CGEventSetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis2, fixedDelta2);
    CGEventSetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis1, rawPointDelta1);
    CGEventSetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis2, rawPointDelta2);
    
    /*Return the event*/
    return event;
}

@end
