//
//  HKLessonViewController.m
//  NewConcept
//
//  Created by user on 14-5-9.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKLessonViewController.h"
#import "HKDictViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "HKPlayerViewController.h"
#import "FPPopoverController.h"
#import "HKPlayerPopViewController.h"
#import "HKInfoViewController.h"
#import "HKUtility.h"

#import "objc/runtime.h"
#import "HK_SwizzleHelper.h"

@interface HKLessonViewController ()

@end

@implementation HKLessonViewController

-(void)removeMenuItems
{
    UIView* subview;
    
    for (UIView* view in self.webView.scrollView.subviews) {
        NSLog(@"%@", [view.class description]);
        if([[view.class description] hasPrefix:@"UIWeb"])
            subview = view;
    }
    
    if(subview == nil) return;
    
    NSString* name = [NSString stringWithFormat:@"%@_SwizzleHelper", subview.class.superclass];
    Class newClass = NSClassFromString(name);
    
    if(newClass == nil)
    {
        newClass = objc_allocateClassPair(subview.class, [name cStringUsingEncoding:NSASCIIStringEncoding], 0);
        if(!newClass) return;
        
        Method method = class_getInstanceMethod([HK_SwizzleHelper class], @selector(canPerformAction:withSender:));
        class_addMethod(newClass, @selector(canPerformAction:withSender:), method_getImplementation(method), method_getTypeEncoding(method));
        
        objc_registerClassPair(newClass);
    }
    
    object_setClass(subview, newClass);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.textViews = [NSMutableArray array];
        _currentParagraph = -1;
        _textOption = LessonTextEnglishAndChinese;
    }
    return self;
}

//- (UITextView *)loadTextView:(NSString *)text fontSize:(CGFloat)fontSize posY:(CGFloat)posY
//{
//    NSString *txt = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    if (txt.length > 0) {
//        
//        CGSize size = [txt sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:_scrollView.frame.size lineBreakMode:NSLineBreakByWordWrapping];
//        size.height += 16;
//        CGRect rect = CGRectMake(0, posY, _scrollView.frame.size.width, size.height);
//        UITextView *textView = [[UITextView alloc] initWithFrame:rect];
//        //textView.layer.borderWidth = 1;
//        textView.font = [UIFont systemFontOfSize:fontSize];
//        textView.scrollEnabled = NO;
//        textView.editable = NO;
//        textView.delegate = self;
//        textView.text = txt;
//        textView.inputView = nil;
//        
//        [_scrollView addSubview:textView];
//        [_textViews addObject:textView];
//        
//        return textView;
//    }
//    return nil;
//}

- (HKNightmodeStyle *)textColorStyle
{
    NSString *plistPath = [HKUtility plistPath:@"BookInfo"];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    BOOL nightmode = [[dict objectForKey:@"Nightmode"] boolValue];
    
    HKNightmodeStyle *style = [[HKNightmodeStyle alloc] init];
    if (nightmode) {
        
        NSString *color = [dict objectForKey:@"Night_BackgroundColor"];
        style.backgroundColor = color;
        color = [dict objectForKey:@"Night_ChTextColor"];
        style.chTextColor = color;
        color = [dict objectForKey:@"Night_EnTextColor"];
        style.enTextColor = color;
    }
    else {
        NSString *color = [dict objectForKey:@"BackgroundColor"];
        style.backgroundColor = color;
        color = [dict objectForKey:@"ChTextColor"];
        style.chTextColor = color;
        color = [dict objectForKey:@"EnTextColor"];
        style.enTextColor = color;
    }
    return style;
}

