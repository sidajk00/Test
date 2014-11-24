//
//  HKPlayListViewController.m
//  NewConcept
//
//  Created by user on 14-5-24.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKPlayListViewController.h"

@interface HKPlayListViewController ()

@end

@implementation HKPlayListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *fileName = [NSString stringWithFormat:@"B%d_Contents.plist", _book];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d", _book]];
    
    self.contents = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
    int row = 0;
    if (_book == 1) {
        row = (_lesson - 1) / 2;
    }
    else {
        row = _lesson - 1;
    }
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_book == 1) {
        return [_contents count] / 2;
    }
    else {
        return [_contents count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlayListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSArray *array = nil;
    NSString *text = nil;
    if (_book == 1) {
        array = [_contents objectAtIndex:indexPath.row * 2];
        text = [NSString stringWithFormat:@"%d-%d", (int)indexPath.row * 2 + 1, (int)indexPath.row * 2 + 2];
    } else {
        array = [_contents objectAtIndex:indexPath.row];
        text = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];
    }
    text = [text stringByAppendingFormat:@" %@", [array objectAtIndex:0]];
    cell.textLabel.text = text;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int lesson = (int)indexPath.row + 1;
    if (_book == 1) {
        lesson = (int)indexPath.row * 2 + 1;
    }
    [self.delegate playListViewControllerDidSelect:self lesson:lesson];
}

@end
