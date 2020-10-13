//
//  Client.m
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <Foundation/Foundation.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "Client.h"

@implementation Client : NSObject

-(instancetype) init:(unsigned int) _port {
    return [self init:_port withAddress:@"127.0.0.1"];
}

-(instancetype) init:(unsigned int) _port withAddress:(NSString*) _host {
    if (self = [super init]) {
        host = _host;
        port = _port;
    }
    
    return self;
}

-(void) start {
    
    // Create the socket address object.
    struct sockaddr_in serverAddress;
    memset(&serverAddress, 0, sizeof(serverAddress));
    
    // Populate the socket address.
    serverAddress.sin_family = AF_INET;
    inet_pton(
          AF_INET,
          [self->host cStringUsingEncoding:NSUTF8StringEncoding],
          &serverAddress.sin_addr
    );
    serverAddress.sin_port = htons(self->port);
    
    // Create the socket and connect to the server.
    self->clientFd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    connect(self->clientFd, (struct sockaddr*) &serverAddress, sizeof(serverAddress));
    
    
    // Wait for ACK...
    // (read 3 characters in and ensure they are "ACK")
    char buffer[4];
    read(self->clientFd, buffer, 3);
    buffer[3] = 0;
    
    if (strcmp(buffer, "ACK") == 0) {
        // Read in number of LEDs (66535 seems like a reasonable max).
        uint8_t buffer[2];
        read(self->clientFd, buffer, 2);
        int ledCount = (buffer[0] << 8) + buffer[1];
        
        if (self->onAckBlock != NULL)
            self->onAckBlock(ledCount);
    }
    
}

-(void) write:(NSString*) data {
    
    const char* buffer = [data UTF8String];
    write(self->clientFd, buffer, sizeof(buffer) + 2);
    
}

-(void) setOnAck:(OnAckBlock) callback {
    
    self->onAckBlock = callback;
    
}

-(void) close {
    
    close(self->clientFd);
    
}

@end
