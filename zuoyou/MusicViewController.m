//
//  MusicViewController.m
//  zuoyou
//
//  Created by microe on 8/12/14.
//  Copyright (c) 2014 microe. All rights reserved.
//

#import "MusicViewController.h"

@interface MusicViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *RealBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@end

@implementation MusicViewController

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
    NSLog(@"MusicController");
    [self setImageView:[StaticValueClass getsettingBgView]];
    
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:self.player];
    [notificationCenter addObserver:self
                           selector:@selector(nowPlayingItemState:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:self.player];
    
    [self.songLabel setAdjustsFontSizeToFitWidth:YES];
    [self.artistLabel setAdjustsFontSizeToFitWidth:YES];
    [self.player beginGeneratingPlaybackNotifications];
    [self isPlayNow];
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
-(void)isPlayNow
{
    MPMusicPlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        [self.playBtn setImage:PNGIMAGE(@"music3") forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        
        [self.playBtn setImage:PNGIMAGE(@"music6") forState:UIControlStateNormal];
        
        
        MPMediaItem *currentItem = [self.player nowPlayingItem];
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:self.musicImageView.frame.size];
        if (artworkImage == nil) {
            [self.musicImageView setImage:PNGIMAGE(@"music7")];
        }else
            [self.musicImageView setImage:artworkImage];
        [self.musicImageView setHidden:NO];
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        NSString *albumStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.artistLabel setText:[NSString stringWithFormat:@"%@ — %@", artistStr,albumStr]];
        [self.songLabel setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
        
    }
    
}
- (IBAction)rewindPressed:(id)sender {
    if ([self.player indexOfNowPlayingItem] == 0) {
        [self.player skipToBeginning];
    } else {
        [self.player endSeeking];
        [self.player skipToPreviousItem];
    }
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
    NSUInteger nowPlayingIndex = [self.player indexOfNowPlayingItem];
    [self.player endSeeking];
    [self.player skipToNextItem];
    if ([self.player nowPlayingItem] == nil) {
        if ([self.collection count] > nowPlayingIndex+1) {
            // added more songs while playing
            [self.player setQueueWithItemCollection:self.collection];
            MPMediaItem *item = [[self.collection items] objectAtIndex:nowPlayingIndex+1];
            [self.player setNowPlayingItem:item];
            [self.player play];
        }
        else {
            // no more songs
            [self.player stop];
        }
    }
}

- (IBAction)addPressed:(id)sender {
    MPMediaType mediaType = MPMediaTypeMusic;
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:mediaType];
    picker.delegate = self;
    [picker setAllowsPickingMultipleItems:YES];
    picker.prompt = NSLocalizedString(@"Select items to play", @"Select items to play");
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - Media Picker Delegate Methods

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {NSLog(@"%s", __func__);
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.collection == nil) {
        self.collection = mediaItemCollection;
        [self.player setQueueWithItemCollection:self.collection];
        MPMediaItem *item = [[self.collection items] objectAtIndex:0];
        [self.player setNowPlayingItem:item];
        [self playPausePressed:self];
    } else {
        NSArray *oldItems = [self.collection items];
        NSArray *newItems = [oldItems arrayByAddingObjectsFromArray:[mediaItemCollection items]];
        self.collection = [[MPMediaItemCollection alloc] initWithItems:newItems];
    }
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification Methods
-(void)nowPlayingItemState:(NSNotification *)notification
{
    MPMusicPlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
        NSLog(@"1");
        [self.playBtn setImage:PNGIMAGE(@"music3") forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        NSLog(@"2");
        [self.playBtn setImage:PNGIMAGE(@"music6") forState:UIControlStateNormal];
    }
}
- (void)nowPlayingItemChanged:(NSNotification *)notification
{
	MPMediaItem *currentItem = [self.player nowPlayingItem];
    if (nil == currentItem) {
        [self.musicImageView setImage:nil];
        [self.musicImageView setHidden:YES];
        [self.artistLabel setText:nil];
        [self.songLabel setText:nil];
    }
    else {
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        if (artwork) {
            UIImage *artworkImage = [artwork imageWithSize:self.musicImageView.frame.size];
            if (artworkImage == nil) {
                [self.musicImageView setImage:PNGIMAGE(@"music7")];
            }else
                [self.musicImageView setImage:artworkImage];
            [self.musicImageView setHidden:NO];
        }
        
        // Display the artist and song name for the now-playing media item
        NSString *artistStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        NSString *albumStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.artistLabel setText:[NSString stringWithFormat:@"%@ — %@", artistStr,albumStr]];
        [self.songLabel setText:[currentItem valueForProperty:MPMediaItemPropertyTitle]];
    }
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










@end
