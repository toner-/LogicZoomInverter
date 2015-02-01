//
//  ZoomInverter.m
//  LogicZoomInverter
//
//  Created by Tony Freggiaro on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ZoomInverter.h"

@implementation ZoomInverter

@synthesize InvertHorizontalZoom, InvertMultiZoom, InvertVerticalZoom, InvertHorizontalScroll, FactorHorizontalZoom, FactorHorizontalScroll, FactorMultiZoom, FactorVerticalZoom;

- (id)init
{
    [super init];
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) Disable
{
    CGEventTapEnable(objMachPort, false);
}

- (void) Enable
{
    CGEventTapEnable(objMachPort, true);
}

- (void)main
{
	
    CFRunLoopRef		objRunLoopRef;
    CFRunLoopSourceRef	objRunLoopSource;
    
    /*Create an event tap to watch for scroll events*/
    objMachPort			= CGEventTapCreate (kCGSessionEventTap,
											kCGTailAppendEventTap,
											kCGEventTapOptionDefault, 
											CGEventMaskBit(kCGEventScrollWheel),
											EventTapCallBack,
											self);

    objRunLoopSource	= CFMachPortCreateRunLoopSource (NULL, objMachPort, 0);
    
    objRunLoopRef		= CFRunLoopGetCurrent();
    
    CFRunLoopAddSource(objRunLoopRef, objRunLoopSource, kCFRunLoopCommonModes);
    
    CGEventTapEnable(objMachPort, true);
    
    /*Run the loop that checks for events*/
    CFRunLoopRun();
        
}

- (int64_t) NewInt64DeltaValue:(int64_t) intCurrentValue Factor: (double) fltFactor Invert:(BOOL) blnInvert
{
    int64_t intNewValue;
    if(intCurrentValue > 0)
        intNewValue = floor(((double)intCurrentValue)*fltFactor);
    else
        intNewValue = ceil(((double)intCurrentValue)*fltFactor);
    
    if(blnInvert)
        intNewValue     = -intNewValue;
    
    return intNewValue;
}

- (double) NewDoubleDeltaValue:(double) dblCurrentValue Factor: (double) fltFactor Invert:(BOOL) blnInvert
{
    double dblNewValue;
    
    dblNewValue = dblCurrentValue*fltFactor;
    
    if(blnInvert)
        dblNewValue     = -1.0*dblNewValue;
    
    return dblNewValue;
}

