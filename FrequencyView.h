//
//  FrequencyView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FrequencyViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface FrequencyView : UIView
@property (weak, nonatomic) IBOutlet UILabel *strengthLable;
@property (weak, nonatomic) IBOutlet UIImageView *strengthImageView;
@property(nonatomic,strong)id delegate;
-(void)indexForSwich:(NSInteger)index;
-(void)setImageWithStrength;
-(void)setLanguage:(NSDictionary *)dic;
@end
