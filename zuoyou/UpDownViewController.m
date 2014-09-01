//
//  UpDownViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "UpDownViewController.h"
static NSInteger myTimer = 0;
@interface UpDownViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *UpDownImageView;
@property (nonatomic, strong) NSTimer *mytimer;//用来定时让右侧的按键0.1s发送一次数据  UP
@property (nonatomic, strong) NSTimer *mytimerDOWN;//用来定时让右侧的按键0.1s发送一次数据  DOWN
@property (nonatomic, strong) NSTimer *mytimerStop;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation UpDownViewController
@synthesize arrayBackDown,arrayBackUp;
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
    NSLog(@"UpDownViewController");
    [self setImageView:[StaticValueClass getsettingBgView]];
    
    /*背部*/
    arrayBackUp= [[NSArray alloc] initWithObjects:@"backdeclieImag1",@"backdeclieImag2",@"backdeclieImag3",@"backdeclieImag4",@"backdeclieImag5",@"backdeclieImag6",@"backdeclieImag7",@"backdeclieImag8",@"backdeclieImag9", nil];
    arrayBackDown= [[NSArray alloc] initWithObjects:@"backdeclieImag9",@"backdeclieImag8",@"backdeclieImag7",@"backdeclieImag6",@"backdeclieImag5",@"backdeclieImag4",@"backdeclieImag3",@"backdeclieImag2",@"backdeclieImag1", nil];
    [self.UpDownImageView setImage:PNGIMAGE(@"backdeclieImag9")];
    [self.UpDownImageView setAnimationDuration:1];
    [self.UpDownImageView setAnimationDuration:7];
    
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(sendMessageToRoUP) userInfo:nil repeats:YES];
    [self.mytimer setFireDate:[NSDate distantFuture]];
    self.mytimerDOWN = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(sendMessageToRoDOWN) userInfo:nil repeats:YES];
    [self.mytimerDOWN setFireDate:[NSDate distantFuture]];
    
    self.mytimerStop = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(sendMessageToRoStop) userInfo:nil repeats:YES];
    [self.mytimerStop setFireDate:[NSDate distantFuture]];
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
-(void)sendMessageToRoStop
{
    myTimer ++;
    if (myTimer > 4) {
        [self.mytimerStop setFireDate:[NSDate distantFuture]];
        myTimer = 0;
    }
    [[EADSessionController sharedController] sendOutBuf:0x1f];
    [[EADSessionController sharedController] sendCommand];
    
}
- (IBAction)OnUpBtnAction:(UIButton *)sender {
    [self.UpDownImageView stopAnimating];
    [self.mytimer setFireDate:[NSDate distantFuture]];
    [self.mytimerStop setFireDate:[NSDate distantPast]];
}//up inside
- (IBAction)OnUpBtnDownAction:(UIButton *)sender {
    NSMutableArray *imagViewArray=[[NSMutableArray alloc] init];
    [self.UpDownImageView setImage:PNGIMAGE(@"backdeclieImag9")];
    for (NSString *img in arrayBackUp) {
        [imagViewArray addObject:PNGIMAGE(img)];
    }
    self.UpDownImageView.animationImages = imagViewArray;
    [self.UpDownImageView startAnimating];
    [self.mytimer setFireDate:[NSDate distantPast]];
}//touch down

- (IBAction)OnDownBtnAction:(UIButton *)sender {
    [self.UpDownImageView stopAnimating];
    [self.mytimerDOWN setFireDate:[NSDate distantFuture]];
    [self.mytimerStop setFireDate:[NSDate distantPast]];
}//up inside
- (IBAction)OnDownBtnDownAction:(UIButton *)sender {
    NSMutableArray *imagViewArray=[[NSMutableArray alloc] init];
    [self.UpDownImageView setImage:PNGIMAGE(@"backdeclieImag1")];
    for (NSString *img in arrayBackDown) {
        [imagViewArray addObject:PNGIMAGE(img)];
    }
    self.UpDownImageView.animationImages = imagViewArray;
    [self.UpDownImageView startAnimating];
    [self.mytimerDOWN setFireDate:[NSDate distantPast]];
}//touch down

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
-(void)sendMessageToRoUP
{
    NSLog(@"1");
    [[EADSessionController sharedController] sendOutBuf:0x1D];
    [[EADSessionController sharedController] sendCommand];
}
-(void)sendMessageToRoDOWN
{
    NSLog(@"2");
    [[EADSessionController sharedController] sendOutBuf:0x1e];
    [[EADSessionController sharedController] sendCommand];
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
