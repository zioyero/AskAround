//
//  AAAppDelegate.m
//  AskAround
//
//  Created by Adrian Castillejos on 2/21/14.
//  Copyright (c) 2014 Holy Moley. All rights reserved.
//

#import "AAAppDelegate.h"
#import "AAFbLoginViewController.h"
#import "AAProfileViewController.h"
#import "AAPerson.h"
#import "AAAsk.h"
#import "AAAnswer.h"
#import "AAFriendsListViewController.h"
#import <Parse/PFFacebookUtils.h>

@implementation AAAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Register our Parse Application.
    [Parse setApplicationId:@"kVViVSOYYHOuHetEpHTXNM2mCriXlqenfzxEFiOw"
                  clientKey:@"41kOXDdJRuRNGuLTKmCmObjDIh7C8DPvNuTndHnl"];

    [AAPerson registerSubclass];
    [AAAsk registerSubclass];
    [AAAnswer registerSubclass];
    

    // Initialize Parse's Facebook Utilities singleton. This uses the FacebookAppID we specified in our App bundle's plist.
    [PFFacebookUtils initializeFacebook];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

//    AAFbLoginViewController *login = [[AAFbLoginViewController alloc] init];
    AAProfileViewController *meProfile = [[AAProfileViewController alloc] init];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:meProfile];
    navigationController.navigationBarHidden = NO;
    [tabBarController addChildViewController:navigationController];
    self.window.rootViewController = tabBarController;


    AAFriendsListViewController *friendsListViewController = [[AAFriendsListViewController alloc] init];
    navigationController = [[UINavigationController alloc] initWithRootViewController:friendsListViewController];
    [tabBarController addChildViewController:navigationController];

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

@end
