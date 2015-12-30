//
//  ViewController.h
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MainView.h"
#import "AutoView.h"
#import "ManualView.h"
#import "LogoView.h"
#import "TopView.h"
#import "FrequencyView.h"
#import "MusicView.h"
#import "HeatView.h"
#import "ModenView.h"
#import "TimeView.h"
#import "UpDownView.h"
#import "ListView.h"
#import "SettingView.h"
#import "StrengthView.h"

@interface ViewController : UIViewController<MainViewDelegate,TopViewDelegate,ListDelegate,ManualViewDelegate,FrequencyViewDelegate,HeatViewDelegate,ModenViewDelegate,TimeViewDelegate,StrengthViewDelegate>
{
    LogoView *logoView;
    MainView *mainView;
    AutoView *autoView;
    ManualView *manualView;
    TopView *topView;
    FrequencyView *frequencuView;
    MusicView *musicView;
    HeatView *heatView;
    ModenView *modenView;
    TimeView *timeView;
    UpDownView *updownView;
    ListView *listView;
    SettingView *settingView;
    StrengthView *strengthView;
    
}
@property(nonatomic,assign)NSInteger myTimer;
@property (nonatomic, strong) NSTimer *mytimer;//没有接收到应答按键0.2s发送一次数据  UP
-(void)setCurrentView:(NSInteger)index;
@end
