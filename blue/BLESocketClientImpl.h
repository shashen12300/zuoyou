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
#define MESSAGEFORLIST  @"MESSEGEFORLIST"

@interface BLESocketClientImpl : SocketClient
@property(nonatomic,strong)NSMutableArray *mPeripheralArray;
- (id)init:(NSString*)serviceUUID notifyCharacteristicUUID:(NSString*)notifyUUID writeCharacteristicUUID:(NSString*)writeUUID;
-(void)ConnectPeripheralMsg:(CBPeripheral *)peripheral;
@end
