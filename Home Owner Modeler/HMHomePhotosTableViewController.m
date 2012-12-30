//
//  HMHomePhotosViewController.m
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/16/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import "HMHomePhotosTableViewController.h"
#import "HMHomeViewController.h"
#import "IIViewDeckController.h"
#import "AppDelegate.h"
#import "HomePhoto.h"
#import "HMHomePhotoTableViewCell.h"

@interface HMHomePhotosTableViewController ()

@end

@implementation HMHomePhotosTableViewController

@synthesize noSavedOrTakenHomePhotos;
@synthesize cameraController;
@synthesize homeImages;
@synthesize homePhotosTableView;
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
    [self setTitle:@"Home Photos"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                          target:self
                                                                                          action:@selector(openCameraApp)];
    
    self.cameraController = [[UIImagePickerController alloc] init];
    [self.cameraController setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getHomePhotos)
                                                 name:kGetHomePhotos
                                               object:nil];
    
    [self.homePhotosTableView registerNib:[UINib nibWithNibName:@"HMHomePhotoTableViewCell" bundle:nil]
                   forCellReuseIdentifier:@"HMHomePhotoTableViewCell"];
    
    [self getHomePhotos];
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
    if (self.homeImages && [self.homeImages count] > 0) {
        return [self.homeImages count];
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.homeImages && [self.homeImages count] > 0) {
        return 175;
    }
    
    return self.view.frame.size.height;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.homeImages && [self.homeImages count] > 0) {
        HMHomePhotoTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"HMHomePhotoTableViewCell"];
        
        if (photoCell == nil) {
            photoCell = [[HMHomePhotoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"HMHomePhotoTableViewCell"];
        }
        
        [photoCell configureCellWithImage:[self.homeImages objectAtIndex:[indexPath row]]];
        
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
//    if (self.homeImages && [self.homeImages count] > 0) {
//        [[displayCell imageView] setImage:[self.homeImages objectAtIndex:[indexPath row]]];
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
    if ([self.homeImages count] > 0) {
        UIImage *selectedImage = [self.homeImages objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomePhotoSelectOrTakeComplete object:selectedImage];
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
        [[(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext] deleteObject:[self.homeImages objectAtIndex:[indexPath row]]];
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

- (void)getHomePhotos {
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HomePhoto" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *homePhotoCDObjects = [[NSArray alloc] initWithArray:[context executeFetchRequest:fetchRequest error:&error]];
    NSMutableArray *homePhotoImages = [[NSMutableArray alloc] init];
    for (HomePhoto *photo in homePhotoCDObjects) {
        [homePhotoImages addObject:photo.home_photo];
    }
    
    self.homeImages = [[NSArray alloc] initWithArray:homePhotoImages];
    
    [self.homePhotosTableView reloadData];
}

- (void)openCameraApp {
    self.openCameraAlert = [[UIAlertView alloc] initWithTitle:@"Select or Take a picture" message:@"Would you like to select a picture or take a new one?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Select", @"Take New", nil];
    
    [self.openCameraAlert show];
}

- (void)updateCoreDataWithNewHomePhoto:(UIImage*)image {
    NSManagedObjectContext *context = [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    HomePhoto *homePhoto = [NSEntityDescription
                            insertNewObjectForEntityForName:@"HomePhoto"
                            inManagedObjectContext:context];
    homePhoto.home_photo = image;
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self getHomePhotos];
}

#pragma mark - UIImagePickerControllerDelegate methods

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    UIImage *chosenImage = [info objectForKey: UIImagePickerControllerOriginalImage];
    [self updateCoreDataWithNewHomePhoto:chosenImage];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end