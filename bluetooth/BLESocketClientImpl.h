//
//  BLEConnection.h
//  BTLE Transfer
//
//  Created by microe on 11/2/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "SocketClient.h"

@interface BLESocketClientImpl : SocketClient

- (id)init:(NSString*)serviceUUID notifyCharacteristicUUID:(NSString*)notifyUUID writeCharacteristicUUID:(NSString*)writeUUID;

@end
