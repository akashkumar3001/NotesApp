//
//  AppDelegate.m
//  DZAKNotes
//
//  Created by Akash Kumar on 9/15/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"

#import "NotesTVC.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    NotesTVC * view = [[NotesTVC alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:view];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}
							

@end
