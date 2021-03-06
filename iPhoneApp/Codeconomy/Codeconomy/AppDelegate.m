//
//  AppDelegate.m
//  Codeconomy
//
//  Created by studio on 2/5/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginSignupViewController.h"
#import "User.h"
#import "Coupon.h"
#import "Transaction.h"
#import "Util.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation UILabel (SubstituteFontName)
- (void)setSubstituteFontName:(NSString *)name UI_APPEARANCE_SELECTOR {
    self.font = [UIFont fontWithName:name size:self.font.pointSize];
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"codeconomy";
        configuration.clientKey = @"";
        configuration.server = @"http://codeconomy.herokuapp.com/parse";
    }]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginSignupViewController *loginSignup = [[LoginSignupViewController alloc] init];
    
    self.window.rootViewController = loginSignup;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [[UILabel appearance] setSubstituteFontName:@"Rubik-Regular"];
    
    // Change search bar font
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSFontAttributeName: [Util getRegularFont:14.0]}];

    // Hide line under navigation bar
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    // Hide arrow from navigation bar
    [UINavigationBar appearance].backIndicatorImage = [[UIImage alloc] init];
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [[UIImage alloc] init];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-10, 0) forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]] setTitleTextAttributes:@{
                                                                                                                       NSFontAttributeName: [Util getRegularFont:17.0],
                                                                                                                       NSForegroundColorAttributeName: [UIColor blackColor]} forState:UIControlStateNormal];
    
    // Set tab bar item font
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[Util getRegularFont:10.0]} forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[[Util sharedManager] colorWithHexString:[Util getBlueColorHex]]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSFontAttributeName: [Util getRegularFont:19.0]}];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) addMockUser {
    User *gary = [[User alloc] initWithUsername:@"garythung" password:@"garythung" displayName:@"Gary Thung" status:0 credits:36 rating:5.0];
    [gary signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
             NSLog(@"%@", error);
        }
    }];
    User *will = [[User alloc] initWithUsername:@"whuang" password:@"whuang" displayName:@"Will Huang" status:0 credits:5 rating:5.0];
    [will signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"%@", error);
        }
    }];
}

- (void) addMockTransaction {
    User *buyer = [[[PFQuery queryWithClassName:@"_User"] whereKey:@"username" equalTo:@"garythung"] getFirstObject];
    User *seller = [[[PFQuery queryWithClassName:@"_User"] whereKey:@"username" equalTo:@"whuang"] getFirstObject];
    Coupon *coupon = [[Coupon alloc] initWithSeller:seller status:0 price:3 expirationDate:[NSDate date] storeName:@"testStore" couponDescription:@"1 free item" additionalInfo:@"less than $50" code:@"freeitem50" category:@"Clothing" deleted:false];
    
    [coupon saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"%@", error);
        }
    }];
    Transaction *transaction = [[Transaction alloc] initWithBuyer:buyer seller:seller coupon:coupon transactionDate:[NSDate date] reviewDescription:nil stars:-1];
    [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!succeeded) {
            NSLog(@"%@", error);
        }
    }];
}

@end
