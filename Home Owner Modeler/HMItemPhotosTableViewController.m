//
//  HMItemsViewController.m
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/16/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import "HMItemPhotosTableViewController.h"
#import "HMHomeViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "ItemPhoto.h"
#import "HMItemPhotoTableViewCell.h"

@interface HMItemPhotosTableViewController ()

@end

@implementation HMItemPhotosTableViewController

@synthesize cameraController;
@synthesize itemImages;
@synthesize itemPhotosTableView;
@synthesize openCameraAlert;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [self.view setFrame:[[HMContainerViewController containerController] screenSize]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self setTitle:@"Item Photos"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(openCameraApp)];
    
    self.cameraController = [[UIImagePickerController alloc] init];
    [self.cameraController setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getItemPhotos)
                                                 name:kGetItemPhotos
                                               object:nil];
    
    [self.itemPhotosTableView registerNib:[UINib nibWithNibName:@"HMItemPhotoTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"HMItemPhotoTableViewCell"];
    
    [self getItemPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate/DataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.itemImages && [self.itemImages count] > 0) {
        return [self.itemImages count];
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemImages && [self.itemImages count] > 0) {
        return 175;
    }
    
    return self.view.frame.size.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemImages && [self.itemImages count] > 0) {
        HMItemPhotoTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"HMItemPhotoTableViewCell"];
        
        if (photoCell == nil) {
            photoCell = [[HMItemPhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HMItemPhotoTableViewCell"];
        }
        
        [photoCell configureCellWithImage:[self.itemImages objectAtIndex:[indexPath row]]];
        
        return photoCell;
    } else {
        
        UITableViewCell *displayCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        
        [[displayCell textLabel] setText:@"You currently have not taken or saved any Home photos."];
        [[displayCell textLabel] setNumberOfLines:2];
        
        return displayCell;
    }

//    UITableViewCell *displayCell;
//    displayCell = [tableView dequeueReusableCellWithIdentifier:@"HMImageTableViewCell"];
//    if (displayCell == nil) {
//        displayCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HMImageTableViewCell"];
//    }
//    if (self.itemImages && [self.itemImages count] > 0) {
//        [[displayCell imageView] setImage:[self.itemImages objectAtIndex:[indexPath row]]];
//        [[displayCell textLabel] setText:@""];
//        [[displayCell imageView] setFrame:CGRectMake(5, 5, displayCell.imageView.frame.size.width*5, displayCell.imageView.frame.size.height*5)];
//        [displayCell setFrame:CGRectMake(0, 0, displayCell.frame.size.width, displayCell.imageView.frame.size.height*5)];
//    } else {
//        [[displayCell textLabel] setText:@"You currently have not taken or saved any Home photos."];
//        [[displayCell textLabel] setNumberOfLines:2];
//    }
//
//    return displayCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.itemImages count] > 0) {
        UIImage *selectedImage = [self.itemImages objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kItemPhotoSelectOrTakeComplete object:selectedImage];
    } else {
        [self openCameraApp];
    }
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] deleteObject:[self.itemImages objectAtIndex:[indexPath row]]];
    }
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.cameraController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    } else {
        [self.cameraController setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [self presentModalViewController:self.cameraController animated:YES];
}

#pragma mark - Private methods

- (IIViewDeckController*)getViewDeckController {
    return [[HMContainerViewController containerController] mainDeckController];
}


- (void)getItemPhotos {
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"ItemPhoto" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *itemPhotoCDObjects = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    NSMutableArray *itemPhotoImages = [[NSMutableArray alloc] init];
    for (ItemPhoto *photo in itemPhotoCDObjects) {
        [itemPhotoImages addObject:photo.item_photo];
    }
    
    self.itemImages = [[NSArray alloc] initWithArray:itemPhotoImages];
    
    [self.itemPhotosTableView reloadData];
}

- (void)openCameraApp {
    self.openCameraAlert = [[UIAlertView alloc] initWithTitle:@"Select or Take a picture" message:@"Would you like to select a picture or take a new one?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select", @"Take New", nil];
    
    [self.openCameraAlert show];
}

- (void)updateCoreDataWithNewItemPhoto:(UIImage*)image {
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    ItemPhoto *itemPhoto = [NSEntityDescription
                            insertNewObjectForEntityForName:@"ItemPhoto"
                            inManagedObjectContext:context];
    itemPhoto.item_photo = image;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self getItemPhotos];
}

#pragma mark - UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage *chosenImage = [info objectForKey: UIImagePickerControllerOriginalImage];
    [self updateCoreDataWithNewItemPhoto:chosenImage];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end