//
//  HMContainerViewController.m
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import "HMContainerViewController.h"
#import "AppDelegate.h"

#define kMenuContentViewTag 1234
#define kViewDeckIpadLeftSizeLand 733
#define kViewDeckIpadLeftSizePort 480
#define kViewDeckIpadRightSizeLand 733
#define kViewDeckIpadRightSizePort 480
#define kViewDeckIphoneLeftSide  38
#define kViewDeckIphoneRightSide 38

typedef enum {
    ViewDeckOpenSideNone,
    ViewDeckOpenSideLeft,
    ViewDeckOpenSideRight
} ViewDeckOpenSide;

@interface HMContainerViewController () {
    CGRect menuRect;
}
@property (nonatomic, assign) ViewDeckOpenSide openSide;
@property (nonatomic, strong) UIImageView *mainDropShadowView;

@property (nonatomic) CGSize currentlyResizedPhotoCGSize;

@end

@implementation HMContainerViewController

@synthesize mainDeckController;
@synthesize menuView;
@synthesize mainViewContainer;
@synthesize coverView;
@synthesize menuAnchor;
@synthesize centerController;
@synthesize leftController;
@synthesize rightController;
@synthesize popOver;
@synthesize mainDropShadowView = _mainDropShadowView;
@synthesize openSide = _openSide;
@synthesize screenSize;
@synthesize currentlyResizedPhotoCGSize;
@synthesize homeViewController, homePhotosTableViewController, itemPhotosTableViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _openSide = ViewDeckOpenSideNone;
        self.screenSize = [[UIScreen mainScreen] bounds];
    }
    return self;
}

# pragma mark - View Life Cycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.homeViewController = [[HMHomeViewController alloc] initWithNibName:@"HMHomeViewController" bundle:nil];
    self.homePhotosTableViewController = [[HMHomePhotosTableViewController alloc] initWithNibName:@"HMHomePhotosTableViewController" bundle:nil];
    self.itemPhotosTableViewController = [[HMItemPhotosTableViewController alloc] initWithNibName:@"HMItemPhotosTableViewController" bundle:nil];
    self.centerController = [[UINavigationController alloc] initWithRootViewController:self.homeViewController];
    self.leftController = [[UINavigationController alloc] initWithRootViewController:self.homePhotosTableViewController];
    self.rightController = [[UINavigationController alloc] initWithRootViewController:self.itemPhotosTableViewController];
    
    self.mainDeckController = [[IIViewDeckController alloc] initWithCenterViewController:self.centerController
                                                                      leftViewController:self.leftController
                                                                     rightViewController:self.rightController];
    
    [self.mainDeckController setDelegate:self];
    
    self.homeViewController.viewDeckController = self.mainDeckController;
    
    self.mainDeckController.view.frame = screenSize;
    
    self.view.multipleTouchEnabled = YES;
    
    
    [self createAndSetupViews];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(setVisibleScrollView:)
//                                                 name:kAGViewDeckDidChangeVisibleController
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

#pragma mark - Notifications

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)createAndSetupViews {
    
    shouldShowMenu = YES;
    
    self.mainViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.menuView = [[HMMenuViewController alloc] initWithNibName:@"HMMenuViewController" bundle:nil];
    menuRect = CGRectMake(self.view.frame.origin.x,
                          self.view.frame.size.height - self.menuView.view.frame.size.height,
                          self.view.frame.size.width,
                          self.menuView.view.frame.size.height);
    self.menuView.view.frame = menuRect;
    
    [self.menuView.scrollView setScrollsToTop:NO];
    [self.menuView.scrollView setClipsToBounds:NO];
    [self.menuView.scrollView setScrollEnabled:YES];
    [self.menuView.scrollView setPagingEnabled:YES];
    [self.menuView.scrollView setContentSize:CGSizeMake(640, menuView.scrollView.bounds.size.height)];
    
    self.menuView.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"TexturedBackgroundColor.png"]];
    
    [self showDefaultMenuButton];
    
    self.menuView.viewDeckController = self.mainDeckController;
    self.menuView.menuDelegate = self;
    
    UIImage *dropShadow = [UIImage imageNamed:@"dropshadow.png"];
    self.mainDropShadowView = [[UIImageView alloc] initWithImage:dropShadow];
    self.mainDropShadowView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 25);
    
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.0;
    
    // Add tap recognizer to cover view
    UITapGestureRecognizer *coverTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(handleTap:)];
    coverTapRecognizer.delegate = self;
    [coverView addGestureRecognizer:coverTapRecognizer];
    
    // Compile views, do not change this order!
    [self.view              addSubview:self.menuView.view];
    [self.mainViewContainer addSubview:self.mainDropShadowView];
    [self.mainViewContainer addSubview:self.mainDeckController.view];
    [self.mainViewContainer addSubview:self.coverView];
    [self.mainViewContainer addSubview:self.menuAnchor];
    [self.view              addSubview:self.mainViewContainer];
}

# pragma mark - Tap Recognizer Methods

- (void)handleTap:(UIPanGestureRecognizer *)recognizer {
    
    [self showMenu:self animated:YES];
}

- (void)showMenu:(id)sender animated:(BOOL)animate {
    
    if (shouldShowMenu) {
        
        [self openMenu];
    } else {
        
        [self closeMenu];
    }
}

# pragma mark - Show Menu Button Action Methods

- (void)showMenuButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.menuAnchor.hidden = NO;
        self.menuAnchor.alpha = 1.0;
    }];
}

- (void)hideMenuButton {
    [UIView animateWithDuration:0.3 animations:^{
        self.menuAnchor.alpha = 0.0;
    }
                     completion:^(BOOL finished){
                         self.menuAnchor.hidden = YES;
                     }];
}

