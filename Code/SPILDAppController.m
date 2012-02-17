//
//  SPILDAppController.m
//  SPILDemo
//
//  Copyright 2009 Kelan Champagne. All rights reserved.
//

#import "SPILDAppController.h"

#import "SPILDTopLayerView.h"
#import "YRKSpinningProgressIndicatorLayer.h"

@interface SPILDAppController ()

// Helper Methods
- (void)setupDeterminateProgressTimer;
- (void)disposeDeterminateProgressTimer;

@end

@implementation SPILDAppController

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Init, Dealloc, etc
//------------------------------------------------------------------------------

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // start with a nice green
    NSColor *niceGreenColor = [NSColor colorWithCalibratedRed:0.40f green:0.69f blue:0.45f alpha:1.0f];
    _fgColorWell.color = niceGreenColor;
    [self pickNewForeColor:_fgColorWell];

    _bgColorWell.color = [NSColor blueColor];
    [self pickNewBackColor:_bgColorWell];
}


//------------------------------------------------------------------------------
#pragma mark -
#pragma mark IB Actions
//------------------------------------------------------------------------------

- (IBAction)pickNewForeColor:(id)sender
{
    [_mainView progressIndicatorLayer].color = [sender color];
}

- (IBAction)pickNewBackColor:(id)sender
{
    [_mainView setPlainBackgroundColor:[sender color]];
}

- (IBAction)selectProgressIndicatorType:(id)sender
{
    if ([[sender selectedCell] tag] == 1) {
        _mainView.progressIndicatorLayer.isIndeterminate = YES;
        if (_determinateProgressTimer != nil) {
            [self disposeDeterminateProgressTimer];
            [[_mainView progressIndicatorLayer] startProgressAnimation];
        }
    }
    else if ([[sender selectedCell] tag] == 2) {
        _mainView.progressIndicatorLayer.isIndeterminate = NO;
        if (_mainView.progressIndicatorLayer.isRunning) {
            [[_mainView progressIndicatorLayer] stopProgressAnimation];
            [self setupDeterminateProgressTimer];
        }
    }

    [_mainView setNeedsDisplay:YES];
}

- (IBAction)startStopProgressIndicator:(id)sender
{
    if ([[_mainView progressIndicatorLayer] isRunning] || (_determinateProgressTimer != nil)) {
        // it is running, so stop it
        if (_mainView.progressIndicatorLayer.isIndeterminate) {
            [[_mainView progressIndicatorLayer] stopProgressAnimation];
        }
        else {
            [self disposeDeterminateProgressTimer];
            _mainView.progressIndicatorLayer.doubleValue = 0;
        }

        [_startStopButton setTitle:@"Start"];
    }
    else {
        // it is stopped, so start it
        if (_mainView.progressIndicatorLayer.isIndeterminate) {
            [[_mainView progressIndicatorLayer] startProgressAnimation];
        } 
        else {
            [self setupDeterminateProgressTimer];
        }

        [_startStopButton setTitle:@"Stop"];
    }
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Helpers
//------------------------------------------------------------------------------

- (void)advanceDeterminateTimer:(NSTimer *)timer {
    // 200 times 0.05s should make a full progress in 10s.
    _mainView.progressIndicatorLayer.doubleValue += 0.5f;

    if (_mainView.progressIndicatorLayer.doubleValue >= 100)
        _mainView.progressIndicatorLayer.doubleValue = 0;
}

- (void)setupDeterminateProgressTimer {
    [self disposeDeterminateProgressTimer];
    
    _determinateProgressTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] 
                                                         interval:0.05f 
                                                           target:self 
                                                         selector:@selector(advanceDeterminateTimer:) 
                                                         userInfo:nil 
                                                          repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_determinateProgressTimer forMode:NSRunLoopCommonModes];
}

- (void)disposeDeterminateProgressTimer {
    [_determinateProgressTimer invalidate];
    [_determinateProgressTimer release];
    _determinateProgressTimer = nil;
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Properties
//------------------------------------------------------------------------------

@synthesize mainView = _mainView;

@end
