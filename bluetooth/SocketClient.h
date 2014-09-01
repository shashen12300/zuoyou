//
//  Socket.h
//  MassageChair
//
//  Created by microe on 6/12/12.
//  Copyright (c) 2012 microe. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SocketState:NSUInteger{
    /**
     * 连接尚未确定
     */
    SocketStateUnkown,
    
    /**
     * 正尝试连接
     */
    SocketStateConnecting,
    
    /**
     * 建立Socket连接，并且可以进行通信。
     */
    SocketStateConnected,
    
    /**
     * 正尝试关闭连接
     */
    SocketStateClosing,
    
    /**
     * 连接已经关闭或不能被打开。
     */
    SocketStateClosed
    
} SocketState;

@protocol SocketDelegate <NSObject>

- (void)socketConnected;

- (void)socketError:(NSString*)message;

- (void)socketClosed;

- (void)socketReceived:(NSData*) data;

@end

@interface SocketClient:NSObject

@property (readonly, atomic, assign) SocketState state;

- (void)addDelegate:(id<SocketDelegate>) delegate;

- (void)removeDelegate:(id<SocketDelegate>) delegate;

- (void)open;

- (void)close;

- (void)send:(NSData*) data;

@end