- (void)showDefaultMenuButton {
    self.menuAnchor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_button.png"]];
    self.menuAnchor.frame = CGRectMake((self.view.frame.size.width / 2) - 35,
                                  self.view.frame.size.height,
                                  68,
                                  59);
    self.menuAnchor.userInteractionEnabled = YES;
    
    // Add tap recognizer to menuAnchor image view
    UITapGestureRecognizer *buttonTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(handleTap:)];
    buttonTapRecognizer.delegate = self;
    [self.menuAnchor addGestureRecognizer:buttonTapRecognizer];
    
    [self animateOpeningMenuButton];
}

- (void)animateOpeningMenuButton {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.menuAnchor.frame = CGRectMake((self.view.frame.size.width / 2) - 35,
                                      self.view.frame.size.height - 59,
                                      68,
                                      59);
    }
                     completion:nil];
}

- (void)animateClosingMenuButton {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.menuAnchor.frame = CGRectMake((self.view.frame.size.width / 2) - 35,
                                           self.view.frame.size.height,
                                           68,
                                           59);
    }
                     completion:nil];
}

#pragma mark - CABasicAnimation Delegate

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [self.menuAnchor.layer removeAllAnimations];
//}

# pragma mark - Menu Open/Close Action Methods

- (void)openMenu {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.menuAnchor.image        = [UIImage imageNamed:@"menu_button_active.png"];
        self.coverView.alpha         = 0.6;
        self.mainViewContainer.frame = CGRectMake(0,
                                             -(self.menuView.view.frame.size.height),
                                             mainViewContainer.frame.size.width,
                                             mainViewContainer.frame.size.height);
        shouldShowMenu               = NO;
    }];
}


- (void)closeMenu {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.menuAnchor.image        = [UIImage imageNamed:@"menu_button.png"];
        self.coverView.alpha         = 0.0;
        self.mainViewContainer.frame = CGRectMake(0, 0, mainViewContainer.frame.size.width, mainViewContainer.frame.size.height);
        shouldShowMenu               = YES;
    }];
}

# pragma mark - AGMenuViewControllerDelegate Methods

- (void)closeMenu:(id)sender {
    [self closeMenu];
}

- (void)openMenu:(id)sender {
    [self openMenu];
}

- (void)resizePhoto {
    [self.homeViewController resizePhoto];
//    self.currentlyResizedPhotoCGSize = [[[self getModelerController] chosenOrTakenHomePhoto] size];
//    UIAlertView *resizeAlert= [[UIAlertView alloc]
//                               initWithTitle: @"Select photo scale"
//                               message:@" "
//                               delegate: nil
//                               cancelButtonTitle:@"Done"
//                               otherButtonTitles:nil];
//    UISlider *resizeSlider=[[UISlider alloc] initWithFrame:CGRectMake(45, 50, 200, 20)];
//    resizeSlider.maximumValue = 20.00;
//    resizeSlider.minimumValue = 1.00;
//    resizeSlider.value = 10.00;
//    [resizeSlider addTarget:self action:@selector(sliderHandler:) forControlEvents:UIControlEventValueChanged];
//    [resizeAlert addSubview:resizeSlider];
//    [resizeAlert show];
}

- (void) sliderHandler: (UISlider *)sender {
    CGFloat scaleSize = sender.value/10;
    [[self.homeViewController selectedHomePhoto] setImage:[self imageWithImage:[self.homeViewController chosenOrTakenHomePhoto] convertToSize:CGSizeMake(self.currentlyResizedPhotoCGSize.width*scaleSize, self.currentlyResizedPhotoCGSize.height*scaleSize)]];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+ (HMContainerViewController*)containerController {
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.containerController;
}

#pragma mark - IIViewDeckControllerDelegate Methods

- (void)viewDeckController:(IIViewDeckController*)viewDeckController
          willOpenViewSide:(IIViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    switch (viewDeckSide) {
        case IIViewDeckLeftSide:{
            [self animateClosingMenuButton];
            break;
        }
        case IIViewDeckRightSide: {
            [self animateClosingMenuButton];
            break;
        }
        case IIViewDeckTopSide:
        case IIViewDeckBottomSide:
        default:
            break;
    }
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController
           didOpenViewSide:(IIViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    
    switch (viewDeckSide) {
        case IIViewDeckLeftSide: {
            
            break;
        }
        case IIViewDeckRightSide: {
            
            break;
        }
        case IIViewDeckTopSide:
        case IIViewDeckBottomSide:
        default:
            break;
    }
    
}

#pragma mark - IIViewDeckControllerDelegate Methods

- (void)viewDeckController:(IIViewDeckController*)viewDeckController
         willCloseViewSide:(IIViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    switch (viewDeckSide) {
        case IIViewDeckLeftSide: {
            [self animateOpeningMenuButton];
            break;
        }
        case IIViewDeckRightSide: {
            [self animateOpeningMenuButton];
            break;
        }
        case IIViewDeckTopSide:
        case IIViewDeckBottomSide:
        default:
            break;
    }
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController
          didCloseViewSide:(IIViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    
    self.openSide = ViewDeckOpenSideNone;
    switch (viewDeckSide) {
        case IIViewDeckLeftSide:{
            
            break;
        }
        case IIViewDeckRightSide: {
            
            break;
        }
        case IIViewDeckTopSide:
        case IIViewDeckBottomSide:
        default:
            break;
    }
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController
 didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:viewDeckController.centerController,
//                              kAGViewDeckVisibleViewControllerKey,
//                              nil];
    
    // post notification here is need be
}

#pragma mark - UIPopoverControllerDelegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (popoverController == self.popOver) {
        self.popOver = nil;
    }
}

@end