- (void)loadWebView
{
    int countEN = (int)[_contentEN count];
    int countZH = (int)[_contentZH count];
    
    if (countEN <= 2 || countZH <= 2) {
        return;
    }
    
//    CGFloat height = 0;
//    CGFloat lineSpacing = 10;
    
    //load content
    assert(countEN == countZH);
    
    int fontSize = [[HKUtility plistValue:@"BookInfo" key:@"FontSize"] intValue];
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>\n"];
    [html appendString:@"<head>\n"];
    [html appendString:@"<style>"];
    HKNightmodeStyle *style = [self textColorStyle];
    [html appendString:[NSString stringWithFormat:@".en {margin-bottom:0px; color:#%@; font-size:%dpt;}", style.enTextColor, fontSize]];
    [html appendString:[NSString stringWithFormat:@".zh {margin-top:0px; color:#%@; font-size:%dpt;}", style.chTextColor, fontSize-5]];
    [html appendString:@"</style>"];
    [html appendString:@"</head>\n"];
    
    
    [html appendString:[NSString stringWithFormat:@"<body style=\"background-color:#%@\">\n", style.backgroundColor]];
    
    _paraCount = countEN < countZH ? countEN : countZH;
    for (int i = 0; i < _paraCount; i++) {
        NSString *textEN = [_contentEN objectAtIndex:i];
        NSString *textZH = [_contentZH objectAtIndex:i];
        if (textEN.length > 0 && textZH.length > 0) {
            if (i == 0) {
                [html appendFormat:@"<div id=\"p%d\" align=\"center\" onclick=\"paraClicked('paraClicked:','p%d');\">", i, i];
            }
            else {
                [html appendFormat:@"<div id=\"p%d\" align=\"left\" onclick=\"paraClicked('paraClicked:','p%d');\">", i, i];
            }
            if (_textOption == LessonTextEnglish) {
                [html appendFormat:@"<p class=\"en\"> %@ </p>", textEN];
            }
            else if (_textOption == LessonTextChinese) {
                [html appendFormat:@"<p class=\"zh\"> %@ </p>", textZH];
            }
            else {
                [html appendFormat:@"<p class=\"en \"> %@ </p>", textEN];
                [html appendFormat:@"<p class=\"zh \"> %@ </p>", textZH];
            }
            [html appendFormat:@"</div>"];
        }
    }
    
    [html appendString:@"</body>\n"];
    [html appendString:@"</html>"];
    
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_webView loadHTMLString:html baseURL:nil];
}

//- (void)loadTextViews
//{
//    NSArray *textArrayEN = [_contentEN componentsSeparatedByString:@"\n"];
//    NSArray *textArrayZH = [_contentZH componentsSeparatedByString:@"\n"];
//    int countEN = [textArrayEN count];
//    int countZH = [textArrayZH count];
//    
//    if (countEN <= 2 || countZH <= 2) {
//        return;
//    }
//    
//    for (UITextView *view in _textViews) {
//        [view removeFromSuperview];
//    }
//    [_textViews removeAllObjects];
//    
//    
//    CGFloat height = 0;
//    CGFloat lineSpacing = 10;
//    
//    //    //load title
//    //    NSString *text = [textArrayEN objectAtIndex:0];
//    //    UITextView *textView = [self loadTextView:text fontSize:20 posY:0];
//    //    textView.textAlignment = NSTextAlignmentCenter;
//    //    height += textView.frame.size.height + lineSpacing;
//    //
//    //    //load question
//    //    text = [textArrayEN objectAtIndex:1];
//    //    textView = [self loadTextView:text fontSize:18 posY:height];
//    //    textView.textColor = [UIColor grayColor];
//    
//    //load content
//    assert(countEN == countZH);
//    
//    NSMutableString *html = [NSMutableString string];
//    [html appendString:@"<html>\n"];
//    [html appendString:@"<body>\n"];
//    [html appendFormat:@"<h1>%@</h1>", @"test"];
//    //    [ret appendFormat:@"<p>%@</p>", text];
//    
//    
//    int count = countEN - 2 <= countZH ? countEN - 2 : countZH;
//    for (int i = 0; i < count; i++) {
//        NSString *text = [textArrayEN objectAtIndex:i];
//        [html appendFormat:@"<p>%@</p>", text];
//        
//        text = [textArrayZH objectAtIndex:i];
//        [html appendFormat:@"<p>%@</p>", text];
//        //        CGFloat fontSize = 12;
//        //        NSTextAlignment textAlignment = NSTextAlignmentLeft;
//        //        UIColor *textColor = [UIColor blackColor];
//        //
//        //        if (i == 0) {
//        //            fontSize = 20;
//        //            textAlignment = NSTextAlignmentCenter;
//        //        }
//        //
//        //        if (i == 1) {
//        //            textColor = [UIColor grayColor];
//        //        }
//        //
//        //        //Load english
//        //        NSString *text = [textArrayEN objectAtIndex:i];
//        //        UITextView *textView = [self loadTextView:text fontSize:fontSize posY:height];
//        //        textView.textAlignment = textAlignment;
//        //        textView.textColor = textColor;
//        //        height += textView.frame.size.height;
//        //
//        //        //Load chaines
//        //        text = [textArrayZH objectAtIndex:i];
//        //        textView = [self loadTextView:text fontSize:fontSize posY:height];
//        //        textView.textAlignment = textAlignment;
//        //        textView.textColor = textColor;
//        //        height += textView.frame.size.height + lineSpacing;
//        
//    }
//    
//    [html appendString:@"</body>\n"];
//    [html appendString:@"</html>"];
//    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
//    [webView loadHTMLString:html baseURL:nil];
//    [self.view addSubview:webView];
//    
//    [self.scrollView setHidden:YES];
//    
//    
//    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, height);
//    _scrollView.layer.borderWidth = 1;
//    _scrollView.layer.borderColor = [UIColor redColor].CGColor;
//}

