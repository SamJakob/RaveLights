//
//  ViewController.h
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <Cocoa/Cocoa.h>
#import "Client.h"

@interface ViewController : NSViewController {
    @private
        /// The socket client to connect to.
        Client* client;
}

@property (strong) IBOutlet NSTextField* hostname;
@property (strong) IBOutlet NSTextField* port;

@property (strong) IBOutlet NSTextView* console;

- (IBAction)onConnectClick:(NSButton *)sender;
- (void) log:(NSString*) data;

@end

