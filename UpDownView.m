//
//  UpDownView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "UpDownView.h"
 static NSInteger myTimer = 0;
@implementation UpDownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)OnUpBtnDownAction:(UIButton *)sender {
   myTimer = 10;
    
    NSMutableArray *imagViewArray=[[NSMutableArray alloc] init];
    [self.UpDownImageView setImage:PNGIMAGE(@"backdeclieImag9")];
    for (NSString *img in self.arrayBackUp) {
        [imagViewArray addObject:PNGIMAGE(img)];
    }
    
    
    self.UpDownImageView.animationImages = imagViewArray;
    [self.UpDownImageView startAnimating];
    [self.mytimer setFireDate:[NSDate distantPast]];
    NSLog(@"down");
}//touch down

- (IBAction)OnDownBtnAction:(UIButton *)sender {
    [self.UpDownImageView stopAnimating];
    [self.mytimer  setFireDate:[NSDate distantFuture]];
    [self.mytimerDOWN setFireDate:[NSDate distantFuture]];
        [self.mytimerStop setFireDate:[NSDate distantPast]];
}//up inside
- (IBAction)OnDownBtnDownAction:(UIButton *)sender {
    myTimer = 10;
    
    NSMutableArray *imagViewArray=[[NSMutableArray alloc] init];
    [self.UpDownImageView setImage:PNGIMAGE(@"backdeclieImag1")];
    for (NSString *img in self.arrayBackDown) {
        [imagViewArray addObject:PNGIMAGE(img)];
    }
    
    self.UpDownImageView.animationImages = imagViewArray;
    [self.UpDownImageView startAnimating];
    [self.mytimerDOWN setFireDate:[NSDate distantPast]];
    NSLog(@"UP");
}//touch down
-(void)OnInitTime
{
    self.mytimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(sendMessageToRoUP) userInfo:nil repeats:YES];
    [self.mytimer setFireDate:[NSDate distantFuture]];
    self.mytimerDOWN = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(sendMessageToRoDOWN) userInfo:nil repeats:YES];
    [self.mytimerDOWN setFireDate:[NSDate distantFuture]];
    
    self.mytimerStop = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(sendMessageToRoStop) userInfo:nil repeats:YES];
    [self.mytimerStop setFireDate:[NSDate distantFuture]];
    
    
    
    [self.UpDownImageView setAnimationDuration:7];
    self.arrayBackUp= [[NSMutableArray alloc] initWithObjects:@"backdeclieImag1",@"backdeclieImag2",@"backdeclieImag3",@"backdeclieImag4",@"backdeclieImag5",@"backdeclieImag6",@"backdeclieImag7",@"backdeclieImag8",@"backdeclieImag9", nil];
    self.arrayBackDown= [[NSMutableArray alloc] initWithObjects:@"backdeclieImag9",@"backdeclieImag8",@"backdeclieImag7",@"backdeclieImag6",@"backdeclieImag5",@"backdeclieImag4",@"backdeclieImag3",@"backdeclieImag2",@"backdeclieImag1", nil];
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
    NSLog(@"stop======");
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