CGEventRef EventTapCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
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
	
	ZoomInverter *objZoomInv = refcon;
    CGEventFlags objEventFlags = CGEventGetFlags(event) & (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand | kCGEventFlagMaskShift | kCGEventFlagMaskControl);
    int64_t intRawDelta1, intRawDelta2, intRawPointDelta1, intRawPointDelta2;
    double dblFixedDelta1, dblFixedDelta2;

    intRawDelta1 = CGEventGetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1);
    intRawDelta2 = CGEventGetIntegerValueField(event, kCGScrollWheelEventDeltaAxis2);
    intRawPointDelta1 = CGEventGetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis1);
    intRawPointDelta2 = CGEventGetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis2);
    dblFixedDelta1 = CGEventGetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis1);
    dblFixedDelta2 = CGEventGetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis2);
    
    if(intRawDelta1 != 0 || intRawPointDelta1 != 0 || dblFixedDelta1 != 0)
    {
        /*Check if a horizontal zoom is active*/
        if((objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand) ||
            objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)))
        {
            intRawDelta1 = [objZoomInv NewInt64DeltaValue:intRawDelta1 Factor:objZoomInv.FactorHorizontalZoom Invert:objZoomInv.InvertHorizontalZoom];
            intRawPointDelta1 = [objZoomInv NewInt64DeltaValue:intRawPointDelta1 Factor:objZoomInv.FactorHorizontalZoom Invert:objZoomInv.InvertHorizontalZoom];
            dblFixedDelta1 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta1 Factor:objZoomInv.FactorHorizontalZoom Invert:objZoomInv.InvertHorizontalZoom];
        }
        /*Check if a multi zoom is active*/
        else if((objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskControl) ||
                 objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskControl | kCGEventFlagMaskCommand)))
        {
            intRawDelta1 = [objZoomInv NewInt64DeltaValue:intRawDelta1 Factor:objZoomInv.FactorMultiZoom Invert:objZoomInv.InvertMultiZoom];
            intRawPointDelta1 = [objZoomInv NewInt64DeltaValue:intRawPointDelta1 Factor:objZoomInv.FactorMultiZoom Invert:objZoomInv.InvertMultiZoom];
            dblFixedDelta1 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta1 Factor:objZoomInv.FactorMultiZoom Invert:objZoomInv.InvertMultiZoom];
        }
        /*Check if a vertical zoom is active*/
        else if((objEventFlags == (kCGEventFlagMaskAlternate) ||
                 objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand | kCGEventFlagMaskShift)))
        {
            intRawDelta1 = [objZoomInv NewInt64DeltaValue:intRawDelta1 Factor:objZoomInv.FactorVerticalZoom Invert:objZoomInv.InvertVerticalZoom];
            intRawPointDelta1 = [objZoomInv NewInt64DeltaValue:intRawPointDelta1 Factor:objZoomInv.FactorVerticalZoom Invert:objZoomInv.InvertVerticalZoom];
            dblFixedDelta1 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta1 Factor:objZoomInv.FactorVerticalZoom Invert:objZoomInv.InvertVerticalZoom];
        }
        /*Check if a horizontal scroll is active*/
        else if((objEventFlags == (kCGEventFlagMaskCommand) ||
                 objEventFlags == (kCGEventFlagMaskShift) ||
                 objEventFlags == (kCGEventFlagMaskControl | kCGEventFlagMaskShift) ||
                 objEventFlags == (kCGEventFlagMaskControl | kCGEventFlagMaskCommand)))
        {
            intRawDelta1 = [objZoomInv NewInt64DeltaValue:intRawDelta1 Factor:objZoomInv.FactorHorizontalScroll Invert:objZoomInv.InvertHorizontalScroll];
            intRawPointDelta1 = [objZoomInv NewInt64DeltaValue:intRawPointDelta1 Factor:objZoomInv.FactorHorizontalScroll Invert:objZoomInv.InvertHorizontalScroll];
            dblFixedDelta1 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta1 Factor:objZoomInv.FactorHorizontalScroll Invert:objZoomInv.InvertHorizontalScroll];
        }
    }
    
    if(intRawDelta2 != 0 || intRawPointDelta2 != 0 || dblFixedDelta2 != 0)
    {
        /*Check if a horizontal zoom is active*/
        if((objEventFlags == (kCGEventFlagMaskAlternate) ||
            objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift)))
        {
            intRawDelta2 = [objZoomInv NewInt64DeltaValue:intRawDelta2 Factor:objZoomInv.FactorHorizontalZoom Invert:objZoomInv.InvertHorizontalZoom];
            intRawPointDelta2 = [objZoomInv NewInt64DeltaValue:intRawPointDelta2 Factor:objZoomInv.FactorHorizontalZoom Invert:objZoomInv.InvertHorizontalZoom];
            dblFixedDelta2 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta2 Factor:objZoomInv.FactorHorizontalZoom Invert:objZoomInv.InvertHorizontalZoom];
        }
        /*Check if a vertical zoom is active*/
        else if((objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskShift | kCGEventFlagMaskCommand) ||
                 objEventFlags == (kCGEventFlagMaskAlternate | kCGEventFlagMaskCommand)))
        {
            intRawDelta2 = [objZoomInv NewInt64DeltaValue:intRawDelta2 Factor:objZoomInv.FactorVerticalZoom Invert:objZoomInv.InvertVerticalZoom];
            intRawPointDelta2 = [objZoomInv NewInt64DeltaValue:intRawPointDelta2 Factor:objZoomInv.FactorVerticalZoom Invert:objZoomInv.InvertVerticalZoom];
            dblFixedDelta2 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta2 Factor:objZoomInv.FactorVerticalZoom Invert:objZoomInv.InvertVerticalZoom];
        }
        /*Check if a horizontal scroll is active*/
        else if((objEventFlags == (kCGEventFlagMaskControl | kCGEventFlagMaskShift) ||
                 objEventFlags == (kCGEventFlagMaskShift)))
        {
            intRawDelta2 = [objZoomInv NewInt64DeltaValue:intRawDelta2 Factor:objZoomInv.FactorHorizontalScroll Invert:objZoomInv.InvertHorizontalScroll];
            intRawPointDelta2 = [objZoomInv NewInt64DeltaValue:intRawPointDelta2 Factor:objZoomInv.FactorHorizontalScroll Invert:objZoomInv.InvertHorizontalScroll];
            dblFixedDelta2 = [objZoomInv NewDoubleDeltaValue:dblFixedDelta2 Factor:objZoomInv.FactorHorizontalScroll Invert:objZoomInv.InvertHorizontalScroll];
        }
    }

    CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis1, intRawDelta1);
    CGEventSetIntegerValueField(event, kCGScrollWheelEventDeltaAxis2, intRawDelta2);
    CGEventSetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis1, dblFixedDelta1);
    CGEventSetDoubleValueField(event, kCGScrollWheelEventFixedPtDeltaAxis2, dblFixedDelta2);
    CGEventSetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis1, intRawPointDelta1);
    CGEventSetIntegerValueField(event, kCGScrollWheelEventPointDeltaAxis2, intRawPointDelta2);
    
    /*Return the event*/
    return event;
}

@end
