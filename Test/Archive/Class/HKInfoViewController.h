//
//  HKInfoViewController.h
//  NewConcept
//
//  Created by user on 14-5-22.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSlider.h"
#import "NightmodeStyleButton.h"
#import "HKNightmodeStyle.h"
#import "HKUtility.h"

typedef NS_ENUM(NSInteger, LessonTextOption) {
    LessonTextEnglishAndChinese,
    LessonTextEnglish,
    LessonTextChinese,
};

@protocol HKInfoViewControllerDelegate <NSObject>

- (void)infoViewController:(id)sender brightness:(CGFloat)brightness;
- (void)infoViewController:(id)sender fontSize:(CGFloat)size;
- (void)infoViewControllerNightmodeChanged:(id)sender;
- (void)infoViewController:(id)sender changeLessonText:(LessonTextOption)option;
- (void)infoViewControllerOpenSetting:(id)sender;
- (void)infoViewController:(id)sender lessonMarkChanged:(LessonMark)mark;

@end

@interface HKInfoViewController : UIViewController <HKSliderDelegate>
{
    HKSlider *_brightnessSlider;
    HKSlider *_fontSlider;
    UIButton *_enchButton;
    UIButton *_enButton;
    UIButton *_chButton;
    
    UIButton *_nightmodeButton;
    UIButton *_hadReadButton;
    UIButton *_settingButton;
}

@property(nonatomic,assign) id<HKInfoViewControllerDelegate> delegate;
@property(nonatomic,assign) CGFloat brightness;
@property(nonatomic,assign) CGFloat fontSize;
@property(nonatomic,assign) LessonTextOption textOption;
@property(nonatomic,retain) HKNightmodeStyle *nightmodeStyle;
@property(nonatomic,assign) LessonMark mark;

@end
