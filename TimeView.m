//
//  TimeView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "TimeView.h"

@implementation TimeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setTime//接收通知
{
    self.timeTextField.text = [NSString  stringWithFormat:@"%ld Min", (long)[StaticValueClass gettimeView]] ;
}
- (IBAction)OnUpBtn:(id)sender {
    NSInteger time = [StaticValueClass gettimeView];
    int i = 0;
    if (25 <= time ) {
        i = 30;
    }else if(20 <= time && time < 25)
    {
        i = 25;
    }else if(15 <= time && time < 20)
    {
        i = 20;
    }else if(10 <= time && time < 15)
    {
        i = 15;
    }else if (5 <= time && time < 10)
    {
        i = 10;
    }else if(time < 5)
    {
        i = 5;
    }
    
    [[EADSessionController sharedController] sendOutBufForMin:i];
    //[[EADSessionController sharedController] sendCommand];
     [self.delegate sendMessageToRoStop];
    
}
- (IBAction)OnDownBtn:(id)sender {
   
    NSInteger timeFlag = [StaticValueClass gettimeView];
    int i = 0;
    if (timeFlag  > 25) {
        i = 25;
    }else if (timeFlag > 20 && timeFlag <= 25){
        i = 20;
    }else if (timeFlag > 15 && timeFlag <= 20){
        i = 15;
    }else if (timeFlag > 10 && timeFlag <= 15){
        i = 10;
    }else if (timeFlag > 5  && timeFlag <= 10){
        i = 5;
    }
    if (i < 5) {
        return;
    }
    [[EADSessionController sharedController] sendOutBufForMin:i];
   // [[EADSessionController sharedController] sendCommand];
    [self.delegate sendMessageToRoStop];
   
}
-(void)setLanguage:(NSDictionary *)dic
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@:",[dic valueForKey:@"time"] ];
    [self.timeLabel setText:str];
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
