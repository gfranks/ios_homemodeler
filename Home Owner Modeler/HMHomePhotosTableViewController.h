//
//  HMHomePhotosViewController.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/16/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHomePhotoSelectOrTakeComplete @"hasTakenOrSelectedHomePhoto"
#define kHomePhotoEntityName @"HomePhoto"
#define kGetHomePhotos @"GetHomePhotos"

@interface HMHomePhotosTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *homePhotosTableView;
@property (strong, nonatomic) IBOutlet UIButton *noSavedOrTakenHomePhotos;
@property (strong, nonatomic) UIImagePickerController *cameraController;
@property (strong, nonatomic) NSArray *homeImages;
@property (strong, nonatomic) UIAlertView *openCameraAlert;

- (void)openCameraApp;

- (void)getHomePhotos;

@end