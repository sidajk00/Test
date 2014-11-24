//
//  HKPlayerViewController.h
//  NewConcept
//
//  Created by user on 14-5-10.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HKPushButton.h"
#import "HKSlider.h"

@protocol HKPlayerViewControllerDelegate <NSObject>

- (void)playerViewController:(id)sender paragraphIndex:(int)index;
//return new lesson
- (int)playerViewControllerNextLesson:(id)sender;
- (int)playerViewControllerPreLesson:(id)sender;
- (BOOL)playerViewControllerOpenLesson:(int)lesson;
- (int)playerViewControllerOpenRandomLesson;
- (void)playerDidStop:(id)sender;
- (void)playerViewController:(id)sender playListClicked:(UIButton *)btn;

@end

@interface HKPlayerViewController : UIViewController<AVAudioPlayerDelegate, HKSliderDelegate>
{
    int _index;
    BOOL _runThread;
    NSString *_currentAudio;
    HKSlider *_playBar;
    UILabel *_currentTimeLabel;
    UILabel *_totalTimeLabel;
    int _playOrder;
    int _playSpeed;
    NSTimer *_timer;
    
    BOOL _autoPlay;
}

@property (nonatomic, assign) int book;
@property (nonatomic, assign) int lesson;
@property (nonatomic, assign) int contentCount;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSArray *playList;

@property (weak, nonatomic) IBOutlet HKPushButton *playButton;
@property (nonatomic, assign) id<HKPlayerViewControllerDelegate> delegate;

@property (nonatomic, retain) NSArray *timeList;
@property (nonatomic, retain) NSThread *runLoopThread;

@property (nonatomic, assign) BOOL americanEnglish;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *speedButton;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)playVioce:(id)sender;

- (IBAction)goNext:(id)sender;

- (IBAction)goPre:(id)sender;

- (IBAction)orderButtonClicked:(id)sender;

- (IBAction)speedButtonClicked:(id)sender;

- (IBAction)stopClicked:(id)sender;

- (IBAction)playListClicked:(id)sender;

- (void)stop;

- (void)playAtPara:(int)paraIndex;

- (BOOL)isPlaying;

- (void)reload;

@end
