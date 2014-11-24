//
//  HKColorViewController.h
//  NewConcept
//
//  Created by user on 14-7-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSettingSubViewController.h"
#import "HKSliderTableViewCell.h"

@interface HKColorViewController : HKSettingSubViewController<HKSliderTableViewCellDelegte, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray *_sections;
    NSArray *_headers;
}
@property (weak, nonatomic) IBOutlet UIView *lessonBgView;
@property (weak, nonatomic) IBOutlet UILabel *enTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *chTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
