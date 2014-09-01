//
//  ViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "ViewController.h"
#import "SettingViewController.h"
static NSInteger myTimer = 0;
@interface ViewController ()
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
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;

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
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

//logo
@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *titileLogoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *logoBackImageView;

@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewController");
    
    [StaticValueClass settingView:[[NSUserDefaults standardUserDefaults] integerForKey:@"languageFlag"]];
    [StaticValueClass settingBgView:[[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundFlag"]];
    [self setLanguageForModeView:[StaticValueClass getsettingView]];
    [self setImageView:[StaticValueClass getsettingBgView]];
    
    [self initCurrentStatus];
    
    [EADSessionController sharedController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OnPauseAction:) name:@"startBtnCurrentStatus" object:nil];
    [self.view setUserInteractionEnabled:NO];
    [self performSelector:@selector(hiddenLogoView) withObject:nil afterDelay:5.0f];
    
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(sendMessageToMCUFiveTimes) userInfo:nil repeats:YES];
    [self.mytimer setFireDate:[NSDate distantFuture]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setLanguageForModeView:[StaticValueClass getsettingView]];
    [self setImageView:[StaticValueClass getsettingBgView]];
}
-(void)hiddenLogoView
{
    [self.view setUserInteractionEnabled:YES];
    [self.LogoImageView setHidden:YES];
    [self.titileLogoImageView setHidden:YES];
    [self.logoBackImageView setHidden:YES];
    self.LogoImageView = nil;
    self.titileLogoImageView = nil;
    self.logoBackImageView = nil;
    
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
-(void)setLanguageForModeView:(NSInteger)index
{
    NSDictionary *dic;
    dic = [SettingViewController setLanguageForMainView:index];
    
    [self.firstLabel setAdjustsFontSizeToFitWidth:YES];
    [self.secondLabel setAdjustsFontSizeToFitWidth:YES];
    [self.thirdLabel setAdjustsFontSizeToFitWidth:YES];
    [self.forthLabel setAdjustsFontSizeToFitWidth:YES];
    [self.fiveLabel setAdjustsFontSizeToFitWidth:YES];
    [self.sixLabel setAdjustsFontSizeToFitWidth:YES];
    [self.sevenLabel setAdjustsFontSizeToFitWidth:YES];
    [self.eightLabel setAdjustsFontSizeToFitWidth:YES];
    [self.nineLabel setAdjustsFontSizeToFitWidth:YES];
    [self.tenLabel setAdjustsFontSizeToFitWidth:YES];
        [self.firstLabel setText:[dic valueForKey:@"automaticmode"] ];//设置强度
        [self.secondLabel setText:[dic valueForKey:@"manualmode "] ];//设置强度
        [self.thirdLabel setText:[dic valueForKey:@"frequency"] ];//设置强度
        [self.forthLabel setText:[dic valueForKey:@"music"] ];//设置强度
        [self.fiveLabel setText:[dic valueForKey:@"heating"] ];//设置强度
        [self.sixLabel setText:[dic valueForKey:@"mode"] ];//设置强度
        [self.sevenLabel setText:[dic valueForKey:@"time"] ];//设置强度
        [self.eightLabel setText:[dic valueForKey:@"strength"] ];//设置强度
        [self.nineLabel setText:[dic valueForKey:@"backajust"] ];//设置强度
        [self.tenLabel setText:[dic valueForKey:@"setting"] ];//设置强度
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
- (IBAction)OnBtnTouchUpAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            NSLog(@"1");
            break;
        }
        case 2:
        {
           
            break;
        }
        case 3:
        {
           
            break;
        }
        case 4:
        {
            NSLog(@"4");
            break;
        }
        case 5:
        {
            NSLog(@"5");
            break;
        }
        case 6:
        {
            NSLog(@"6");
            break;
        }
        case 7:
        {
            NSLog(@"7");
            break;
        }
        case 8:
        {
            NSLog(@"8");
            break;
        }
        case 9:
        {
            NSLog(@"9");
            break;
        }
        case 10:
        {
            NSLog(@"10");
            break;
        }
            
        default:
            break;
    }
}
-(void)initCurrentStatus
{
    [StaticValueClass StartBtnState:0];
    [self.firstBtn setEnabled:NO];
    [self.secondBtn setEnabled:NO];
    [self.thirdBtn setEnabled:NO];
    [self.forthBtn setEnabled:NO];
    [self.fithBtn setEnabled:NO];
    [self.sixBtn setEnabled:NO];
    [self.sevenBtn setEnabled:NO];
    [self.eigthBtn setEnabled:NO];
    //[self.nineBtn setEnabled:NO];
    [self.startBtn setImage:PNGIMAGE(@"power2") forState:UIControlStateNormal];
}
- (IBAction)OnPauseAction:(id)sender {
    NSInteger index = [StaticValueClass getStartBtnState];
    if (index == 1) {
        [StaticValueClass StartBtnState:0];
        [self.firstBtn setEnabled:NO];
        [self.secondBtn setEnabled:NO];
        [self.thirdBtn setEnabled:NO];
        [self.forthBtn setEnabled:NO];
        [self.fithBtn setEnabled:NO];
        [self.sixBtn setEnabled:NO];
        [self.sevenBtn setEnabled:NO];
        [self.eigthBtn setEnabled:NO];
        //[self.nineBtn setEnabled:NO];
        [self.startBtn setImage:PNGIMAGE(@"power2") forState:UIControlStateNormal];
        [[MPMusicPlayerController iPodMusicPlayer] pause];
        [[EADSessionController sharedController] sendOutBuf:0x02];
        [self.mytimer setFireDate:[NSDate distantPast]];
    }
    else
    {
        [StaticValueClass StartBtnState:1];
        [self.firstBtn setEnabled:YES];
        [self.secondBtn setEnabled:YES];
        [self.thirdBtn setEnabled:YES];
        [self.forthBtn setEnabled:YES];
        [self.fithBtn setEnabled:YES];
        [self.sixBtn setEnabled:YES];
        [self.sevenBtn setEnabled:YES];
        [self.eigthBtn setEnabled:YES];
        [self.startBtn setImage:PNGIMAGE(@"Power1") forState:UIControlStateNormal];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)_sessionDataReceived:(NSNotification *)notification
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        uint32_t bytesAvailable = 0;
        uint8_t myinBuf[256] ={0};
        while ((bytesAvailable = (uint32_t)[[EADSessionController sharedController] readBytesAvailable]) > 0) {
            NSData *data = [[EADSessionController sharedController] readData:bytesAvailable];
            [data getBytes:myinBuf];
            
            
            if(data.length == 7 )
            {
                
            }
            
            if (data.length == 10) {
                
            }
            
            
            
            [self stopMessageToMCUFiveTimes];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    uint8_t inBuf[256] ={0};
                    [data getBytes:inBuf];
                    if( bytesAvailable<256 )
                    {
                      
                        switch (inBuf[2]) {
                            case 0x01:
                            {
                                switch (inBuf[3]) {
                                    case 0xA5:
                                    {
                                        [StaticValueClass autoView:1];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0xAA:
                                    {
                                        [StaticValueClass autoView:0];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x00:
                                    {
                                        [StaticValueClass autoView:0];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AutoViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            case 0x02:
                            {
                                switch (inBuf[3]) {
                                    case 0xa5:
                                    {
                                        [StaticValueClass heatingView:0xa5];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"heatingViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x00:
                                    {
                                        [StaticValueClass heatingView:0x00];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"heatingViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            case 0x03:
                            {
                                switch (inBuf[3]) {
                                    case 0x00:
                                    {
                                        [StaticValueClass modeView:0x00];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"modenViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x01:
                                    {
                                        [StaticValueClass modeView:0x01];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"modenViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x02:
                                    {
                                        [StaticValueClass modeView:0x02];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"modenViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x03:
                                    {
                                        [StaticValueClass modeView:0x03];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"modenViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x04:
                                    {
                                        [StaticValueClass modeView:0x04];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"modenViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                               
                                break;
                            }
                            case 0x04:
                            {
                                switch (inBuf[3]) {
                                    case 0x00:
                                    {
                                        [StaticValueClass strengthView:0x00];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x01:
                                    {
                                        [StaticValueClass strengthView:0x01];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x02:
                                    {
                                        [StaticValueClass strengthView:0x02];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x03:
                                    {
                                        [StaticValueClass strengthView:0x03];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x04:
                                    {
                                        [StaticValueClass strengthView:0x04];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x05:
                                    {
                                        [StaticValueClass strengthView:0x05];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x06:
                                    {
                                        [StaticValueClass strengthView:0x06];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"strengthViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                               
                                break;
                            }
                            case 0x05:
                            {
                                switch (inBuf[3]) {
                                    case 0x00:
                                    {
                                        [StaticValueClass frequencyView:0x00];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x01:
                                    {
                                        [StaticValueClass frequencyView:0x01];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x02:
                                    {
                                        [StaticValueClass frequencyView:0x02];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x03:
                                    {
                                        [StaticValueClass frequencyView:0x03];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x04:
                                    {
                                        [StaticValueClass frequencyView:0x04];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x05:
                                    {
                                        [StaticValueClass frequencyView:0x05];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x06:
                                    {
                                        [StaticValueClass frequencyView:0x06];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"frequenceViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            case 0x06:
                            {
                                switch (inBuf[3]) {
                                    case 0x00:
                                    {
                                        [StaticValueClass manualView:0x00];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"manualViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x30:
                                    {
                                        [StaticValueClass manualView:0x30];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"manualViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x0C:
                                    {
                                        [StaticValueClass manualView:0x0c];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"manualViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    case 0x03:
                                    {
                                        [StaticValueClass manualView:0x03];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"manualViewDataReceivedNotification" object:nil];
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            case 0x07:
                            {
                                switch (inBuf[3]) {
                                    case 0x00:
                                    {
                                        break;
                                    }
                                    case 0x01:
                                    {
                                        break;
                                    }
                                    case 0x02:
                                    {
                                        break;
                                    }
                                    default:
                                        break;
                                }
                                break;
                            }
                            case 0x08:
                            {
                                [StaticValueClass timeView:inBuf[3]];
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"timeViewDataReceivedNotification" object:nil];
                                break;
                            }
                            default:
                                break;
                        }
                    }
                });
            }
        }
        
        
    });
    
    
}

@end
