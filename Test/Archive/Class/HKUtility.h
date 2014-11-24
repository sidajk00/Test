//
//  HKUtility.h
//  NewConcept
//
//  Created by user on 14-5-15.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LessonMark) {
    LessonMarkNone,
    LessonMarkHasRead,
    LessonMarkLearnt
};

@interface HKUtility : NSObject

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isCircle:(BOOL)circle;

+ (void)createDefaultBookInfoPlist;
+ (void)setDefaultDaymode;
+ (void)setDefaultNightmode;
+ (void)createDefaultPlayPlist;
+ (NSString *)plistPath:(NSString *)name;
+ (id)plistValue:(NSString *)name key:(NSString *)key;
+ (void)writePlistValue:(NSString *)name value:(id)obj key:(NSString *)key;

+ (NSString *)objectToJsonString:(id)obj;

+ (id)jsonStringToObject:(NSString *)jsonString;

+ (NSString *)dictUrl;
+ (NSArray *)dictList;

+ (LessonMark)lessonMark:(int)book lesson:(int)lesson;
+ (void)setLessonMark:(LessonMark)mark book:(int)book lesson:(int)lesson;

@end

//@interface UINavigationController (Rotation_IOS6)
//-(BOOL)shouldAutorotate;
//
//-(NSUInteger)supportedInterfaceOrientations;
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation;
//
//@end
