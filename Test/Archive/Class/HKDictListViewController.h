//
//  HKDictListViewController.h
//  NewConcept
//
//  Created by user on 14-7-13.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKSettingSubViewController.h"

@interface HKDictListViewController : HKSettingSubViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dictList;
}


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
