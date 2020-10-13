//
//  ViewController.m
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import "ViewController.h"

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
    
    __block ViewController* this = self;
    BOOL isConnecting = sender.state == NSControlStateValueOn;
    
    if (isConnecting) {
        for (int i = 0; i < 10; i++)
            [self log:@""];
        
        [self log:@"Connecting to server..."];
        
        client = [[Client alloc] init:self->_port.intValue withAddress:self->_hostname.stringValue];
        
        [client setOnAck:^(int ledCount){
            
            [this log:[@"Hostname: " stringByAppendingString:this->_hostname.stringValue]];
            [this log:[@"Port: " stringByAppendingString:this->_port.stringValue]];
            
            [this log:@"Connection is ready!"];
            [this log:[NSString stringWithFormat:@"Controller reports a %d led array.", ledCount]];
        }];
        
        [client start];
        [client write:@"$HANDSHAKE"];
        
        dispatch_group_t lightDispatch = dispatch_group_create();
        dispatch_group_async(lightDispatch, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            // TODO: Get audio data.
            [self->client write:@"!255"];
            
        });
    } else {
        [self log:@"Disconnecting from server..."];
        if (client != NULL) {
            [client close];
            client = NULL;
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
