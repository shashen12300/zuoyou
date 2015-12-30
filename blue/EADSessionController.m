/*
 
     File: EADSessionController.m
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

#import "EADSessionController.h"
#import "common.h"

#define MAX_SYSC_DATA_NUM 32


NSString *EADSessionDataReceivedNotification = @"EADSessionDataReceivedNotification";

@implementation EADSessionController

//@synthesize accessory = _accessory;
//@synthesize protocolString = _protocolString;

@synthesize isConnected;
@synthesize isConnecting;
//@synthesize inData;
@synthesize powerStatus;
@synthesize isPaused;
@synthesize massageMode;
@synthesize uppperIntensity;
@synthesize handSpeed;
@synthesize handWidth;
@synthesize armPressureStatus;
@synthesize lowerPressureStatus;
@synthesize armPressureIntensity;
@synthesize lowerPressureIntensity;
@synthesize footRollerSpeed;
@synthesize footStretchStatus;
@synthesize otherFootRollerStatus;
@synthesize otherBackHeartStatus;
@synthesize theTimes;


#pragma mark Internal



#pragma mark Public Methods

+ (EADSessionController *)sharedController
{
    static EADSessionController *sessionController = nil;
    if (sessionController == nil) {
        sessionController = [[EADSessionController alloc] init];
        sessionController.isConnected = false;
        
        
        //application method
        //[sessionController initAccessoryData];
        [sessionController initApplicationData];
        //[sessionController initTimer];
        
     [sessionController initBLE];
        //[self performSelector:@selector(initBLE) withObject:sessionController afterDelay:5];

    }

    return sessionController;
}
//这个方法被sharecontroller调用了
- (void) initBLE
{
    socketDelegates=[[NSMutableSet alloc] init];
    _readData = [[NSMutableData alloc] init];
    bleSocketClient=[[BLESocketClientImpl alloc] init:@"FFE0" notifyCharacteristicUUID:@"FFE1" writeCharacteristicUUID:@"FFE2"];
    [bleSocketClient addDelegate:self];
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [bleSocketClient addDelegate:dele];
    }
    
    [bleSocketClient open];
    isConnecting= true;
    isConnected= false;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reConnnectSocket) name:@"RECONNECT" object:nil];
}
-(void)reConnnectSocket
{
    if (bleSocketClient != nil) {
        [bleSocketClient close];
    }
    
   
    bleSocketClient=[[BLESocketClientImpl alloc] init:@"FFE0" notifyCharacteristicUUID:@"FFE1" writeCharacteristicUUID:@"FFE2"];
    [bleSocketClient addDelegate:self];
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [bleSocketClient addDelegate:dele];
    }
    
    [bleSocketClient open];
    isConnecting= true;
    isConnected= false;
}


-(BLESocketClientImpl *)getBleSocketClient
{
    return bleSocketClient;
}

// high level read method 
- (NSData *)readData:(NSUInteger)bytesToRead
{
    NSData *data;
    @synchronized(_readData){
    if ([_readData length] >= bytesToRead) {
        NSRange range = NSMakeRange(0, bytesToRead);
        data = [_readData subdataWithRange:range];
        [_readData replaceBytesInRange:range withBytes:NULL length:0];
    }
    }
    return data;
}

// get number of bytes read into local buffer
- (NSUInteger)readBytesAvailable
{
    return [_readData length];
}

#pragma mark EAAccessoryDelegate
#pragma mark NSStreamDelegateEventExtensions



#pragma mark Application command method
//将缓存清空，在每次调用到sendCallCommand,sendOutBuf的时候会调用到
-(void) resetOutBuffer
{
    for (int i=0; i<10; i++) {
		outBuf[i]=0;
	}
}


-(void) sendCallCommand:(int) index {
    [self resetOutBuffer];
    switch (index) {
        case 0x01:  //接听
            outBuf[4] = 'C';
            outBuf[5] = 'E';
            break;
        case 0x02:  //拒接
            outBuf[4] = 'C';
            outBuf[5] = 'F';
            break;
        case 0x03:  //Vol up
            outBuf[4] = 'C';
            outBuf[5] = 'K';
            break;
        case 0x04:  //Vol down
            outBuf[4] = 'C';
            outBuf[5] = 'L';
            break;
 
        default:
            break;
    }
    
    outBuf[0] = 'A';
    outBuf[1] = 'T';
    outBuf[2] = '#';
    outBuf[3] = 'T';
    outBuf[6] = 'T' + outBuf[4] + outBuf[5];
//    outBuf[7] = '\r';
//    outBuf[8] = '\n';
}

-(void)sendOutBuf:(int)index{
    
    [self resetOutBuffer];
    
    switch (index) {
        case 0x00:
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0xaa;
            break;
        }
        case 0x01:  //DATA0  手动
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0xaa;
            break;
        }
        case 0x02:  //DATA0  关
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0x00;
            break;
        }
        case 0x22: //自动
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0xa5;
            break;
        }
        case 0x03:  //DATA1  加热和常温  开
        {
            outBuf[3] = 0x02;
            outBuf[4] = 0xA5;
            
            break;
        }
        case 0x04:  //DATA1  加热和常温关
        {
            outBuf[3] = 0x02;
            outBuf[4] = 0x00;
            break;
        }
        case 0x05:  //DATA2  关 模式
        {
            outBuf[3] = 0x03;
            outBuf[4] = 0x00;
            break;
        }
        case 0x06:  //DATA2  模式一
        {
            outBuf[3] = 0x03;
            outBuf[4] = 0x01;
            break;
        }
        case 0x07:  //DATA2  二
        {
            outBuf[3] = 0x03;
            outBuf[4] = 0x02;
            break;
        }
        case 0x08:  //DATA2  三
        {
            outBuf[3] = 0x03;
            outBuf[4] = 0x03;
            break;
        }
        case 0x09:  //DATA2  四
        {
            outBuf[3] = 0x03;
            outBuf[4] = 0x04;
            break;
        }
        case 0x0a:  //DATA3  强度 关
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x00;
            break;
        }
        case 0x0b:  //DATA3  一档
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x01;
            break;
        }
        case 0x0c:  //DATA3  二档
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x02;
            break;
        }
        case 0x0d:  //DATA3  三档
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x03;
            break;
        }
        case 0x0e:  //DATA3  四档
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x04;
            break;
        }
        case 0x0f:  //DATA3  五档
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x05;
            break;
        }
        case 0x10:  //DATA3  六档
        {
            outBuf[3] = 0x04;
            outBuf[4] = 0x06;
            break;
        }
        case 0x11:  //DATA4  速度 关
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x00;
            break;
        }
        case 0x12:  //DATA4  一档
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x01;
            break;
        }
        case 0x13:  //DATA4  二档
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x02;
            break;
        }
        case 0x14:  //DATA4  三档
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x03;
            break;
        }
        case 0x15:  //DATA4  四档
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x04;
            break;
        }
        case 0x16:  //DATA4  五档
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x05;
            break;
        }
        case 0x17:  //DATA4  六档
        {
            outBuf[3] = 0x05;
            outBuf[4] = 0x06;
            break;
        }
        case 0x18:  //DATA5  关
        {
            outBuf[3] = 0x06;
            outBuf[4] = 0x00;
            break;
        }
        case 0x19:  //DATA5  颈部
        {
            outBuf[3] = 0x06;
            outBuf[4] = 0x30;
            break;
        }
        case 0x1a:  //DATA5  背部
        {
            outBuf[3] = 0x06;
            outBuf[4] = 0x0c;
            break;
        }
        case 0x1b:  //DATA5  腰部
        {
            outBuf[3] = 0x06;
            outBuf[4] = 0x03;
            break;
        }
        case 0x1c:  //DATA6  推杆状态
        {
            outBuf[3] = 0x07;
            outBuf[4] = 0x00;
            break;
        }
        case 0x1d:  //DATA7  背靠升
        {
            outBuf[3] = 0x07;
            outBuf[4] = 0x01;
            break;
        }
        case 0x1e:  //DATA7  背靠降
        {
            outBuf[3] = 0x07;
            outBuf[4] = 0x02;
            break;
        }
        case 0x1f:  //DATA7  停止
        {
            outBuf[3] = 0x07;
            outBuf[4] = 0x00;
            break;
        }
            //        case 0x20:  //DATA6  脚部降
            //        {
            //            outBuf[3] = 0x07;
            //            outBuf[4] = 0x04;
            //            break;
            //        }
        case 0x21: //查询
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0x55;
        }
        case 0x23: //应答指令  正确
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0x55;
            break;
        }
        case 0x24://应答指令  错误
        {
            outBuf[3] = 0x01;
            outBuf[4] = 0x50;
        }
            
        default:
            break;
    }
    
    outBuf[0] = 0xff;
    outBuf[1] = 0x86;
    outBuf[2] = 0x04;
    outBuf[5] = outBuf[2] + outBuf[3] + outBuf[4];
    
}
-(void)sendOutBufForMin:(int)min
{
    outBuf[0] = 0xff;
    outBuf[1] = 0x86;
    outBuf[2] = 0x04;
    outBuf[3] = 0x08;
    outBuf[4] = min;
    outBuf[5] = outBuf[2] + outBuf[3] + outBuf[4];
}
//发送命令的
- (void) sendCommand
{
    //NSInteger res = [_session.outputStream write:outBuf maxLength:20];
    //NSLog(@"res ");
    
    if(bleSocketClient!=nil&&bleSocketClient.state==SocketStateConnected){
        NSData *data=[[NSData alloc] initWithBytes:outBuf length:6];
        [bleSocketClient send:data];
    }
}


- (void) initApplicationData
{
    powerStatus = FALSE; //initial power off
    isPaused = FALSE;
    massageMode = 0; //default manual;
    
    uppperIntensity = 0;
    handSpeed = 0;
    handWidth = 0;
    armPressureStatus = FALSE;
    armPressureIntensity = 0;
    lowerPressureStatus = 0;
    lowerPressureIntensity = 0;
    footRollerSpeed = 0;
    footStretchStatus = FALSE;
    otherFootRollerStatus = FALSE;
    otherBackHeartStatus = TRUE;
    
}




 //*/

