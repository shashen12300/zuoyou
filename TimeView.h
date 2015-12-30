//
//  TimeView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TimeViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface TimeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property(nonatomic,strong)id delegate;
-(void)setTime;
-(void)setLanguage:(NSDictionary *)dic;
@end
