//
//  HMItemsViewController.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/16/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kItemPhotoSelectOrTakeComplete @"hasTakenOrSelectedItemPhoto"
#define kItemPhotoEntityName @"ItemPhoto"
#define kGetItemPhotos @"GetItemPhotos"

@interface HMItemPhotosTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *itemPhotosTableView;
@property (strong, nonatomic) UIImagePickerController *cameraController;
@property (strong, nonatomic) NSArray *itemImages;
@property (strong, nonatomic) UIAlertView *openCameraAlert;

- (void)getItemPhotos;

@end