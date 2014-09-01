//
//  StaticValueClass.m
//  zuoyou
//
//  Created by microe on 8/14/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "StaticValueClass.h"
static NSInteger startValue = 0;
static NSInteger autoValue = 0;
static NSInteger manualValue = 0;
static NSInteger frequencyValue = 0;
static NSInteger heatingValue = 0;
static NSInteger modeValue = 0;
static NSInteger timeValue = 0;
static NSInteger strengthValue = 0;
static NSInteger settingValue = 0;
static NSInteger settingBgValue = 0;
@implementation StaticValueClass
+(NSInteger)getStartBtnState
{
    return startValue;
}
+(NSInteger)getAutoView
{
    return autoValue;
}
+(NSInteger)getManualView
{
    return manualValue;
}
+(NSInteger)getFrequencyView
{
    return frequencyValue;
}
+(NSInteger)getHeatingView
{
    return heatingValue;
}
+(NSInteger)getModeView
{
    return modeValue;
}
+(NSInteger)gettimeView
{
    return timeValue;
}
+(NSInteger)getstrengthView
{
    return strengthValue;
}
+(NSInteger)getsettingView
{
    return settingValue;
}
+(NSInteger)getsettingBgView
{
    return settingBgValue;
}


+(void)StartBtnState:(NSInteger)index
{
    startValue = index;
}
+(void)autoView:(NSInteger)index
{
    autoValue = index;
}
+(void)manualView:(NSInteger)index
{
    manualValue = index;
}
+(void)frequencyView:(NSInteger)index
{
    frequencyValue = index;
}
+(void)heatingView:(NSInteger)index
{
    heatingValue = index;
}
+(void)modeView:(NSInteger)index
{
    modeValue = index;
}
+(void)timeView:(NSInteger)index
{
    timeValue = index;
}
+(void)strengthView:(NSInteger)index
{
    strengthValue = index;
}
+(void)settingView:(NSInteger)index
{
    settingValue = index;
}
+(void)settingBgView:(NSInteger)index
{
    settingBgValue = index;
}
@end
