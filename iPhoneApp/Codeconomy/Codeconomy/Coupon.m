//
//  CouponCode.m
//  Codeconomy
//
//  Created by studio on 2/26/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon
@dynamic seller;
@dynamic status;
@dynamic price;
@dynamic expirationDate;
@dynamic storeName;
@dynamic couponDescription;
@dynamic additionalInfo;
@dynamic code;
@dynamic category;
@dynamic deleted;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Coupon";
}

- (instancetype)initWithSeller:(User *)seller
                        status:(int)status
                         price:(int)price
                expirationDate:(NSDate *)expirationDate
                     storeName:(NSString *)storeName
             couponDescription:(NSString *)couponDescription
                additionalInfo:(NSString *)additionalInfo
                          code:(NSString *)code
                      category:(NSString *)category
                       deleted:(BOOL)deleted {
    self = [super init];
    if (self) {
        self.seller = seller;
        self.status = status;
        self.price = price;
        self.expirationDate = expirationDate;
        self.storeName = storeName;
        self.couponDescription = couponDescription;
        self.additionalInfo = additionalInfo;
        self.code = code;
        self.category = category;
        self.deleted = deleted;
    }
    return self;
}

@end
