//
//  MusicView.m
//  zuoyou
//
//  Created by Ricky on 15-10-31.
//  Copyright (c) 2015年 microe. All rights reserved.
//

#import "MusicView.h"

@interface MusicView()
@property (nonatomic, strong) NSNumber *totalTime;
@property (nonatomic, strong) NSTimer *timer;

@end
@implementation MusicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //[self initMusicStaup];
}
-(void)initMusicStaup
{
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    self.player.repeatMode = MPMusicRepeatModeAll;
   // self.player.shuffleMode = MPMusicShuffleModeOff;
    _musicArray = [[NSMutableArray alloc] init];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_NowPlayingItemChanged:)
     name:        MPMusicPlayerControllerNowPlayingItemDidChangeNotification
     object:      self.player];
    
    [notificationCenter
     addObserver: self
     selector:    @selector (handle_PlaybackStateChanged:)
     name:        MPMusicPlayerControllerPlaybackStateDidChangeNotification
     object:      self.player];
    
    [self.player beginGeneratingPlaybackNotifications];
    
    
    
    [self setCurrentState];
    [self mediaPlayPicker];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
   
      [self.tableView reloadData];
    [self.tableView setHidden:true];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapGestureRecognizer:)];
//    [self addGestureRecognizer:tap];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  
    if ([self.tableView isHidden]) {
        return;
    }
      NSLog(@"HelloWorld");
    [self.tableView setHidden:true];
}
-(void)isPlayPause
{
    MPMusicPlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.playBtn setBackgroundImage:PNGIMAGE(@"music3") forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.playBtn setBackgroundImage:PNGIMAGE(@"music6") forState:UIControlStateNormal];
    }
}
-(void)handle_NowPlayingItemChanged:(id)musicObject
{
    NSNotification * notific = (NSNotification *)musicObject;
    NSDictionary *dic = notific.userInfo;
    [self  setCurrentState];
    NSLog(@"musicObject: %@",dic);
}
-(void)setCurrentState
{
    MPMediaItem *currentMusic = self.player.nowPlayingItem;
    MPMediaItemArtwork *artwork =
    [currentMusic valueForProperty: MPMediaItemPropertyArtwork];
    UIImage *artworkImage =
    [artwork imageWithSize: self.musicImageView.bounds.size];
    if (artworkImage == nil) {
        artworkImage = PNGIMAGE(@"music7");
    }
    NSString *strName = [currentMusic valueForProperty: MPMediaItemPropertyTitle];
    [self.songLabel setText:strName];
    
    NSString *artistStr = [currentMusic valueForProperty:MPMediaItemPropertyArtist];
    if (artistStr== nil) {
        artistStr = @"None";
    }
    [self.artistLabel setText:artistStr];
    self.musicImageView.image = artworkImage;
    
}
- (void)mediaPlayPicker {
    
   // MPMediaQuery *myPlaylistsQuery = [MPMediaQuery songsQuery];  //albumsQuery 资料库   playlistsQuery  播放列表
     MPMediaQuery *myPlaylistsQuery = [MPMediaQuery songsQuery];
    
    NSArray *playlists = [myPlaylistsQuery collections];
    NSMutableArray *array = [NSMutableArray new];
    self.collection = nil;
    for (MPMediaPlaylist *playlist in playlists) {
        NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        if ([playlist items].count) {
            
            if (self.collection == nil) {
                self.collection = playlist;
                
                
            } else {
                NSArray *oldItems = [self.collection items];
                NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[playlist items]];
                self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
            }
            
            NSArray *songs = [playlist items];
            for (MPMediaItem *song in songs) {
                NSMutableDictionary *dic = [NSMutableDictionary new];
                NSString *artistStr = [song valueForProperty:MPMediaItemPropertyArtist];
                NSString *albumStr = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                NSString *musicTitle = [song valueForProperty:MPMediaItemPropertyTitle];
                NSString *musicAttribute = [NSString stringWithFormat:@"%@", artistStr];
                [dic setObject:song forKey:@"music"];
                [dic setObject:musicAttribute forKey:@"Attribute"];
                [dic setObject:albumStr forKey:@"subtitle"];
                [dic setObject:musicTitle forKey:@"title"];
                [array addObject:dic];
            }
        }
    }
    [self.player setQueueWithItemCollection:self.collection];
    _musicArray = array;
    
  }
-(void)handle_PlaybackStateChanged:(id)musicObject
{
    NSNotification * notific = (NSNotification *)musicObject;
    NSDictionary *dic = notific.userInfo;
    NSLog(@"musicObject: %@",dic);
    NSString *str = [dic valueForKey:@"MPMusicPlayerControllerPlaybackStateKey"];
    NSLog(@"strstrstr%@",str);
    if ([str integerValue]==1) {
        [self.playBtn setBackgroundImage:PNGIMAGE(@"music6") forState:UIControlStateNormal];
        [self  setCurrentState];
    }
    else if ([str integerValue] == 2)
    {
        [self.playBtn setBackgroundImage:PNGIMAGE(@"music3") forState:UIControlStateNormal];
    }
}



- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)rewindPressed:(id)sender {
    
//    if ([self.player indexOfNowPlayingItem] == 0) {
//        [self.player skipToBeginning];
//    } else {
//        [self.player endSeeking];
        [self.player skipToPreviousItem];
   // }

}


- (IBAction)playPausePressed:(id)sender {
    MPMusicPlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.player play];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.player pause];
    }
}

- (IBAction)fastForwardPressed:(id)sender {
   // NSInteger nowPlayingIndex = [self.player indexOfNowPlayingItem];
    //if (nowPlayingIndex+1 <[self.collection count]) {
        //[self.player endSeeking];
        [self.player skipToNextItem];
   // }
    
//    if ([self.player nowPlayingItem] == nil) {
//        if ([self.collection count] > nowPlayingIndex+1) {
//            // added more songs while playing
//            [self.player setQueueWithItemCollection:self.collection];
//            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
//            [self.player setNowPlayingItem:item];
//            [self.player play];
//        }
//        else {
//            // no more songs
//            [self.player stop];
//            
//        }
//    }
}
- (IBAction)addPressed:(id)sender {
    
   // [self mediaPlayPicker];
     [self.tableView setHidden:NO];
    [self.tableView reloadData];
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   // NSLog(@"歌曲数量 : %d      %d",_musicArray.count,[self.collection items].count);
    return _musicArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }

    [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
    [cell setBackgroundColor: [UIColor colorWithRed:41/255.0f green:36/255.0f blue:33/255.0f alpha:1] ];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = _musicArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    [self.player setQueueWithItemCollection:self.collection];
    MPMediaItem *item = [[self.collection items]objectAtIndex:indexPath.row];
    [self.player setNowPlayingItem:item];
    [self.player play];
    tableView.hidden = YES;
    
}
@end
