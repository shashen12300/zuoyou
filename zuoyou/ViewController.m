//
//  ViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"ViewController");
    

    [StaticValueClass settingView:[[NSUserDefaults standardUserDefaults] integerForKey:@"languageFlag"]];
    [StaticValueClass settingBgView:[[NSUserDefaults standardUserDefaults] integerForKey:@"BackgroundFlag"]];
    
    
    [EADSessionController sharedController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_sessionDataReceived:) name:EADSessionDataReceivedNotification object:nil];

    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(sendMessage) userInfo:nil repeats:YES];
       [self.mytimer setFireDate:[NSDate distantFuture]];
        self.myTimer = 0;
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMassage) name:ISCONNECTED object:nil];
    [self initView];

}
- (void)openMassage{
    [logoView setHidden:TRUE];
     [topView setUserInteractionEnabled:TRUE];
     [self setCurrentView:0];
}
-(void)showView
{
    [logoView setHidden:TRUE];
    [topView setUserInteractionEnabled:TRUE];
    [self setCurrentView:0];

}

#pragma mark
-(void)initView
{
    // [holder insertSubview:view atIndex:0];
    NSArray *nibObjects;
    if (isPad) {
        nibObjects=[[NSBundle mainBundle] loadNibNamed:@"ViewController_iPad" owner:self options:nil];
    }else
    {
        nibObjects=[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil];
    }
    
   
   
    
    topView = [nibObjects objectAtIndex:1];
    [topView setFrame:CGRectMake(0, 0,App_Frame_Width,App_Frame_Height)];
    [self.view insertSubview:topView atIndex:3];
    //[topView.RealBackground setImageView:[StaticValueClass getsettingBgView]];
    [topView setImageView:[StaticValueClass getsettingBgView]];
    topView.delegate = self;
    
    
    mainView = [nibObjects objectAtIndex:2];
    [topView.mTopView insertSubview:mainView atIndex:11];
    mainView.delegate  = self;
    topView.powerDelegate = mainView;
    [mainView initCurrentStatus];
    
    autoView = [nibObjects objectAtIndex:3];
    autoView.delegate = self;
    [topView.mTopView insertSubview:autoView atIndex:10];
     [[NSNotificationCenter defaultCenter] addObserver:autoView selector:@selector(setBtnActionForAnimation) name:@"AutoViewDataReceivedNotification" object:nil];
    
    manualView = [nibObjects objectAtIndex:4];
    manualView.delegate = self;
    [topView.mTopView insertSubview:manualView atIndex:9];
    [[NSNotificationCenter defaultCenter] addObserver:manualView selector:@selector(setBtnSel) name:@"manualViewDataReceivedNotification" object:nil];
    
    frequencuView = [nibObjects objectAtIndex:5];
    frequencuView.delegate = self;
    [topView.mTopView insertSubview:frequencuView atIndex:8];
     [[NSNotificationCenter defaultCenter] addObserver:frequencuView selector:@selector(setImageWithStrength) name:@"frequenceViewDataReceivedNotification" object:nil];
    
    
    musicView = [nibObjects objectAtIndex:6];
    [topView.mTopView insertSubview:musicView atIndex:7];
    musicView.rootViewCtrl = self;
    [musicView initMusicStaup];
    mainView.musicView = musicView;
    
    heatView = [nibObjects objectAtIndex:7];
    heatView.delegate = self;
    [topView.mTopView insertSubview:heatView atIndex:6];
    [[NSNotificationCenter defaultCenter] addObserver:heatView selector:@selector(setHeatState) name:@"heatingViewDataReceivedNotification" object:nil];
    [heatView initHeatView];
    
    modenView = [nibObjects objectAtIndex:8];
    modenView.delegate = self;
    [topView.mTopView insertSubview:modenView atIndex:5];
     [[NSNotificationCenter defaultCenter] addObserver:modenView selector:@selector(setBtnSel) name:@"modenViewDataReceivedNotification" object:nil];
    
    timeView = [nibObjects objectAtIndex:9];
    timeView.delegate = self;
    [topView.mTopView insertSubview:timeView atIndex:4];
      [[NSNotificationCenter defaultCenter] addObserver:timeView selector:@selector(setTime) name:@"timeViewDataReceivedNotification" object:nil];
    
    
    strengthView = [nibObjects objectAtIndex:10];
    strengthView.delegate = self;
    [topView.mTopView insertSubview:strengthView atIndex:3];
    [[NSNotificationCenter defaultCenter] addObserver:strengthView selector:@selector(setImageWithStrength) name:@"strengthViewDataReceivedNotification" object:nil];
    
    updownView = [nibObjects objectAtIndex:11];
    [topView.mTopView insertSubview:updownView atIndex:2];
    [updownView OnInitTime];
    
    settingView = [nibObjects objectAtIndex:12];
    [topView.mTopView insertSubview:settingView atIndex:1];
    settingView.RealBackground = topView.RealBackground;
//    [topView setHidden:NO];
   
    // [listView setHidden:TRUE];
    [self setCurrentView:0];
    
    [topView setUserInteractionEnabled:NO];
    logoView = [nibObjects objectAtIndex:0];
    [logoView setFrame:CGRectMake(0, 0,App_Frame_Width,App_Frame_Height)];
    [self.view insertSubview:logoView atIndex:20];
    
    
    listView = [nibObjects objectAtIndex: 13];
    [listView setCenter:topView.mTopView.center];
    [logoView addSubview:listView];
    listView.mPeripheralListView.delegate = listView;
    listView.mPeripheralListView.dataSource = listView;
     [[NSNotificationCenter defaultCenter] addObserver:listView selector:@selector(updateListView) name:MESSAGEFORLIST object:nil];
    [listView updateListView];
    listView.delegate = self;
    
  //  [self showView];
}
-(void)initTopView
{
    
}
-(void)setCurrentView:(NSInteger)index
{
    [mainView setHidden:TRUE];
    [autoView setHidden:TRUE];
    [manualView setHidden: TRUE];
    [frequencuView setHidden:TRUE];
    [musicView setHidden:TRUE];
    [heatView setHidden:TRUE];
    [modenView setHidden:TRUE];
    [timeView setHidden:TRUE];
    [strengthView setHidden:TRUE];
    [updownView setHidden:TRUE];
    [settingView setHidden:TRUE];
    [topView.mImageView setHidden:NO];
     [topView.mBackBtn setHidden:NO];
    switch (index) {
            case 0:
        {
            [mainView setHidden:FALSE];
            [topView.mImageView setHidden:YES];
            [topView.mBackBtn setHidden:YES];
            [mainView setLanguage:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]]];
            break;
        }
        case 1:
        {
            [autoView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main1")];
            [autoView setBtnActionForAnimation];
           
        }
            break;
            case 2:
        {
            [manualView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main2")];
            [manualView setLanguage:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]]];
            break;
        }
            case 3:
        {
            [frequencuView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main3")];
            [frequencuView setLanguage:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]]];
            break;
        }
            case 4:
        {
            [musicView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main4")];
            break;
        }
            case 5:
        {
            [heatView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main5")];
            
            break;
        }
            case  6:
        {
            [modenView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main6")];
            [modenView setLanguage:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]]];
            break;
            
        }
            case 7:
        {
            [timeView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main7")];
            [timeView setLanguage:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]]];
            break;
        }
            case  8:
        {
            [strengthView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main8")];
            [strengthView setLanguage:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]]];
            break;
        }
            case 9:
        {
            [updownView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main9")];
            break;
        }
            case 10:
        {
            [settingView setHidden:FALSE];
            [topView.mImageView setImage:PNGIMAGE(@"main10")];
            [settingView setLanguageDic:[SettingView setLanguageForMainView:[StaticValueClass getsettingView]] selLanguage:[StaticValueClass getsettingView] setBg:[StaticValueClass getsettingBgView]];
            break;
        }
            
        default:
            break;
    }
 //   [[nibObjects objectAtIndex:index] setHidden:FALSE];
}
-(void)showIndexView:(NSInteger)index
{
    [self setCurrentView:index];
}
-(void)viewWillAppear:(BOOL)animated
{
    [EADSessionController sharedController];
}
-(void)hiddenLogoView
{
    [self.view setUserInteractionEnabled:YES];
   
}
-(void)sendMessageToMCUFiveTimes
{
    [self.mytimer setFireDate:[NSDate distantPast]];
    
  
}
-(void)sendMessage
{
    self.myTimer++;
    if (self.myTimer > 4) {
        [self.mytimer setFireDate:[NSDate distantFuture]];
        self.myTimer = 0;
    }
    [[EADSessionController sharedController] sendCommand];
}




-(void)sendMessageToRoStop
{
    [self.mytimer setFireDate:[NSDate distantPast]];
}

-(void)stopMessageToMCUFiveTimes
{
    [self.mytimer setFireDate:[NSDate distantFuture]];
    self.myTimer=0;
}




- (IBAction)OnBtnTouchUpAction:(UIButton *)sender {
   
}
-(void)initCurrentStatus
{
    [StaticValueClass StartBtnState:0];
  
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
