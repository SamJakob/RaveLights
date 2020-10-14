//
//  ViewController.h
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <Cocoa/Cocoa.h>

#import "Client.h"

#import "SerialClient.h"
#import "TCPClient.h"

@interface ViewController : NSViewController

@property (strong) IBOutlet NSTextField* hostname;
@property (strong) IBOutlet NSTextField* port;

@property (strong) IBOutlet NSTextField* serialPort;

@property (strong) IBOutlet NSTextView* console;
@property (strong) IBOutlet NSTabView* connectionTabView;

- (IBAction)onConnectClick:(NSButton *)sender;
- (void) log:(NSString*) data;

@end