//这里是将每个界面都添加到delegate的数组中，然后通过便利将有添加的对象一一取出来，然后将在接口上接收到的消息在通过代理的方式
//发送到每个“委托”的函数中
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


- (void)socketConnected
{
    isConnecting=false;
    isConnected=true;
   //   [[NSNotificationCenter defaultCenter] postNotificationName:ISCONNECTED object:self userInfo:nil];
   // [self sendOutBuf:0x31];
    //[self sendCommand];
}

- (void)socketError:(NSString*)message
{


}

- (void)socketClosed
{
    //对socketClient对象进行初始化
    bleSocketClient=[[BLESocketClientImpl alloc] init:@"FFE0" notifyCharacteristicUUID:@"FFE1" writeCharacteristicUUID:@"FFE2"];
    [bleSocketClient addDelegate:self];
    
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [bleSocketClient addDelegate:dele];
    }
    isConnecting= true;
    isConnected=false;
    [[NSNotificationCenter defaultCenter] postNotificationName:MISSCONNNECTED object:self userInfo:nil];
    [bleSocketClient open];
    
}
//在这里会将数据发送给委托的类里，当前我正在操作的类是ServiceViewController   2014/02/27 阿任修改了这段代码
- (void)socketReceived:(NSData*) data
{

    @synchronized(_readData){
    [_readData appendData:data];
    }
    [self performSelectorOnMainThread:@selector(received:) withObject:data waitUntilDone:NO];
    NSLog(@"received: %@", [self hexStringFromNSData: data]);
}

