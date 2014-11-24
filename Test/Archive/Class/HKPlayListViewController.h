//
//  HKPlayListViewController.h
//  NewConcept
//
//  Created by user on 14-5-24.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HKPlayListViewControllerDelegate <NSObject>

- (void)playListViewControllerDidSelect:(id)sender lesson:(int)lesson;

@end

@interface HKPlayListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, assign) int book;
@property (nonatomic, assign) int lesson;
@property (nonatomic, retain) NSArray *contents;
@property (nonatomic, assign) id<HKPlayListViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