- (void)loadLessonData
{
    NSString *fileName = [NSString stringWithFormat:@"Lesson%03d.txt", _lesson];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d/Lesson", _book]];
    NSString *text = [[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableArray *timeList = [NSMutableArray array];
    NSMutableArray *contentEN = [NSMutableArray array];
    NSMutableArray *contentZH = [NSMutableArray array];
    
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSString *line in lines) {
        
        int index = 0;
        if ([line hasPrefix:@"["]) {
            NSRange range = [line rangeOfString:@"]"];
            CGFloat sec = [[line substringWithRange:NSMakeRange(1, range.location + 1)] floatValue];
            [timeList addObject:[NSNumber numberWithFloat:sec]];
            index = (int)range.location + 1;
        }
        
        NSString *para = [line substringFromIndex:index];
        NSArray *array = [para componentsSeparatedByString:@"^"];
        [contentEN addObject:[array objectAtIndex:0]];
        if ([array count] > 1) {
            [contentZH addObject:[array objectAtIndex:1]];
        }
        else {
            [contentZH addObject:@"问题"];
        }
    }
    
    self.contentEN = contentEN;
    self.contentZH = contentZH;
    self.timeList = timeList;
    
    _playerController.timeList = _timeList;
    _playerPopController.timeList = _timeList;
}

- (void)loadPlayerView
{
    if (_playerController == nil) {
        self.playerController = [[HKPlayerViewController alloc] initWithNibName:@"HKPlayerViewController" bundle:nil];
        
        _playerController.delegate = self;
        _playerController.contentCount = _contentCount;
        _playerController.book = _book;
        _playerController.lesson = _lesson;
        _playerController.timeList = _timeList;
        _playerController.americanEnglish = [[HKUtility plistValue:@"BookInfo" key:@"Accent"] isEqualToString:@"美音"];
        
        _playerController.view.frame = CGRectMake(0, self.webView.frame.size.height, self.view.frame.size.width, _playerController.view.frame.size.height);
        _playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_playerController.view];
        
    }
    else {
        _playerController.book = _book;
        _playerController.lesson = _lesson;
        _playerController.timeList = _timeList;
        _playerController.americanEnglish = [[HKUtility plistValue:@"BookInfo" key:@"Accent"] isEqualToString:@"美音"];
        [_playerController reload];
    }
}

- (void)loadText
{
    if (_book == 1) {
        self.title = [NSString stringWithFormat:@"第%d册 第%d-%d课", _book, _lesson, _lesson + 1];
    }
    else {
        self.title = [NSString stringWithFormat:@"第%d册 第%d课", _book, _lesson];
    }
    
    [self loadLessonData];
    [self loadWebView];
}

