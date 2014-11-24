//
//  HKRTViewController.m
//  NewConcept
//
//  Created by user on 14-5-8.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKRTViewController.h"
#import "HKContentsViewController.h"

@interface HKRTViewController ()

@end

@implementation HKRTViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadContentsView:(int)book
{
    
    HKContentsViewController *controller = [[HKContentsViewController alloc] initWithNibName:@"HKContentsViewController" bundle:nil];
    controller.book = book;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    //[nav.navigationBar setBackgroundColor:[UIColor blackColor]];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:NO];
    self.navController = nav;
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

- (IBAction)Book1:(id)sender
{
    [self loadContentsView:1];
}

- (IBAction)Book2:(id)sender
{
    [self loadContentsView:2];
}

- (IBAction)Book3:(id)sender
{
    [self loadContentsView:3];
}

- (IBAction)Book4:(id)sender
{
    [self loadContentsView:4];
}


@end
