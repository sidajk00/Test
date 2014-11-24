//
//  HKPlayerPopViewController.m
//  NewConcept
//
//  Created by user on 14-5-18.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKPlayerPopViewController.h"
#import "HKLessonViewController.h"
#import "HKUtility.h"

#define Speed_1 0.5
#define Speed_2 0.7
#define Speed_3 1.0
#define Speed_4 1.5
#define Speed_5 2.0

@interface HKPlayerPopViewController ()

@end

@implementation HKPlayerPopViewController

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

- (void)loadTimeList
{
    _start = 0;
    if (_paraIndex > 0) {
        _start = [[_timeList objectAtIndex:_paraIndex - 1] floatValue];
    }
    _end = [[_timeList objectAtIndex:_paraIndex] floatValue];
    
    _player.currentTime = _start;
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
    
    BOOL play = NO;
    
    int index = _paraIndex;
    if (_playOrder == 1) {
        if (index < _paraCount - 1) {
            index++;
            play = YES;
        }
    }
    else if (_playOrder == 2) {
        play = YES;
    }
    else if (_playOrder == 3) {
        if (index < _paraCount - 1) {
            index++;
        }
        else {
            index = 0;
        }
        play = YES;
    }
    else if (_playOrder == 4) {
        index = rand() % _paraCount;
        play = YES;
    }
    else if (_playOrder == 5) {
        play = NO;
    }
    
    if (play) {
        [self playPara:index];
        [self updatePlayerButton];
        [self.delegate playerPopViewController:self playPara:index];
    }
}

- (void)playPara:(int)index
{
    if (index >= 0 && index < _paraCount) {
        _paraIndex = index;
        [self stop];
        [self reload];
        [self play];
    }
}

- (void)playingTimer:(NSTimer *)timer
{
    if ([_player isPlaying]) {
        if (_player.currentTime > _end) {
            [self finished];
        }
        else {
            _playBar.value = _player.currentTime - _start;
            if (!_playBar.isSliding) {
                _currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_playBar.value) / 60, (int)ceilf(_playBar.value) % 60];
            }
        }
    } else {
        //[self stop];
    }
}

- (void)loadPlayBar
{
    if (_playBar == nil) {
        _playBar = [[HKSlider alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width - 80, 20)];
        _playBar.delegate = self;
        _playBar.enabled = NO;
        _playBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
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
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)ceilf(_end - _start) / 60, (int)ceilf(_end - _start) % 60];
        [self.view addSubview:_totalTimeLabel];
    }
    _playBar.minimumValue = 0;
    _playBar.maximumValue = _end - _start;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
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
    else if (_playOrder == 5) {
        [_orderButton setImage:[UIImage imageNamed:@"order5.png"] forState:UIControlStateNormal];
    }
}

- (void)writePlist:(id)value key:(NSString *)key
{
    [HKUtility writePlistValue:@"Play" value:value key:key];
}

- (void)orderChanged
{
    [self updateOrder];
    
    [self writePlist:[NSNumber numberWithInt:_playOrder] key:@"P_Order"];
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
    [self writePlist:[NSNumber numberWithInt:_playSpeed] key:@"P_Speed"];
}

- (void)updatePlayerButton
{
    _playButton.buttonSelected = _player.isPlaying;
    
    _preButton.enabled = _paraIndex > 0;
    
    _nextButton.enabled = _paraIndex < _paraCount - 1;
    
    _stopButton.enabled = _player.isPlaying;
}

- (void)loadPlayerUI
{
    [self loadPlayBar];
    
    [self updatePlayerButton];
    [self speedChanged];
    [self orderChanged];
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
    [_player setNumberOfLoops:0];
    _player.enableRate = YES;
    [_player prepareToPlay];
    
    NSString *plistPath = [HKUtility plistPath:@"Play"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSNumber *speed = [dictionary objectForKey:@"P_Speed"];
    NSNumber *order = [dictionary objectForKey:@"P_Order"];
    _playSpeed = [speed intValue];
    _playOrder = [order intValue];
}

- (void)reload
{
    [self loadPlayer];
    [self loadTimeList];
    [self loadPlayerUI];
    
    //[self startRunloop];
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
    //[_delegate playerViewController:self paragraphIndex:_index];
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
    [_player play];
    _playBar.enabled = YES;
    _stopButton.enabled = YES;
    _playButton.buttonSelected = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingTimer:)  userInfo:nil repeats:YES];
}

- (void)pause
{
    [_player pause];
}

