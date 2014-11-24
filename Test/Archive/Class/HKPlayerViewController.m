//
//  HKPlayerViewController.m
//  NewConcept
//
//  Created by user on 14-5-10.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKPlayerViewController.h"
#import "HKUtility.h"


#define Speed_1 0.5
#define Speed_2 0.7
#define Speed_3 1.0
#define Speed_4 1.5
#define Speed_5 2.0


@interface HKPlayerViewController ()

@end

@implementation HKPlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _index = -1;
        _americanEnglish = YES;
        _playOrder = 1;
        _playSpeed = 3;
    }
    return self;
}

- (void)startRunloop
{
    if (_runLoopThread == nil) {
        _runThread = YES;
        self.runLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(jumpParaRunLoop) object:nil];
        
        [_runLoopThread setName:@"JumpRunLoopThread"];
        [_runLoopThread start];
    }
}

- (void)finished
{
    [self stop];
    
    if (_playOrder == 1) {
        if ([self gotoNextLesson]) {
            _autoPlay = YES;
        }
    }
    else if (_playOrder == 3) {
        if ([self gotoNextLesson]) {
            _autoPlay = YES;
        }
        else {
            if ([self.delegate playerViewControllerOpenLesson:1]) {
                //[self loadNewLesson:1];
            }
            _autoPlay = YES;
        }
    }
    else if (_playOrder == 4) {
        [self.delegate playerViewControllerOpenRandomLesson];
        //[self loadNewLesson:newLesson];
        _autoPlay = YES;
    }
}

- (void)playingTimer:(NSTimer *)timer
{
    if ([_player isPlaying]) {
        _playBar.value = _player.currentTime;
        if (!_playBar.isSliding) {
            _currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_player.currentTime) / 60, (int)ceilf(_player.currentTime) % 60];
        }
        
        NSInteger count = [_timeList count];
        for (int i = 0; i < count; i++) {
            NSNumber *time = [_timeList objectAtIndex:i];
            if (_player.currentTime < [time floatValue]) {
                if (_index != i) {
                    NSLog(@"index %d", i);
                    _index = i;
                    [self performSelectorOnMainThread:@selector(playNextParagraph) withObject:nil waitUntilDone:YES];
                }
                break;
            }
        }
    }
}

- (void)updateTimeLabels
{
    _currentTimeLabel.text = @"00:00";
    _totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_player.duration) / 60, (int)ceilf(_player.duration) % 60];
}

- (void)loadPlayBar
{
    if (_playBar == nil) {
        _playBar = [[HKSlider alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width - 80, 20)];
        _playBar.minimumValue = 0;
        _playBar.maximumValue = _player.duration;
        _playBar.delegate = self;
        _playBar.enabled = NO;
        [self.view addSubview:_playBar];
        
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        _currentTimeLabel.font = [UIFont systemFontOfSize:10];
        _currentTimeLabel.text = @"00:00";
        [self.view addSubview:_currentTimeLabel];
        
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40, 0, 40, 20)];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        _totalTimeLabel.font = [UIFont systemFontOfSize:10];
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_player.duration) / 60, (int)ceilf(_player.duration) % 60];
        [self.view addSubview:_totalTimeLabel];
    }
    
    _playBar.minimumValue = 0;
    _playBar.maximumValue = _player.duration;
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)updateOrder
{
    if (_playOrder == 1) {
        [_orderButton setImage:[UIImage imageNamed:@"order1.png"] forState:UIControlStateNormal];
    }
    else if (_playOrder == 2) {
        [_orderButton setImage:[UIImage imageNamed:@"order2.png"] forState:UIControlStateNormal];
    }
    else if (_playOrder == 3) {
        [_orderButton setImage:[UIImage imageNamed:@"order3.png"] forState:UIControlStateNormal];
    }
    else if (_playOrder == 4) {
        [_orderButton setImage:[UIImage imageNamed:@"order4.png"] forState:UIControlStateNormal];
    }
}

- (void)orderChanged
{
    [self updateOrder];
    
    [self writePlist:[NSNumber numberWithInt:_playOrder] key:@"Order"];
}

- (void)updateSpeed
{
    if (_playSpeed == 1) {
        _player.rate = Speed_1;
        [_speedButton setImage:[UIImage imageNamed:@"speed1.png"] forState:UIControlStateNormal];
    }
    else if (_playSpeed == 2) {
        _player.rate = Speed_2;
        [_speedButton setImage:[UIImage imageNamed:@"speed2.png"] forState:UIControlStateNormal];
    }
    else if (_playSpeed == 3) {
        _player.rate = Speed_3;
        [_speedButton setImage:[UIImage imageNamed:@"speed3.png"] forState:UIControlStateNormal];
    }
    else if (_playSpeed == 4) {
        _player.rate = Speed_4;
        [_speedButton setImage:[UIImage imageNamed:@"speed4.png"] forState:UIControlStateNormal];
    }
    else if (_playSpeed == 5) {
        _player.rate = Speed_5;
        [_speedButton setImage:[UIImage imageNamed:@"speed5.png"] forState:UIControlStateNormal];
    }
}

- (void)speedChanged
{
    [self updateSpeed];
    [self writePlist:[NSNumber numberWithInt:_playSpeed] key:@"Speed"];
}

- (void)updatePlayerButton
{
    _preButton.enabled = _lesson > 1;
    
    if (_book == 1) {
        _nextButton.enabled = _lesson < _contentCount - 1;
    }
    else {
        _nextButton.enabled = _lesson < _contentCount;
    }
    _stopButton.enabled = _player.isPlaying;
}

