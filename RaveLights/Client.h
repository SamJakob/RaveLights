//
//  Client.h
//  RaveLights
//
//  Created by Joshua Everett on 14/10/2020.
//

#ifndef Client_h
#define Client_h

typedef void (^OnAckBlock)(int);

@interface Client : NSObject {
    
    @package
        /// The callback to execute when the connection
        /// is acknowledged by the server.
        OnAckBlock onAckBlock;
    
};

-(void) start;
-(void) close;

-(void) setOnAck:(OnAckBlock) callback;
-(void) write:(NSString*) data;
-(void) writeData:(NSData*) data;

@end

#endif /* Client_h */
