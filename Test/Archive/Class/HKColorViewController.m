//
//  HKColorViewController.m
//  NewConcept
//
//  Created by user on 14-7-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKColorViewController.h"
#import "HKUtility.h"

@interface HKColorViewController ()

@end

@implementation HKColorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && self.navigationController != nil) {
//        CGFloat top = [self.topLayoutGuide length];
//    }
//}

- (void)loadData
{
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:3];
    if ([self.parameter boolValue]) { //nightmode
        [sections addObject:[self rgbFromPlist:@"Night_BackgroundColor"]];
        [sections addObject:[self rgbFromPlist:@"Night_EnTextColor"]];
        [sections addObject:[self rgbFromPlist:@"Night_ChTextColor"]];
    }
    else {
        [sections addObject:[self rgbFromPlist:@"BackgroundColor"]];
        [sections addObject:[self rgbFromPlist:@"EnTextColor"]];
        [sections addObject:[self rgbFromPlist:@"ChTextColor"]];
    }
    [sections addObject:[NSArray arrayWithObject:@"恢复默认"]];
    
    _sections = sections;
    
    _headers = [NSArray arrayWithObjects:@"背景", @"英文", @"中文", @"", nil];
}

- (void)updateSampleView
{
    NSArray *color = [_sections objectAtIndex:0];
    _lessonBgView.backgroundColor = [UIColor colorWithRed:[[color objectAtIndex:0] floatValue] green:[[color objectAtIndex:1] floatValue] blue:[[color objectAtIndex:2] floatValue] alpha:1];
    
    color = [_sections objectAtIndex:1];
    _enTextLabel.textColor = [UIColor colorWithRed:[[color objectAtIndex:0] floatValue] green:[[color objectAtIndex:1] floatValue] blue:[[color objectAtIndex:2] floatValue] alpha:1];
    
    color = [_sections objectAtIndex:2];
    _chTextLabel.textColor = [UIColor colorWithRed:[[color objectAtIndex:0] floatValue] green:[[color objectAtIndex:1] floatValue] blue:[[color objectAtIndex:2] floatValue] alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self loadData];
    
    [self updateSampleView];
}

- (NSArray *)rgbFromPlist:(NSString *)key
{
    NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:3];
    NSString *color = [HKUtility plistValue:@"BookInfo" key:key];
    NSString *r = [color substringToIndex:2];
    [colorArray addObject:[NSNumber numberWithFloat:[self hexInt:r] / 255.0f]];
    NSString *g = [color substringWithRange:NSMakeRange(2, 2)];
    [colorArray addObject:[NSNumber numberWithFloat:[self hexInt:g] / 255.0f]];
    NSString *b = [color substringFromIndex:4];
    [colorArray addObject:[NSNumber numberWithFloat:[self hexInt:b] / 255.0f]];
    return colorArray;
}

- (void)saveRgbToPlist:(NSString *)key
{
    
}

- (unsigned)hexInt:(NSString *)hex
{
    unsigned color = 0;
    
    NSScanner* scan = [NSScanner scannerWithString:hex];
    [scan scanHexInt:&color];
    
    
    return color;
}

- (NSString *)intHex:(unsigned)value
{
    return [NSString stringWithFormat:@"%02x", value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSString *)colorValue:(NSArray *)rgb
{
    NSString *stringValue = @"";
    CGFloat r = [[rgb objectAtIndex:0] floatValue];
    stringValue = [stringValue stringByAppendingString:[self intHex:roundf(r * 255)]];
    CGFloat g = [[rgb objectAtIndex:1] floatValue];
    stringValue = [stringValue stringByAppendingString:[self intHex:roundf(g * 255)]];
    CGFloat b = [[rgb objectAtIndex:2] floatValue];
    stringValue = [stringValue stringByAppendingString:[self intHex:roundf(b * 255)]];
    return stringValue;
}

- (void)savePlist
{
    NSArray *color = [_sections objectAtIndex:0];
    if ([self.parameter boolValue]) { //nightmode
        [HKUtility writePlistValue:@"BookInfo" value:[self colorValue:color] key:@"Night_BackgroundColor"];
    }
    else {
        [HKUtility writePlistValue:@"BookInfo" value:[self colorValue:color] key:@"BackgroundColor"];
        NSLog(@"%@", [HKUtility plistValue:@"BookInfo" key:@"BackgroundColor"]);
    }
    
    
    color = [_sections objectAtIndex:1];
    if ([self.parameter boolValue]) { //nightmode
        [HKUtility writePlistValue:@"BookInfo" value:[self colorValue:color] key:@"Night_EnTextColor"];
    }
    else {
        [HKUtility writePlistValue:@"BookInfo" value:[self colorValue:color] key:@"EnTextColor"];
    }
    
    color = [_sections objectAtIndex:2];
    if ([self.parameter boolValue]) { //nightmode
        [HKUtility writePlistValue:@"BookInfo" value:[self colorValue:color] key:@"Night_ChTextColor"];
    }
    else {
        [HKUtility writePlistValue:@"BookInfo" value:[self colorValue:color] key:@"ChTextColor"];
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

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_headers objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [_sections count] - 1) {
        static NSString *CellIdentifier = @"SliderCell";
        HKSliderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"HKSliderTableViewCell" owner:self options:nil];
            cell = [nibs lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.slider.minimumValue = 0;
            cell.slider.maximumValue = 1;
        }
        
        NSArray *section = [_sections objectAtIndex:indexPath.section];
        NSNumber *value = [section objectAtIndex:indexPath.row];
        cell.slider.value = [value floatValue];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"RestoreDefaultsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.textLabel.text = [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [_sections count] - 1) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"这将恢复为默认颜色。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"恢复默认颜色" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([self.parameter boolValue]) { //nightmode
            [HKUtility setDefaultNightmode];
        }
        else {
            [HKUtility setDefaultDaymode];
        }
        [self loadData];
        [self updateSampleView];
        [self.tableView reloadData];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if ([self.parameter boolValue]) { //nightmode
            [HKUtility setDefaultNightmode];
        }
        else {
            [HKUtility setDefaultDaymode];
        }
        [self loadData];
        [self updateSampleView];
        [self.tableView reloadData];
    }
}

#pragma mark - HKSliderTableViewCellDelegte
- (void)sliderTableViewCellValueChanged:(id)sender
{
    HKSliderTableViewCell *cell = (HKSliderTableViewCell *)sender;
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    CGFloat newValue = cell.slider.value;
    NSMutableArray *rgb = [_sections objectAtIndex:indexPath.section];
    [rgb replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:newValue]];
    
    [self updateSampleView];
    
    [self savePlist];
}

@end
