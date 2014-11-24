//
//  HKSettingSubViewController.h
//  NewConcept
//
//  Created by user on 14-7-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

@protocol HKSettingSubViewControllerDelegate <NSObject>

- (void)settingSubViewDidFinish:(id)sender;

@end

@interface HKSettingSubViewController : UIViewController

@property (nonatomic, assign) id<HKSettingSubViewControllerDelegate> delegate;
@property (nonatomic, retain) id parameter;
@property (nonatomic, retain) NSIndexPath *indexPath;

- (void)back;

@end
