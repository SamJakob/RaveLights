//
//  Client.h
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#ifndef TCPClient_h
#define TCPClient_h

@interface TCPClient : Client {
    
    @private
        /// The hostname the client should connect to.
        NSString* host;
    
        /// The port number the client should connect to.
        unsigned int port;
    
        /// The POSIX file descriptor for the socket.
        int clientFd;
    
};

-(instancetype) init:(unsigned int) _port;
-(instancetype) init:(unsigned int) _port withAddress:(NSString*) _host;

-(void) start;
-(void) close;

-(void) write:(NSString*) data;

@end

#endif /* Client_h */
