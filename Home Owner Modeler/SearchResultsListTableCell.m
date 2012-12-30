//
//  SearchResultsListTableCell.m
//  Apartments
//
//  Created by Alondo Brewington on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsListTableCell.h"
#import "AGMyPlace.h"
#import "AGMyPlaceLogic.h"
#import "AGListingLogic.h"
#import "AGListing.h"
#import "AGStylesheet+SearchResults.h"
#import <RestKit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "AGEnvironment.h"
#import "AGBannerManager.h"

@interface SearchResultsListTableCell()
{
    int currentAdUnitIndex;
}

@end

@implementation SearchResultsListTableCell
@synthesize view;
@synthesize propertyImageView;
@synthesize callButton;
@synthesize propertyNameLabel;
@synthesize propertyAddressLabel;
@synthesize propertyPriceLabel;
@synthesize bathLabel;
@synthesize bedLabel;
@synthesize cellContainerView;
@synthesize dealsLabel;
@synthesize bedIcon;
@synthesize bathIcon;
@synthesize bedBathView;
@synthesize spotlightBackgroundView;
@synthesize propertyDetailsView;
@synthesize dealsTagIcon;
@synthesize dealsTextContainer;
@synthesize dealBanner;
@synthesize dealBannerLbl;
@synthesize searchResultsDetailsBorderView;
@synthesize telcoImageView;
@synthesize calledImage;
@synthesize emailedImage;
@synthesize viewedImage;
@synthesize favoritedImage;
@synthesize bedBathOverlay;
@synthesize bedBathSeperator;
@synthesize cellShadow;
@synthesize listingLogic = _listingLogic;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithListing:(AGListingLogic *)aListingLogic{
    
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchResultsTableCell"]){
        [self configureCellForListingLogic:aListingLogic];
    }
    
    return self;
}

- (void)configureCellForListingLogic:(AGListingLogic *)aListingLogic
{
    self.listingLogic = nil;
    self.listingLogic = aListingLogic;
    [self configureCellForListingLogic:aListingLogic index:0 dma:@"null" targetcode:@"null"];
}

