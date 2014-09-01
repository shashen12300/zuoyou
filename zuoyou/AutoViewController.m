//
//  AutoViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "AutoViewController.h"

static NSInteger myTimer = 0;
@interface AutoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *autoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation AutoViewController

@synthesize autoBtn,backImgView;
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
    NSLog(@"AutoViewController");
    backImgView.animationDuration = 2;
    [self setImageView:[StaticValueClass getsettingBgView]];
    [self setBtnActionForAnimation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBtnActionForAnimation) name:@"AutoViewDataReceivedNotification" object:nil];
    
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
-(void)setBtnActionForAnimation//接收通知
{
    [self stopMessageToMCUFiveTimes];
    NSInteger flag = [StaticValueClass getAutoView];
    switch (flag) {
        case 0:
        {
            if (backImgView.isAnimating == NO) {
                return;
            }
            [backImgView stopAnimating];
            break;
        }
        case 1:
        {
            if (backImgView.isAnimating == YES) {
                return;
            }
            NSMutableArray *imagViewArray=[[NSMutableArray alloc] init];
            NSArray *array = [[NSArray alloc] initWithObjects:@"manual1",@"manual2",@"manual3", nil];
            for (NSString *img in array) {
                [imagViewArray addObject:PNGIMAGE(img)];
                
            }
            backImgView.animationImages = imagViewArray;
            
            [backImgView startAnimating];
            break;
        }
        default:
            break;
    }
}
- (IBAction)OnBtnAction:(id)sender {
    if ([StaticValueClass getAutoView] == 0) {
        [[EADSessionController sharedController] sendOutBuf:0x22];
    }
    else if([StaticValueClass getAutoView] == 1)
    {
        [[EADSessionController sharedController] sendOutBuf:0x01];
    }
    [self.mytimer setFireDate:[NSDate distantPast]];
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
