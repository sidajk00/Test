//
//  HKLessonViewController.h
//  NewConcept
//
//  Created by user on 14-5-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKPlayerViewController.h"
#import "FPPopoverController.h"
#import "HKPlayerPopViewController.h"
#import "HKInfoViewController.h"
#import "HKPlayListViewController.h"
#import "HKSettingViewController.h"

@protocol HKLessonViewControllerDelegate <NSObject>

- (void)lessonViewController:(id)sender lessonChenged:(int)lesson;

@end

@interface HKLessonViewController : UIViewController <UIWebViewDelegate, HKPlayerViewControllerDelegate, FPPopoverControllerDelegate, HKPlayerPopViewControllerDelegate,
HKInfoViewControllerDelegate, HKPlayListViewControllerDelegate, HKSettingViewControllerDelegate>
{
    FPPopoverController *_popController;
    HKPlayerPopViewController *_playerPopController;
    int _paraCount;
    BOOL _menuVisible;
    //UIWindow *_brightnessWindow;
    UIPinchGestureRecognizer *_pinchRecognizer;
    
    LessonTextOption _textOption;
    
    BOOL _dissmissed;
}

@property (nonatomic, assign) id<HKLessonViewControllerDelegate> delegate;
@property (nonatomic, assign) int book;
@property (nonatomic, assign) int lesson;
@property (nonatomic, assign) int contentCount;
@property (nonatomic, retain) NSArray *contentEN;
@property (nonatomic, retain) NSArray *contentZH;
@property (nonatomic, retain) NSArray *timeList;
@property (nonatomic, retain) NSMutableArray *textViews;
@property (nonatomic, retain) HKPlayerViewController *playerController;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, assign) int currentParagraph;

@end
