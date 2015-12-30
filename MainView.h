//
//  MainView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "MusicView.h"
@protocol MainViewDelegate <NSObject>
-(void)showIndexView:(NSInteger)index;
@end
@interface MainView : UIView<TopViewMainViewDelegate>
{
   
}
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *forthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightLabel;
@property (weak, nonatomic) IBOutlet UILabel *nineLabel;
@property (weak, nonatomic) IBOutlet UILabel *tenLabel;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fithBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIButton *sevenBtn;
@property (weak, nonatomic) IBOutlet UIButton *eigthBtn;
@property (weak, nonatomic) IBOutlet UIButton *nineBtn;
@property (weak, nonatomic) IBOutlet UIButton *tenBtn;

@property(strong,nonatomic)MusicView *musicView;
@property (nonatomic, strong) NSTimer *mytimerStop;
@property(nonatomic,strong)id delegate;
-(void)setLanguage:(NSDictionary *)dic;
-(void)initCurrentStatus;
@end
