//
//  HeatViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "HeatViewController.h"
static NSInteger myTimer = 0;
@interface HeatViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *heatBtn;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation HeatViewController

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
    NSLog(@"HeatViewController");
    [self setHeatState];
    [self setImageView:[StaticValueClass getsettingBgView]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setHeatState) name:@"heatingViewDataReceivedNotification" object:nil];
    
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
-(void)startMessageToMCUFiveTimes
{
    [self.mytimer setFireDate:[NSDate distantPast]];
}
- (IBAction)heatBtnaction:(UIButton *)sender {
   // [self.mytimer setFireDate:[NSDate distantPast]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    NSInteger index = [StaticValueClass getHeatingView];
    switch (index) {
        case 0xa5:
        {
            [[EADSessionController sharedController] sendOutBuf:0x04];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
        default:
        {
            [[EADSessionController sharedController] sendOutBuf:0x03];
            [[EADSessionController sharedController] sendCommand];
            break;
        }
    }
    [self performSelector:@selector(startMessageToMCUFiveTimes) withObject:nil afterDelay:0.2f];
}
-(void)setHeatState//接收通知
{
    [self stopMessageToMCUFiveTimes];
    NSInteger index = [StaticValueClass getHeatingView];
    switch (index) {
        case 0:
        {
            [self.heatBtn setImage:PNGIMAGE(@"heat1") forState:UIControlStateNormal];
            break;
        }
        case 0xa5:
        {
            [self.heatBtn setImage:PNGIMAGE(@"heat2") forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
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