- (void)configureCellForListingLogic:(AGListingLogic *)aListingLogic index:(int)index dma:(NSString *)dma targetcode:(NSString *)targetCode
{
    [super configureCellForListingLogic:aListingLogic];
    
    //UIView *bgColorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 239.0)];
    UIView *bgColorView = [[UIView alloc] init];
    
    // if this is a free listing
    if([aListingLogic.listing.source isEqualToString:kAGFreeListingSource])
    {
        [self.bedBathOverlay setHidden:YES];
        [self.bedBathSeperator setHidden:YES];
        [self.bathIcon setHidden:YES];
        [self.bathLabel setHidden:YES];
        [self.bedIcon setHidden:YES];
        [self.bedLabel setHidden:YES];
    
        [self.propertyImageView setImage:[AGStyleSheet defaultFreeSearchResultsListPropertyImage]];
    }
    else
    {
        [self.bedBathOverlay setHidden:NO];
        [self.bedBathSeperator setHidden:NO];
        [self.bathIcon setHidden:NO];
        [self.bathLabel setHidden:NO];
        [self.bedIcon setHidden:NO];
        [self.bedLabel setHidden:NO];
        
        [self.bedLabel setText:aListingLogic.listing.beds];
        [self.bedIcon setImage:[AGStyleSheet defaultPropertyBedIcon]];
        [self.bathLabel setText:aListingLogic.listing.baths];
        [self.bathIcon setImage:[AGStyleSheet defaultPropertyBathIcon]];
        
        NSString *photoUrl = [NSString stringWithFormat:@"%@/%@", [AGEnvironment sharedEnvironment].img_server_host, aListingLogic.listing.photoURL];
        
        [self.propertyImageView setImageWithURL:[NSURL URLWithString:photoUrl]
                               placeholderImage:[AGStyleSheet defaultSearchResultsListPropertyImage]];
    }    
    
    [self.propertyNameLabel setText: aListingLogic.listing.name];
    [self.propertyAddressLabel setText:aListingLogic.listing.displayAddress];
    [self.propertyPriceLabel setText:aListingLogic.listing.prices];
    
    [cellContainerView setBackgroundColor:[UIColor whiteColor]];
    [self.spotlightBackgroundView setHidden:YES];
    [self.cellSeparatorLine setHidden:YES];
    
    [self.telcoImageView setHidden:YES];
    
    currentAdUnitIndex = index;
    
    if(aListingLogic.hasPartnerClient)
    {
        CGRect borderFrame = self.searchResultsDetailsBorderView.frame;
        borderFrame.size.height = 195.0;
        self.searchResultsDetailsBorderView.frame = borderFrame;
        
        CGRect shadowFrame = self.cellShadow.frame;
        shadowFrame.origin.y = 216.0;
        self.cellShadow.frame = shadowFrame;
        
        CGRect spotlightBackgroundFrame = self.spotlightBackgroundView.frame;
        spotlightBackgroundFrame.size.height = 239.0;
        self.spotlightBackgroundView.frame = spotlightBackgroundFrame;
        
        CGRect cellSeparatorLineFrame = self.cellSeparatorLine.frame;
        cellSeparatorLineFrame.origin.y = 238.0;
        self.cellSeparatorLine.frame = cellSeparatorLineFrame;
        
        dispatch_queue_t imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(imageQueue, ^{
            
            // remove any old image
            [self.telcoImageView setImage:nil];
            [self.telcoImageView setHidden:NO];
            
            int queuedAdUnitIndex = currentAdUnitIndex;
            NSDictionary *telCoBannerData = [[AGBannerManager sharedInstance] loadTelCoWithId:TelcoAdUnitIDResultsList
                                                                                          dma:dma
                                                                                   targetcode:targetCode
                                                                                        tflag:aListingLogic.listing.partner.client
                                                                                     forIndex:(index + 1)];

            if (queuedAdUnitIndex == currentAdUnitIndex) {
                // load banner image and tracking pixel
                UIImage *trackingPixel = [[AGBannerManager sharedInstance] getTelCoBannerImage:[telCoBannerData objectForKey:@"trackingPixelPath"]];
                if (trackingPixel) {
                    // We dont need to display the trackingPixel, just need to make sure we've loaded it so it will fire off a tracking event
                    trackingPixel = nil;
                }
                NSString* bannerURL = [telCoBannerData objectForKey:@"bannerImagePath"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.telcoImageView setImageWithURL:[NSURL URLWithString:bannerURL]];
                });
            }
        });
    }
    else
    {
        CGRect borderFrame = self.searchResultsDetailsBorderView.frame;
        borderFrame.size.height = 170.0;
        self.searchResultsDetailsBorderView.frame = borderFrame;
        
        CGRect shadowFrame = self.cellShadow.frame;
        shadowFrame.origin.y = 191.0;
        self.cellShadow.frame = shadowFrame;
        
        CGRect spotlightBackgroundFrame = self.spotlightBackgroundView.frame;
        spotlightBackgroundFrame.size.height = 214.0;
        self.spotlightBackgroundView.frame = spotlightBackgroundFrame;
        
        CGRect cellSeparatorLineFrame = self.cellSeparatorLine.frame;
        cellSeparatorLineFrame.origin.y = 213.0;
        self.cellSeparatorLine.frame = cellSeparatorLineFrame;
    }
    
    if (aListingLogic.isSpotlight) {
        [self.spotlightBackgroundView setHidden:NO];
        [self.cellSeparatorLine setHidden:NO];
        
        [self.spotlightBackgroundView setBackgroundColor:[AGStyleSheet spotlightTableCellBackgroundColor]];
        
        [bgColorView setBackgroundColor:[AGStyleSheet searchResultsSpotlightDetailsHighlightColor]];
    }
    else {
    
        [bgColorView setBackgroundColor:[AGStyleSheet searchResultsDetailsHighlightColor]];
    }
    
    [self setSelectedBackgroundView:bgColorView];
    
    if (nil == dealBannerLbl) {
        dealBannerLbl = [[UILabel alloc] initWithFrame:CGRectMake(32, 27, 49, 21)];
    }
    
    dealBannerLbl.text            = @"DEAL";
    dealBannerLbl.backgroundColor = [UIColor clearColor];
    dealBannerLbl.textColor       = [UIColor whiteColor];
    dealBannerLbl.shadowColor     = [UIColor darkGrayColor];
    dealBannerLbl.shadowOffset    = CGSizeMake(1, 1);
    dealBannerLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    // rotate 45 degrees
    dealBannerLbl.transform = CGAffineTransformMakeRotation(M_PI / -3.8);
    [self.view addSubview:dealBannerLbl];
    
    [self.dealBanner setHidden:YES];
    [self.dealsTextContainer setHidden:YES];
    [dealBannerLbl setHidden:YES];
    
    if (aListingLogic.hasCoupon) {
        
        [self.dealBanner setHidden:NO];
        [dealBannerLbl setHidden:NO];
        
        [self.dealsLabel setText:aListingLogic.listing.couponHeadlineText];
        [self.dealsTextContainer setHidden:NO];
    }
    
    AGMyPlaceLogic *apartmentListingLogic = [AGMyPlaceLogic getForListing:aListingLogic.listing];
    
    [self configureIcons:apartmentListingLogic.myPlace listingLogic:apartmentListingLogic];
}

