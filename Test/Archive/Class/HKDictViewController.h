//
//  HKDictViewController.h
//  NewConcept
//
//  Created by user on 14-5-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKDictViewController : UIViewController<UIWebViewDelegate>


@property (nonatomic, retain) NSString *text;

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@property (nonatomic, retain) IBOutlet UINavigationBar *titleBar;


@end
