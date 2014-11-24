//
//  SKProduct+LocalizedPrice.h
//  NewConcept
//
//  Created by user on 14-9-3.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
