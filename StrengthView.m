//
//  StrengthView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "StrengthView.h"

@implementation StrengthView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setImageWithStrength//用来接收一下通知
{
    NSString *str = [ NSString stringWithFormat:@"strength%ld",(long)[StaticValueClass getstrengthView]];
    [self.strengthImageView setImage:PNGIMAGE(str)];
}
- (IBAction)OnSubBtnAction:(id)sender {
    //  [self.mytimer setFireDate:[NSDate distantPast]];
 
    NSInteger index = [StaticValueClass getstrengthView];
    if (index>0) {
        index--;
        [self indexForSwich:index];
    }
   
}
- (IBAction)OnAddBtnAction:(id)sender {
    // [self.mytimer setFireDate:[NSDate distantPast]];
    
    NSInteger index = [StaticValueClass getstrengthView];
    if (index < 6) {
        index++;
        [self indexForSwich:index];
    }
    
}
-(void)indexForSwich:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            NSLog(@"1");
            [[EADSessionController sharedController] sendOutBuf:0x0b];
            
            break;
        }
        case 2:
        {
            NSLog(@"2");
            [[EADSessionController sharedController] sendOutBuf:0x0c];
            
            break;
        }
        case 3:
        {
            NSLog(@"3");
            [[EADSessionController sharedController] sendOutBuf:0x0d];
           
            break;
        }
        case 4:
        {
            NSLog(@"4");
            [[EADSessionController sharedController] sendOutBuf:0x0e];
            break;
        }
        case 5:
        {
            NSLog(@"5");
            [[EADSessionController sharedController] sendOutBuf:0x0f];
           
            break;
        }
        case 6:
        {
            NSLog(@"6");
            [[EADSessionController sharedController] sendOutBuf:0x10];
            
            break;
        }
            
        default:
            break;
    }
    //[[EADSessionController sharedController] sendCommand];
    [self.delegate sendMessageToRoStop];
}
-(void)setLanguage:(NSDictionary *)dic
{
    NSString *str  = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"strength"] ];
    [self.strengthLable setText: str];//设置强度
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
