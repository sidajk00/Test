//
//  HKUtility.m
//  NewConcept
//
//  Created by user on 14-5-15.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import "HKUtility.h"

@implementation HKUtility

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    return [HKUtility imageWithColor:color size:size isCircle:NO];	
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size isCircle:(BOOL)circle
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    if (circle) {
        CGContextFillEllipseInRect(context, rect);
    }
    else {
        CGContextFillRect(context, rect);
    }
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)createDefaultBookInfoPlist
{
    NSString *name = @"BookInfo";
    NSString *plistPath = [HKUtility plistPath:name];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ([dict objectForKey:@"Nightmode"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithBool:NO] key:@"Nightmode"];
    }
    if ([dict objectForKey:@"EnTextColor"] == nil) {
        [self writePlistValue:name value:@"000000" key:@"EnTextColor"];
    }
    if ([dict objectForKey:@"ChTextColor"] == nil) {
        [self writePlistValue:name value:@"78d23c" key:@"ChTextColor"];
    }
    if ([dict objectForKey:@"Night_EnTextColor"] == nil) {
        [self writePlistValue:name value:@"ffffff" key:@"Night_EnTextColor"];
    }
    if ([dict objectForKey:@"Night_ChTextColor"] == nil) {
        [self writePlistValue:name value:@"bebebe" key:@"Night_ChTextColor"];
    }
    if ([dict objectForKey:@"BackgroundColor"] == nil) {
        [self writePlistValue:name value:@"ffffff" key:@"BackgroundColor"];
    }
    if ([dict objectForKey:@"Night_BackgroundColor"] == nil) {
        [self writePlistValue:name value:@"0a5aaa" key:@"Night_BackgroundColor"];
    }
    if ([dict objectForKey:@"FontSize"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithInt:20] key:@"FontSize"];
    }
    if ([dict objectForKey:@"Brightness"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithInt:1] key:@"Brightness"];
    }
    if ([dict objectForKey:@"Accent"] == nil) {
        [self writePlistValue:name value:@"美音" key:@"Accent"];
    }
    if ([dict objectForKey:@"Dict"] == nil) {
        [self writePlistValue:name value:@"Dict" key:@"Dict"];
    }
    if ([dict objectForKey:@"HadReadBook1"] == nil) {
        [self writePlistValue:name value:[HKUtility objectToJsonString:[NSDictionary dictionary]] key:@"HadReadBook1"];
    }
    if ([dict objectForKey:@"HadReadBook2"] == nil) {
        [self writePlistValue:name value:[HKUtility objectToJsonString:[NSDictionary dictionary]] key:@"HadReadBook2"];
    }
    if ([dict objectForKey:@"HadReadBook3"] == nil) {
        [self writePlistValue:name value:[HKUtility objectToJsonString:[NSDictionary dictionary]] key:@"HadReadBook3"];
    }
    if ([dict objectForKey:@"HadReadBook4"] == nil) {
        [self writePlistValue:name value:[HKUtility objectToJsonString:[NSDictionary dictionary]] key:@"HadReadBook4"];
    }
    if ([dict objectForKey:@"FullVersion1"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithBool:NO] key:@"FullVersion1"];
    }
    if ([dict objectForKey:@"FullVersion2"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithBool:NO] key:@"FullVersion2"];
    }
    if ([dict objectForKey:@"FullVersion3"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithBool:NO] key:@"FullVersion3"];
    }
    if ([dict objectForKey:@"FullVersion4"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithBool:NO] key:@"FullVersion4"];
    }
}

+ (void)setDefaultDaymode
{
    NSString *name = @"BookInfo";
    [self writePlistValue:name value:@"000000" key:@"EnTextColor"];
    [self writePlistValue:name value:@"78d23c" key:@"ChTextColor"];
    [self writePlistValue:name value:@"ffffff" key:@"BackgroundColor"];
}

