//
//  ManualView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "ManualView.h"

@implementation ManualView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)OnManualBtnAcion:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [[EADSessionController sharedController] sendOutBuf:0x19];
            break;
        }
        case 2:
        {
            [[EADSessionController sharedController] sendOutBuf:0x1a];
            break;
        }
        case 3:
        {
            [[EADSessionController sharedController] sendOutBuf:0x1b];
            break;
        }
        default:
            break;
    }
   // [[EADSessionController sharedController] sendCommand];
    [self.delegate sendMessageToRoStop];
}
//设置按键的变化
-(void)setBtnSel//接收通知
{
   
    [self.firstLabel setTextColor:[UIColor whiteColor]];
    [self.sendLabel setTextColor:[UIColor whiteColor]];
    [self.thirdLabel setTextColor:[UIColor whiteColor]];
    NSInteger index = [StaticValueClass getManualView];
    switch (index) {
        case 0x30:
        {
            [self.firstLabel setTextColor:[UIColor greenColor]];
            break;
        }
        case 0x0c:
        {
            [self.sendLabel setTextColor:[UIColor greenColor]];
            break;
        }
        case 0x03:
        {
            [self.thirdLabel setTextColor:[UIColor greenColor]];
            break;
        }
        default:
            break;
    }
    
}
-(void)setLanguage :(NSDictionary *)dic
{
    [self.firstLabel setAdjustsFontSizeToFitWidth:YES];
    [self.sendLabel setAdjustsFontSizeToFitWidth:YES];
    [self.thirdLabel setAdjustsFontSizeToFitWidth:YES];
    [self.firstLabel setText:[dic valueForKeyPath:@"massageshoulder"]];
    [self.sendLabel setText:[dic valueForKeyPath:@"massageback"]];
    [self.thirdLabel setText:[dic valueForKeyPath:@"massagewaist"]];
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
