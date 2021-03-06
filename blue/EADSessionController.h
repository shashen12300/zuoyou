/*
 
     File: EADSessionController.h
 Abstract: n/a
  Version: 1.1
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2010 Apple Inc. All Rights Reserved.
 
 
 */

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "SocketClient.h"
#import "BLESocketClientImpl.h"
#define ISCONNECTED  @"isConnectedMsg"
#define MISSCONNNECTED @"missConnectedMsg"
extern NSString *EADSessionDataReceivedNotification;

// NOTE: EADSessionController is not threadsafe, calling methods from different threads will lead to unpredictable results
@interface EADSessionController : NSObject < NSStreamDelegate, SocketDelegate> {
    //EAAccessory *_accessory;
    //EASession *_session;
    //NSString *_protocolString;

    //NSMutableData *_writeData;
    NSMutableData *_readData;
    
    BOOL isConnected;
    //BOOL isSyncDone;
    
    BOOL isConnecting;
    
   
    uint8_t outBuf[7];
    //NSData *inData;
        
    //NSTimer *accessoryTimer;
    //NSArray *myAccessoryArray;
    //BOOL newAccessory;//新会话标识符
    
    //Application Data

    BOOL powerStatus;
    BOOL isPaused;
    uint8_t massageMode; // auto / manual
    uint8_t uppperIntensity;
    uint8_t handSpeed;
    uint8_t handWidth;
    BOOL armPressureStatus;
    uint8_t armPressureIntensity;
    uint8_t lowerPressureStatus;
    uint8_t lowerPressureIntensity;
    uint8_t footRollerSpeed;
    BOOL footStretchStatus;
    BOOL otherFootRollerStatus;
    BOOL otherBackHeartStatus;
    
    
    BLESocketClientImpl *bleSocketClient;
    NSMutableSet            *socketDelegates;
    
    @public
    uint8_t copyoutBuf[2];
}


@property (nonatomic, readonly) EAAccessory *accessory;
@property (nonatomic, readonly) NSString *protocolString;
@property (nonatomic, strong) NSData *inData;
@property (assign) BOOL isConnected;
@property (assign) BOOL isConnecting;

//App data
@property (assign) BOOL powerStatus;
@property (assign) BOOL isPaused;
@property (assign) uint8_t massageMode;
@property (assign) uint8_t uppperIntensity;
@property (assign) uint8_t handSpeed;
@property (assign) uint8_t handWidth;
@property (assign) BOOL armPressureStatus;
@property (assign) uint8_t armPressureIntensity;
@property (assign) uint8_t lowerPressureStatus;
@property (assign) uint8_t lowerPressureIntensity;
@property (assign) uint8_t footRollerSpeed;
@property (assign) BOOL     footStretchStatus;
@property (assign) BOOL otherFootRollerStatus;
@property (assign) BOOL otherBackHeartStatus;
@property (nonatomic, assign) NSInteger theTimes;;





+ (EADSessionController *)sharedController;
-(BLESocketClientImpl *)getBleSocketClient;
//- (void)setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString;

//- (void)openSession;
//- (void)closeSession;
//- (void)startSession;

//- (void)writeData:(NSData *)data;
//- (uint8_t*)getData;

- (NSUInteger)readBytesAvailable;
- (NSData *)readData:(NSUInteger)bytesToRead;

//Application data access method
//- (void) initAccessoryData;
//- (void) initApplicationData;
//- (void) initTimer;
//- (void) checkAccessory;


//- (void) appDataSync;
- (void) resetOutBuffer;
- (void) sendOutBuf:(int)index;
- (void) sendCommand;
- (void) sendCallCommand:(int) index ;
- (void) update:(NSData*)data;
-(void)sendOutBufForMin:(int)min;



- (void)addDelegate:(id<SocketDelegate>) delegate;

- (void)removeDelegate:(id<SocketDelegate>) delegate;

@end
