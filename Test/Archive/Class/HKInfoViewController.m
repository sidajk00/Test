//
//  HKInfoViewController.m
//  NewConcept
//
//  Created by user on 14-5-22.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HKPushButton.h"
#import "HKUtility.h"


@interface HKInfoViewController ()

@end

@implementation HKInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadBrightnessSlider
{
    _brightnessSlider = [[HKSlider alloc] initWithFrame:CGRectZero];
    _brightnessSlider.thumbSize = 18;
    CGRect rect = CGRectMake(40, 20, self.view.frame.size.width - 80, 20);
    _brightnessSlider.frame = rect;
    _brightnessSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _brightnessSlider.minimumValue = 0;
    _brightnessSlider.maximumValue = 1;
    _brightnessSlider.value = _brightness;
    _brightnessSlider.delegate = self;
    [self.view addSubview:_brightnessSlider];
    
    UIButton *reduceBrightnessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rect = CGRectMake(0, 10, 40, 40);
    reduceBrightnessBtn.frame = rect;
    reduceBrightnessBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [reduceBrightnessBtn setImage:[UIImage imageNamed:@"light_small.png"] forState:UIControlStateNormal];
    [reduceBrightnessBtn addTarget:self action:@selector(reduceBrightnessClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reduceBrightnessBtn];
    
    UIButton *increaseBrightnessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rect = CGRectMake(self.view.frame.size.width - 40, 10, 40, 40);
    increaseBrightnessBtn.frame = rect;
    increaseBrightnessBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [increaseBrightnessBtn setImage:[UIImage imageNamed:@"light.png"] forState:UIControlStateNormal];
    [increaseBrightnessBtn addTarget:self action:@selector(increaseBrightnessClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:increaseBrightnessBtn];
}

- (void)loadFontSlider
{
    _fontSlider = [[HKSlider alloc] initWithFrame:CGRectZero];
    _fontSlider.thumbSize = 18;
    CGRect rect = CGRectMake(40, 60, self.view.frame.size.width - 80, 20);
    _fontSlider.frame = rect;
    _fontSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _fontSlider.minimumValue = 10;
    _fontSlider.maximumValue = 30;
    _fontSlider.value = _fontSize;
    _fontSlider.delegate = self;
    [self.view addSubview:_fontSlider];
    
    UIButton *reduceFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rect = CGRectMake(0, 50, 40, 40);
    reduceFontBtn.frame = rect;
    reduceFontBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    //[reduceFontBtn setImage:[UIImage imageNamed:@"bp_next.png"] forState:UIControlStateNormal];
    [reduceFontBtn setTitle:@"A-" forState:UIControlStateNormal];
    [reduceFontBtn addTarget:self action:@selector(reduceFontClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reduceFontBtn];
    
    UIButton *increaseFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rect = CGRectMake(self.view.frame.size.width - 40, 50, 40, 40);
    increaseFontBtn.frame = rect;
    increaseFontBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    //[increaseFontBtn setImage:[UIImage imageNamed:@"bp_next.png"] forState:UIControlStateNormal];
    [increaseFontBtn setTitle:@"A+" forState:UIControlStateNormal];
    [increaseFontBtn addTarget:self action:@selector(increaseFontClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:increaseFontBtn];
}

- (void)loadLessonOptions
{
    _enchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enchButton.frame = CGRectMake(20, 100, 30, 30);
    [_enchButton setTitle:@"英/中" forState:UIControlStateNormal];
    _enchButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _enchButton.layer.borderWidth = 1;
    _enchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _enchButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_enchButton addTarget:self action:@selector(englishAndChinese:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enchButton];
    
    _enButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _enButton.frame = CGRectMake((self.view.frame.size.width - 30)/2, 100, 30, 30);
    _enButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [_enButton setTitle:@"英" forState:UIControlStateNormal];
    _enButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _enButton.layer.borderWidth = 1;
    _enButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_enButton addTarget:self action:@selector(onlyEnglish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_enButton];
    
    _chButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chButton.frame = CGRectMake(self.view.frame.size.width - 20 - 30, 100, 30, 30);
    _chButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [_chButton setTitle:@"中" forState:UIControlStateNormal];
    _chButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _chButton.layer.borderWidth = 1;
    _chButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [_chButton addTarget:self action:@selector(onlyChinese:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chButton];
    
    [self updateTextOptionButtons];
}

- (void)loadNightmode
{
    _nightmodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nightmodeButton.frame = CGRectMake(20, 150, 30, 30);
    _nightmodeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_nightmodeButton setImage:[UIImage imageNamed:@"light.png"] forState:UIControlStateNormal];
    _nightmodeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_nightmodeButton addTarget:self action:@selector(nightmodeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nightmodeButton];
    
    if (_mark != LessonMarkNone) {
        _hadReadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hadReadButton.frame = CGRectMake((self.view.frame.size.width - 30)/2, 150, 30, 30);
        _hadReadButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        if (_mark == LessonMarkHasRead) {
            [_hadReadButton setImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
        }
        else {
            [_hadReadButton setImage:[UIImage imageNamed:@"known.png"] forState:UIControlStateNormal];
        }
        
        _hadReadButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_hadReadButton addTarget:self action:@selector(hadReadClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_hadReadButton];
    }
    
    _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingButton.frame = CGRectMake(self.view.frame.size.width - 50, 150, 30, 30);
    _settingButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    [_settingButton setImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    _settingButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_settingButton addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingButton];
    
    _nightmodeButton.selected = [[HKUtility plistValue:@"BookInfo" key:@"Nightmode"] boolValue];
    [self updateNightmodeButton];
}

- (UIColor *)rgb:(NSString *)colorString
{
    if ([colorString length] != 6) {
        return nil;
    }
    
    unsigned r = 0, g = 0, b = 0;
    
    NSString *value = [colorString substringToIndex:2];
    NSScanner* scan = [NSScanner scannerWithString:value];
    [scan scanHexInt:&r];
    
    value = [colorString substringWithRange:NSMakeRange(2, 2)];
    scan = [NSScanner scannerWithString:value];
    [scan scanHexInt:&g];

    
    value = [colorString substringFromIndex:4];
    scan = [NSScanner scannerWithString:value];
    [scan scanHexInt:&b];

    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1];
}

- (void)updateNightmodeButton
{
    if (_nightmodeButton.selected) {
        [_nightmodeButton setImage:[UIImage imageNamed:@"moon.png"] forState:UIControlStateNormal];
    }
    else {
        [_nightmodeButton setImage:[UIImage imageNamed:@"light.png"] forState:UIControlStateNormal];
    }
}

- (void)nightmodeClicked:(id)sender
{
    _nightmodeButton.selected = !_nightmodeButton.selected;
    
    [self updateNightmodeButton];
    
    [HKUtility writePlistValue:@"BookInfo" value:[NSNumber numberWithBool:_nightmodeButton.selected] key:@"Nightmode"];
    [self.delegate infoViewControllerNightmodeChanged:self];
}

- (void)hadReadClicked:(id)sender
{
    if (_mark == LessonMarkHasRead) {
        _mark = LessonMarkLearnt;
    }
    else {
        _mark = LessonMarkHasRead;
    }
    [self.delegate infoViewController:self lessonMarkChanged:_mark];
    
    if (_mark == LessonMarkHasRead) {
        [_hadReadButton setImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
    }
    else {
        [_hadReadButton setImage:[UIImage imageNamed:@"known.png"] forState:UIControlStateNormal];
    }
}

- (void)setting:(id)sender
{
    [self.delegate infoViewControllerOpenSetting:self];
}

- (void)updateTextOptionButtons
{
    if (_textOption == LessonTextEnglishAndChinese) {
        _enchButton.selected = YES;
        _enchButton.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else {
        _enchButton.selected = NO;
        _enchButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    if (_textOption == LessonTextEnglish) {
        _enButton.selected = YES;
        _enButton.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else {
        _enButton.selected = NO;
        _enButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    
    if (_textOption == LessonTextChinese) {
        _chButton.selected = YES;
        _chButton.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else {
        _chButton.selected = NO;
        _chButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

- (void)englishAndChinese:(id)sender
{
    self.textOption = LessonTextEnglishAndChinese;
    [self updateTextOptionButtons];
    [self.delegate infoViewController:self changeLessonText:LessonTextEnglishAndChinese];
}

- (void)onlyEnglish:(id)sender
{
    self.textOption = LessonTextEnglish;
    [self updateTextOptionButtons];
    [self.delegate infoViewController:self changeLessonText:LessonTextEnglish];
}

- (void)onlyChinese:(id)sender
{
    self.textOption = LessonTextChinese;
    [self updateTextOptionButtons];
    [self.delegate infoViewController:self changeLessonText:LessonTextChinese];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadBrightnessSlider];
    [self loadFontSlider];
    [self loadLessonOptions];
    [self loadNightmode];
}

- (void)reduceBrightnessClicked:(id)sender
{
    if (_brightnessSlider.value > 0) {
        _brightnessSlider.value -= 0.1;
        [self.delegate infoViewController:self brightness:_brightnessSlider.value];
    }
}

- (void)increaseBrightnessClicked:(id)sender
{
    if (_brightnessSlider.value < _brightnessSlider.maximumValue) {
        _brightnessSlider.value += 0.1;
        [self.delegate infoViewController:self brightness:_brightnessSlider.value];
    }
}

- (void)reduceFontClicked:(id)sender
{
    if (_fontSlider.value > 0) {
        _fontSlider.value -= (_fontSlider.maximumValue - _fontSlider.minimumValue) / 10;
        [self.delegate infoViewController:self fontSize:_fontSlider.value];
    }
}

- (void)increaseFontClicked:(id)sender
{
    if (_fontSlider.value < _fontSlider.maximumValue) {
        _fontSlider.value += (_fontSlider.maximumValue - _fontSlider.minimumValue) / 10;
        [self.delegate infoViewController:self fontSize:_fontSlider.value];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - HKSliderDelegate
- (void)sliderValueChanging:(id)sender
{
    if (sender == _brightnessSlider) {
        [self.delegate infoViewController:self brightness:_brightnessSlider.value];
    }
    else if (sender == _fontSlider) {
        [self.delegate infoViewController:self fontSize:_fontSlider.value];
    }
}

- (void)sliderValueChanged:(id)sender
{
    if (sender == _brightnessSlider) {
        [self.delegate infoViewController:self brightness:_brightnessSlider.value];
    }
    else if (sender == _fontSlider) {
        [self.delegate infoViewController:self fontSize:_fontSlider.value];
    }
}

@end
