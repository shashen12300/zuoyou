//
//  TimeViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "TimeViewController.h"
#import "SettingViewController.h"
static NSInteger myTimer = 0;
@interface TimeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation TimeViewController

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
    NSLog(@"TimerViewController");
    [self setImageView:[StaticValueClass getsettingBgView]];
    [self setLanguageForModeView:10];
    [self setTime];
    
    //timeViewDataReceivedNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTime) name:@"timeViewDataReceivedNotification" object:nil];
    
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
-(void)setTime//接收通知
{
    [self stopMessageToMCUFiveTimes];
    if ([StaticValueClass gettimeView] > 30 || [StaticValueClass gettimeView] < 0) {
        return;
    }
    self.timeTextField.text = [NSString  stringWithFormat:@"%ld Min", (long)[StaticValueClass gettimeView]] ;
}
-(void)setLanguageForModeView:(NSInteger)index
{
    NSDictionary *dic;
    dic = [SettingViewController setLanguageForMainView:index];
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@:",[dic valueForKey:@"time"] ];
    [self.timeLabel setText:str];
}
- (IBAction)OnUpBtn:(id)sender {
    //[self.mytimer setFireDate:[NSDate distantPast]];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    NSInteger time = [StaticValueClass gettimeView];
    int i = 0;
    if (25 <= time ) {
        i = 30;
    }else if(20 <= time && time < 25)
    {
        i = 25;
    }else if(15 <= time && time < 20)
    {
        i = 20;
    }else if(10 <= time && time < 15)
    {
        i = 15;
    }else if (5 <= time && time < 10)
    {
        i = 10;
    }else if(time < 5)
    {
        i = 5;
    }
    
    [[EADSessionController sharedController] sendOutBufForMin:i];
    [[EADSessionController sharedController] sendCommand];
    [self performSelector:@selector(startMessageToMCUFiveTimes) withObject:nil afterDelay:0.2f];
}
- (IBAction)OnDownBtn:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMessageToMCUFiveTimes) object:nil];
    NSInteger timeFlag = [StaticValueClass gettimeView];
    int i = 0;
    if (timeFlag  > 25) {
        i = 25;
    }else if (timeFlag > 20 && timeFlag <= 25){
        i = 20;
    }else if (timeFlag > 15 && timeFlag <= 20){
        i = 15;
    }else if (timeFlag > 10 && timeFlag <= 15){
        i = 10;
    }else if (timeFlag > 5  && timeFlag <= 10){
        i = 5;
    }
    if (i < 5) {
        return;
    }
    [[EADSessionController sharedController] sendOutBufForMin:i];
    [[EADSessionController sharedController] sendCommand];
    [self performSelector:@selector(startMessageToMCUFiveTimes) withObject:nil afterDelay:0.2f];
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
