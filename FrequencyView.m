//
//  FrequencyView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "FrequencyView.h"

@implementation FrequencyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)OnSubBtnAction:(id)sender {
    
    
   
    
    NSInteger index = [StaticValueClass getFrequencyView];
    if (index < 6) {
        index++;
        [self indexForSwich:index];
    }
  
}
- (IBAction)OnAddBtnAction:(id)sender {
    NSInteger index = [StaticValueClass getFrequencyView];
    if (index>0) {
        index--;
        [self indexForSwich:index];
    }
}
-(void)setImageWithStrength//用来接收一下通知
{
   // if ([StaticValueClass getFrequencyView] < 0 || [StaticValueClass getFrequencyView] > 6) //{
  //      return;
 //   }
    NSString *str = [ NSString stringWithFormat:@"FRstrength%ld",(long)[StaticValueClass getFrequencyView]-1];
    [self.strengthImageView setImage:PNGIMAGE(str)];
}
-(void)indexForSwich:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            NSLog(@"1");
            [[EADSessionController sharedController] sendOutBuf:0x12];
          //  [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 2:
        {
            NSLog(@"2");
            [[EADSessionController sharedController] sendOutBuf:0x13];
          //  [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 3:
        {
            NSLog(@"3");
            [[EADSessionController sharedController] sendOutBuf:0x14];
           // [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 4:
        {
            NSLog(@"4");
            [[EADSessionController sharedController] sendOutBuf:0x15];
          //  [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 5:
        {
            NSLog(@"5");
            [[EADSessionController sharedController] sendOutBuf:0x16];
           // [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 6:
        {
            NSLog(@"6");
            [[EADSessionController sharedController] sendOutBuf:0x17];
           // [[EADSessionController sharedController] sendCommand];
            break;
        }
            
        default:
            break;
    }
    [self.delegate sendMessageToRoStop];
}
-(void)setLanguage:(NSDictionary *)dic
{
    NSString *str  = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"frequency"] ];
    [self.strengthLable setAdjustsFontSizeToFitWidth:YES];
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
