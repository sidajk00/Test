//
//  HKSlider.m
//  NewConcept
//
//  Created by user on 14-5-15.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKSlider.h"
#import "HKUtility.h"
#import <QuartzCore/QuartzCore.h>

@implementation HKSlider

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    _thumb.enabled = enabled;
    if (enabled) {
        [_maxView setBackgroundColor:_maximumTrackTintColor];
    }
    else {
        [_maxView setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)initialize
{
    _fixHitTest.x = -1;
    
    _thumbImageDict = [NSMutableDictionary dictionary];
    _value = 0.0f;
    _minimumValue = 0.0f;
    _maximumValue = 1.0f;
    _continuous = YES;
    self.minimumTrackTintColor = [UIColor colorWithRed:77/255.0 green:184/255.0 blue:74/255.0 alpha:1];
    self.maximumTrackTintColor = [UIColor lightGrayColor];
    self.thumbTintColor = [UIColor whiteColor];
    _thumbSize = 15;
    
    _minView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 2) / 2, self.frame.size.width, 2)];
    _minView.backgroundColor = _minimumTrackTintColor;
    [self addSubview:_minView];
    _maxView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 2) / 2, self.frame.size.width, 2)];
    _maxView.backgroundColor = _maximumTrackTintColor;
    [self addSubview:_maxView];
    
    _thumb = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - _thumbSize) / 2, _thumbSize, _thumbSize)];
    
    [_thumb setImage:[HKUtility imageWithColor:[UIColor whiteColor] size:CGSizeMake(_thumbSize * 2, _thumbSize * 2) isCircle:YES] forState:UIControlStateNormal];
    [_thumb setImage:[HKUtility imageWithColor:[UIColor grayColor] size:CGSizeMake(_thumbSize * 2, _thumbSize * 2) isCircle:YES] forState:UIControlStateDisabled];
    
    _thumb.layer.shadowColor = [UIColor blackColor].CGColor;
    _thumb.layer.shadowOffset = CGSizeMake(0, 1);
    _thumb.layer.shadowOpacity = 0.8;
    _thumb.layer.shadowRadius = 0.5;
    _thumb.userInteractionEnabled = NO;
    
    [self addSubview:_thumb];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (BOOL)isValidState:(UIControlState)state
{
    if (state == UIControlStateNormal || state == UIControlStateHighlighted || state == UIControlStateDisabled || state == UIControlStateSelected) {
        return YES;
    }
    
    return NO;
}

- (void)setThumbImage:(UIImage *)image forState:(UIControlState)state
{
    if (image && [self isValidState:state]) {
        [_thumbImageDict setObject:image forKey:[NSNumber numberWithInt:state]];
    }
}

- (void)setMinimumTrackImage:(UIImage *)image forState:(UIControlState)state
{
    
}

- (void)setMaximumTrackImage:(UIImage *)image forState:(UIControlState)state
{
    
}

- (void)updateThumbLocation
{
    if (_maximumValue - _minimumValue > 0.000001) {
        _minView.frame = CGRectMake(0, (self.frame.size.height - 2) / 2, self.frame.size.width, 2);
        CGFloat pos = (self.frame.size.width - _thumbSize) * (_value - _minimumValue) / (_maximumValue - _minimumValue);
        _maxView.frame = CGRectMake(pos, (self.frame.size.height - 2) / 2, self.frame.size.width - pos, 2);
        _thumb.frame = CGRectMake(pos, (self.frame.size.height - _thumbSize) / 2, _thumbSize, _thumbSize);
    }
}

- (void)setValue:(float)value
{
    if (!_isSliding) {
        [self valueChanged:value];
    }
}

- (void)valueChanged:(CGFloat)newValue
{
    if (newValue < _minimumValue) {
        newValue = _minimumValue;
    }
    if (newValue > _maximumValue) {
        newValue = _maximumValue;
    }
    _value = newValue;
    
    [self updateThumbLocation];
}

- (BOOL)ptInClient:(CGPoint)pt
{
    CGRect rect = CGRectMake(0, (self.frame.size.height - _thumbSize) / 2, self.frame.size.width, _thumbSize);
    return CGRectContainsPoint(rect, pt);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *subview = [super hitTest:point withEvent:event];
    
    if ([self pointInside:point withEvent:event]) {
        if (self.enabled && [self ptInClient:point]) {
            return self;
        }
        else {
            return nil;
        }
    }
    
    return subview;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _fixHitTest.x = -1;
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGRect thumbRect = _thumb.frame;
    thumbRect.origin.x -= 5;
    thumbRect.origin.y -= 5;
    thumbRect.size.width += 5;
    thumbRect.size.height += 5;
    CGPoint pt = [touch locationInView:self];
    
    if (CGRectContainsPoint(thumbRect, pt)) {
        _isSliding = YES;
        [_thumb setHighlighted:YES];
    }
    
    CGFloat newValue = (_maximumValue - _minimumValue) * (pt.x - _thumbSize / 2) / (self.frame.size.width - _thumbSize) + _minimumValue;
    
    [self valueChanged:newValue];
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:self];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [_thumb setHighlighted:NO];
    _isSliding = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if ([_thumb isHighlighted]) {
        if (_maximumValue - _minimumValue > 0.000001) {
            CGPoint pt = [touch locationInView:self];
            CGFloat newValue = (_maximumValue - _minimumValue) * (pt.x - _thumbSize / 2) / (self.frame.size.width - _thumbSize) + _minimumValue;
            [self valueChanged:newValue];
            if ([self.delegate respondsToSelector:@selector(sliderValueChanging:)]) {
                [self.delegate sliderValueChanging:self];
            }
            NSLog(@"value %f\n", _value);
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [_thumb setHighlighted:NO];
    NSLog(@"value %f\n", _value);
    if ([self.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
        [self.delegate sliderValueChanged:self];
    }
    
    _isSliding = NO;
}

@end