+ (void)setDefaultNightmode
{
    NSString *name = @"BookInfo";
    [self writePlistValue:name value:@"ffffff" key:@"Night_EnTextColor"];
    [self writePlistValue:name value:@"bebebe" key:@"Night_ChTextColor"];
    [self writePlistValue:name value:@"0a5aaa" key:@"Night_BackgroundColor"];
}

+ (void)createDefaultPlayPlist
{
    NSString *name = @"Play";
    NSString *plistPath = [HKUtility plistPath:name];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    if ([dict objectForKey:@"P_Order"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithInt:1] key:@"P_Order"];
    }
    if ([dict objectForKey:@"Order"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithInt:1] key:@"Order"];
    }
    if ([dict objectForKey:@"P_Speed"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithInt:3] key:@"P_Speed"];
    }
    if ([dict objectForKey:@"Speed"] == nil) {
        [self writePlistValue:name value:[NSNumber numberWithInt:3] key:@"Speed"];
    }
}

+ (NSString *)plistPath:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 
    //document path
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //plist path
    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plit", name]];
    
    return plistPath;
}

+ (id)plistValue:(NSString *)name key:(NSString *)key
{
    NSString *plistPath = [HKUtility plistPath:name];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return [dict objectForKey:key];
}

+ (void)writePlistValue:(NSString *)name value:(id)value key:(NSString *)key
{
    NSString *plistPath = [HKUtility plistPath:name];
    
    NSMutableDictionary *dict = nil;
    if(![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        dict = [[NSMutableDictionary alloc] init];
    }
    else {
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    
    [dict setObject:value forKey:key];
    [dict writeToFile:plistPath atomically:YES];
}

+ (NSString *)dictUrl
{
    NSString *defaultUrl = @"http://m.youdao.com/dict?q=";
    
    NSString *dictName = [self plistValue:@"BookInfo" key:@"Dict"];
    if (![dictName isKindOfClass:[NSString class]]) {
        return defaultUrl;
    }
    
    if ([dictName isEqualToString:@"有道"]) {
        return defaultUrl;
    }
    else if ([dictName isEqualToString:@"金山词霸"]) {
        return @"http://wap.iciba.com/cword/";
    }
    else if ([dictName isEqualToString:@"Dict"]) {
        return @"http://m.dict.cn/";
    }
    
    return defaultUrl;
}

+ (NSArray *)dictList
{
    return [NSArray arrayWithObjects:@"金山词霸", @"Dict", @"有道", nil];
}

+ (NSString *)objectToJsonString:(id)obj
{
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

+ (id)jsonStringToObject:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    return object;
}

+ (LessonMark)lessonMark:(int)book lesson:(int)lesson
{
    NSDictionary *hadReadLessons = [HKUtility jsonStringToObject:[HKUtility plistValue:@"BookInfo" key:[NSString stringWithFormat:@"HadReadBook%d", book]]];
    return [[hadReadLessons objectForKey:[NSString stringWithFormat:@"%d", lesson]] intValue];
}

+ (void)setLessonMark:(LessonMark)mark book:(int)book lesson:(int)lesson
{
    NSDictionary *hadReadLessons = [HKUtility jsonStringToObject:[HKUtility plistValue:@"BookInfo" key:[NSString stringWithFormat:@"HadReadBook%d", book]]];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:hadReadLessons];
    [newDict setObject:[NSNumber numberWithInt:mark] forKey:[NSString stringWithFormat:@"%d", lesson]];
    [HKUtility writePlistValue:@"BookInfo" value:[HKUtility objectToJsonString:newDict] key:[NSString stringWithFormat:@"HadReadBook%d", book]];
    
    NSLog(@"%@", [HKUtility plistValue:@"BookInfo" key:@"HadReadBook2"]);
}

@end


@implementation UINavigationController (Rotation_IOS6)
-(BOOL)shouldAutorotate {
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations {
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}
@end

