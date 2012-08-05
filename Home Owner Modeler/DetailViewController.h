//
//  DetailViewController.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 8/5/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
