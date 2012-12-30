//
//  HMHomePhotoTableViewCell.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomePhotoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *homePhoto;

- (void)configureCellWithImage:(UIImage*)image;

@end
