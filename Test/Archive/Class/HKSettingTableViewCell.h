//
//  HKSettingTableViewCell.h
//  NewConcept
//
//  Created by user on 14-7-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSettingTableCellData.h"

@interface HKSettingTableViewCell : UITableViewCell
{
    UISwitch *_switchButton;
    UILabel *_detailLabel;
}

@property (nonatomic, retain) HKSettingTableCellData *data;

- (void)load;

@end
