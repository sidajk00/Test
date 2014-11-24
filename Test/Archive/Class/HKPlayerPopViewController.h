//
//  HKPlayerPopViewController.h
//  NewConcept
//
//  Created by user on 14-5-18.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HKPushButton.h"
#import "HKSlider.h"
#import "HKPlayerViewController.h"

@protocol HKPlayerPopViewControllerDelegate <NSObject>

- (void)playerPopViewController:(id)sender playPara:(int)index;

@end
@interface HKPlayerPopViewController : UIViewController<AVAudioPlayerDelegate, HKSliderDelegate, UITextFieldDelegate>
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
    CGFloat _start;
    CGFloat _end;
}

@property (nonatomic, assign) int book;
@property (nonatomic, assign) int lesson;
@property (nonatomic, assign) int paraIndex;
@property (nonatomic, assign) int paraCount;
@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSArray *playList;

@property (weak, nonatomic) IBOutlet HKPushButton *playButton;
@property (nonatomic, assign) id<HKPlayerPopViewControllerDelegate> delegate;

@property (nonatomic, retain) NSArray *timeList;
@property (nonatomic, retain) NSThread *runLoopThread;

@property (nonatomic, assign) BOOL americanEnglish;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *speedButton;
@property (weak, nonatomic) IBOutlet UIButton *preButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *startTime;
@property (weak, nonatomic) IBOutlet UITextField *endTime;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

- (IBAction)playVioce:(id)sender;

- (IBAction)goNext:(id)sender;

- (IBAction)goPre:(id)sender;

- (IBAction)orderButtonClicked:(id)sender;

- (IBAction)speedButtonClicked:(id)sender;

- (IBAction)stopClicked:(id)sender;

- (void)reload;

- (void)play;

- (void)stop;

- (IBAction)fixTime;

@end
