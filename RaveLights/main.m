//
//  main.m
//  RaveLights
//
//  Created by Sam Mearns on 10/12/20.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        // dispatch_group_t permission = dispatch_group_create();
        // dispatch_group_enter(permission);
        
        NSLog(@"Requesting authorization for audio capture...");
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            NSLog(@"Granted!");
        }];
        
        /*__block BOOL authorizationGranted = FALSE;
        
        switch([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
                case AVAuthorizationStatusAuthorized:
                    NSLog(@"Authorization granted... Proceeding.");
                    authorizationGranted = TRUE;
                    dispatch_group_leave(permission);
                    break;
                
                case AVAuthorizationStatusNotDetermined:
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                        if (granted) {
                            NSLog(@"Authorization granted... Proceeding.");
                            authorizationGranted = TRUE;
                        }
                        else {
                            NSLog(@"ERROR: Authorization not granted! Halting.");
                        }
                    }];
            
                    dispatch_group_leave(permission);
                    break;
            
                case AVAuthorizationStatusDenied:
                case AVAuthorizationStatusRestricted:
                    NSLog(@"ERROR: Authorization must be granted for audio capture..");
                    dispatch_group_leave(permission);
                    break;
        }
        
        dispatch_group_wait(permission, DISPATCH_TIME_FOREVER);
        if (!authorizationGranted) {
            return -1;
        }*/
    }
    
    return NSApplicationMain(argc, argv);
    
}
