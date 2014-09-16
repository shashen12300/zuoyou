 //
//  BLEConnection.m
//  BTLE Transfer
//
//  Created by microe on 11/2/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "BLESocketClientImpl.h"
//http://blog.csdn.net/dwarven/article/details/37873777
@interface BLESocketClientImpl()<CBCentralManagerDelegate, CBPeripheralDelegate>
{
    NSString                *serviceUUID;
    NSString                *notifyCharacteristicUUID;
    NSString                *writeCharacteristicUUID;
    
    BOOL notifyCharacteristicReady,writeCharacteristicReady;
    
    NSMutableSet            *socketDelegates;
    dispatch_queue_t centralQueue;
}

@property (nonatomic, strong) CBCentralManager        *centralManager;
@property (strong) CBPeripheral        *discoveredPeripheral;
@property (nonatomic, strong) CBCharacteristic        *writeCharacteristic;

@end

@implementation BLESocketClientImpl

@synthesize state=_state;

#pragma mark  override

- (id)init:(NSString*)sUUID notifyCharacteristicUUID:(NSString*)notifyUUID writeCharacteristicUUID:(NSString*)writeUUID
{
    self = [super init];
    if (self) {
        serviceUUID=sUUID;
        notifyCharacteristicUUID=notifyUUID;
        writeCharacteristicUUID=writeUUID;
        
        socketDelegates=[[NSMutableSet alloc] init];
        _state=SocketStateUnkown;
    }
    return self;
}

- (void)dealloc
{
    [self close];
    //[super dealloc];
}

#pragma mark public

- (void)addDelegate:(id<SocketDelegate>) delegate
{
    [socketDelegates addObject:delegate];
}

- (void)removeDelegate:(id<SocketDelegate>) delegate
{
    if([socketDelegates containsObject:delegate]){
        [socketDelegates removeObject:delegate];
    }
}

- (void) open
{
    if(_state==SocketStateUnkown){
        
        _state=SocketStateConnecting;
        centralQueue = dispatch_queue_create("cn.com.microe", DISPATCH_QUEUE_SERIAL);// or however you want to create your dispatch_queue_t

        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    }
}

- (void)close
{
    _state=SocketStateClosing;
    [self cleanup];
    [socketDelegates removeAllObjects];
    _state=SocketStateClosed;
    
    [self didClosed];
}

- (void)send:(NSData*) data
{
    if(_state==SocketStateConnected){
        if(_writeCharacteristic==nil){
            for (CBService *ss in _discoveredPeripheral.services){
                NSLog(@"Service UUID: %@", ss.UUID);
                for (CBCharacteristic *cc in ss.characteristics) {
                    NSLog(@"Characteristic UUID: %@", cc.UUID);
                    if([cc.UUID isEqual:[CBUUID UUIDWithString:writeCharacteristicUUID]]){
                        _writeCharacteristic=cc;
                    }
                }
            }
        }
    
        [_discoveredPeripheral writeValue:data forCharacteristic:_writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
}

#pragma mark  internal


- (void) didError:(NSString*)message
{
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [dele socketError:message];
    }
}

- (void) didReceived: (NSData*) data
{
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [dele socketReceived:data];
    }
}

- (void) didConnected
{
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [dele socketConnected];
    }
}

- (void) didClosed
{
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [dele socketClosed];
    }
}

#pragma mark ble connect


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    [self scan];
    
}


- (void)scan
{
    [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:serviceUUID]]
                                                options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    NSLog(@"Scanning started");
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (RSSI.integerValue > -15) {
        return;
    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    if([peripheral.name hasPrefix:@"Fihonest"]){
        
        [_centralManager stopScan];
    
        if (_discoveredPeripheral != peripheral) {
            
            _discoveredPeripheral = peripheral;
            
            NSLog(@"Connecting to peripheral %@", peripheral);
            [_centralManager connectPeripheral:_discoveredPeripheral options:nil];
            
        }
        
    }
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSString* log=[NSString stringWithFormat:@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]];
    NSLog(@"Error: %@",log);
    [self didError:log];
    [self close];
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    [_centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:@[[CBUUID UUIDWithString:serviceUUID]]];
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSString *log=[NSString stringWithFormat:@"Error discovering services: %@", [error localizedDescription]];
        NSLog(@"Error: %@",log);
        [self didError:log];
        [self close];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:notifyCharacteristicUUID]] forService:service];
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:writeCharacteristicUUID]] forService:service];
    }
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSString *log=[NSString stringWithFormat:@"Error discovering characteristics: %@", [error localizedDescription]];
        NSLog(@"Error: %@",log);
        [self close];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
    
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:notifyCharacteristicUUID]]) {
            
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            notifyCharacteristicReady=true;
        }
        
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:writeCharacteristicUUID]]){
            writeCharacteristicReady=true;
        }
        
    }
    
    if(notifyCharacteristicReady&&writeCharacteristicReady&&_state==SocketStateConnecting){
        _state=SocketStateConnected;
        [self didConnected];
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    //NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    [self didReceived:characteristic.value];
    
    //NSLog(@"Received: %@", stringFromData);
    
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:notifyCharacteristicUUID]]) {
        return;
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    else {
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [_centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RECONNECT" object:nil];
     _discoveredPeripheral = nil;
}


- (void)cleanup
{
    if (!_discoveredPeripheral.isConnected) {
        return;
    }
    
    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:notifyCharacteristicUUID]]) {
                        if (characteristic.isNotifying) {
                            [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            
                            return;
                        }
                    }
                }
            }
        }
    }
    
    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
}


@end
