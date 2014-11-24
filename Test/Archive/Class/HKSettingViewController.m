//
//  HKSettingViewController.m
//  NewConcept
//
//  Created by user on 14-7-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKSettingViewController.h"
#import "HKSettingTableCellData.h"
#import "HKUtility.h"
#import "HKColorViewController.h"
#import "HKSettingSubViewController.h"

@interface HKSettingViewController ()

@end

@implementation HKSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.navigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"X" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    [_tableView reloadData];
}

- (void)reloadData
{
    NSMutableArray *group = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    HKSettingTableCellData *data = [[HKSettingTableCellData alloc] init];
    data.text = @"在线词典";
    data.valueType = SettingValueTypeText;
    data.value = [HKUtility plistValue:@"BookInfo" key:@"Dict"];
    data.className = @"HKDictListViewController";
    data.title = @"在线词典";
    [array addObject:data];
    [group addObject:array];
    
    array = [NSMutableArray arrayWithCapacity:3];
    data = [[HKSettingTableCellData alloc] init];
    data.text = @"白天模式";
    data.valueType = SettingValueTypeOther;
    data.className = @"HKColorViewController";
    data.title = @"白天模式";
    [array addObject:data];
    
    data = [[HKSettingTableCellData alloc] init];
    data.text = @"夜晚模式";
    data.valueType = SettingValueTypeOther;
    data.className = @"HKColorViewController";
    data.title = @"夜晚模式";
    data.parameter = [NSNumber numberWithBool:YES];
    [array addObject:data];
    
    data = [[HKSettingTableCellData alloc] init];
    data.text = @"发音";
    data.valueType = SettingValueTypeText;
    data.value = [HKUtility plistValue:@"BookInfo" key:@"Accent"];
    data.className = @"HKAccentViewController";
    data.title = @"发音";
    [array addObject:data];
    
    [group addObject:array];
    
    _settings = group;
}

- (void)close:(id)sender
{
    [self.delegate settingViewControllerDidFinish:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)pushColorViewController:(BOOL)nightmode
{
    
}

- (void)pushController:(NSString *)className title:(NSString *)title parameter:(id)parameter indexPath:(NSIndexPath *)indexPath
{
    HKSettingSubViewController *controller = [(HKSettingSubViewController *)[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
 
    controller.parameter = parameter;
    controller.title = title;
    controller.delegate = self;
    controller.indexPath = indexPath;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_settings objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    HKSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HKSettingTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
    }
    
    NSArray *section = [_settings objectAtIndex:indexPath.section];
    HKSettingTableCellData *data = [section objectAtIndex:indexPath.row];
    cell.data = data;
    
    [cell load];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [_settings objectAtIndex:indexPath.section];
    HKSettingTableCellData *data = [section objectAtIndex:indexPath.row];
    if (data.className) {
        [self pushController:data.className title:data.title parameter:data.parameter indexPath:indexPath];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - HKSettingSubViewControllerDelegate
- (void)settingSubViewDidFinish:(id)sender
{
    
}

@end
