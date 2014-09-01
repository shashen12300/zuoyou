//
//  ModenViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "ModenViewController.h"
#import "SettingViewController.h"
static NSInteger myTimer = 0;
@interface ModenViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *modeBtn4;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation ModenViewController

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
    NSLog(@"ModenViewController");
    [self setImageView:[StaticValueClass getsettingBgView]];
    [self setLanguageForModeView:10];
    [self setBtnSel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnSel) name:@"modenViewDataReceivedNotification" object:nil];
    
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
- (IBAction)OnModeBtnDownAction:(UIButton *)sender {
  // [self.mytimer setFireDate:[NSDate distantFuture]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    switch (sender.tag) {
        case 1:
        {
            NSLog(@"1");
            [[EADSessionController sharedController] sendOutBuf:0x06];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 2:
        {
            NSLog(@"2");
            [[EADSessionController sharedController] sendOutBuf:0x07];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 3:
        {
            NSLog(@"3");
            [[EADSessionController sharedController] sendOutBuf:0x08];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 4:
        {
            NSLog(@"4");
            [[EADSessionController sharedController] sendOutBuf:0x09];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        default:
            break;
    }
    [self performSelector:@selector(startMessageToMCUFiveTimes) withObject:nil afterDelay:0.2f];
}
//设置按键的变化
-(void)setBtnSel //通知
{
    [self stopMessageToMCUFiveTimes];
    [self setBtnToNormal];
    NSInteger index = [StaticValueClass getModeView];
    switch (index) {
        case 0x01:
        {
            [self.modeBtn1 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        case 0x02:
        {
            [self.modeBtn2 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        case 0x03:
        {
            [self.modeBtn3 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        case 0x04:
        {
            [self.modeBtn4 setBackgroundImage:PNGIMAGE(@"mode2") forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    
    
}
-(void)setBtnToNormal
{
    [self.modeBtn1 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    [self.modeBtn2 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    [self.modeBtn3 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
    [self.modeBtn4 setBackgroundImage:PNGIMAGE(@"mode1") forState:UIControlStateNormal];
}
-(void)setLanguageForModeView:(NSInteger)index
{
    NSDictionary *dic;
    dic = [SettingViewController setLanguageForMainView:index];
    [self.modeBtn1 setTitle:[dic valueForKeyPath:@"mode1"] forState:UIControlStateNormal];
    [self.modeBtn2 setTitle:[dic valueForKeyPath:@"mode2"] forState:UIControlStateNormal];
    [self.modeBtn3 setTitle:[dic valueForKeyPath:@"mode3"] forState:UIControlStateNormal];
    [self.modeBtn4 setTitle:[dic valueForKeyPath:@"mode4"] forState:UIControlStateNormal];
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
