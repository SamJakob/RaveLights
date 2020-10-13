//
//  Client.h
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#ifndef Client_h
#define Client_h

typedef void (^OnAckBlock)(int);

@interface Client : NSObject {
    
    @private
        /// The hostname the client should connect to.
        NSString* host;
    
        /// The port number the client should connect to.
        unsigned int port;
    
        /// The POSIX file descriptor for the socket.
        int clientFd;
    
        /// The callback to execute when the connection
        /// is acknowledged by the server.
        OnAckBlock onAckBlock;
    
};

-(instancetype) init:(unsigned int) _port;
-(instancetype) init:(unsigned int) _port withAddress:(NSString*) _host;

-(void) start;
-(void) close;

-(void) setOnAck:(OnAckBlock) callback;
-(void) write:(NSString*) data;

@end

#endif /* Client_h */
