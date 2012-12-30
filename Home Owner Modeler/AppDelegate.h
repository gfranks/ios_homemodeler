//
//  AppDelegate.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 8/5/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMContainerViewController.h"
#import "IIViewDeckController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) HMContainerViewController *containerController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