- (void)menuWillShow:(NSNotification *)notification
{
    UIMenuItem *dict = [[UIMenuItem alloc] initWithTitle:@"在线词典" action:@selector(dict:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:dict, nil]];
    [menu setTargetRect:self.view.frame inView:self.view.superview];
    //[menu setMenuVisible:YES animated:YES];
}

- (void)menuDidShow:(NSNotification *)notification
{
    _menuVisible = YES;
}

- (void)menuDidHide:(NSNotification *)notification
{
    _menuVisible = NO;
}

//- (void)installBrightnessWindow
//{
//    if (_brightnessWindow == nil) {
//        _brightnessWindow = [[UIWindow alloc] initWithFrame:self.view.window.frame];
//        _brightnessWindow.windowLevel = UIWindowLevelStatusBar + 1;
//        _brightnessWindow.userInteractionEnabled = NO;
//        _brightnessWindow.backgroundColor = [UIColor blackColor];
//        _brightnessWindow.alpha = 0;
//        _brightnessWindow.hidden = NO;
//        [self.view.window addSubview:_brightnessWindow];
//    }
//}

- (void)loadMenuItems
{
    UIMenuItem *dict = [[UIMenuItem alloc] initWithTitle:@"在线词典" action:@selector(dict:)];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:[NSArray arrayWithObjects:dict, nil]];
    [menu setTargetRect:self.view.frame inView:self.view.superview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidShow:) name:UIMenuControllerDidShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dissmissed = NO;
    
    //[self removeMenuItems];
    [self loadMenuItems];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setImage:[UIImage imageNamed:@"cfg.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(info:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem.customView = btn;
    
    _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
    [self.webView addGestureRecognizer:_pinchRecognizer];
    
    [self loadText];
}

- (void)handlePanFrom:(id)sender
{
    int fontSize = [[HKUtility plistValue:@"BookInfo" key:@"FontSize"] intValue];
    
    fontSize = fontSize * _pinchRecognizer.scale;
    fontSize = fontSize < 10 ? 10 : fontSize;
    fontSize = MIN(fontSize, 30);
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.fontSize=\"%fpt\";", floorf(fontSize + 0.5)]];
    [self writeBookInfoPlist:[NSNumber numberWithInt:floorf(fontSize + 0.5)] key:@"FontSize"];
}

