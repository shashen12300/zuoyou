//
//  TopView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "TopView.h"

@implementation TopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)OnBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self.powerDelegate OnPowerBtnClick];
            [self.startBtn setSelected:[StaticValueClass getStartBtnState]];
        }
            break;
        case 2:
        {
            NSLog(@"123");
            [self.delegate showIndexView:0];
        }
        default:
            break;
    }
    NSLog(@"OnBtnClick");
}
-(void)setImageView:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
            [self.RealBackground setImage: PNGIMAGE(@"bg2")];
            
            break;
        }
        case 1:
        {
            [self.RealBackground setImage: PNGIMAGE(@"bg3")];
            break;
        }
        case 2:
        {
            [self.RealBackground setImage: PNGIMAGE(@"bg1")];
            
            break;
        }
            
        default:
            break;
    }
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
