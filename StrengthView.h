//
//  StrengthView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StrengthViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface StrengthView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *strengthImageView;
@property (weak, nonatomic) IBOutlet UILabel *strengthLable;
@property(nonatomic,strong)id delegate;
-(void)setImageWithStrength;
-(void)setLanguage:(NSDictionary *)dic;
@end