- (void)dict:(id)sender
{
    HKDictViewController *controller = [[HKDictViewController alloc] initWithNibName:@"HKDictViewController" bundle:nil];
    controller.text = [self.webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [nav.navigationBar setBackgroundColor:[UIColor blackColor]];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)canBecomeFirstResponder
{
    [super canBecomeFirstResponder];
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    [super canPerformAction:action withSender:sender];
    if (action == @selector(dict:)) {
        return YES;
    }
    return NO;
}

- (void)back:(id)sender
{
    _dissmissed = YES;
    [_popController dismissPopoverAnimated:NO];
    _popController = nil;
    [_playerController stop];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeBookInfoPlist:(id)value key:(NSString *)key
{
    [HKUtility writePlistValue:@"BookInfo" value:value key:key];
}

- (void)info:(id)sender
{
    UIButton *btn = sender;
    
    HKInfoViewController *controller = [[HKInfoViewController alloc] initWithNibName:@"HKInfoViewController" bundle:nil];
    controller.delegate = self;
    controller.brightness = [UIScreen mainScreen].brightness;
    controller.textOption = _textOption;
    
    controller.fontSize = [[HKUtility plistValue:@"BookInfo" key:@"FontSize"] floatValue];
    
    controller.mark = [HKUtility lessonMark:_book lesson:_lesson];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.delegate = self;
    _popController = popover;
    popover.tint = FPPopoverTransparent | FPPopoverBlackTint;
    
    popover.contentSize = CGSizeMake(controller.view.frame.size.width, controller.view.frame.size.height);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    NSLog(@"%@", btn.superview);
    
    [popover presentPopoverFromView:btn];
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

- (void)dealloc
{
    //[_brightnessWindow removeFromSuperview];
    [_popController dismissPopoverAnimated:NO];
    _popController = nil;
    NSLog(@"Lesson dealloc");
}

- (void)loadHighlightParaJavaScript
{
    NSString *js = @""
    //////HighlightParaScript
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function highlightPara(elementId) { "
        "var top = document.getElementById(elementId).getBoundingClientRect().top;"
        "var bottom = document.getElementById(elementId).getBoundingClientRect().bottom;"
        "var docTop = document.documentElement.getBoundingClientRect().top;"
        "if (bottom - top > document.body.clientHeight)"
        "{"
            "window.scrollTo(0, top - docTop);"
        "}"
        "else "
        "{"
            "window.scrollTo(0, top - docTop + (bottom - top - document.body.clientHeight) / 2);"
        "}"
        "document.getElementById(elementId).style.border='dashed';"
        "document.getElementById(elementId).style.borderColor='blue';"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    ///////ScrollScript
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function scrollToCurrentPara(elementId) { "
        "var top = document.getElementById(elementId).getBoundingClientRect().top;"
        "var bottom = document.getElementById(elementId).getBoundingClientRect().bottom;"
        "var docTop = document.documentElement.getBoundingClientRect().top;"
        "var docBottom = document.documentElement.getBoundingClientRect().bottom;"
        "var scroll = 0;"
        "if (bottom - top > document.body.clientHeight - 200)"
        "{"
            "scroll = top - docTop - 100;"
            //"window.scrollTo(0, top - docTop);"
        "}"
        "else "
        "{"
            //"window.scrollTo(0, top - docTop + (bottom - top - document.body.clientHeight) / 2);"
            "scroll = top - docTop + (bottom - top - document.body.clientHeight) / 2;"
        "}"
        "if (scroll > docBottom - docTop - document.body.clientHeight) {"
            //"scroll = docBottom - docTop - document.body.clientHeight;"
        "}"
        "window.scrollTo(0, scroll);"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    ///////ParaClickedScript
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function paraClicked(cmd,parameter) { "
        "window.location.href='objc://'+cmd+':/'+parameter;"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    ///////GetStyle
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function getStyle(name) { "
        "for (var i=0; i < document.styleSheets.length; i++) {"
            "var rules;"
            "if (document.styleSheets[i].cssRules) {"
                "rules = document.styleSheets[i].cssRules;"
            "} else {"
                "rules = document.styleSheets[i].rules;"
            "}"
        "}"
        "for (var j=0; j < rules.length; j++) {"
            "if (rules[j].selectorText == name) {"
                "return rules[j].style;"
            "}"
        "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    ///////FontSize
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function changeFontSize(size) { "
        "getStyle('.en').fontSize = size + 'pt';"
        "getStyle('.zh').fontSize = size-5 + 'pt';"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    ////////TextColor
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function changeTextColor(enColor, zhColor) { "
        "getStyle('.en').color = enColor;"
        "getStyle('.zh').color = zhColor;"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    
    /////////BackgroundColor
    "var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function changeBackgroundColor(bgColor) { "
        "document.getElementsByTagName('body')[0].style.backgroundColor = bgColor;"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);"
    
    "";//end js
    
    [_webView stringByEvaluatingJavaScriptFromString:js];
}

- (CGRect)rectOfPopover:(int)paraIndex
{
    NSString *top = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"p%d\").getBoundingClientRect().top;", paraIndex]];
    NSString *bottom = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"p%d\").getBoundingClientRect().bottom;", paraIndex]];
    
    CGFloat topValue = [top floatValue];
    CGFloat bottomValue = [bottom floatValue];
    CGFloat height = bottomValue - topValue;
    
    if (topValue < 100 && bottomValue + 100 > self.webView.frame.size.height) {
        topValue = 100;
        height = self.webView.frame.size.height - 100;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        topValue += 64;
    }
    
    return CGRectMake(0, topValue, self.webView.frame.size.width, height);
}

- (void)popPlayerView:(int)paraIndex
{
    HKPlayerPopViewController *controller = [[HKPlayerPopViewController alloc] initWithNibName:@"HKPlayerPopViewController" bundle:nil];
    _playerPopController = controller;
    controller.book = _book;
    controller.lesson = _lesson;
    controller.paraCount = _paraCount;
    controller.delegate = self;
    controller.paraIndex = paraIndex;
    controller.timeList = _timeList;
    controller.view.backgroundColor = [UIColor clearColor];
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.delegate = self;
    _popController = popover;
    popover.tint = FPPopoverTransparent | FPPopoverBlackTint;
    
    popover.contentSize = CGSizeMake(self.view.frame.size.width, controller.view.frame.size.height);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    [popover presentPopoverFromRect:[self rectOfPopover:paraIndex] inView:self.webView];
}

- (void)paraClicked:(NSString *)pId
{
    NSLog(@"%@ clicked dismissed=%d \n", pId, _dissmissed);
    
    if (_dissmissed || pId.length <= 1) {
        return;
    }
    
    if (!_menuVisible) {
        int index = [[pId substringFromIndex:1] intValue];
        if ([_playerController isPlaying]) {
            [_playerController playAtPara:index];
        }
        else {
            [self popPlayerView:index];
        }
    }
}

- (void)loadNewLosson:(int)lesson
{
    _lesson = lesson;
    [self.delegate lessonViewController:self lessonChenged:_lesson];
    [self loadText];
}

#pragma mark - FPPopoverControllerDelegate

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

- (void)popoverControllerDidDismissPopover:(FPPopoverController *)popoverController
{
    _popController = nil;
    [_playerPopController stop];
    _playerPopController = nil;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self loadPlayerView];
    [self loadHighlightParaJavaScript];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"]) {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        NSString *funcStr = [arrFucnameAndParameter objectAtIndex:0];
        
        if ([arrFucnameAndParameter count] == 1) {
        }
        else {
            if([funcStr isEqualToString:@"paraClicked:"]) {
                [self paraClicked:[arrFucnameAndParameter objectAtIndex:1]];
            }
        }
    }
    return YES;
}

#pragma mark - HKPlayerViewControllerDelegate
- (void)playerViewController:(id)delegate paragraphIndex:(int)index
{
    if (_currentParagraph >= 0) {
        NSString *js = [NSString stringWithFormat:@"document.getElementById(\"p%d\").style.border=\"none\"", _currentParagraph];
        [_webView stringByEvaluatingJavaScriptFromString:js];
    }
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"highlightPara(\"p%d\");", index]];
    
//    NSString *ret = [_webView stringByEvaluatingJavaScriptFromString:@"window.innerHeight;"];
//    NSString *top = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"p%d\").getBoundingClientRect().top;", index]];
//    NSString *bottom = [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementById(\"p%d\").getBoundingClientRect().bottom;", index]];
//    NSLog(@"screen %@, %f, %f, top = %@, bottom = %@", ret, self.webView.frame.size.height, self.webView.bounds.size.height, top, bottom);
    _currentParagraph = index;
}

