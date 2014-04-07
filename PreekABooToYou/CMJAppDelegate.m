//
//  CMJAppDelegate.m
//  PreekABooToYou
//
//  Created by Claire Jencks on 4/4/14.
//  Copyright (c) 2014 Claire Jencks. All rights reserved.
//

#import "CMJAppDelegate.h"
#import "AllProfileViewController.h"
#import "FriendsViewController.h"
#import "CoWorkerViewController.h"

@implementation CMJAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UITabBarController *tabBarController = (id)self.window.rootViewController;
    AllProfileViewController *allProfileViewController;
    FriendsViewController *friendsViewController;
    CoWorkerViewController *coWorkersViewController;
    for (UINavigationController *navController in tabBarController.viewControllers)
    {
        for (UIViewController *viewController in navController.viewControllers)
        {
            if ([viewController isKindOfClass:[AllProfileViewController class]])
            {
                allProfileViewController = (id)viewController;
            }
            else if ([viewController isKindOfClass:[FriendsViewController class]])
            {
                friendsViewController = (id)viewController;
            }
            else if ([viewController isKindOfClass:[CoWorkerViewController class]])
            {
                coWorkersViewController = (id)viewController;
            }
        }
    }
    allProfileViewController.managedObjectContext = self.managedObjectContext;
    friendsViewController.managedObjectContext = self.managedObjectContext;
    coWorkersViewController.managedObjectContext = self.managedObjectContext;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    }

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PreekABooToYou" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PreekABooToYou.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
