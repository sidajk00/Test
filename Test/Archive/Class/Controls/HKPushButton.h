//
//  HKPushButton.h
//  NewConcept
//
//  Created by user on 14-5-11.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKPushButton : UIButton

@property (nonatomic, assign) BOOL buttonSelected;
@property (nonatomic, retain) UIImage *buttonSelectedImage;
@property (nonatomic, retain) UIImage *buttonNormalImage;

@end
