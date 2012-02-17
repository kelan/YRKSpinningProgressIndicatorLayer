//
//  YRKSpinningProgressIndicatorLayer.h
//  SPILDemo
//
//  Copyright 2009 Kelan Champagne. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


@interface YRKSpinningProgressIndicatorLayer : CALayer {
    BOOL _isIndeterminate;

    BOOL _isRunning;
    NSTimer *_animationTimer;
    NSUInteger _position;

    CGColorRef _foreColor;
    CGFloat _fadeDownOpacity;

    NSUInteger _numFins;
    NSMutableArray *_finLayers;

    double _maxValue;
    double _doubleValue;
}

- (void)toggleProgressAnimation;
- (void)startProgressAnimation;
- (void)stopProgressAnimation;

// Properties and Accessors
@property (readonly) BOOL isRunning;
@property (assign) BOOL isIndeterminate;
@property (assign) double maxValue;
@property (assign) double doubleValue;
@property (readwrite, copy) NSColor *color;  // "copy" because we don't retain it -- we create a CGColor from it

@end

// Helper Functions
CGColorRef CGColorCreateFromNSColor(NSColor *nscolor);
NSColor *NSColorFromCGColorRef(CGColorRef cgcolor);
