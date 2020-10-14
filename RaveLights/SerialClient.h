//
//  SerialClient.h
//  RaveLights
//
//  Created by Joshua Everett on 14/10/2020.
//

#ifndef SerialClient_h
#define SerialClient_h

#import "ORSSerialPort.h"
#import "ORSSerialPortManager.h"

@interface SerialClient : Client<ORSSerialPortDelegate> {
    
    @private
        /// The serial socket port.
        NSString* port;
    
        /// The ORSSerialPort object.
        ORSSerialPort* serialPort;
    
};

-(instancetype) init:(NSString*) _port;

-(void) start;
-(void) close;

-(void) write:(NSString*) data;

@end

#endif /* SerialClient_h */
