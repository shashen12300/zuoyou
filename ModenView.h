//
//  ModenView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ModenViewDelegate <NSObject>
-(void)sendMessageToRoStop;
@end
@interface ModenView : UIView
@property (weak, nonatomic) IBOutlet UIButton *modeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn4;
@property(nonatomic,strong)id delegate;
-(void)setBtnSel ;
-(void)setLanguage:(NSDictionary *)dic;
@end