- (void)received:(NSData *)data {
  //  NSLog(@"data %@",data);
    //这个通知由谁来接收
    [[NSNotificationCenter defaultCenter] postNotificationName:EADSessionDataReceivedNotification object:self userInfo:nil];
    //修改后被添加上的
    NSArray *list=[socketDelegates allObjects];
    for(id<SocketDelegate> dele in list){
        [dele socketReceived:data];
    }
}

- (NSString *)hexStringFromNSData:(NSData *)data {
    
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@ ",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@ ",hexStr,newHexStr];
    } 
    return hexStr; 
}

- (void) update:(NSData*)data {
    if(bleSocketClient!=nil&&bleSocketClient.state==SocketStateConnected){
      //  [bleSocketClient send:data];
        [self sendMessageBy102:data];
        NSLog(@"send: %@", [self hexStringFromNSData: data]);
    }
}
-(void)sendMessageBy102:(NSData *)data
{
    NSLog(@"file length: %lu", (unsigned long)data.length);
    NSRange range ;
    
    range.length = 102;
    int times = data.length/102;
    int shengxia = data.length%102;
    if (data.length%102 > 0) {
        times++;
    }
    for (int i = 0; i<times; i++) {
        //        - (NSData *)subdataWithRange:(NSRange)range;
        range.location = i*102;
        if ((shengxia != 0) && (times == (i+1))) {
            range.length = shengxia;
        }
        [bleSocketClient send: [data subdataWithRange:range]];
        NSLog(@"send: %@", [self hexStringFromNSData: [data subdataWithRange:range]]);
    }
}

@end
