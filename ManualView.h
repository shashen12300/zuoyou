//
//  ManualView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ManualViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface ManualView : UIView
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property(nonatomic,strong)id delegate;
-(void)setBtnSel;
-(void)setLanguage:(NSDictionary *)dic;

@end
