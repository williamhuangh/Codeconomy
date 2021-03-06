//
//  Filter.m
//  Codeconomy
//
//  Created by studio on 2/26/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

#import "Filter.h"

@implementation Filter
@dynamic category;
@dynamic coupon;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Filter";
}

- (instancetype)initWithCategory:(int)category
                        coupon:(Coupon *)coupon {
    self = [super init];
    if (self) {
        self.category = category;
        self.coupon = coupon;
    }
    return self;
}
@end
