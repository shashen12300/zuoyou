//
//  MusicView.h
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MusicView : UIView<MPMediaPickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) UIViewController *rootViewCtrl;
@property (strong, nonatomic) MPMediaItemCollection *collection;
@property (nonatomic, strong) MPMusicPlayerController *player;
@property (weak, nonatomic) IBOutlet UIImageView *mImageBg;

//@property (nonatomic, strong) UITableView *musicTableView;
@property (nonatomic, strong) NSMutableArray *musicArray;
-(void)initMusicStaup;
@end
