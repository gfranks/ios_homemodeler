//
//  SearchResultsListTableCell.h
//  Apartments
//
//  Created by Alondo Brewington on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AGListingTableCell.h"

@interface SearchResultsListTableCell : AGListingTableCell

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIImageView *propertyImageView;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *propertyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *propertyPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *telcoImageView;
@property (weak, nonatomic) IBOutlet UILabel *bathLabel;
@property (weak, nonatomic) IBOutlet UILabel *bedLabel;
@property (weak, nonatomic) IBOutlet UIView *cellContainerView;
@property (weak, nonatomic) IBOutlet UILabel *dealsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bedIcon;
@property (weak, nonatomic) IBOutlet UIImageView *bathIcon;
@property (weak, nonatomic) IBOutlet UIView *bedBathView;
@property (weak, nonatomic) IBOutlet UIView *spotlightBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *propertyDetailsView;
@property (weak, nonatomic) IBOutlet UIImageView *dealsTagIcon;
@property (weak, nonatomic) IBOutlet UIView *dealsTextContainer;
@property (weak, nonatomic) IBOutlet UIImageView *dealBanner;
@property (weak, nonatomic) IBOutlet UIImageView *calledImage;
@property (weak, nonatomic) IBOutlet UIImageView *emailedImage;
@property (weak, nonatomic) IBOutlet UIImageView *viewedImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoritedImage;
@property (weak, nonatomic) IBOutlet UIView *searchResultsDetailsBorderView;
@property (strong, nonatomic) UILabel *dealBannerLbl;
@property (weak, nonatomic) IBOutlet UIImageView *bedBathOverlay;
@property (weak, nonatomic) IBOutlet UIImageView *bedBathSeperator;
@property (weak, nonatomic) IBOutlet UIImageView *cellShadow;
@property (weak, nonatomic) IBOutlet UIImageView *cellSeparatorLine;


- (id)initWithListing:(AGListingLogic *)aListingLogic;
- (void)configureDealTextForRect:(CGRect)rect;


@end
