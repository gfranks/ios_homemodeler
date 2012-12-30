//
//  HMItemPhotoTableViewCell.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMItemPhotoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *itemPhoto;

- (void)configureCellWithImage:(UIImage*)image;

@end
