//
//  AppDelegate.h
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <Cocoa/Cocoa.h>
#import "AudioKit/AudioKit.h"

#import "Client.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    AKFrequencyTracker* freqTracker;
    
    @public
        /// The socket client to connect to.
        Client* client;
}

@end

