//
//  StaticValueClass.h
//  zuoyou
//
//  Created by microe on 8/14/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticValueClass : NSObject
+(NSInteger)getStartBtnState;
+(NSInteger)getAutoView;
+(NSInteger)getManualView;
+(NSInteger)getFrequencyView;
+(NSInteger)getHeatingView;
+(NSInteger)getModeView;
+(NSInteger)gettimeView;
+(NSInteger)getstrengthView;
+(NSInteger)getsettingView;
+(NSInteger)getsettingBgView;

+(void)StartBtnState:(NSInteger)index;
+(void)autoView:(NSInteger)index;
+(void)manualView:(NSInteger)index;
+(void)frequencyView:(NSInteger)index;
+(void)heatingView:(NSInteger)index;
+(void)modeView:(NSInteger)index;
+(void)timeView:(NSInteger)index;
+(void)strengthView:(NSInteger)index;
+(void)settingView:(NSInteger)index;
+(void)settingBgView:(NSInteger)index;

@end
