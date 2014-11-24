//
//  HKContentTableViewCell.h
//  NewConcept
//
//  Created by user on 14-5-10.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKUtility.h"

@protocol HKContentTableViewCellDelegate <NSObject>

- (void)contentTableViewCell:(id)sender markChanged:(LessonMark)mark;

@end

@interface HKContentTableViewCell : UITableViewCell

@property (nonatomic, assign) id<HKContentTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lessonNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *lessonNameEN;
@property (weak, nonatomic) IBOutlet UILabel *lessonNameZH;
@property (weak, nonatomic) IBOutlet UIButton *readMarkButton;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, assign) LessonMark mark;

- (IBAction)lessonMarkClicked:(id)sender;

@end
