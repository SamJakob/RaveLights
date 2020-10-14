//
//  ViewController.m
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)onConnectClick:(NSButton *)sender {
    
    AppDelegate* appDelegate = [[NSApplication sharedApplication] delegate];
    
    __block ViewController* this = self;
    BOOL isConnecting = sender.state == NSControlStateValueOn;
    
    if (isConnecting) {
        for (int i = 0; i < 10; i++)
            [self log:@""];
        
        [self log:@"Connecting to server..."];
        
        if ([_connectionTabView.selectedTabViewItem.identifier isEqual:@"tcpSocket"]) {
            
            appDelegate->client = [[TCPClient alloc] init:self->_port.intValue withAddress:self->_hostname.stringValue];
            
            [appDelegate->client setOnAck:^(int ledCount){
                
                [this log:@"Protocol: TCP Socket"];
                [this log:[@"Hostname: " stringByAppendingString:this->_hostname.stringValue]];
                [this log:[@"Port: " stringByAppendingString:this->_port.stringValue]];
                
                [this log:@"Connection is ready!"];
                [this log:[NSString stringWithFormat:@"Controller reports a %d led array.", ledCount]];
                
            }];
            
        } else if ([_connectionTabView.selectedTabViewItem.identifier isEqual:@"usbSerial"]) {
            
            appDelegate->client = [[SerialClient alloc] init:this->_serialPort.stringValue];
            
            [appDelegate->client setOnAck:^(int ledCount) {
                
                [this log:@"Protocol: USB Serial"];
                [this log:[@"Port: /dev/" stringByAppendingString:this->_serialPort.stringValue]];
                
                [this log:@"Connection is ready!"];
                [this log:[NSString stringWithFormat:@"Controller reports that it does not give a fuck about the length of the LED array."]];
                
            }];
            
        }
        
        [appDelegate->client start];
        [appDelegate->client write:@"$HANDSHAKE"];
        
        dispatch_group_t lightDispatch = dispatch_group_create();
        dispatch_group_async(lightDispatch, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // TODO: Get audio data.
            [appDelegate->client write:@"!-1"];
            
        });
    } else {
        [self log:@"Disconnecting from server..."];
        if (appDelegate->client != NULL) {
            [appDelegate->client close];
            appDelegate->client = NULL;
        }
    }
    
}

- (void) log:(NSString*) data {
    data = [data stringByAppendingString:@"\n"];
    
    [self->_console.textStorage.mutableString appendString:data];
    
    [self->_console scrollRangeToVisible:NSMakeRange(self->_console.string.length, 0)];
    
    NSLog(@"%@", data);
}

@end
