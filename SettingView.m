//
//  SettingView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setImageView:(NSInteger)index
{
    [self setImageBtnColor:index];
    switch (index) {
        case 0:
        {
            //            if (backGroundFlag == 0) {
            //                return;
            //            }
            [self.RealBackground setImage: PNGIMAGE(@"bg2")];
            [self.backgroundView setImage:PNGIMAGE(@"setting1")];
            break;
        }
        case 1:
        {
            //            if (backGroundFlag == 1) {
            //                return;
            //            }
            [self.RealBackground setImage: PNGIMAGE(@"bg3")];
            [self.backgroundView setImage:PNGIMAGE(@"setting2")];
            break;
        }
        case 2:
        {
            //            if (backGroundFlag == 2) {
            //                return;
            //            }
            [self.RealBackground setImage: PNGIMAGE(@"bg1")];
            [self.backgroundView setImage:PNGIMAGE(@"setting3")];
            break;
        }
            
        default:
            break;
    }
}
-(void)setImageBtnColor:(NSInteger)index
{
    [self.firstBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.thirthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    switch (index) {
        case 0://蓝色
        {
            [self.firstBtn setTitleColor:[UIColor colorWithRed:0.2f green:0.6f blue:1.0f alpha:1] forState:UIControlStateNormal];
            break;
        }
        case 1://绿色
        {
            [self.secondBtn setTitleColor:[UIColor colorWithRed:0.4f green:0.8f blue:0.3f alpha:1] forState:UIControlStateNormal];
            break;
        }
        case 2://深绿
        {
            [self.thirthBtn setTitleColor:[UIColor colorWithRed:0.0f green:0.8f blue:0.7f alpha:1] forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}
+(NSDictionary *)setLanguageForMainView:(NSInteger)index
{
    static NSDictionary *dic = nil;
    if (dic == nil) {
        switch (index) {
            case 0:
            {
                dic = [[NSDictionary alloc] initWithContentsOfFile:PLISTPATH("zh")];
                break;
            }
            case 1:
            {
                dic = [[NSDictionary alloc] initWithContentsOfFile:PLISTPATH("en")];
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
            {
                dic = [dic initWithContentsOfFile:PLISTPATH("zh")];
                break;
            }
            case 1:
            {
                dic = [dic initWithContentsOfFile:PLISTPATH("en")];
                break;
            }
            default:
                break;
        }
    }
    return dic;
}
- (IBAction)OnBtnDownAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self setImageView:0];
            [StaticValueClass settingBgView:0];
            break;
        }
        case 2:
        {
            [self setImageView:1];
            [StaticValueClass settingBgView:1];
            break;
        }
        case 3:
        {
            [self setImageView:2];
            [StaticValueClass settingBgView:2];
            break;
        }
        case 4:
        {
            [SettingView setLanguageForMainView:0];
            [StaticValueClass settingView:0];
            [self setLanguageColor:0];
            [self setLanguageForModeView:[SettingView setLanguageForMainView:0]];
            
            break;
        }
        case 5:
        {
            [SettingView setLanguageForMainView:1];
            [self setLanguageForModeView:[SettingView setLanguageForMainView:1]];
            [StaticValueClass settingView:1];
            [self setLanguageColor:1];
            break;
        }
        default:
            break;
    }
    
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setInteger:[StaticValueClass getsettingView] forKey:@"languageFlag"];
    [userdefault setInteger:[StaticValueClass getsettingBgView] forKey:@"BackgroundFlag"];
   NSInteger index =  [StaticValueClass getsettingView];
    index =[StaticValueClass getsettingBgView];
}
-(void)setLanguageColor:(NSInteger)index
{
    [self.forthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.fithBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    switch (index) {
        case 0://蓝色
        {
            [self.forthBtn setTitleColor:[UIColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:1] forState:UIControlStateNormal];
            break;
        }
        case 1://绿色
        {
            [self.fithBtn setTitleColor:[UIColor colorWithRed:0.6f green:0.2f blue:0.9f alpha:1] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
-(void)setLanguageForModeView:(NSDictionary *)dic
{
    [self.firstBtn setTitle:[dic valueForKey:@"magicblue"] forState:UIControlStateNormal];
    [self.secondBtn setTitle:[dic valueForKey:@"dawn"] forState:UIControlStateNormal];
    [self.thirthBtn setTitle:[dic valueForKey:@"raindew"] forState:UIControlStateNormal];
    
}
-(void)setLanguageDic:(NSDictionary *)dic  selLanguage:(NSInteger)index setBg:(NSInteger)bg
{
    [self setLanguageForModeView:dic];
    [self setLanguageColor:index];
    [self setImageView:bg];
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
