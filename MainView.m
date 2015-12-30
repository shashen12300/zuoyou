//
//  MainView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)OnBtnClick:(UIButton *)sender {
    NSLog(@"tag:%ld",(long)sender.tag);
    switch (sender.tag) {
        case 1:
        {
            [self.delegate showIndexView:1];
            break;
        }
            
        case 2:
        {
             [self.delegate showIndexView:2];
            break;
        }
        case 3:
        {
             [self.delegate showIndexView:3];
            break;
        }
        case 4:
        {
             [self.delegate showIndexView:4];
            break;
        }
        case 5:
        {
             [self.delegate showIndexView:5];
            break;
        }
        case 6:
        {
             [self.delegate showIndexView:6];
            break;
        }
        case 7:
        {
             [self.delegate showIndexView:7];
            break;
        }
        case 8:
        {
             [self.delegate showIndexView:8];
            break;
        }
        case 9:
        {
             [self.delegate showIndexView:9];
            break;
        }
        case 10:
        {
             [self.delegate showIndexView:10];
            break;
        }
        default:
            break;
    }
}
-(void)setLanguage:(NSDictionary *)dic
{
    [self.firstLabel setAdjustsFontSizeToFitWidth:YES];
    [self.secondLabel setAdjustsFontSizeToFitWidth:YES];
    [self.thirdLabel setAdjustsFontSizeToFitWidth:YES];
    [self.forthLabel setAdjustsFontSizeToFitWidth:YES];
    [self.fiveLabel setAdjustsFontSizeToFitWidth:YES];
    [self.sixLabel setAdjustsFontSizeToFitWidth:YES];
    [self.sevenLabel setAdjustsFontSizeToFitWidth:YES];
    [self.eightLabel setAdjustsFontSizeToFitWidth:YES];
    [self.nineLabel setAdjustsFontSizeToFitWidth:YES];
    [self.tenLabel setAdjustsFontSizeToFitWidth:YES];
    [self.firstLabel setText:[dic valueForKey:@"automaticmode"] ];//设置强度
    [self.secondLabel setText:[dic valueForKey:@"manualmode "] ];//设置强度
    [self.thirdLabel setText:[dic valueForKey:@"frequency"] ];//设置强度
    [self.forthLabel setText:[dic valueForKey:@"music"] ];//设置强度
    [self.fiveLabel setText:[dic valueForKey:@"heating"] ];//设置强度
    [self.sixLabel setText:[dic valueForKey:@"mode"] ];//设置强度
    [self.sevenLabel setText:[dic valueForKey:@"time"] ];//设置强度
    [self.eightLabel setText:[dic valueForKey:@"strength"] ];//设置强度
    [self.nineLabel setText:[dic valueForKey:@"backajust"] ];//设置强度
    [self.tenLabel setText:[dic valueForKey:@"setting"] ];//设置强度
}
-(void)OnPowerBtnClick
{
    NSLog(@"clicked");
    NSInteger index = [StaticValueClass getStartBtnState];
    if (index == 1) {
        [self.mytimerStop setFireDate:[NSDate distantPast]];
        [StaticValueClass StartBtnState:0];
        [self.firstBtn setEnabled:NO];
        [self.secondBtn setEnabled:NO];
        [self.thirdBtn setEnabled:NO];
        [self.forthBtn setEnabled:NO];
        [self.fithBtn setEnabled:NO];
        [self.sixBtn setEnabled:NO];
        [self.sevenBtn setEnabled:NO];
        [self.eigthBtn setEnabled:NO];
        [self.delegate showIndexView:0];
        [self.musicView.player stop];
    }
    else
    {
        [StaticValueClass StartBtnState:1];
        [self.firstBtn setEnabled:YES];
        [self.secondBtn setEnabled:YES];
        [self.thirdBtn setEnabled:YES];
        [self.forthBtn setEnabled:YES];
        [self.fithBtn setEnabled:YES];
        [self.sixBtn setEnabled:YES];
        [self.sevenBtn setEnabled:YES];
        [self.eigthBtn setEnabled:YES];
    }
}
-(void)initCurrentStatus
{
    [StaticValueClass StartBtnState:0];
    [self.firstBtn setEnabled:NO];
    [self.secondBtn setEnabled:NO];
    [self.thirdBtn setEnabled:NO];
    [self.forthBtn setEnabled:NO];
    [self.fithBtn setEnabled:NO];
    [self.sixBtn setEnabled:NO];
    [self.sevenBtn setEnabled:NO];
    [self.eigthBtn setEnabled:NO];
    
    self.mytimerStop = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(sendMessageToRoStop) userInfo:nil repeats:YES];
    [self.mytimerStop setFireDate:[NSDate distantFuture]];
}
-(void)sendMessageToRoStop
{
    static NSInteger myTimer = 0;
    myTimer ++;
    if (myTimer > 4) {
        [self.mytimerStop setFireDate:[NSDate distantFuture]];
        myTimer = 0;
    }
    [[EADSessionController sharedController] sendOutBuf:0x02];
    [[EADSessionController sharedController] sendCommand];
    NSLog(@"stop======");
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
