//
//  HKCopyableLabel.h
//  NewConcept
//
//  Created by user on 14-5-11.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKCopyableLabel;

@protocol HKCopyableLabelDelegate <NSObject>

@optional
- (NSString *)stringToCopyForCopyableLabel:(HKCopyableLabel *)copyableLabel;
- (CGRect)copyMenuTargetRectInCopyableLabelCoordinates:(HKCopyableLabel *)copyableLabel;

@end

@interface HKCopyableLabel : UILabel

@property (nonatomic, assign) BOOL copyingEnabled; // Defaults to YES

@property (nonatomic, weak) id<HKCopyableLabelDelegate> copyableLabelDelegate;

@property (nonatomic, assign) UIMenuControllerArrowDirection copyMenuArrowDirection; // Defaults to UIMenuControllerArrowDefault

@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end
