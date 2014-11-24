//
//  HKTextDirectoryViewController.m
//  NewConcept
//
//  Created by user on 14-5-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKContentsViewController.h"
#import "HKLessonViewController.h"
#import "HKContentTableViewCell.h"
#import "Reachability.h"
#import "InAppRageIAPHelper.h"
#import "MBProgressHUD.h"
#import "HKUtility.h"

#import <JavaScriptCore/JavaScriptCore.h>

#import "InAppPurchaseManager.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface HKContentsViewController ()

@end

@implementation HKContentsViewController

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
    
    _fullVersion = [[HKUtility plistValue:@"BookInfo" key:[NSString stringWithFormat:@"FullVersion%d", _book]] boolValue];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    
    if (_book == 1) {
        self.title = @"新概念 第一册";
    }
    else if (_book == 2) {
        self.title = @"新概念 第二册";
    }
    else if (_book == 3) {
        self.title = @"新概念 第三册";
    }
    else if (_book == 4) {
        self.title = @"新概念 第四册";
    }
    
    //Load the bookX contents from file.
    NSString *fileName = [NSString stringWithFormat:@"B%d_Contents.plist", _book];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d", _book]];
    
    self.contents = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    
//    for (int i = 1; i <= 143; i+=2) {
//        NSString *fileName = [NSString stringWithFormat:@"Lesson%03den.txt", i];
//        NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Lesson/EN", _book]];
//        NSString *contentEN = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//        contentEN = [contentEN stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        
//        
//        fileName = [NSString stringWithFormat:@"Lesson%03dzh.txt", i];
//        path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Lesson/ZH", _book]];
//        NSString *contentZH = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
//        
//        contentZH = [contentZH stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        
//        if ([[contentEN componentsSeparatedByString:@"\n"] count] != [[contentZH componentsSeparatedByString:@"\n"] count]) {
//            NSLog(@"\n%d", i);
//        }
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)setting:(id)sender
{
    HKSettingViewController *controller = [[HKSettingViewController alloc] initWithNibName:@"HKSettingViewController" bundle:nil];
    controller.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [nav.navigationBar setBackgroundColor:[UIColor blackColor]];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:NO];
}

- (void)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)productsLoaded:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[InAppRageIAPHelper sharedHelper] buyProduct:product];
    
    //self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //_hud.labelText = @"Buying fable...";
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:30];
}

- (void)productPurchased:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    _fullVersion = YES;
    [HKUtility writePlistValue:@"BookInfo" value:[NSNumber numberWithBool:YES] key:[NSString stringWithFormat:@"FullVersion%d", _book]];
    
    [self.tableView reloadData];
}

- (void)productPurchaseFailed:(NSNotification *)notification
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
}

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Timeout!";
    _hud.detailsLabelText = @"Please try again later.";
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}

- (void)getProductsInfo {
    NSSet * set = [NSSet setWithArray:@[@"FullVersion1"]];
    SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    request.delegate = self;
    [request start];
}
// 以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        NSLog(@"无法获取产品信息，购买失败。");
        return;
    }
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)unlockBook
{
     [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"网络不可用";
        [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    } else {
        if ([InAppRageIAPHelper sharedHelper].products == nil) {
            
            [[InAppRageIAPHelper sharedHelper] requestProducts];
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"正在连接...";
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }
        else {
            self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            _hud.labelText = @"正在连接...";
            SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
            [[InAppRageIAPHelper sharedHelper] buyProduct:product];
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30];
        }
    }
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
    static NSString *CellIdentifier = @"ContentCell";
    HKContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HKContentTableViewCell" owner:self options:nil];
        cell = [nibs lastObject];
        cell.delegate = self;
    }
    
    NSArray *array = nil;
    int lesson = 1;
    if (_book == 1) {
        array = [_contents objectAtIndex:indexPath.row * 2];
        cell.lessonNumLabel.text = [NSString stringWithFormat:@"%d-%d", (int)indexPath.row * 2 + 1, (int)indexPath.row * 2 + 2];
        lesson = (int)indexPath.row * 2 + 1;
    } else {
        array = [_contents objectAtIndex:indexPath.row];
        cell.lessonNumLabel.text = [NSString stringWithFormat:@"%d", (int)indexPath.row + 1];
        lesson = (int)indexPath.row + 1;
    }
    
    cell.locked = NO;
    if (!_fullVersion) {
        if (_book == 1 || _book == 2) {
            if (indexPath.row > 30) {
                cell.locked = YES;
            }
        }
        if (_book > 2) {
            if (indexPath.row > 20) {
                cell.locked = YES;
            }
        }
    }
    
    cell.mark = [HKUtility lessonMark:_book lesson:lesson];
    cell.lessonNameEN.text = [array objectAtIndex:0];
    cell.lessonNameZH.text = [array objectAtIndex:1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HKContentTableViewCell *cell = (HKContentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.locked) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"购买完整版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
        HKLessonViewController *lessonController = [[HKLessonViewController alloc] initWithNibName:@"HKLessonViewController" bundle:nil];
        lessonController.book = _book;
        lessonController.contentCount = (int)[self.contents count];
        lessonController.delegate = self;
        if (_book == 1) {
            lessonController.lesson = (int)indexPath.row * 2 + 1;
        }
        else {
            lessonController.lesson = (int)indexPath.row + 1;
        }
        
        [self.navigationController pushViewController:lessonController animated:YES];
        
        if ([HKUtility lessonMark:_book lesson:lessonController.lesson] == LessonMarkNone) {
            [HKUtility setLessonMark:LessonMarkHasRead book:_book lesson:lessonController.lesson];
        }
    }
}

#pragma mark HKLessonViewControllerDelegate
- (void)lessonViewController:(id)sender lessonChenged:(int)lesson
{
    int row = 0;
    if (_book == 1) {
        row = (lesson - 1) / 2;
    }
    else {
        row = lesson - 1;
    }
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}

#pragma mark - HKSettingViewControllerDelegate
- (void)settingViewControllerDidFinish:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == !buttonIndex) {
        [self unlockBook];
    }
}

#pragma mark - HKContentTableViewCellDelegate
- (void)contentTableViewCell:(id)sender markChanged:(LessonMark)mark
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    int lesson = 1;
    if (_book == 1) {
        lesson = (int)indexPath.row * 2 + 1;
    }
    else {
        lesson = (int)indexPath.row + 1;
    }
    [HKUtility setLessonMark:mark book:_book lesson:lesson];
}

@end