- (int)playerViewControllerNextLesson:(id)delegate
{
    NSString *fileName = [NSString stringWithFormat:@"B%d_Contents.plist", _book];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d", _book]];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    int newLesson = _lesson + 1;
    if (_book == 1) {
        newLesson++;
    }
    if (newLesson <= [array count]) {
        [self loadNewLosson:newLesson];
    }
    
    return _lesson;
}

- (BOOL)playerViewControllerOpenLesson:(int)lesson
{
    NSString *fileName = [NSString stringWithFormat:@"B%d_Contents.plist", _book];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d", _book]];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if (lesson > 0 && lesson <= [array count]) {
        [self loadNewLosson:lesson];
        return YES;
    }
    
    return NO;
}

- (int)playerViewControllerOpenRandomLesson
{
    NSString *fileName = [NSString stringWithFormat:@"B%d_Contents.plist", _book];
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"Data/Book%d", _book]];
    
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    int newLesson = rand() % [array count] + 1;
    [self loadNewLosson:newLesson];
    return _lesson;
}

- (int)playerViewControllerPreLesson:(id)delegate
{
    int newLesson = _lesson - 1;
    if (_book == 1) {
        newLesson--;
    }
    if (newLesson >= 1) {
        [self loadNewLosson:newLesson];
    }
    return _lesson;
}

