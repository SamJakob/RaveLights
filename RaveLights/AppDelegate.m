//
//  AppDelegate.m
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <AudioKit/AudioKit.h>
#import "AppDelegate.h"

#import <math.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

NSOperationQueue* queue;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSLog(@"Preparing to read audio data...");
    [AKSettings setAudioInputEnabled:true];
    [AKSettings setSampleRate:44100];
    
    NSError *error;
    
    AKDevice* targetDevice;
    for (AKDevice* microphone in [AKManager inputDevices]) {
        if (![microphone.description containsString:@"Microphone"]) {
            targetDevice = microphone;
            NSLog(@"Target device identified! (%@)", targetDevice.description);
        }
    }
    
    if (targetDevice == NULL) {
        NSAlert* alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Fuck."];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        
        return;
    }
    
     [AKManager setInputDevice:targetDevice error:&error];
    
    AKMicrophone* microphone = [[AKMicrophone alloc] initWith:nil];
    self->freqTracker = [[AKFrequencyTracker alloc] init:microphone hopSize:4096 peakCount:20];
    
    if (error != NULL) {
        NSLog(@"%@", @"An error has occurred that prevented the microphone device from being set.");
        NSLog(@"%@", error);
    }
    
    AKBooster* silence = [[AKBooster alloc] init:freqTracker gain: 0];
    
    [AKManager setOutput:silence];
    [AKManager startAndReturnError:&error];
    
    queue = [NSOperationQueue new];
    [queue setMaxConcurrentOperationCount:1];
    
    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:true];
}

- (void)timerTicked:(NSTimer*) timer {
    
    void (^block)(void) = ^{
        if (true || self->freqTracker.amplitude > 0.01) {
            if (self->freqTracker.frequency <= 1500) {
                [self dispatchFrequency:round(self->freqTracker.frequency)];
                
                // [self dispatchFrequency:round(self->freqTracker.frequency)];
            }
        }
    };
    
    [queue addOperationWithBlock:block];
    
}

uint16_t prevFreq = 0;
- (void) dispatchFrequency:(uint16_t) frequency {
    
    if (client != NULL) {
        
        if (frequency != prevFreq) {
            NSLog(@"%d", frequency);
            
            uint8_t mappedFrequency = [self map:frequency fromMax:300 toMax:255];
            [client writeData:[NSData dataWithBytes:&mappedFrequency length:1]];
            
            prevFreq = frequency;
        }
        
    }
    
}

- (uint8_t) map:(int) value fromMax:(int) oldMax toMax:(int) newMax {
    
    if (value > oldMax) value = oldMax;
    
    double divisor = ((double) value) / oldMax;
    return floor(newMax * divisor);
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}


@end
