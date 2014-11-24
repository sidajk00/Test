//
//  InAppPurchaseManager.h
//  NewConcept
//
//  Created by user on 14-9-2.
//  Copyright (c) 2014年 Ice. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}

- (void)requestProUpgradeProductData;


- (void)loadStore;
- (BOOL)canMakePurchases;
- (void)purchaseProUpgrade:(SKProduct *)product;

@end
