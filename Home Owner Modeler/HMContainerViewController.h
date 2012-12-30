//
//  HMContainerViewController.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "HMMenuViewController.h"
#import "HMHomeViewController.h"
#import "HMHomePhotosTableViewController.h"
#import "HMItemPhotosTableViewController.h"

static NSString * const kAGViewDeckDidChangeVisibleController = @"AGViewDeckDidChangeVisibleController";
static NSString * const kAGViewDeckVisibleViewControllerKey = @"visibleViewController";

@class HMHomeViewController;

@interface HMContainerViewController : UIViewController <UIGestureRecognizerDelegate,
UIScrollViewDelegate,
IIViewDeckControllerDelegate,
HMMenuViewControllerDelegate,
UIPopoverControllerDelegate> {
    BOOL shouldShowMenu;
}

@property (strong, nonatomic) IIViewDeckController *mainDeckController;
@property (strong, nonatomic) HMMenuViewController *menuView;
@property (strong, nonatomic) UIView *mainViewContainer;
@property (strong, nonatomic) UIView *coverView;
@property (strong, nonatomic) UIImageView *menuAnchor;
@property (strong, nonatomic) UINavigationController *centerController;
@property (strong, nonatomic) UINavigationController *leftController;
@property (strong, nonatomic) UINavigationController *rightController;
@property (strong, nonatomic) HMHomeViewController *homeViewController;
@property (strong, nonatomic) HMHomePhotosTableViewController *homePhotosTableViewController;
@property (strong, nonatomic) HMItemPhotosTableViewController *itemPhotosTableViewController;
@property (strong, nonatomic) UIPopoverController* popOver;
@property (nonatomic) CGRect screenSize;

- (void)showMenu:(id)sender animated:(BOOL)animate;
- (void)openMenu;
- (void)closeMenu;

+ (HMContainerViewController*)containerController;

@end