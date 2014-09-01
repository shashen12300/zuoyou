//
//  SettingViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "SettingViewController.h"
static NSInteger backGroundFlag = 0;
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirthBtn;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fithBtn;
@property (weak, nonatomic) IBOutlet UIButton *sixBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *RealBackground;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"SettingViewController");
    [self setImageView:[StaticValueClass getsettingBgView]];
    [self setLanguageColor:[StaticValueClass getsettingView]];
    [self setLanguageForModeView];
    [self setImageBtnColor:[StaticValueClass getsettingBgView]];
    [self getStartBtnCurrentState];
}
-(void)getStartBtnCurrentState
{
    NSInteger index = [StaticValueClass getStartBtnState];
    if (index == 0) {
        [self.startBtn setImage:PNGIMAGE(@"power2") forState:UIControlStateNormal];
    }else if (index == 1)
    {
        [self.startBtn setImage:PNGIMAGE(@"Power1") forState:UIControlStateNormal];
    }
}
- (IBAction)OnPauseAction:(id)sender {
    NSInteger index = [StaticValueClass getStartBtnState];
    if (index == 0) {
        [self.startBtn setImage:PNGIMAGE(@"Power1") forState:UIControlStateNormal];
    }
    else
    {
        [self.startBtn setImage:PNGIMAGE(@"power2") forState:UIControlStateNormal];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startBtnCurrentStatus" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault setInteger:[StaticValueClass getsettingView] forKey:@"languageFlag"];
    [userdefault setInteger:[StaticValueClass getsettingBgView] forKey:@"BackgroundFlag"];
}
//初始化一个字典单例
+(NSDictionary *)setLanguageForMainView:(NSInteger)index
{
    static NSDictionary *dic = nil;
    if (dic == nil) {
        switch (index) {
            case 0:
            {
                dic = [[NSDictionary alloc] initWithContentsOfFile:PLISTPATH("zh")];
                break;
            }
            case 1:
            {
                dic = [[NSDictionary alloc] initWithContentsOfFile:PLISTPATH("en")];
                break;
            }
            default:
                break;
        }
    }
    else
    {
        switch (index) {
            case 0:
            {
                dic = [dic initWithContentsOfFile:PLISTPATH("zh")];
                break;
            }
            case 1:
            {
                dic = [dic initWithContentsOfFile:PLISTPATH("en")];
                break;
            }
            default:
                break;
        }
    }
    return dic;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"ok");
    }];
}
- (IBAction)OnBtnDownAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [self setImageView:0];
            [StaticValueClass settingBgView:0];
            break;
        }
        case 2:
        {
            [self setImageView:1];
            [StaticValueClass settingBgView:1];
            break;
        }
        case 3:
        {
            [self setImageView:2];
            [StaticValueClass settingBgView:2];
            break;
        }
        case 4:
        {
            [SettingViewController setLanguageForMainView:0];
            [StaticValueClass settingView:0];
            [self setLanguageColor:0];
            [self setLanguageForModeView];
            
            break;
        }
        case 5:
        {
            [SettingViewController setLanguageForMainView:1];
            [self setLanguageForModeView];
            [StaticValueClass settingView:1];
            [self setLanguageColor:1];
            break;
        }
        default:
            break;
    }
}
-(void)setLanguageForModeView
{
    NSDictionary *dic;
    dic = [SettingViewController setLanguageForMainView:10];
    
    [self.firstBtn setTitle:[dic valueForKey:@"magicblue"] forState:UIControlStateNormal];
    [self.secondBtn setTitle:[dic valueForKey:@"dawn"] forState:UIControlStateNormal];
    [self.thirthBtn setTitle:[dic valueForKey:@"raindew"] forState:UIControlStateNormal];
    
}
-(void)setImageView:(NSInteger)index
{
    [self setImageBtnColor:index];
    switch (index) {
        case 0:
        {
//            if (backGroundFlag == 0) {
//                return;
//            }
            [self.RealBackground setImage: PNGIMAGE(@"bg2")];
            [self.backgroundView setImage:PNGIMAGE(@"setting1")];
            backGroundFlag = 0;
            break;
        }
        case 1:
        {
//            if (backGroundFlag == 1) {
//                return;
//            }
            [self.RealBackground setImage: PNGIMAGE(@"bg3")];
            [self.backgroundView setImage:PNGIMAGE(@"setting2")];
            backGroundFlag = 1;
            break;
        }
        case 2:
        {
//            if (backGroundFlag == 2) {
//                return;
//            }
            [self.RealBackground setImage: PNGIMAGE(@"bg1")];
            [self.backgroundView setImage:PNGIMAGE(@"setting3")];
            backGroundFlag = 2;
            break;
        }
            
        default:
            break;
    }
}
-(void)setImageBtnColor:(NSInteger)index
{
    [self setImageBtnTextNormal];
  
    switch (index) {
        case 0://蓝色
        {
            [self.firstBtn setTitleColor:[UIColor colorWithRed:0.2f green:0.6f blue:1.0f alpha:1] forState:UIControlStateNormal];
            break;
        }
        case 1://绿色
        {
            [self.secondBtn setTitleColor:[UIColor colorWithRed:0.4f green:0.8f blue:0.3f alpha:1] forState:UIControlStateNormal];
            break;
        }
        case 2://深绿
        {
            [self.thirthBtn setTitleColor:[UIColor colorWithRed:0.0f green:0.8f blue:0.7f alpha:1] forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}
-(void)setImageBtnTextNormal
{
   [self.firstBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.thirthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
-(void)setLanguageColor:(NSInteger)index
{
    [self setLanguangeBtnTextNormal];
    switch (index) {
        case 0://蓝色
        {
            [self.forthBtn setTitleColor:[UIColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:1] forState:UIControlStateNormal];
            break;
        }
        case 1://绿色
        {
            [self.fithBtn setTitleColor:[UIColor colorWithRed:0.6f green:0.2f blue:0.9f alpha:1] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}
-(void)setLanguangeBtnTextNormal
{
    [self.forthBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.fithBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
