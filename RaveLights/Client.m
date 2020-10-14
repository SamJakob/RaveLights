//
//  Client.m
//  RaveLights
//
//  Created by Joshua Everett on 14/10/2020.
//

#import <Foundation/Foundation.h>
#import "Client.h"

@implementation Client : NSObject

-(void) setOnAck:(OnAckBlock) callback {
    self->onAckBlock = callback;
}

@end
