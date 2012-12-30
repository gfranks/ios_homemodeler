//
//  HMItemPhotoTableViewCell.m
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import "HMItemPhotoTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HMItemPhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithImage:(UIImage*)image {
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    CGFloat difference = 177/image.size.height;
    newImageWidth = image.size.width/difference;
    newImageHeight = 177;
    
    [self.itemPhoto setImage:[self imageWithImage:image convertToSize:CGSizeMake(newImageWidth, newImageHeight)]];
    
    [self.itemPhoto.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.itemPhoto.layer setBorderWidth: 1.0];
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
