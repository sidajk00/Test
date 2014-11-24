//
//  NightmodeStyleButton.m
//  NewConcept
//
//  Created by user on 14-7-2.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "NightmodeStyleButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation NightmodeStyleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)clicked:(id)sender
{
    [self setSelected:![self isSelected]];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if ([self isSelected]) {
        self.layer.borderColor = [UIColor greenColor].CGColor;
    }
    else {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
    }
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
