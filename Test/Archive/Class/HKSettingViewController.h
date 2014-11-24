//
//  HKSettingViewController.h
//  NewConcept
//
//  Created by user on 14-7-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSettingTableViewCell.h"
#import "HKSettingSubViewController.h"

@protocol HKSettingViewControllerDelegate <NSObject>

- (void)settingViewControllerDidFinish:(id)sender;

@end

@interface HKSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
HKSettingSubViewControllerDelegate>
{
    NSArray *_settings;
}

@property(nonatomic, assign) id<HKSettingViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
