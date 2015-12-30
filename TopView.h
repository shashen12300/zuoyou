//
//  TopView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TopViewDelegate <NSObject>
-(void)showIndexView:(NSInteger)index;
-(void)sendMessageToRoStop;
@end
@protocol TopViewMainViewDelegate <NSObject>
-(void)OnPowerBtnClick;
@end
@interface TopView : UIView
@property (weak, nonatomic) IBOutlet UIView *mTopView;
@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UIButton *mBackBtn;
@property (weak, nonatomic) IBOutlet UIImageView *RealBackground;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property(nonatomic,strong) id powerDelegate;
@property (nonatomic,strong) id delegate;
-(void)setImageView:(NSInteger)index;
@end