- (void)stop
{
    [_playButton setButtonSelected:NO];
    [_player stop];
    _player.currentTime = _start;
    [_timer invalidate];
    _timer = nil;
    _playBar.value = _playBar.minimumValue;
    _playBar.enabled = NO;
    _stopButton.enabled = NO;
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
    int index = _paraIndex;
    if (index + 1 < _paraCount) {
        index++;
        [self playPara:index];
        [self.delegate playerPopViewController:self playPara:index];
    }
    [self updatePlayerButton];
}

- (IBAction)goPre:(id)sender
{
    int index = _paraIndex;
    if (index > 0) {
        index--;
        [self playPara:index];
        [self.delegate playerPopViewController:self playPara:index];
        [self updatePlayerButton];
    }
}

- (IBAction)orderButtonClicked:(id)sender
{
    _playOrder++;
    if (_playOrder > 5) {
        _playOrder = 1;
    }
    [self orderChanged];
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

- (void)writeNewTimeList:(NSString *)newText
{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    NSString *fileName = [NSString stringWithFormat:@"tl%03d.txt", _lesson];
//    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Audio/03", _book]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    
//    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"/Users/user/Documents/Projects/NewConcept/NewConcept/Data/Book%d/Lesson/Lesson%03d.txt", _book, _lesson];
    //NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        
        //[fileManager createFileAtPath:filePath contents:nil attributes:nil];
        [newText writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"Lesson%03d.txt", _lesson];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Lesson", _book]];
    if ([fileManager fileExistsAtPath:path]) {
        
        //[fileManager createFileAtPath:path contents:nil attributes:nil];
        [newText writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)loadLessonData
{
    NSString *fileName = [NSString stringWithFormat:@"Lesson%03d.txt", _lesson];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Lesson", _book]];
    NSString *text = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *timeList = [NSMutableArray array];
    
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        
        //int index = 0;
        if ([line hasPrefix:@"["]) {
            NSRange range = [line rangeOfString:@"]"];
            CGFloat sec = [[line substringWithRange:NSMakeRange(1, range.location + 1)] floatValue];
            [timeList addObject:[NSNumber numberWithFloat:sec]];
            //index = (int)range.location + 1;
        }
    }
    self.timeList = timeList;;
}

- (IBAction)fixTime
{
    NSString *fileName = [NSString stringWithFormat:@"Lesson%03d.txt", _lesson];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Lesson", _book]];
    
    NSString *timesText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[timesText componentsSeparatedByString:@"\n"]];
    
    BOOL fixed = NO;
    if (_paraIndex > 0) {
        NSString *para = [array objectAtIndex:_paraIndex - 1];
        NSRange range = [para rangeOfString:@"]"];
        NSString *startStr = [[array objectAtIndex:_paraIndex - 1] substringWithRange:NSMakeRange(1, range.location - 1)];
        NSString *fixStart = _startTime.text;
        if (fixStart.length > 0) {
            CGFloat newStart = [startStr floatValue] + [fixStart floatValue];
            NSString *newPara = [NSString stringWithFormat:@"[%.3f]%@", newStart, [para substringFromIndex:range.location + 1]];
            [array replaceObjectAtIndex:_paraIndex - 1 withObject:newPara];
            fixed = YES;
        }
    }
    
    
    NSString *fixEnd = _endTime.text;
    NSString *para = [array objectAtIndex:_paraIndex];
    NSRange range = [para rangeOfString:@"]"];
    NSString *endStr = [para substringWithRange:NSMakeRange(1, range.location - 1)];
    if (fixEnd.length > 0) {
        CGFloat newEnd = [endStr floatValue] + [fixEnd floatValue];
        NSString *newPara = [NSString stringWithFormat:@"[%.3f]%@", newEnd, [para     substringFromIndex:range.location + 1]];
        [array replaceObjectAtIndex:_paraIndex withObject:newPara];
        fixed = YES;
    }
    if (fixed) {
        NSString *newText = [array componentsJoinedByString:@"\n"];
        [self writeNewTimeList:newText];
        HKLessonViewController *test = (HKLessonViewController *)self.delegate;
        [self loadLessonData];
        test.timeList = self.timeList;
        [_startTime resignFirstResponder];
        [_endTime resignFirstResponder];
        [self stop];
        [self reload];
        NSLog(@"new %@, old %@", newText, timesText);
    }
    _startTime.text = nil;
    _endTime.text = nil;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
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
    _player.currentTime = _playBar.value + _start;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
