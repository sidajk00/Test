//
//  HKContentTableViewCell.m
//  NewConcept
//
//  Created by user on 14-5-10.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKContentTableViewCell.h"

@implementation HKContentTableViewCell

- (void)setLocked:(BOOL)locked
{
    _locked = locked;
    if (_locked) {
        _lessonNameEN.textColor = [UIColor lightGrayColor];
        _lessonNameZH.textColor = [UIColor lightGrayColor];
        _lessonNumLabel.textColor = [UIColor lightGrayColor];
    }
    else {
        _lessonNameEN.textColor = [UIColor blackColor];
        _lessonNameZH.textColor = [UIColor darkGrayColor];
        _lessonNumLabel.textColor = [UIColor blackColor];
    }
}

- (void)setMark:(LessonMark)mark
{
    _mark = mark;
    if (_mark == LessonMarkNone) {
        [_readMarkButton setImage:nil forState:UIControlStateNormal];
    }
    else if (_mark == LessonMarkHasRead) {
        [_readMarkButton setImage:[UIImage imageNamed:@"read.png"] forState:UIControlStateNormal];
    }
    else if (_mark == LessonMarkLearnt) {
        [_readMarkButton setImage:[UIImage imageNamed:@"known.png"] forState:UIControlStateNormal];
    }
}

- (void)lessonMarkClicked:(id)sender
{
    if (_mark != LessonMarkNone) {
        if (_mark == LessonMarkHasRead) {
            self.mark = LessonMarkLearnt;
        }
        else {
            self.mark = LessonMarkHasRead;
        }
        [self.delegate contentTableViewCell:self markChanged:_mark];
    }
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