- (void)loadPlayerUI
{
    [self updatePlayerButton];
    [self updateSpeed];
    [self updateOrder];
    [self loadPlayBar];
}

- (void)loadPlayer
{
    NSString *audioFileName = [NSString stringWithFormat:@"ly%03d.mp3", _lesson];
    _currentAudio = audioFileName;
    NSString* audioPath = [[NSBundle mainBundle] pathForResource:audioFileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Audio/%@", _book, _americanEnglish ? @"02" : @"01"]];
    
    
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    _player.delegate = self;
    [_player setVolume:1];
    if (_playOrder == 2) {
        [_player setNumberOfLoops:-1];
    }
    else {
        [_player setNumberOfLoops:0];
    }
    
    _player.enableRate = YES;
    [_player prepareToPlay];
    
    NSString *plistPath = [HKUtility plistPath:@"Play"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSNumber *speed = [dictionary objectForKey:@"Speed"];
    NSNumber *order = [dictionary objectForKey:@"Order"];
    _playSpeed = [speed intValue];
    _playOrder = [order intValue];
    
    [self updateTimeLabels];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //让app支持接受远程控制事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    _playButton.showsTouchWhenHighlighted = YES;
    _playButton.buttonNormalImage = [UIImage imageNamed:@"play.png"];
    _playButton.buttonSelectedImage = [UIImage imageNamed:@"pause.png"];
    
    [self reload];

    //[self startRunloop];
}

- (void)reload
{
    [self loadPlayer];
    [self loadPlayerUI];
    
    if (_autoPlay) {
        [self play];
        _autoPlay = NO;
    }
}

- (void)viewDidUnload
{
    _playBar = nil;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)playNextParagraph
{
    [_delegate playerViewController:self paragraphIndex:_index];
}

- (void)jumpParaRunLoop
{
    while (_runThread) {
        [[NSRunLoop currentRunLoop] run];
        
        NSInteger count = [_timeList count];
        for (int i = 0; i < count; i++) {
            NSNumber *time = [_timeList objectAtIndex:i];
            if (_player.currentTime < [time floatValue]) {
                if (_index != i) {
                    _index = i;
                    [self performSelectorOnMainThread:@selector(playNextParagraph) withObject:nil waitUntilDone:YES];
                }
                break;
            }
        }
    }
}

- (void)play
{
    _playBar.enabled = YES;
    _stopButton.enabled = YES;
    _playButton.buttonSelected = YES;
    [_player play];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playingTimer:)  userInfo:nil repeats:YES];
}

- (void)pause
{
    [_player pause];
}

- (void)stop
{
    [_playButton setButtonSelected:NO];
    [_player stop];
    _player.currentTime = 0;
    [_timer invalidate];
    _timer = nil;
    _playBar.value = _playBar.minimumValue;
    _playBar.enabled = NO;
    _stopButton.enabled = NO;
    [self.delegate playerDidStop:self];
}

- (BOOL)isPlaying
{
    return [_player isPlaying];
}

- (void)playAtPara:(int)paraIndex
{
    if ([_player isPlaying]) {
        CGFloat time = 0;
        int index = paraIndex - 1;
        if (index >= 0) {
            time = [[_timeList objectAtIndex:index] floatValue];
        }
        _player.currentTime = time;
    }
}

- (void)writePlist:(id)value key:(NSString *)key
{
    [HKUtility writePlistValue:@"Play" value:value key:key];
}

- (void)loadNewLesson:(int)newLesson
{
    _lesson = newLesson;
    [self reload];
    [self updatePlayerButton];
}

- (BOOL)gotoNextLesson
{
    int newLesson = [self.delegate playerViewControllerNextLesson:self];
    if (newLesson != _lesson) {
        //[self loadNewLesson:newLesson];
        return YES;
    }
    return NO;
}

- (IBAction)playVioce:(id)sender
{
    if (_playButton.buttonSelected) {
        [self play];
    } else {
        [self pause];
    }
}

- (IBAction)goNext:(id)sender
{
    [self stop];
    [self gotoNextLesson];
}

- (IBAction)goPre:(id)sender
{
    int newLesson = [self.delegate playerViewControllerPreLesson:self];
    if (newLesson != _lesson) {
        _lesson = newLesson;
        [self stop];
        [self reload];
        [self updatePlayerButton];
    }
}

- (IBAction)orderButtonClicked:(id)sender
{
    _playOrder++;
    if (_playOrder >= 5) {
        _playOrder = 1;
    }
    [self orderChanged];
    
    if (_playOrder == 2) {
        [_player setNumberOfLoops:-1];
    }
    else {
        [_player setNumberOfLoops:0];
    }
}

- (IBAction)speedButtonClicked:(id)sender
{
    _playSpeed++;
    if (_playSpeed >= 6) {
        _playSpeed = 1;
    }
    [self speedChanged];
}

- (IBAction)stopClicked:(id)sender
{
    [self stop];
}

- (IBAction)playListClicked:(id)sender
{
    [self.delegate playerViewController:self playListClicked:sender];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _runThread = NO;
    _runLoopThread = nil;
    
    [self finished];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    NSLog(@"123");
}

#pragma mark - HKSliderDelegate
- (void)sliderValueChanging:(id)sender
{
    _currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_playBar.value) / 60, (int)ceilf(_playBar.value) % 60];
}

- (void)sliderValueChanged:(id)sender
{
    _currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_playBar.value) / 60, (int)ceilf(_playBar.value) % 60];
    if (_player.duration < _playBar.value) {
        [self finished];
    }
    else {
        _player.currentTime = _playBar.value;
    }
}

@end
