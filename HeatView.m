//
//  HeatView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "HeatView.h"

@implementation HeatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)heatBtnaction:(UIButton *)sender {
    // [self.mytimer setFireDate:[NSDate distantPast]];
    NSInteger index = [StaticValueClass getHeatingView];
    switch (index) {
        case 0xa5:
        {
            [[EADSessionController sharedController] sendOutBuf:0x04];
         //  [self.mytimer setFireDate:[NSDate distantPast]];
            break;
        }
        default:
        {
            [[EADSessionController sharedController] sendOutBuf:0x03];
            // [self.mytimer setFireDate:[NSDate distantPast]];
            break;
        }
            
    }
    [self.delegate sendMessageToRoStop];
  
}
-(void)setHeatState//接收通知
{
    //[self stopMessageToMCUFiveTimes];
    NSInteger index = [StaticValueClass getHeatingView];
    switch (index) {
        case 0:
        {
           // [self.heatBtn setImage:PNGIMAGE(@"heat1") forState:UIControlStateNormal];
            [self.heatBtn setSelected:NO];
            break;
        }
        case 0xa5:
        {
           // [self.heatBtn setImage:PNGIMAGE(@"heat2") forState:UIControlStateNormal];
            [self.heatBtn setSelected:YES];
            break;
        }
        default:
            break;
    }
}
-(void)initHeatView
{
//    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(sendMessageToRoStop) userInfo:nil repeats:YES];
//    [self.mytimer setFireDate:[NSDate distantFuture]];
//    self.myTimer = 0;
}
//-(void)sendMessageToRoStop
//{
//    self.myTimer ++;
//    if (self.myTimer > 5) {
//        [self.mytimer setFireDate:[NSDate distantFuture]];
//        self.myTimer = 0;
//    }
//    [[EADSessionController sharedController] sendCommand];
//}
//-(void)stopMessageToMCUFiveTimes
//{
//    [self.mytimer setFireDate:[NSDate distantFuture]];
//    self.myTimer=0;
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
