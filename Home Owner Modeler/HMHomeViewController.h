//
//  HMHomeController.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/16/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMMenuViewController.h"
#import "IIViewDeckController.h"
#import "HMContainerViewController.h"

@interface HMHomeViewController : UIViewController

@property (strong, nonatomic) IIViewDeckController *viewDeckController;

@property (retain, nonatomic) UIImage *chosenOrTakenItemPhoto;
@property (retain, nonatomic) UIImage *chosenOrTakenHomePhoto;

@property (strong, nonatomic) IBOutlet UIImageView *selectedHomePhoto;
@property (strong, nonatomic) IBOutlet UIImageView *selectedItemPhoto;

@property (strong, nonatomic) IBOutlet UILabel *noHomePhotoSelectView;
@property (strong, nonatomic) IBOutlet UILabel *noItemPhotoSelectView;

@property (weak, nonatomic) IBOutlet UIButton *openHomePhotosButton;
@property (weak, nonatomic) IBOutlet UIButton *openItemPhotosButton;
- (IBAction)openHomePhotos:(id)sender;
- (IBAction)openItemPhotos:(id)sender;

- (void)resizePhoto;

@end
