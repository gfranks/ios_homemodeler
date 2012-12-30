//
//  HMMenuViewController.m
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import "HMMenuViewController.h"
#import "AppDelegate.h"

const int kWidthOfSinglePage = 320;

@interface HMMenuViewController () {
    CGFloat scrollViewWidth;
}

@end

@implementation HMMenuViewController
@synthesize menuDelegate;
@synthesize scrollView;
@synthesize pageControl;
@synthesize viewDeckController;
@synthesize cropPhoto, resizePhoto, contrast;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scrollViewWidth = self.scrollView.frame.size.width;
    int pages = (scrollViewWidth / kWidthOfSinglePage);
    self.pageControl.numberOfPages = pages;
    self.pageControl.currentPage = 0;
    [self.scrollView setDelegate:self];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setCropPhoto:nil];
    [self setResizePhoto:nil];
    [self setContrast:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)openCropTool:(id)sender {
    NSLog(@"Opening cropping tool");
    
    [menuDelegate closeMenu:sender];
}

- (IBAction)openResizeTool:(id)sender {
    NSLog(@"Opening resizing tool");
    [[HMContainerViewController containerController] resizePhoto];
    [menuDelegate closeMenu:sender];
}

- (IBAction)openContrastEditor:(id)sender {
    NSLog(@"Opening contrast editor");
    
    [menuDelegate closeMenu:sender];
}

- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

# pragma mark - Method to return ViewDeck's center controllers view

# pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    int page = floor((self.scrollView.contentOffset.x - scrollViewWidth / 2) / scrollViewWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
