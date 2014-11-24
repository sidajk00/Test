//
//  HKPushButton.m
//  NewConcept
//
//  Created by user on 14-5-11.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKPushButton.h"

@implementation HKPushButton

- (void)setButtonSelected:(BOOL)buttonSelected
{
    _buttonSelected = buttonSelected;
    if (_buttonSelected) {
        if (_buttonSelectedImage) {
            [self setImage:_buttonSelectedImage forState:UIControlStateNormal];
        }
    }
    else {
        [self setImage:_buttonNormalImage forState:UIControlStateNormal];
    }
}

- (void)setButtonNormalImage:(UIImage *)buttonNormalImage
{
    if (self.buttonNormalImage != buttonNormalImage) {
        _buttonNormalImage = buttonNormalImage;
        [self setImage:_buttonNormalImage forState:UIControlStateNormal];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonSelected = NO;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _buttonSelected = !_buttonSelected;
    if (_buttonSelected) {
        if (_buttonSelectedImage) {
            [self setImage:_buttonSelectedImage forState:UIControlStateNormal];
        }
    }
    else {
        [self setImage:_buttonNormalImage forState:UIControlStateNormal];
    }
    [super touchesEnded:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
