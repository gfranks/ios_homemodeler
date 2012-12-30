//
//  HMHomeController.m
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/16/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import "HMHomeViewController.h"
#import "HMHomePhotosTableViewController.h"
#import "HMItemPhotosTableViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "HomePhoto.h"
#import "ItemPhoto.h"
#import <QuartzCore/QuartzCore.h>

#define kMenuContentViewTag 1234

@interface HMHomeViewController () {
    CGRect menuRect;
}

@property (nonatomic, strong) UIImageView *mainDropShadowView;
@property (nonatomic) BOOL didSelectMenuOptionToResize;

@end

@implementation HMHomeViewController

@synthesize viewDeckController;
@synthesize chosenOrTakenHomePhoto, chosenOrTakenItemPhoto;
@synthesize selectedHomePhoto, selectedItemPhoto;
@synthesize noHomePhotoSelectView, noItemPhotoSelectView;
@synthesize openHomePhotosButton, openItemPhotosButton;
@synthesize didSelectMenuOptionToResize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        [self.view setFrame:[[HMContainerViewController containerController] screenSize]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:@"Home Modeler"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSelectedHomePhoto:)
                                                 name:kHomePhotoSelectOrTakeComplete
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSelectedItemPhoto:)
                                                 name:kItemPhotoSelectOrTakeComplete
                                               object:nil];
    
    [self.view bringSubviewToFront:self.openHomePhotosButton];
    [self.view bringSubviewToFront:self.openItemPhotosButton];
    [self.openHomePhotosButton setHidden:NO];
    [self.openItemPhotosButton setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openHomePhotosButton.transform = CGAffineTransformMakeRotation(M_PI);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction methods

- (IBAction)openHomePhotos:(id)sender {
    [[self getViewDeckController] toggleLeftView];
}

- (IBAction)openItemPhotos:(id)sender {
    [[self getViewDeckController] toggleRightView];
}

#pragma mark - Class methods

- (void)resizePhoto {
    UIAlertView *resizeAlert= [[UIAlertView alloc]
                               initWithTitle: @"Select photo scale"
                               message:nil
                               delegate: nil
                               cancelButtonTitle:@"Done"
                               otherButtonTitles:nil];
    UISlider *resizeSlider=[[UISlider alloc] initWithFrame:CGRectMake(20, 50, 200, 20)];
    resizeSlider.maximumValue=10.00;
    resizeSlider.minimumValue=1.00;
    [resizeSlider addTarget:self action:@selector(sliderHandler:) forControlEvents:UIControlEventValueChanged];
    [resizeAlert addSubview:resizeSlider];
    [resizeAlert show];
}

#pragma mark - Private methods

- (IIViewDeckController*)getViewDeckController {
    return [[HMContainerViewController containerController] mainDeckController];
}

- (void) sliderHandler: (UISlider *)sender {
    [self.selectedHomePhoto setImage:[UIImage imageWithCGImage:self.chosenOrTakenHomePhoto.CGImage scale:(sender.value)/10 orientation:[self.chosenOrTakenHomePhoto imageOrientation]]];
}

- (void)updateSelectedHomePhoto:(NSNotification*)notification {
    NSLog(@"Received notification with home photo");
    [self.noHomePhotoSelectView setHidden:YES];
    
    UIImage *homePhoto = (UIImage*)[notification object];
    
    CGFloat kMaxHomeImageHeight = 194;
    
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    if (homePhoto.size.height > kMaxHomeImageHeight) {
        CGFloat product = homePhoto.size.height/kMaxHomeImageHeight;
        newImageWidth = homePhoto.size.width/product;
        newImageHeight = kMaxHomeImageHeight;
    } else {
        CGFloat difference = kMaxHomeImageHeight/homePhoto.size.height;
        newImageWidth = homePhoto.size.width/difference;
        newImageHeight = kMaxHomeImageHeight;
    }
    
    [self.selectedHomePhoto setImage:[self imageWithImage:homePhoto convertToSize:CGSizeMake(newImageWidth, newImageHeight)]];
    CGRect selectedHomePhotoFrame = self.selectedHomePhoto.frame;
    selectedHomePhotoFrame.size.width = newImageWidth;
    selectedHomePhotoFrame.origin.x = ([[UIScreen mainScreen] bounds].size.width - newImageWidth)/2;
    [self.selectedHomePhoto setFrame:selectedHomePhotoFrame];
    [self setChosenOrTakenHomePhoto:homePhoto];
    
    [[[HMContainerViewController containerController] mainDeckController] toggleLeftView];
}

- (void)updateSelectedItemPhoto:(NSNotification*)notification {
    NSLog(@"Received notification with item photo");
    [self.noItemPhotoSelectView setHidden:YES];
    
    UIImage *itemPhoto = (UIImage*)[notification object];
    
    CGFloat kMaxItemImageHeight = 117;
    
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    if (itemPhoto.size.height > kMaxItemImageHeight) {
        CGFloat product = itemPhoto.size.height/kMaxItemImageHeight;
        newImageWidth = itemPhoto.size.width/product;
        newImageHeight = kMaxItemImageHeight;
    } else {
        CGFloat difference = kMaxItemImageHeight/itemPhoto.size.height;
        newImageWidth = itemPhoto.size.width/difference;
        newImageHeight = kMaxItemImageHeight;
    }
    
    [self.selectedItemPhoto setImage:[self imageWithImage:itemPhoto convertToSize:CGSizeMake(newImageWidth, newImageHeight)]];
    CGRect selectedItemPhotoFrame = self.selectedItemPhoto.frame;
    selectedItemPhotoFrame.size.width = newImageWidth;
    selectedItemPhotoFrame.origin.x = ([[UIScreen mainScreen] bounds].size.width - newImageWidth)/2;
    selectedItemPhotoFrame.origin.y = self.selectedHomePhoto.frame.origin.y + self.selectedHomePhoto.frame.size.height + 2;
    [self.selectedItemPhoto setFrame:selectedItemPhotoFrame];
    [self setChosenOrTakenItemPhoto:itemPhoto];
    
    [[[HMContainerViewController containerController] mainDeckController] toggleRightView];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void)viewDidUnload {
    [self setOpenHomePhotosButton:nil];
    [self setOpenItemPhotosButton:nil];
    [super viewDidUnload];
}

@end