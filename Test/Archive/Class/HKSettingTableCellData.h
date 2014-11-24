//
//  HKSettingTableCellData.h
//  NewConcept
//
//  Created by user on 14-7-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SettingValueType) {
    SettingValueTypeBool,
    SettingValueTypeText,
    SettingValueTypeOther
};

@interface HKSettingTableCellData : NSObject

@property(nonatomic, retain) NSString *text;
@property(nonatomic, assign) SettingValueType valueType;
@property(nonatomic, retain) id value;
@property(nonatomic, retain) NSString *className;
@property(nonatomic, retain) NSString *title;
@property (nonatomic, retain) id parameter;

@end
