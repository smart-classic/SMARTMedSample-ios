/*
 SMAppDelegate.m
 SMART Medications Sample

 Created by Pascal Pfiffner on 8/10/12.
 Copyright (c) 2012 CHIP, Boston Children's Hospital. All rights reserved.
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

#import "SMAppDelegate.h"
#import "SMServer.h"
#import "MedListViewController.h"


@interface SMAppDelegate ()

@property (nonatomic, readwrite, strong) SMServer *smart;
@property (nonatomic, strong) MedListViewController *listController;

@end


@implementation SMAppDelegate

@synthesize smart, window, listController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

	self.listController = [[MedListViewController alloc] initWithStyle:UITableViewStylePlain];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:listController];
    [self.window makeKeyAndVisible];
	
    return YES;
}



#pragma mark - Framework Delegate
- (UIViewController *)viewControllerToPresentLoginViewController:(SMLoginViewController *)loginVC
{
	return window.rootViewController;
}

- (void)userDidLogout:(SMServer *)fromServer
{
	[listController unloadData];
}


@end
