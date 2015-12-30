//
//  ModenView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "ModenView.h"

@implementation ModenView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)OnModeBtnDownAction:(UIButton *)sender {
  
   
    switch (sender.tag) {
        case 1:
        {
            NSLog(@"1");
            [[EADSessionController sharedController] sendOutBuf:0x06];
           
            break;
        }
        case 2:
        {
            NSLog(@"2");
            [[EADSessionController sharedController] sendOutBuf:0x07];
            
            break;
        }
        case 3:
        {
            NSLog(@"3");
            [[EADSessionController sharedController] sendOutBuf:0x08];
           
            break;
        }
        case 4:
        {
            NSLog(@"4");
            [[EADSessionController sharedController] sendOutBuf:0x09];
            
            break;
        }
        default:
            break;
    }
    //[[EADSessionController sharedController] sendCommand];
    [self.delegate sendMessageToRoStop];
}
//设置按键的变化
-(void)setBtnSel //通知
{
    
    [self.modeBtn1 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    [self.modeBtn2 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    [self.modeBtn3 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    [self.modeBtn4 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    NSInteger index = [StaticValueClass getModeView];
    switch (index) {
        case 0x01:
        {
            [self.modeBtn1 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        case 0x02:
        {
            [self.modeBtn2 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        case 0x03:
        {
            [self.modeBtn3 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        case 0x04:
        {
            [self.modeBtn4 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    
}
-(void)setLanguage:(NSDictionary *)dic{
    [self.modeBtn1 setTitle:[dic valueForKeyPath:@"mode1"] forState:UIControlStateNormal];
    [self.modeBtn2 setTitle:[dic valueForKeyPath:@"mode2"] forState:UIControlStateNormal];
    [self.modeBtn3 setTitle:[dic valueForKeyPath:@"mode3"] forState:UIControlStateNormal];
    [self.modeBtn4 setTitle:[dic valueForKeyPath:@"mode4"] forState:UIControlStateNormal];

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
