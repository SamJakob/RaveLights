//
//  SerialClient.m
//  RaveLights
//
//  Created by Joshua Everett on 14/10/2020.
//

#import <Foundation/Foundation.h>

#include "Client.h"
#include "SerialClient.h"

@implementation SerialClient : Client

-(instancetype) init:(NSString*) _port {
    if (self = [super init]) {
        port = _port;
    }
    
    return self;
}

-(void) start {
    
    self->serialPort = [[ORSSerialPort alloc] initWithPath:[@"/dev/" stringByAppendingString:self->port]];
    [serialPort setBaudRate:@230400];
    [serialPort setDelegate:self];
    
    [serialPort open];
    
    if (self->onAckBlock != NULL)
        self->onAckBlock(69);
    
}

-(void) close {
    
    [serialPort close];
    self->serialPort = NULL;
    
}

-(void) write:(NSString*) data {
    
    NSData* buffer = [data dataUsingEncoding:NSUTF8StringEncoding];
    [serialPort sendData:buffer];
    
}

-(void) writeData:(NSData*) data {
    
    [serialPort sendData:data];
    
}

- (void)serialPort:(ORSSerialPort*) serialPort didEncounterError:(NSError*) error {
    NSLog(@"The serial connection encountered an error: %@", error);
}

// onReceive
- (void)serialPort:(ORSSerialPort*) serialPort didReceiveData:(NSData*) data {
    
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

- (void)serialPortWasRemovedFromSystem:(nonnull ORSSerialPort *)serialPort {
    
    self->serialPort = NULL;
    
}

@end
