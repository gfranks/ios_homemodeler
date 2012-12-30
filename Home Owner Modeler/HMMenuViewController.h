//
//  HMMenuViewController.h
//  Home Owner Modeler
//
//  Created by Garrett Franks on 12/17/12.
//  Copyright (c) 2012 Garrett Franks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"

@protocol HMMenuViewControllerDelegate;

@interface HMMenuViewController : UIViewController <UIScrollViewDelegate>

@property (assign) id<HMMenuViewControllerDelegate>  menuDelegate;
@property (nonatomic, weak) IBOutlet UIScrollView  * scrollView;
@property (nonatomic, weak) IBOutlet UIPageControl * pageControl;
@property (nonatomic, weak) IIViewDeckController   * viewDeckController;
@property (weak, nonatomic) IBOutlet UIButton *cropPhoto;
@property (weak, nonatomic) IBOutlet UIButton *resizePhoto;
@property (weak, nonatomic) IBOutlet UIButton *contrast;

- (IBAction)openCropTool:(id)sender;
- (IBAction)openResizeTool:(id)sender;
- (IBAction)openContrastEditor:(id)sender;
- (IBAction)changePage:(id)sender;

@end

@protocol HMMenuViewControllerDelegate <NSObject>

@optional
- (void)closeMenu:(id)sender;
- (void)openMenu:(id)sender;
- (void)resizePhoto;

@end