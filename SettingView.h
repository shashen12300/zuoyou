//
//  SettingView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirthBtn;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fithBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (nonatomic,strong) UIImageView *RealBackground;
+(NSDictionary *)setLanguageForMainView:(NSInteger)index;
-(void)setLanguageForModeView:(NSDictionary *)dic;
-(void)setLanguageDic:(NSDictionary *)dic  selLanguage:(NSInteger)index setBg:(NSInteger)bg;
@end
