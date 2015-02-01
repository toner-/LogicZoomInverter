//
//  ZoomInverter.h
//  LogicZoomInverter
//
//  Created by Tony Freggiaro on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

CGEventRef EventTapCallBack (CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon);

@interface ZoomInverter : NSOperation{
    CFMachPortRef objMachPort;
}

@property (nonatomic) BOOL InvertHorizontalZoom;
@property (nonatomic) BOOL InvertVerticalZoom;
@property (nonatomic) BOOL InvertMultiZoom;
@property (nonatomic) BOOL InvertHorizontalScroll;
@property (nonatomic) double FactorHorizontalZoom;
@property (nonatomic) double FactorHorizontalScroll;
@property (nonatomic) double FactorVerticalZoom;
@property (nonatomic) double FactorMultiZoom;

- (void) Enable;
- (void) Disable;
- (int64_t) NewInt64DeltaValue:(int64_t) intCurrentValue Factor: (double) fltFactor Invert:(BOOL) blnInvert;
- (double) NewDoubleDeltaValue:(double) dblCurrentValue Factor: (double) fltFactor Invert:(BOOL) blnInvert;

@end