- (void)configureDealTextForRect:(CGRect)rect {
    if (self.listingLogic.hasCoupon) {
        if (self.dealBannerLbl) {
            [self.dealBannerLbl removeFromSuperview];
            self.dealBannerLbl = nil;
        }
        
        dealBannerLbl = [[UILabel alloc] initWithFrame:rect];
        dealBannerLbl.text            = @"DEAL";
        dealBannerLbl.backgroundColor = [UIColor clearColor];
        dealBannerLbl.textColor       = [UIColor whiteColor];
        dealBannerLbl.shadowColor     = [UIColor darkGrayColor];
        dealBannerLbl.shadowOffset    = CGSizeMake(1, 1);
        dealBannerLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        
        // rotate 45 degrees
        dealBannerLbl.transform = CGAffineTransformMakeRotation(M_PI / -3.8);
        [self.view addSubview:dealBannerLbl];
    }
}

- (void)configureIcons:(AGMyPlace*)apartmentListing listingLogic:(AGMyPlaceLogic *)apartmentListingLogic {
    
    NSInteger iconsOffest;
    NSInteger iconWidth = 13;
    NSInteger favoritedPosition = 0;
    NSInteger emailedPosition   = 0;
    NSInteger calledPosition    = 0;
    NSInteger viewedPosition    = 0;
    
    [self.calledImage setHidden:!apartmentListing.isCalledValue];
    [self.viewedImage setHidden:![apartmentListingLogic isViewedOnly]];
    [self.emailedImage setHidden:!apartmentListing.isEmailedValue];
    [self.favoritedImage setHidden:!apartmentListing.isFavoritedValue];
    
    iconsOffest = 207;
    viewedPosition = iconsOffest - 6;
    favoritedPosition = iconsOffest;
    emailedPosition   = iconsOffest - (iconWidth * apartmentListing.isFavoritedValue);
    calledPosition    = iconsOffest - (iconWidth * apartmentListing.isFavoritedValue) - (iconWidth * apartmentListing.isEmailedValue);
    
    [self.favoritedImage setFrame:CGRectMake(favoritedPosition, 47, 10, 10)];
    [self.emailedImage setFrame:CGRectMake(emailedPosition, 47, 10, 10)];
    [self.calledImage setFrame:CGRectMake(calledPosition, 47, 10, 10)];
    [self.viewedImage setFrame:CGRectMake(viewedPosition, 47, 16, 10)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setBackgroundViewColors];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    [self setBackgroundViewColors];
}

- (void)setBackgroundViewColors{
    [self.propertyDetailsView setBackgroundColor:[AGStyleSheet propertyDetailBackgroundViewColor]];
    
    [self.searchResultsDetailsBorderView setBackgroundColor:[AGStyleSheet searchResultsDetailsBorderColor]];
    
}

@end
