//
//  AutoView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "AutoView.h"

@implementation AutoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)OnBtnClick:(UIButton *)sender {
    NSLog(@"AutoViewClick!");
    if ([StaticValueClass getAutoView] == 0) {
        [[EADSessionController sharedController] sendOutBuf:0x22];
    }
    else if([StaticValueClass getAutoView] == 1)
    {
        [[EADSessionController sharedController] sendOutBuf:0x01];
    }
    
   // [[EADSessionController sharedController] sendCommand];
    [self.delegate sendMessageToRoStop];
}
-(void)setBtnActionForAnimation//接收通知
{
    
    NSInteger flag = [StaticValueClass getAutoView];
    switch (flag) {
        case 0:
        {
            if (self.backImgView.isAnimating == NO) {
                return;
            }
            [self.backImgView stopAnimating];
            break;
        }
        case 1:
        {
            if (self.backImgView.isAnimating == YES) {
                return;
            }
            NSMutableArray *imagViewArray=[[NSMutableArray alloc] init];
            NSArray *array = [[NSArray alloc] initWithObjects:@"manual1",@"manual2",@"manual3", nil];
            for (NSString *img in array) {
                [imagViewArray addObject:PNGIMAGE(img)];
                
            }
            self.backImgView.animationImages = imagViewArray;
            self.backImgView.animationDuration = 3;
            [self.backImgView startAnimating];
            break;
        }
        default:
            break;
    }
}
-(void)initWithAutoView
{
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(sendMessageToRoStop) userInfo:nil repeats:YES];
    [self.mytimer setFireDate:[NSDate distantFuture]];
    self.myTimer = 0;
}
-(void)stopMessageToMCUFiveTimes
{
    [self.mytimer setFireDate:[NSDate distantFuture]];
    self.myTimer=0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
