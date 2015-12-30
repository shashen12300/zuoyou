//
//  HeatView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeatViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface HeatView : UIView
@property (weak, nonatomic) IBOutlet UIButton *heatBtn;
@property(nonatomic,strong)id delegate;
-(void)setHeatState;
-(void)initHeatView;
@end
