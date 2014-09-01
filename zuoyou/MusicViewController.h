//
//  MusicViewController.h
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MusicViewController : UIViewController<MPMediaPickerControllerDelegate>
//音乐而生的两个
@property (strong, nonatomic) MPMusicPlayerController *player;
@property (strong, nonatomic) MPMediaItemCollection *collection;
@end
