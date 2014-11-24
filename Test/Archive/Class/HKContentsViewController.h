//
//  HKTextDirectoryViewController.h
//  NewConcept
//
//  Created by user on 14-5-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKLessonViewController.h"
#import "MBProgressHUD.h"
#import "StoreKit/StoreKit.h"
#import "InAppPurchaseManager.h"
#import "HKContentTableViewCell.h"

@interface HKContentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HKLessonViewControllerDelegate, HKSettingViewControllerDelegate, SKProductsRequestDelegate, UIAlertViewDelegate, HKContentTableViewCellDelegate>
{
    InAppPurchaseManager *_iap;
    
    BOOL _fullVersion;
}

@property (nonatomic, assign) int book;
@property (nonatomic, retain) NSArray *contents;

@property (nonatomic, retain) MBProgressHUD *hud;

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