- (void)playerDidStop:(id)delegate
{
    if (_currentParagraph >= 0) {
        NSString *js = [NSString stringWithFormat:@"document.getElementById(\"p%d\").style.border=\"none\"", _currentParagraph];
        [_webView stringByEvaluatingJavaScriptFromString:js];
        _currentParagraph = -1;
    }
}

#pragma mark - HKPlayerPopViewControllerDelegate
- (void)playerPopViewController:(id)sender playPara:(int)index
{
    HKPlayerPopViewController *controller = sender;
    [UIView animateWithDuration:0.2 animations:^{
        
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"scrollToCurrentPara(\"p%d\");", controller.paraIndex]];
    } completion:^(BOOL finished) {
        if (finished) {
            [_popController moveToRect:[self rectOfPopover:controller.paraIndex]];
        }
    }];
}

- (void)playerViewController:(id)delegate playListClicked:(id)sender
{
    UIButton *btn = sender;
    
    HKPlayListViewController *controller = [[HKPlayListViewController alloc] initWithNibName:@"HKPlayListViewController" bundle:nil];
    controller.delegate = self;
    controller.book = _book;
    controller.lesson = _lesson;
    
    FPPopoverController *popover = [[FPPopoverController alloc] initWithViewController:controller];
    popover.delegate = self;
    _popController = popover;
    popover.tint = FPPopoverTransparent | FPPopoverBlackTint;
    
    popover.contentSize = CGSizeMake(controller.view.frame.size.width, controller.view.frame.size.height);
    popover.arrowDirection = FPPopoverArrowDirectionAny;
    
    NSLog(@"%@", btn.superview);
    
    [popover presentPopoverFromView:btn];
}

#pragma mark - HKInfoViewControllerDelegate
- (void)infoViewController:(id)sender brightness:(CGFloat)brightness
{
    UIScreen *screen = [UIScreen mainScreen];
    [screen setBrightness:brightness];
}

- (void)infoViewController:(id)sender fontSize:(CGFloat)size
{
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeFontSize(%d);", (int)floorf(size + 0.5)]];
    [self writeBookInfoPlist:[NSNumber numberWithInt:floorf(size + 0.5)] key:@"FontSize"];
}

- (void)infoViewController:(id)sender changeLessonText:(LessonTextOption)option
{
    _textOption = option;
    [self loadWebView];
}

- (void)infoViewControllerNightmodeChanged:(id)sender
{
    HKNightmodeStyle *style = [self textColorStyle];
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeTextColor(\"#%@\", \"#%@\");", style.enTextColor, style.chTextColor]];
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"changeBackgroundColor(\"#%@\");", style.backgroundColor]];
}

- (void)infoViewControllerOpenSetting:(id)sender
{
    [_popController dismissPopoverAnimated:NO];
    
    HKSettingViewController *controller = [[HKSettingViewController alloc] initWithNibName:@"HKSettingViewController" bundle:nil];
    controller.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [nav.navigationBar setBackgroundColor:[UIColor blackColor]];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    [self presentViewController:nav animated:YES completion:NO];
}

- (void)infoViewController:(id)sender lessonMarkChanged:(LessonMark)mark
{
    [HKUtility setLessonMark:mark book:_book lesson:_lesson];
}

#pragma mark - HKPlayListViewControllerDelegate
- (void)playListViewControllerDidSelect:(id)sender lesson:(int)lesson
{
    [_popController dismissPopoverAnimated:YES];
    if (_lesson != lesson) {
        [_playerController stop];
        [self loadNewLosson:lesson];
    }
}

#pragma mark - HKSettingViewControllerDelegate
- (void)settingViewControllerDidFinish:(id)sender
{
    [self loadText];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
