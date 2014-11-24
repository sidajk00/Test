//
//  HKSlider.h
//  NewConcept
//
//  Created by user on 14-5-15.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKSliderDelegate <NSObject>
@optional
- (void)sliderValueChanging:(id)sender;

- (void)sliderValueChanged:(id)sender;

@end

@interface HKSlider : UIControl
{
    NSMutableDictionary *_thumbImageDict;
    UIButton *_thumb;
    UIImageView *_minView;
    UIImageView *_maxView;
    CGPoint _fixHitTest;
}

@property (nonatomic, assign) id<HKSliderDelegate> delegate;

@property (nonatomic, assign) CGFloat thumbSize;

@property(nonatomic) float value;                                 // default 0.0. this value will be pinned to min/max
@property(nonatomic, assign) BOOL isSliding;

@property(nonatomic) float minimumValue;                          // default 0.0. the current value may change if outside new min value
@property(nonatomic) float maximumValue;                          // default 1.0. the current value may change if outside new max value

@property(nonatomic,retain) UIImage *minimumValueImage;          // default is nil. image that appears to left of control (e.g. speaker off)
@property(nonatomic,retain) UIImage *maximumValueImage;          // default is nil. image that appears to right of control (e.g. speaker max)

@property(nonatomic,getter=isContinuous) BOOL continuous;        // if set, value change events are generated any time the value changes due to dragging. default = YES

@property(nonatomic,retain) UIColor *minimumTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,retain) UIColor *maximumTrackTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nonatomic,retain) UIColor *thumbTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state;
- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state;
- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state;

@end
