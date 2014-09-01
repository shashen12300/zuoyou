//
//  StrengthViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "StrengthViewController.h"
#import "SettingViewController.h"
static NSInteger myTimer = 0;
@interface StrengthViewController ()
@property (weak, nonatomic) IBOutlet UILabel *strengthLable;
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *strengthImageView;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation StrengthViewController

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
    NSLog(@"StrengthViewController");
    [self setLanguageForModeView:[StaticValueClass getsettingView]];
    [self setImageView:[StaticValueClass getsettingBgView]];
    [self setImageWithStrength];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setImageWithStrength) name:@"strengthViewDataReceivedNotification" object:nil];
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(sendMessageToMCUFiveTimes) userInfo:nil repeats:YES];
    [self.mytimer setFireDate:[NSDate distantFuture]];
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
-(void)sendMessageToMCUFiveTimes
{
    myTimer++;
    if (myTimer > 4) {
        
        [self.mytimer setFireDate:[NSDate distantFuture]];
        myTimer = 0;
    }
    [[EADSessionController sharedController] sendCommand];
}
-(void)stopMessageToMCUFiveTimes
{
    [self.mytimer setFireDate:[NSDate distantFuture]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    myTimer=0;
}
-(void)startMessageToMCUFiveTimes
{
    [self.mytimer setFireDate:[NSDate distantPast]];
}
- (IBAction)OnSubBtnAction:(id)sender {
  //  [self.mytimer setFireDate:[NSDate distantPast]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    NSInteger index = [StaticValueClass getstrengthView];
    if (index>0) {
        index--;
        [self indexForSwich:index];
    }
    [self performSelector:@selector(startMessageToMCUFiveTimes) withObject:nil afterDelay:0.2f];
}
- (IBAction)OnAddBtnAction:(id)sender {
   // [self.mytimer setFireDate:[NSDate distantPast]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    NSInteger index = [StaticValueClass getstrengthView];
    if (index < 6) {
        index++;
        [self indexForSwich:index];
    }
    [self performSelector:@selector(startMessageToMCUFiveTimes) withObject:nil afterDelay:0.2f];
}
-(void)setImageWithStrength//用来接收一下通知
{
    [self stopMessageToMCUFiveTimes];
    if ([StaticValueClass getstrengthView] < 0 || [StaticValueClass getstrengthView] > 6) {
        return;
    }
    NSString *str = [ NSString stringWithFormat:@"strength%ld",(long)[StaticValueClass getstrengthView]];
    [self.strengthImageView setImage:PNGIMAGE(str)];
}
-(void)indexForSwich:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            NSLog(@"1");
            [[EADSessionController sharedController] sendOutBuf:0x0b];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 2:
        {
            NSLog(@"2");
            [[EADSessionController sharedController] sendOutBuf:0x0c];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 3:
        {
            NSLog(@"3");
            [[EADSessionController sharedController] sendOutBuf:0x0d];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 4:
        {
            NSLog(@"4");
            [[EADSessionController sharedController] sendOutBuf:0x0e];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 5:
        {
            NSLog(@"5");
            [[EADSessionController sharedController] sendOutBuf:0x0f];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 6:
        {
            NSLog(@"6");
            [[EADSessionController sharedController] sendOutBuf:0x10];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setLanguageForModeView:(NSInteger)index
{
    NSDictionary *dic;
    dic = [SettingViewController setLanguageForMainView:index];
    NSString *str  = [[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"strength"] ];
    [self.strengthLable setText: str];//设置强度
}

- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        NSLog(@"ok");
    }];
}
-(void)setImageView:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            
            [self.RealBackgroundView setImage: PNGIMAGE(@"bg2")];
            
            break;
        }
        case 1:
        {
            [self.RealBackgroundView setImage: PNGIMAGE(@"bg3")];
            break;
        }
        case 2:
        {
            [self.RealBackgroundView setImage: PNGIMAGE(@"bg1")];
            
            break;
        }
            
        default:
            break;
    }
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
