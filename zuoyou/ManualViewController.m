//
//  ManualViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "ManualViewController.h"
#import "SettingViewController.h"
static NSInteger myTimer = 0;
@interface ManualViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation ManualViewController

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
    NSLog(@"ManualViewController");
    [self setLanguageForModeView:[StaticValueClass getsettingView]];
    [self setImageView:[StaticValueClass getsettingBgView]];
    [self setBtnSel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnSel) name:@"manualViewDataReceivedNotification" object:nil];
    
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
    myTimer=0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)OnManualBtnAcion:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            [[EADSessionController sharedController] sendOutBuf:0x19];
          //  [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 2:
        {
            [[EADSessionController sharedController] sendOutBuf:0x1a];
           // [[EADSessionController sharedController] sendCommand];
            break;
        }
        case 3:
        {
            [[EADSessionController sharedController] sendOutBuf:0x1b];
          //  [[EADSessionController sharedController] sendCommand];
            break;
        }
        default:
            break;
    }
     [self.mytimer setFireDate:[NSDate distantPast]];
}
//设置按键的变化
-(void)setBtnSel//接收通知
{
    [self stopMessageToMCUFiveTimes];
    [self setBtnToNormal];
    NSInteger index = [StaticValueClass getManualView];
    switch (index) {
        case 0x30:
        {
           [self.firstLabel setTextColor:[UIColor greenColor]];
            break;
        }
        case 0x0c:
        {
            [self.sendLabel setTextColor:[UIColor greenColor]];
            break;
        }
        case 0x03:
        {
           [self.thirdLabel setTextColor:[UIColor greenColor]];
            break;
        }
        default:
            break;
    }
    
}
-(void)setBtnToNormal
{
    [self.firstLabel setTextColor:[UIColor whiteColor]];
    [self.sendLabel setTextColor:[UIColor whiteColor]];
    [self.thirdLabel setTextColor:[UIColor whiteColor]];
}

-(void)setLanguageForModeView:(NSInteger)index
{
    NSDictionary *dic;
    dic = [SettingViewController setLanguageForMainView:index];
    [self.firstLabel setAdjustsFontSizeToFitWidth:YES];
    [self.sendLabel setAdjustsFontSizeToFitWidth:YES];
    [self.thirdLabel setAdjustsFontSizeToFitWidth:YES];
    [self.firstLabel setText:[dic valueForKeyPath:@"massageshoulder"]];
    [self.sendLabel setText:[dic valueForKeyPath:@"massageback"]];
    [self.thirdLabel setText:[dic valueForKeyPath:@"massagewaist"]];
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
