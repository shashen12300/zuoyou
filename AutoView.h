//
//  AutoView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AutoViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface AutoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (nonatomic, strong) NSTimer *mytimer;
@property (nonatomic,assign) NSInteger myTimer;
@property(nonatomic,strong)id delegate;
-(void)setBtnActionForAnimation;
@end
