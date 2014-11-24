//
//  HKAccentViewController.h
//  NewConcept
//
//  Created by user on 14-7-11.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKSettingSubViewController.h"


@interface HKAccentViewController : HKSettingSubViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
