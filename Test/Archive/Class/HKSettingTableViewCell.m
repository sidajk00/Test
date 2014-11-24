//
//  HKSettingTableViewCell.m
//  NewConcept
//
//  Created by user on 14-7-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKSettingTableViewCell.h"

@implementation HKSettingTableViewCell

- (void)awakeFromNib
{
    
}

- (void)load
{
    self.textLabel.text = _data.text;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (_data.valueType == SettingValueTypeBool) {
        if (!_switchButton) {
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 59, (self.contentView.frame.size.height - 31) / 2, 49, 31)];
            _switchButton = switchButton;
            [self.contentView addSubview:switchButton];
        }
        [_switchButton setSelected:[_data.value boolValue]];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        if (_switchButton) {
            [_switchButton removeFromSuperview];
            _switchButton = nil;
        }
    }
    
    if (_data.valueType == SettingValueTypeText) {
        if (!_detailLabel) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 110, 0, 80, self.contentView.frame.size.height)];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentRight;
            _detailLabel = label;
            [self.contentView addSubview:label];
        }
        _detailLabel.text = _data.value;
    }
    else {
        if (_detailLabel) {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
