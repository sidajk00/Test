//
//  HKSliderTableViewCell.m
//  NewConcept
//
//  Created by user on 14-7-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKSliderTableViewCell.h"

@implementation HKSliderTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)valueChanged:(id)sender
{
    [self.delegate sliderTableViewCellValueChanged:self];
}

@end
