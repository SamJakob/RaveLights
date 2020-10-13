//
//  AppDelegate.m
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <AudioKit/AudioKit.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSOperationQueue* queue;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSLog(@"Preparing to read audio data...");
    [AKSettings setAudioInputEnabled:true];
    
    AKMicrophone* microphone = [[AKMicrophone alloc] initWith:nil];
    self->freqTracker = [[AKFrequencyTracker alloc] init:microphone hopSize:4096 peakCount:20];
    
    AKBooster* silence = [[AKBooster alloc] init:freqTracker gain: 0];
    
    NSError *error;
    [AKManager setOutput:silence];
    [AKManager startAndReturnError:&error];
    
    queue = [NSOperationQueue new];
    [queue setMaxConcurrentOperationCount:1];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:true];
}

- (void)timerTicked:(NSTimer*) timer {
    
    void (^block)(void) = ^{
        if (self->freqTracker.amplitude > 0.1) {
            NSLog(@"%f", self->freqTracker.frequency);
        }
    };
    
    [queue addOperationWithBlock:block];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


@end
