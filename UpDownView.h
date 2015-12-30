//
//  UpDownView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpDownView : UIView
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *UpDownImageView;
@property (nonatomic, strong) NSTimer *mytimer;//用来定时让右侧的按键0.1s发送一次数据  UP
@property (nonatomic, strong) NSTimer *mytimerDOWN;//用来定时让右侧的按键0.1s发送一次数据  DOWN
@property (nonatomic, strong) NSTimer *mytimerStop;
@property (nonatomic,strong) NSMutableArray *arrayBackDown;
@property (nonatomic,strong) NSMutableArray *arrayBackUp;
-(void)OnInitTime;
@end
